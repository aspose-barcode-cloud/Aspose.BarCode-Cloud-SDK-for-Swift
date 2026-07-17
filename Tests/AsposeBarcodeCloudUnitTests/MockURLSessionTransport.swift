import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
@testable import AsposeBarcodeCloud

/// Shared, configurable mock transport for offline pipeline tests.
///
/// Tests install a handler that maps each outgoing `URLRequest` to a canned
/// `(Data?, URLResponse?, Error?)` triple, so the whole request pipeline
/// (encoding, interception, response decoding, download-to-file, error/retry
/// handling) runs without touching the network. XCTest runs the methods of a
/// test class serially, so the shared static handler is reset in `setUp`.
enum MockTransport {
    struct Reply {
        var data: Data?
        var response: URLResponse?
        var error: (any Error)?

        init(data: Data? = nil, response: URLResponse? = nil, error: (any Error)? = nil) {
            self.data = data
            self.response = response
            self.error = error
        }
    }

    private nonisolated(unsafe) static var handler: (@Sendable (URLRequest) -> Reply)?
    private(set) nonisolated(unsafe) static var lastRequest: URLRequest?

    static func reset() {
        handler = nil
        lastRequest = nil
    }

    static func set(_ handler: @escaping @Sendable (URLRequest) -> Reply) {
        self.handler = handler
    }

    /// Convenience: reply with a fixed HTTP status, body and headers.
    static func respond(status: Int, body: Data? = nil, headers: [String: String] = [:]) {
        set { request in
            let url = request.url ?? URL(string: "https://example.com/")!
            let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers)
            return Reply(data: body, response: response)
        }
    }

    static func reply(for request: URLRequest) -> Reply {
        lastRequest = request
        guard let handler else {
            return Reply(error: URLError(.unsupportedURL))
        }
        return handler(request)
    }

    /// Build an `HTTPURLResponse` for a request URL (defaults to a stub URL).
    static func httpResponse(_ status: Int, url: String = "https://example.com/v4.0/x", headers: [String: String] = [:]) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: url)!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers)!
    }
}

/// A `URLSessionProtocol` that answers through `MockTransport`.
final class MockURLSession: URLSessionProtocol {
    func dataTaskFromProtocol(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTaskProtocol {
        MockURLSessionDataTask(request: request, completionHandler: completionHandler)
    }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol, @unchecked Sendable {
    let taskIdentifier = 0
    let progress = Progress(totalUnitCount: 1)

    private let request: URLRequest
    private let completionHandler: @Sendable (Data?, URLResponse?, (any Error)?) -> Void

    init(request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        self.request = request
        self.completionHandler = completionHandler
    }

    func resume() {
        let reply = MockTransport.reply(for: request)
        completionHandler(reply.data, reply.response, reply.error)
    }

    func cancel() {}
}

/// Request-builder subclasses that inject `MockURLSession` in place of the
/// shared live session, without changing any other pipeline behaviour.
final class MockURLSessionRequestBuilder<T: Sendable>: URLSessionRequestBuilder<T>, @unchecked Sendable {
    override func createURLSession() -> URLSessionProtocol {
        MockURLSession()
    }
}

final class MockURLSessionDecodableRequestBuilder<T: Decodable & Sendable>: URLSessionDecodableRequestBuilder<T>, @unchecked Sendable {
    override func createURLSession() -> URLSessionProtocol {
        MockURLSession()
    }
}

final class MockRequestBuilderFactory: RequestBuilderFactory, Sendable {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        MockURLSessionRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        MockURLSessionDecodableRequestBuilder<T>.self
    }
}
