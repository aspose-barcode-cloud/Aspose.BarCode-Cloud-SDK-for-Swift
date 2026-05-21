import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

final class AsposeBarcodeCloudTests: XCTestCase {
    func testDefaultBasePath() {
        let client = AsposeBarcodeCloudClient(configuration: AsposeBarcodeCloudConfiguration())
        XCTAssertEqual(client.apiConfiguration.basePath, "https://api.aspose.cloud/v4.0")
    }

    func testTokenRequestUsesClientCredentialsFormBody() throws {
        let configuration = AsposeBarcodeCloudConfiguration(
            clientId: "client id",
            clientSecret: "secret/value",
            tokenURL: "https://example.com/connect/token",
            timeoutInterval: 42
        )

        let request = try configuration.makeTokenRequest()
        let body = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        let bodyItems = Dictionary(uniqueKeysWithValues: body.split(separator: "&").map { item -> (String, String) in
            let parts = item.split(separator: "=", maxSplits: 1).map(String.init)
            return (
                parts[0].removingPercentEncoding ?? parts[0],
                parts.count > 1 ? (parts[1].removingPercentEncoding ?? parts[1]) : ""
            )
        })

        XCTAssertEqual(request.url?.absoluteString, "https://example.com/connect/token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.timeoutInterval, 42)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(bodyItems["grant_type"], "client_credentials")
        XCTAssertEqual(bodyItems["client_id"], "client id")
        XCTAssertEqual(bodyItems["client_secret"], "secret/value")
    }

    func testAccessTokenConfigurationAppliesHeadersToGeneratedRequests() async throws {
        let client = AsposeBarcodeCloudClient(
            configuration: AsposeBarcodeCloudConfiguration(
                accessToken: "test-token",
                host: "https://example.com/v4.0",
                sdkName: "custom swift sdk",
                sdkVersion: "1.2.3"
            )
        )

        let requestBuilder = GenerateAPI.generateWithRequestBuilder(
            barcodeType: .qr,
            data: "hello",
            apiConfiguration: client.apiConfiguration
        )
        let headers = (requestBuilder as! URLSessionRequestBuilder<Data>).buildHeaders()

        XCTAssertEqual(client.apiConfiguration.basePath, "https://example.com/v4.0")
        XCTAssertEqual(headers["x-aspose-client"], "custom swift sdk")
        XCTAssertEqual(headers["x-aspose-client-version"], "1.2.3")

        let intercepted = try await intercept(
            request: URLRequest(url: URL(string: "https://example.com/v4.0/barcode/generate/QR")!),
            requestBuilder: requestBuilder as! URLSessionRequestBuilder<Data>,
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "Authorization"), "Bearer test-token")
    }

    func testAuthorizeUsesInjectedTokenFetcher() async throws {
        let configuration = AsposeBarcodeCloudConfiguration(
            clientId: "client-id",
            clientSecret: "client-secret"
        )

        let client = AsposeBarcodeCloudClient(configuration: configuration) { configuration, completion in
            XCTAssertEqual(configuration.clientId, "client-id")
            XCTAssertEqual(configuration.clientSecret, "client-secret")
            completion(.success("fetched-token"))
        }

        let token = try await client.authorize()

        XCTAssertEqual(token, "fetched-token")
        XCTAssertEqual(configuration.accessToken, "fetched-token")
        XCTAssertEqual(client.apiConfiguration.customHeaders["x-aspose-client"], "swift sdk")
        XCTAssertEqual(
            client.apiConfiguration.customHeaders["x-aspose-client-version"],
            AsposeBarcodeCloudConfiguration.defaultSdkVersion
        )
    }

    func testAuthorizeFailsWithoutTokenOrCredentials() async {
        let client = AsposeBarcodeCloudClient(configuration: AsposeBarcodeCloudConfiguration())

        do {
            _ = try await client.authorize()
            XCTFail("Expected missing credentials error")
        } catch AsposeBarcodeCloudClientError.missingCredentials {
            // Expected path.
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    private func intercept(
        request: URLRequest,
        requestBuilder: URLSessionRequestBuilder<Data>,
        apiConfiguration: AsposeBarcodeCloudAPIConfiguration
    ) async throws -> URLRequest {
        try await withCheckedThrowingContinuation { continuation in
            apiConfiguration.interceptor.intercept(
                urlRequest: request,
                urlSession: URLSession.shared,
                requestBuilder: requestBuilder
            ) { result in
                continuation.resume(with: result)
            }
        }
    }

    func testGenerateSmokeWhenIntegrationEnvironmentIsEnabled() async throws {
        guard let client = try await makeIntegrationClient() else {
            return
        }

        let (responseData, responseError) = generateBarcodeData("Aspose.BarCode Swift SDK", client: client)

        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
        XCTAssertGreaterThan(responseData?.count ?? 0, 0)
    }

    func testGenerateScanAndRecognizeBase64SmokeWhenIntegrationEnvironmentIsEnabled() async throws {
        guard let client = try await makeIntegrationClient() else {
            return
        }

        let barcodeValue = "Aspose.BarCode Swift SDK live roundtrip"
        let (generatedData, generateError) = generateBarcodeData(barcodeValue, client: client)
        XCTAssertNil(generateError)

        let fileBase64 = try XCTUnwrap(generatedData).base64EncodedString()

        let (scanResponse, scanError) = scanBase64(fileBase64, client: client)
        XCTAssertNil(scanError)
        XCTAssertEqual(scanResponse?.barcodes?.first?.barcodeValue, barcodeValue)

        let (recognizeResponse, recognizeError) = recognizeBase64(fileBase64, barcodeType: .qr, client: client)
        XCTAssertNil(recognizeError)
        XCTAssertEqual(recognizeResponse?.barcodes?.first?.barcodeValue, barcodeValue)
    }

    private func makeIntegrationClient() async throws -> AsposeBarcodeCloudClient? {
        guard ProcessInfo.processInfo.environment["ASPOSE_RUN_INTEGRATION_TESTS"] == "true" else {
            return nil
        }

        guard let configuration = TestConfiguration.load() else {
            return nil
        }

        let client = AsposeBarcodeCloudClient(configuration: configuration)
        _ = try await client.authorize()
        return client
    }

    private func generateBarcodeData(_ value: String, client: AsposeBarcodeCloudClient) -> (Data?, Error?) {
        let expectation = expectation(description: "generate barcode")
        let responseData = ThreadSafeBox<Data>()
        let responseError = ThreadSafeBox<Error>()

        GenerateAPI.generate(
            barcodeType: .qr,
            data: value,
            imageFormat: .png,
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            responseData.set(data)
            responseError.set(error)
            expectation.fulfill()
        }

        _ = XCTWaiter.wait(for: [expectation], timeout: 60)

        return (responseData.value, responseError.value)
    }

    private func scanBase64(_ fileBase64: String, client: AsposeBarcodeCloudClient) -> (BarcodeResponseList?, Error?) {
        let expectation = expectation(description: "scan barcode")
        let response = ThreadSafeBox<BarcodeResponseList>()
        let responseError = ThreadSafeBox<Error>()

        ScanAPI.scanBase64(
            scanBase64Request: ScanBase64Request(fileBase64: fileBase64),
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            response.set(data)
            responseError.set(error)
            expectation.fulfill()
        }

        _ = XCTWaiter.wait(for: [expectation], timeout: 60)

        return (response.value, responseError.value)
    }

    private func recognizeBase64(_ fileBase64: String, barcodeType: DecodeBarcodeType, client: AsposeBarcodeCloudClient) -> (BarcodeResponseList?, Error?) {
        let expectation = expectation(description: "recognize barcode")
        let response = ThreadSafeBox<BarcodeResponseList>()
        let responseError = ThreadSafeBox<Error>()

        let request = RecognizeBase64Request(
            barcodeTypes: [barcodeType],
            fileBase64: fileBase64
        )

        RecognizeAPI.recognizeBase64(
            recognizeBase64Request: request,
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            response.set(data)
            responseError.set(error)
            expectation.fulfill()
        }

        _ = XCTWaiter.wait(for: [expectation], timeout: 60)

        return (response.value, responseError.value)
    }
}

private final class ThreadSafeBox<Value>: @unchecked Sendable {
    private let lock = NSLock()
    private var storedValue: Value?

    var value: Value? {
        lock.withLock { storedValue }
    }

    func set(_ value: Value?) {
        lock.withLock { storedValue = value }
    }
}

private enum TestConfiguration {
    private static let defaultConfigPath = "Tests/configuration.json"

    static func load() -> AsposeBarcodeCloudConfiguration? {
        if let configuration = loadFromFile(defaultConfigPath) {
            return configuration
        }

        return loadFromEnvironment(ProcessInfo.processInfo.environment)
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
