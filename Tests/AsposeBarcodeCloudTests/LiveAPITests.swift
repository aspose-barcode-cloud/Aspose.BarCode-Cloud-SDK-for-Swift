import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Live integration tests for the async/await variants of the Generate,
/// Scan, and Recognize APIs. These call the real Aspose.BarCode Cloud API and
/// require credentials: set TEST_CONFIGURATION_ACCESS_TOKEN, create
/// Tests/configuration.json from Tests/configuration.example.json, or set
/// TEST_CONFIGURATION_CLIENT_ID and TEST_CONFIGURATION_CLIENT_SECRET.
final class LiveAPITests: XCTestCase {
    private static let publicBarcodeImageURL = "https://products.aspose.app/barcode/scan/img/how-to/scan/step2.png"
    private static let publicBarcodeImageDecodedValue = "http://en.m.wikipedia.org"

    // MARK: - Integration: Generate

    func testGenerate() async throws {
        let client = try await makeIntegrationClient()
        let data = try await GenerateAPI.generate(
            barcodeType: .qr,
            data: "Aspose.BarCode Swift SDK",
            barcodeImageParams: BarcodeImageParams(imageFormat: .png),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertGreaterThan(data.count, 0)
    }

    func testGenerateBody() async throws {
        let client = try await makeIntegrationClient()
        let params = GenerateParams(
            barcodeType: .qr,
            encodeData: EncodeData(dataType: .base64Bytes, data: "VGVzdA=="),
            barcodeImageParams: BarcodeImageParams(imageFormat: .jpeg)
        )
        let data = try await GenerateAPI.generateBody(
            generateParams: params,
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertGreaterThan(data.count, 0)
    }

    func testGenerateMultipart() async throws {
        let client = try await makeIntegrationClient()
        let data = try await GenerateAPI.generateMultipart(
            barcodeType: .qr,
            data: "54657374",
            dataType: .hexBytes,
            barcodeImageParams: BarcodeImageParams(backgroundColor: "0xffe"),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertGreaterThan(data.count, 0)
    }

    // MARK: - Integration: Scan

    func testScan() async throws {
        let client = try await makeIntegrationClient()
        let response = try await ScanAPI.scan(
            fileUrl: Self.publicBarcodeImageURL,
            apiConfiguration: client.apiConfiguration
        )
        let barcodes = try XCTUnwrap(response.barcodes)
        XCTAssertEqual(barcodes.count, 1)
        XCTAssertEqual(barcodes[0].type, "QR")
        XCTAssertEqual(barcodes[0].barcodeValue, Self.publicBarcodeImageDecodedValue)
    }

    func testScanBase64() async throws {
        let client = try await makeIntegrationClient()
        let barcodeValue = "Aspose.BarCode scanBase64 roundtrip"
        let generated = try await GenerateAPI.generate(
            barcodeType: .qr,
            data: barcodeValue,
            apiConfiguration: client.apiConfiguration
        )
        let response = try await ScanAPI.scanBase64(
            scanBase64Request: ScanBase64Request(fileBase64: generated.base64EncodedString()),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, barcodeValue)
    }

    func testScanMultipart() async throws {
        let client = try await makeIntegrationClient()
        let barcodeValue = "Aspose.BarCode scanMultipart roundtrip"
        let generated = try await GenerateAPI.generate(
            barcodeType: .qr,
            data: barcodeValue,
            apiConfiguration: client.apiConfiguration
        )
        let response = try await ScanAPI.scanMultipart(
            file: generated,
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, barcodeValue)
    }

    // MARK: - Integration: Recognize

    func testRecognize() async throws {
        let client = try await makeIntegrationClient()
        let response = try await RecognizeAPI.recognize(
            barcodeType: .qr,
            fileUrl: Self.publicBarcodeImageURL,
            recognitionMode: .fast,
            recognitionImageKind: .clearImage,
            apiConfiguration: client.apiConfiguration
        )
        let barcodes = try XCTUnwrap(response.barcodes)
        XCTAssertEqual(barcodes.count, 1)
        XCTAssertEqual(barcodes[0].type, "QR")
        XCTAssertEqual(barcodes[0].barcodeValue, Self.publicBarcodeImageDecodedValue)
    }

    func testRecognizeBase64() async throws {
        let client = try await makeIntegrationClient()
        let barcodeValue = "Aspose.BarCode recognizeBase64 roundtrip"
        let generated = try await GenerateAPI.generate(
            barcodeType: .qr,
            data: barcodeValue,
            apiConfiguration: client.apiConfiguration
        )
        let response = try await RecognizeAPI.recognizeBase64(
            recognizeBase64Request: RecognizeBase64Request(
                barcodeTypes: [.qr],
                fileBase64: generated.base64EncodedString()
            ),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, barcodeValue)
    }

    func testRecognizeMultipart() async throws {
        let client = try await makeIntegrationClient()
        let barcodeValue = "Aspose.BarCode recognizeMultipart roundtrip"
        let generated = try await GenerateAPI.generate(
            barcodeType: .qr,
            data: barcodeValue,
            apiConfiguration: client.apiConfiguration
        )
        let response = try await RecognizeAPI.recognizeMultipart(
            barcodeType: .qr,
            file: generated,
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, barcodeValue)
    }

    // MARK: - Helpers

    private func makeIntegrationClient() async throws -> AsposeBarcodeCloudClient {
        let configuration = try XCTUnwrap(
            TestConfiguration.load(),
            "Integration credentials missing. Set TEST_CONFIGURATION_ACCESS_TOKEN, create Tests/configuration.json from Tests/configuration.example.json, or set TEST_CONFIGURATION_CLIENT_ID and TEST_CONFIGURATION_CLIENT_SECRET."
        )
        let client = AsposeBarcodeCloudClient(configuration: configuration)
        _ = try await client.authorize()
        return client
    }
}

private enum TestConfiguration {
    private static let defaultConfigPath = "Tests/configuration.json"

    static func load() -> AsposeBarcodeCloudConfiguration? {
        if let configuration = loadFromFile(defaultConfigPath) {
            return configuration
        }

        if let configuration = loadFromFile(sourceRelativeConfigPath()) {
            return configuration
        }

        return loadFromEnvironment(ProcessInfo.processInfo.environment)
    }

    private static func sourceRelativeConfigPath() -> String {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("configuration.json")
            .path
    }

    private static func loadFromFile(_ path: String) -> AsposeBarcodeCloudConfiguration? {
        guard FileManager.default.fileExists(atPath: path),
              let data = FileManager.default.contents(atPath: path)
        else {
            return nil
        }

        do {
            let payload = try JSONDecoder().decode(Payload.self, from: data)
            return payload.makeConfiguration()
        } catch {
            XCTFail("Failed to load \(path): \(error)")
            return nil
        }
    }

    private static func loadFromEnvironment(_ environment: [String: String]) -> AsposeBarcodeCloudConfiguration? {
        let payload = Payload(
            accessToken: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_ACCESS_TOKEN",
            ]),
            clientId: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_CLIENT_ID",
                "ASPOSE_CLIENT_ID",
            ]),
            clientSecret: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_CLIENT_SECRET",
                "ASPOSE_CLIENT_SECRET",
            ]),
            host: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_HOST",
                "TEST_CONFIGURATION_BASE_URL",
            ]),
            tokenURL: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_TOKEN_URL",
            ])
        )

        return payload.makeConfiguration()
    }

    private static func firstValue(in environment: [String: String], names: [String]) -> String? {
        for name in names {
            if let value = environment[name], !value.isEmpty {
                return value
            }
        }

        return nil
    }

    private struct Payload: Decodable {
        let accessToken: String?
        let clientId: String?
        let clientSecret: String?
        let host: String?
        let tokenURL: String?

        init(
            accessToken: String? = nil,
            clientId: String? = nil,
            clientSecret: String? = nil,
            host: String? = nil,
            tokenURL: String? = nil
        ) {
            self.accessToken = accessToken
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.host = host
            self.tokenURL = tokenURL
        }

        enum CodingKeys: String, CodingKey {
            case accessToken
            case clientId
            case clientSecret
            case host
            case baseUrl
            case tokenURL
            case tokenUrl
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
            clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
            clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret)
            host = try container.decodeIfPresent(String.self, forKey: .host)
                ?? container.decodeIfPresent(String.self, forKey: .baseUrl)
            tokenURL = try container.decodeIfPresent(String.self, forKey: .tokenURL)
                ?? container.decodeIfPresent(String.self, forKey: .tokenUrl)
        }

        func makeConfiguration() -> AsposeBarcodeCloudConfiguration? {
            if let accessToken, !accessToken.isEmpty {
                return AsposeBarcodeCloudConfiguration(
                    accessToken: accessToken,
                    host: host ?? AsposeBarcodeCloudConfiguration.defaultHost,
                    tokenURL: tokenURL ?? AsposeBarcodeCloudConfiguration.defaultTokenURL
                )
            }

            guard let clientId, !clientId.isEmpty,
                  let clientSecret, !clientSecret.isEmpty
            else {
                return nil
            }

            return AsposeBarcodeCloudConfiguration(
                clientId: clientId,
                clientSecret: clientSecret,
                host: host ?? AsposeBarcodeCloudConfiguration.defaultHost,
                tokenURL: tokenURL ?? AsposeBarcodeCloudConfiguration.defaultTokenURL
            )
        }
    }
}
