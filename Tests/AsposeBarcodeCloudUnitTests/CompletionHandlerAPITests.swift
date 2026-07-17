import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline tests for the completion-handler variants of the generated APIs.
///
/// Requests are served by a mock `URLSessionProtocol` implementation injected
/// through `requestBuilderFactory`, so the full request pipeline (parameter
/// encoding, auth interception, response decoding) runs without any network
/// access.
final class CompletionHandlerAPITests: XCTestCase {
    override func setUp() {
        super.setUp()
        MockTransport.reset()
        // Serve generate requests with image bytes and recognize/scan requests
        // with a canned barcode list, keyed on the request path.
        MockTransport.set { request in
            let url = request.url ?? URL(string: "https://example.com/")!
            let body: Data
            let contentType: String
            if url.path.contains("/barcode/generate") {
                body = MockBarcodeTransport.generatedImageBytes
                contentType = "image/png"
            } else {
                body = MockBarcodeTransport.recognizeResponseJSON
                contentType = "application/json"
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": contentType]
            )
            return MockTransport.Reply(data: body, response: response)
        }
    }

    // MARK: - Generate

    func testGenerateCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "generate completion")

        GenerateAPI.generate(
            barcodeType: .qr,
            data: "hello world",
            dataType: .stringData,
            barcodeImageParams: BarcodeImageParams(imageFormat: .png),
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            XCTAssertNil(error)
            XCTAssertEqual(data, MockBarcodeTransport.generatedImageBytes)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testGenerateBodyCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "generateBody completion")

        let params = GenerateParams(
            barcodeType: .qr,
            encodeData: EncodeData(dataType: .stringData, data: "payload")
        )
        GenerateAPI.generateBody(
            generateParams: params,
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            XCTAssertNil(error)
            XCTAssertEqual(data, MockBarcodeTransport.generatedImageBytes)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testGenerateMultipartCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "generateMultipart completion")

        GenerateAPI.generateMultipart(
            barcodeType: .qr,
            data: "54657374",
            dataType: .hexBytes,
            apiConfiguration: client.apiConfiguration
        ) { data, error in
            XCTAssertNil(error)
            XCTAssertEqual(data, MockBarcodeTransport.generatedImageBytes)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    // MARK: - Recognize

    func testRecognizeCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "recognize completion")

        RecognizeAPI.recognize(
            barcodeType: .qr,
            fileUrl: "https://example.com/barcode.png",
            recognitionMode: .normal,
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testRecognizeBase64CompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "recognizeBase64 completion")

        let request = RecognizeBase64Request(barcodeTypes: [.qr], fileBase64: "VGVzdA==")
        RecognizeAPI.recognizeBase64(
            recognizeBase64Request: request,
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testRecognizeMultipartCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "recognizeMultipart completion")

        RecognizeAPI.recognizeMultipart(
            barcodeType: .qr,
            file: Data([0x01, 0x02, 0x03]),
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    // MARK: - Scan

    func testScanCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "scan completion")

        ScanAPI.scan(
            fileUrl: "https://example.com/barcode.png",
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testScanBase64CompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "scanBase64 completion")

        ScanAPI.scanBase64(
            scanBase64Request: ScanBase64Request(fileBase64: "VGVzdA=="),
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    func testScanMultipartCompletionVariant() {
        let client = makeMockClient()
        let done = expectation(description: "scanMultipart completion")

        ScanAPI.scanMultipart(
            file: Data([0x0A, 0x0B, 0x0C]),
            apiConfiguration: client.apiConfiguration
        ) { response, error in
            XCTAssertNil(error)
            XCTAssertEqual(response?.barcodes?.first?.barcodeValue, MockBarcodeTransport.recognizedValue)
            done.fulfill()
        }

        wait(for: [done], timeout: 5)
    }

    // MARK: - Helpers

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
        return client
    }
}

/// Canned responses shared by the mock transport.
private enum MockBarcodeTransport {
    static let generatedImageBytes = Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
    static let recognizedValue = "mock-barcode-value"
    static let recognizeResponseJSON = Data(
        #"{"barcodes":[{"barcodeValue":"mock-barcode-value","type":"QR"}]}"#.utf8
    )
}
