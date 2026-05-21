import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

final class RequestBuilderTests: XCTestCase {
    func testGenerateGetRequestShape() async throws {
        let client = makeTestClient()

        let builder = GenerateAPI.generateWithRequestBuilder(
            barcodeType: .qr,
            data: "hello world",
            dataType: .stringData,
            imageFormat: .png,
            textLocation: ._none,
            apiConfiguration: client.apiConfiguration
        )

        XCTAssertEqual(builder.method, "GET")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertNil(builder.parameters)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/generate/QR")

        let queryItems = queryItems(from: builder.URLString)
        XCTAssertEqual(queryItems["data"], "hello world")
        XCTAssertEqual(queryItems["dataType"], "StringData")
        XCTAssertEqual(queryItems["imageFormat"], "Png")
        XCTAssertEqual(queryItems["textLocation"], "None")

        let headers = (builder as! URLSessionRequestBuilder<Data>).buildHeaders()
        XCTAssertEqual(headers["x-aspose-client"], "swift sdk test")
        XCTAssertEqual(headers["x-aspose-client-version"], "0.0-test")

        let intercepted = try await intercept(
            request: URLRequest(url: URL(string: "https://example.com/v4.0/barcode/generate/QR")!),
            requestBuilder: builder as! URLSessionRequestBuilder<Data>,
            apiConfiguration: client.apiConfiguration
        )
        XCTAssertEqual(intercepted.value(forHTTPHeaderField: "Authorization"), "Bearer test-token")
    }

    func testGenerateBodyRequestShape() throws {
        let generateParams = GenerateParams(
            barcodeType: .qr,
            encodeData: EncodeData(dataType: .stringData, data: "payload")
        )

        let builder = GenerateAPI.generateBodyWithRequestBuilder(generateParams: generateParams)

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/generate-body")
        XCTAssertEqual(builder.headers["Content-Type"], "application/json")

        let body = try jsonObject(from: builder.parameters)
        XCTAssertEqual(body["barcodeType"] as? String, "QR")

        let encodeData = body["encodeData"] as? [String: Any]
        XCTAssertEqual(encodeData?["data"] as? String, "payload")
        XCTAssertEqual(encodeData?["dataType"] as? String, "StringData")
    }

    func testGenerateMultipartRequestShape() {
        let builder = GenerateAPI.generateMultipartWithRequestBuilder(
            barcodeType: .qr,
            data: "payload",
            dataType: .stringData,
            imageFormat: .png,
            textLocation: ._none
        )

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/generate-multipart")
        XCTAssertEqual(builder.headers["Content-Type"], "multipart/form-data")
        XCTAssertEqual(builder.parameters?["barcodeType"] as? String, "QR")
        XCTAssertEqual(builder.parameters?["data"] as? String, "payload")
        XCTAssertEqual(builder.parameters?["dataType"] as? String, "StringData")
        XCTAssertEqual(builder.parameters?["imageFormat"] as? String, "Png")
        XCTAssertEqual(builder.parameters?["textLocation"] as? String, "None")
    }

    func testRecognizeGetRequestShape() {
        let builder = RecognizeAPI.recognizeWithRequestBuilder(
            barcodeType: .qr,
            fileUrl: "https://example.com/code.png",
            recognitionMode: .fast,
            recognitionImageKind: .photo
        )

        XCTAssertEqual(builder.method, "GET")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertNil(builder.parameters)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/recognize")

        let queryItems = queryItems(from: builder.URLString)
        XCTAssertEqual(queryItems["barcodeType"], "QR")
        XCTAssertEqual(queryItems["fileUrl"], "https://example.com/code.png")
        XCTAssertEqual(queryItems["recognitionMode"], "Fast")
        XCTAssertEqual(queryItems["recognitionImageKind"], "Photo")
    }

    func testRecognizeBase64RequestShape() throws {
        let request = RecognizeBase64Request(
            barcodeTypes: [.qr],
            fileBase64: "aGVsbG8=",
            recognitionMode: .normal,
            recognitionImageKind: .clearImage
        )

        let builder = RecognizeAPI.recognizeBase64WithRequestBuilder(recognizeBase64Request: request)

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/recognize-body")
        XCTAssertEqual(builder.headers["Content-Type"], "application/json")

        let body = try jsonObject(from: builder.parameters)
        XCTAssertEqual(body["barcodeTypes"] as? [String], ["QR"])
        XCTAssertEqual(body["fileBase64"] as? String, "aGVsbG8=")
        XCTAssertEqual(body["recognitionMode"] as? String, "Normal")
        XCTAssertEqual(body["recognitionImageKind"] as? String, "ClearImage")
    }

    func testRecognizeMultipartRequestShape() {
        let fileData = Data([1, 2, 3])

        let builder = RecognizeAPI.recognizeMultipartWithRequestBuilder(
            barcodeType: .qr,
            file: fileData,
            recognitionMode: .excellent,
            recognitionImageKind: .scannedDocument
        )

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/recognize-multipart")
        XCTAssertEqual(builder.headers["Content-Type"], "multipart/form-data")
        XCTAssertEqual(builder.parameters?["barcodeType"] as? String, "QR")
        XCTAssertEqual(builder.parameters?["file"] as? String, fileData.base64EncodedString())
        XCTAssertEqual(builder.parameters?["recognitionMode"] as? String, "Excellent")
        XCTAssertEqual(builder.parameters?["recognitionImageKind"] as? String, "ScannedDocument")
    }

    func testScanGetRequestShape() {
        let builder = ScanAPI.scanWithRequestBuilder(fileUrl: "https://example.com/code.png")

        XCTAssertEqual(builder.method, "GET")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertNil(builder.parameters)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/scan")
        XCTAssertEqual(queryItems(from: builder.URLString)["fileUrl"], "https://example.com/code.png")
    }

    func testScanBase64RequestShape() throws {
        let request = ScanBase64Request(fileBase64: "aGVsbG8=")

        let builder = ScanAPI.scanBase64WithRequestBuilder(scanBase64Request: request)

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/scan-body")
        XCTAssertEqual(builder.headers["Content-Type"], "application/json")

        let body = try jsonObject(from: builder.parameters)
        XCTAssertEqual(body["fileBase64"] as? String, "aGVsbG8=")
    }

    func testScanMultipartRequestShape() {
        let fileData = Data([4, 5, 6])

        let builder = ScanAPI.scanMultipartWithRequestBuilder(file: fileData)

        XCTAssertEqual(builder.method, "POST")
        XCTAssertTrue(builder.requiresAuthentication)
        XCTAssertEqual(URLComponents(string: builder.URLString)?.path, "/v4.0/barcode/scan-multipart")
        XCTAssertEqual(builder.headers["Content-Type"], "multipart/form-data")
        XCTAssertEqual(builder.parameters?["file"] as? String, fileData.base64EncodedString())
    }

    private func makeTestClient() -> AsposeBarcodeCloudClient {
        return AsposeBarcodeCloudClient(
            configuration: AsposeBarcodeCloudConfiguration(
                accessToken: "test-token",
                host: "https://example.com/v4.0",
                sdkName: "swift sdk test",
                sdkVersion: "0.0-test"
            )
        )
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

    private func queryItems(from urlString: String) -> [String: String] {
        let items = URLComponents(string: urlString)?.queryItems ?? []
        return Dictionary(uniqueKeysWithValues: items.map { ($0.name, $0.value ?? "") })
    }

    private func jsonObject(from parameters: [String: Any]?) throws -> [String: Any] {
        guard let data = parameters?["jsonData"] as? Data else {
            XCTFail("Expected jsonData parameter")
            return [:]
        }

        let object = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = object as? [String: Any] else {
            XCTFail("Expected JSON object")
            return [:]
        }

        return dictionary
    }
}
