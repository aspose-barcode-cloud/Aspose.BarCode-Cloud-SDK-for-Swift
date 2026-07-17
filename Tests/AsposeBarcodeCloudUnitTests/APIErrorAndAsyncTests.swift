import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline tests covering the API wrappers' error branches (completion handlers
/// invoked with a failure) and the async variants, driven through the shared
/// mock transport so no network is used.
final class APIErrorAndAsyncTests: XCTestCase {
    private static let recognizeJSON = Data(#"{"barcodes":[{"barcodeValue":"mock","type":"QR"}]}"#.utf8)

    override func setUp() {
        super.setUp()
        MockTransport.reset()
    }

    // MARK: - Completion-handler failure branches

    func testGenerateCompletionFailure() {
        MockTransport.respond(status: 500, body: Data("boom".utf8))
        expectCompletionError { client, done in
            GenerateAPI.generate(barcodeType: .qr, data: "x", apiConfiguration: client.apiConfiguration) { data, error in
                XCTAssertNil(data)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testGenerateBodyCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            let params = GenerateParams(barcodeType: .qr, encodeData: EncodeData(dataType: .stringData, data: "p"))
            GenerateAPI.generateBody(generateParams: params, apiConfiguration: client.apiConfiguration) { data, error in
                XCTAssertNil(data)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testGenerateMultipartCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            GenerateAPI.generateMultipart(barcodeType: .qr, data: "54657374", dataType: .hexBytes, apiConfiguration: client.apiConfiguration) { data, error in
                XCTAssertNil(data)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testRecognizeCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            RecognizeAPI.recognize(barcodeType: .qr, fileUrl: "https://example.com/x.png", apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testRecognizeBase64CompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            let request = RecognizeBase64Request(barcodeTypes: [.qr], fileBase64: "VGVzdA==")
            RecognizeAPI.recognizeBase64(recognizeBase64Request: request, apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testRecognizeMultipartCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            RecognizeAPI.recognizeMultipart(barcodeType: .qr, file: Data([1, 2, 3]), apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testScanCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            ScanAPI.scan(fileUrl: "https://example.com/x.png", apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testScanBase64CompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            ScanAPI.scanBase64(scanBase64Request: ScanBase64Request(fileBase64: "VGVzdA=="), apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    func testScanMultipartCompletionFailure() {
        MockTransport.respond(status: 500)
        expectCompletionError { client, done in
            ScanAPI.scanMultipart(file: Data([4, 5, 6]), apiConfiguration: client.apiConfiguration) { response, error in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                done()
            }
        }
    }

    // MARK: - Async variants (offline)

    func testRecognizeBase64Async() async throws {
        respondRecognize()
        let client = makeMockClient()
        let response = try await RecognizeAPI.recognizeBase64(
            recognizeBase64Request: RecognizeBase64Request(barcodeTypes: [.qr], fileBase64: "VGVzdA=="),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, "mock")
    }

    func testRecognizeMultipartAsync() async throws {
        respondRecognize()
        let client = makeMockClient()
        let response = try await RecognizeAPI.recognizeMultipart(
            barcodeType: .qr,
            file: Data([1, 2, 3]),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, "mock")
    }

    func testScanMultipartAsync() async throws {
        respondRecognize()
        let client = makeMockClient()
        let response = try await ScanAPI.scanMultipart(
            file: Data([4, 5, 6]),
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(response.barcodes?.first?.barcodeValue, "mock")
    }

    // MARK: - Helpers

    private func respondRecognize() {
        MockTransport.respond(status: 200, body: Self.recognizeJSON, headers: ["Content-Type": "application/json"])
    }

    private func makeMockClient() -> AsposeBarcodeCloudClient {
        let client = AsposeBarcodeCloudClient(
            configuration: AsposeBarcodeCloudConfiguration(
                accessToken: "test-token",
                host: "https://example.com/v4.0",
                sdkName: "swift sdk test",
                sdkVersion: "0.0-test"
            )
        )
        client.apiConfiguration.requestBuilderFactory = MockRequestBuilderFactory()
        client.apiConfiguration.apiResponseQueue = DispatchQueue(label: "test.api")
        return client
    }

    private func expectCompletionError(_ body: (AsposeBarcodeCloudClient, @escaping @Sendable () -> Void) -> Void) {
        let client = makeMockClient()
        let done = expectation(description: "completion")
        body(client) { done.fulfill() }
        wait(for: [done], timeout: 5)
    }
}
