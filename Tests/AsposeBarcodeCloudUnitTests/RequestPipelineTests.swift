import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline tests that drive the `URLSessionRequestBuilder` pipeline through a
/// mock `URLSessionProtocol`. They exercise parameter encoding, response
/// decoding, download-to-file, and the error/retry paths without any network.
final class RequestPipelineTests: XCTestCase {
    override func setUp() {
        super.setUp()
        MockTransport.reset()
    }

    // MARK: - Pure helpers / public surface

    func testRequestBuilderErrorDescriptions() {
        XCTAssertEqual(URLSessionRequestBuilderError.unsupportedHTTPMethod("ZZ").description, "Unsupported HTTP method: ZZ")
        XCTAssertEqual(URLSessionRequestBuilderError.unsupportedMediaType("x/y").description, "Unsupported media type: x/y")
        XCTAssertEqual(URLSessionRequestBuilderError.unsupportedResponseBodyType("Foo").description, "Unsupported response body type: Foo")
        XCTAssertEqual(
            URLSessionRequestBuilderError.unprocessableMultipartValue(key: "k", valueDescription: "v").description,
            "Unprocessable multipart value for key k: v"
        )
        XCTAssertEqual(URLSessionRequestBuilderError.unprocessableBody(description: "b").description, "Unprocessable request body: b")
    }

    func testFactoryReturnsBuilderTypes() {
        let factory = URLSessionRequestBuilderFactory()
        let nonDecodable: RequestBuilder<Data>.Type = factory.getNonDecodableBuilder()
        let decodable: RequestBuilder<SampleModel>.Type = factory.getBuilder()
        XCTAssertTrue(nonDecodable == URLSessionRequestBuilder<Data>.self)
        XCTAssertTrue(decodable == URLSessionDecodableRequestBuilder<SampleModel>.self)
    }

    func testContentTypeForFormPartDefaultIsNil() {
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        XCTAssertNil(builder.contentTypeForFormPart(fileURL: URL(fileURLWithPath: "/tmp/x.png")))
    }

    func testDefaultInterceptorPassthroughAndRetry() throws {
        let interceptor = DefaultOpenAPIInterceptor()
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        let request = try URLRequest(url: XCTUnwrap(URL(string: "https://example.com/v4.0/x")))

        let passthrough = expectation(description: "intercept")
        interceptor.intercept(urlRequest: request, urlSession: MockURLSession(), requestBuilder: builder) { result in
            if case let .success(returned) = result {
                XCTAssertEqual(returned.url, request.url)
            } else {
                XCTFail("expected passthrough success")
            }
            passthrough.fulfill()
        }

        let retryDone = expectation(description: "retry")
        interceptor.retry(urlRequest: request, urlSession: MockURLSession(), requestBuilder: builder, data: nil, response: nil, error: URLError(.timedOut)) { retry in
            if case .dontRetry = retry {} else { XCTFail("default interceptor should not retry") }
            retryDone.fulfill()
        }

        wait(for: [passthrough, retryDone], timeout: 5)
    }

    // MARK: - Parameter encodings

    func testGetQueryEncoding() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "GET",
            parameters: ["alpha": "one two", "beta": "3"]
        )
        _ = try XCTUnwrap(execute(builder))
        let query = try XCTUnwrap(MockTransport.lastRequest?.url?.query)
        XCTAssertTrue(query.contains("alpha="))
        XCTAssertTrue(query.contains("beta=3"))
    }

    func testFormURLEncoding() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["alpha": "one two"],
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
        _ = try XCTUnwrap(execute(builder))
        let request = try XCTUnwrap(MockTransport.lastRequest)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        let body = try XCTUnwrap(request.httpBody.flatMap { String(data: $0, encoding: .utf8) })
        XCTAssertTrue(body.contains("alpha="))
    }

    func testOctetStreamEncodingWithData() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let payload = Data([0x10, 0x20, 0x30])
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["body": payload],
            headers: ["Content-Type": "application/octet-stream"]
        )
        _ = try XCTUnwrap(execute(builder))
        XCTAssertEqual(MockTransport.lastRequest?.httpBody, payload)
    }

    func testOctetStreamEncodingWithFileURL() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let fileURL = try writeTempFile(Data([0x41, 0x42, 0x43]), ext: "bin")
        defer { try? FileManager.default.removeItem(at: fileURL) }

        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["body": fileURL],
            headers: ["Content-Type": "application/octet-stream"]
        )
        _ = try XCTUnwrap(execute(builder))
        XCTAssertEqual(MockTransport.lastRequest?.httpBody, Data([0x41, 0x42, 0x43]))
    }

    func testOctetStreamEncodingUnsupportedBodyFails() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["body": UnsupportedValue()],
            headers: ["Content-Type": "application/octet-stream"]
        )
        let result = try XCTUnwrap(execute(builder))
        assertFailure(result)
    }

    func testUnsupportedMediaTypeFails() throws {
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["a": "b"],
            headers: ["Content-Type": "application/zip"]
        )
        let result = try XCTUnwrap(execute(builder))
        assertFailure(result)
    }

    // MARK: - Multipart encoding

    func testMultipartWithFileURLNumberAndUUID() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let fileURL = try writeTempFile(Data([0x01, 0x02]), ext: "png")
        defer { try? FileManager.default.removeItem(at: fileURL) }

        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: [
                "file": fileURL,
                "count": NSNumber(value: 7),
                "id": UUID(),
                "label": "text-part",
            ],
            headers: ["Content-Type": "multipart/form-data"]
        )
        _ = try XCTUnwrap(execute(builder))
        let request = try XCTUnwrap(MockTransport.lastRequest)
        XCTAssertTrue(request.value(forHTTPHeaderField: "Content-Type")?.hasPrefix("multipart/form-data; boundary=") ?? false)
        let body = try XCTUnwrap(request.httpBody.flatMap { String(data: $0, encoding: .utf8) })
        XCTAssertTrue(body.contains("name=\"file\""))
        XCTAssertTrue(body.contains("name=\"count\""))
        XCTAssertTrue(body.contains("name=\"id\""))
    }

    func testMultipartUnsupportedValueFails() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: ["bad": UnsupportedValue()],
            headers: ["Content-Type": "multipart/form-data"]
        )
        let result = try XCTUnwrap(execute(builder))
        assertFailure(result)
    }

    func testMultipartEmptyParametersSucceeds() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(
            SampleModel.self,
            method: "POST",
            parameters: [:],
            headers: ["Content-Type": "multipart/form-data"]
        )
        _ = try successBody(XCTUnwrap(execute(builder)))
    }

    // MARK: - Response decoding (decodable builder)

    func testDecodeSuccess() throws {
        MockTransport.respond(status: 200, body: sampleJSON)
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        XCTAssertEqual(try successBody(result), SampleModel(name: "abc"))
    }

    func testDecodeMalformedJSONFails() throws {
        MockTransport.respond(status: 200, body: Data("not json".utf8))
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    func testEmptyDataRequiredModelFails() throws {
        MockTransport.respond(status: 200, body: Data())
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    func testEmptyDataOptionalModelSucceedsWithNil() throws {
        MockTransport.respond(status: 200, body: Data())
        let builder = makeDecodableBuilder(SampleModel?.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        XCTAssertNil(try successBody(result))
    }

    func testStringBody() throws {
        MockTransport.respond(status: 200, body: Data("hello body".utf8))
        let builder = makeDecodableBuilder(String.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        XCTAssertEqual(try successBody(result), "hello body")
    }

    func testDataBody() throws {
        let bytes = Data([0x89, 0x50, 0x4E, 0x47])
        MockTransport.respond(status: 200, body: bytes)
        let builder = makeDecodableBuilder(Data.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        XCTAssertEqual(try successBody(result), bytes)
    }

    func testNonHTTPResponseFails() throws {
        MockTransport.set { request in
            let response = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            return MockTransport.Reply(data: Data(), response: response)
        }
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    func testNon2xxStatusFails() throws {
        MockTransport.respond(status: 500, body: Data("server error".utf8))
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        if case let .failure(.error(status, _, _, _)) = result {
            XCTAssertEqual(status, 500)
        } else {
            XCTFail("expected 500 failure")
        }
    }

    func testTransportErrorFails() throws {
        MockTransport.set { _ in MockTransport.Reply(error: URLError(.timedOut)) }
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    // MARK: - Base (non-decodable) builder

    func testVoidResponseSucceeds() throws {
        MockTransport.respond(status: 200, body: Data())
        let builder = makeBuilder(Void.self, method: "GET")
        let result = try XCTUnwrap(execute(builder))
        if case .failure = result { XCTFail("expected Void success") }
    }

    func testUnsupportedResponseBodyTypeFails() throws {
        MockTransport.respond(status: 200, body: Data())
        let builder = makeBuilder(Int.self, method: "GET")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    // MARK: - Download to file (URL response)

    func testDownloadToFileWithContentDisposition() throws {
        MockTransport.respond(
            status: 200,
            body: Data("file-bytes".utf8),
            headers: ["Content-Disposition": "attachment; filename=\"result.png\""]
        )
        let builder = makeDecodableBuilder(URL.self, method: "GET", urlString: "https://example.com/v4.0/barcode/download")
        let result = try XCTUnwrap(execute(builder))
        let fileURL = try successBody(result)
        XCTAssertTrue(fileURL.lastPathComponent.contains("result.png"))
        XCTAssertEqual(try Data(contentsOf: fileURL), Data("file-bytes".utf8))
        try? FileManager.default.removeItem(at: fileURL)
    }

    func testDownloadToFileWithoutContentDisposition() throws {
        MockTransport.respond(status: 200, body: Data("more-bytes".utf8))
        let builder = makeDecodableBuilder(URL.self, method: "GET", urlString: "https://example.com/v4.0/barcode/download")
        let result = try XCTUnwrap(execute(builder))
        let fileURL = try successBody(result)
        XCTAssertTrue(fileURL.lastPathComponent.contains("tmp.AsposeBarcodeCloud."))
        try? FileManager.default.removeItem(at: fileURL)
    }

    func testDownloadMissingDataFails() throws {
        MockTransport.set { request in
            MockTransport.Reply(data: nil, response: MockTransport.httpResponse(200, url: request.url!.absoluteString))
        }
        let builder = makeDecodableBuilder(URL.self, method: "GET", urlString: "https://example.com/v4.0/barcode/download")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    // MARK: - Request build failures

    func testInvalidHTTPMethodFails() throws {
        let builder = makeDecodableBuilder(SampleModel.self, method: "FOOBAR")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    func testMalformedURLStringFails() throws {
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET", urlString: "https://example.com/v4.0/a b c")
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    // MARK: - Interceptor behaviour

    func testInterceptorFailurePropagates() throws {
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET", interceptor: FailingInterceptor())
        try assertFailure(XCTUnwrap(execute(builder)))
    }

    func testInterceptorRetryIsHonoured() throws {
        MockTransport.respond(status: 500, body: Data("err".utf8))
        let interceptor = RetryOnceInterceptor(retries: 1)
        let builder = makeDecodableBuilder(SampleModel.self, method: "GET", interceptor: interceptor)
        try assertFailure(XCTUnwrap(execute(builder)))
        XCTAssertEqual(interceptor.retryCalls, 2, "should retry once then stop")
    }

    // MARK: - Helpers

    private func makeConfig(interceptor: OpenAPIInterceptor) -> AsposeBarcodeCloudAPIConfiguration {
        AsposeBarcodeCloudAPIConfiguration(
            basePath: "https://example.com/v4.0",
            apiResponseQueue: DispatchQueue(label: "test.pipeline"),
            interceptor: interceptor
        )
    }

    private func makeDecodableBuilder<T: Decodable & Sendable>(
        _: T.Type,
        method: String,
        parameters: [String: any Sendable]? = nil,
        headers: [String: String] = [:],
        urlString: String = "https://example.com/v4.0/thing",
        interceptor: OpenAPIInterceptor = DefaultOpenAPIInterceptor()
    ) -> MockURLSessionDecodableRequestBuilder<T> {
        MockURLSessionDecodableRequestBuilder<T>(
            method: method,
            URLString: urlString,
            parameters: parameters,
            headers: headers,
            requiresAuthentication: false,
            apiConfiguration: makeConfig(interceptor: interceptor)
        )
    }

    private func makeBuilder<T: Sendable>(
        _: T.Type,
        method: String,
        parameters: [String: any Sendable]? = nil,
        headers: [String: String] = [:],
        urlString: String = "https://example.com/v4.0/thing"
    ) -> MockURLSessionRequestBuilder<T> {
        MockURLSessionRequestBuilder<T>(
            method: method,
            URLString: urlString,
            parameters: parameters,
            headers: headers,
            requiresAuthentication: false,
            apiConfiguration: makeConfig(interceptor: DefaultOpenAPIInterceptor())
        )
    }

    private func execute<T>(_ builder: URLSessionRequestBuilder<T>, timeout: TimeInterval = 5) -> Result<Response<T>, ErrorResponse>? {
        let box = ResultBox<T>()
        let done = expectation(description: "execute \(T.self)")
        builder.execute { result in
            box.set(result)
            done.fulfill()
        }
        wait(for: [done], timeout: timeout)
        return box.value
    }

    private func successBody<T>(_ result: Result<Response<T>, ErrorResponse>) throws -> T {
        switch result {
        case let .success(response):
            return response.body
        case let .failure(error):
            throw error
        }
    }

    private func assertFailure(_ result: Result<Response<some Any>, ErrorResponse>, file: StaticString = #filePath, line: UInt = #line) {
        if case .success = result {
            XCTFail("expected failure", file: file, line: line)
        }
    }

    private func writeTempFile(_ data: Data, ext: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("aspose-test-\(UUID().uuidString).\(ext)")
        try data.write(to: url)
        return url
    }

    private var sampleJSON: Data {
        Data(#"{"name":"abc"}"#.utf8)
    }
}

// MARK: - Test fixtures

struct SampleModel: Codable, Equatable {
    let name: String
}

struct UnsupportedValue {}

private final class ResultBox<T>: @unchecked Sendable {
    private let lock = NSLock()
    private var stored: Result<Response<T>, ErrorResponse>?

    func set(_ value: Result<Response<T>, ErrorResponse>) {
        lock.lock()
        stored = value
        lock.unlock()
    }

    var value: Result<Response<T>, ErrorResponse>? {
        lock.lock()
        defer { lock.unlock() }
        return stored
    }
}

private final class FailingInterceptor: OpenAPIInterceptor {
    func intercept(urlRequest _: URLRequest, urlSession _: URLSessionProtocol, requestBuilder _: RequestBuilder<some Any>, completion: @Sendable @escaping (Result<URLRequest, any Error>) -> Void) {
        completion(.failure(URLError(.cancelled)))
    }

    func retry(urlRequest _: URLRequest, urlSession _: URLSessionProtocol, requestBuilder _: RequestBuilder<some Any>, data _: Data?, response _: URLResponse?, error _: any Error, completion: @Sendable @escaping (OpenAPIInterceptorRetry) -> Void) {
        completion(.dontRetry)
    }
}

private final class RetryOnceInterceptor: OpenAPIInterceptor, @unchecked Sendable {
    private let lock = NSLock()
    private var retriesLeft: Int
    private var calls = 0

    init(retries: Int) {
        retriesLeft = retries
    }

    var retryCalls: Int {
        lock.lock()
        defer { lock.unlock() }
        return calls
    }

    func intercept(urlRequest: URLRequest, urlSession _: URLSessionProtocol, requestBuilder _: RequestBuilder<some Any>, completion: @Sendable @escaping (Result<URLRequest, any Error>) -> Void) {
        completion(.success(urlRequest))
    }

    func retry(urlRequest _: URLRequest, urlSession _: URLSessionProtocol, requestBuilder _: RequestBuilder<some Any>, data _: Data?, response _: URLResponse?, error _: any Error, completion: @Sendable @escaping (OpenAPIInterceptorRetry) -> Void) {
        lock.lock()
        calls += 1
        let shouldRetry = retriesLeft > 0
        if shouldRetry { retriesLeft -= 1 }
        lock.unlock()
        completion(shouldRetry ? .retry : .dontRetry)
    }
}
