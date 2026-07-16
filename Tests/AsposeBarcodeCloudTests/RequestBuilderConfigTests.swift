import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline tests for the mutable properties of `AsposeBarcodeCloudAPIConfiguration`
/// and `RequestBuilder`, plus the base `RequestBuilder.execute` stub.
final class RequestBuilderConfigTests: XCTestCase {
    func testAPIConfigurationSetters() {
        let configuration = AsposeBarcodeCloudAPIConfiguration()

        configuration.basePath = "https://example.com/custom"
        XCTAssertEqual(configuration.basePath, "https://example.com/custom")

        configuration.customHeaders = ["X-Custom": "value"]
        XCTAssertEqual(configuration.customHeaders["X-Custom"], "value")

        configuration.credential = URLCredential(user: "u", password: "p", persistence: .none)
        XCTAssertEqual(configuration.credential?.user, "u")

        configuration.apiResponseQueue = DispatchQueue(label: "custom.queue")
        XCTAssertEqual(configuration.apiResponseQueue.label, "custom.queue")

        let helper = CodableHelper()
        configuration.codableHelper = helper
        XCTAssertTrue(configuration.codableHelper === helper)

        configuration.successfulStatusCodeRange = 200 ..< 400
        XCTAssertEqual(configuration.successfulStatusCodeRange, 200 ..< 400)
    }

    func testRequestBuilderMutableProperties() {
        let builder = RequestBuilder<Data>(
            method: "GET",
            URLString: "https://example.com/v4.0/thing",
            parameters: nil,
            requiresAuthentication: false,
            apiConfiguration: AsposeBarcodeCloudAPIConfiguration()
        )

        builder.credential = URLCredential(user: "user", password: "secret", persistence: .none)
        XCTAssertEqual(builder.credential?.user, "user")

        builder.headers = ["H": "V"]
        XCTAssertEqual(builder.headers["H"], "V")

        var progressSeen = false
        builder.onProgressReady = { _ in progressSeen = true }
        XCTAssertNotNil(builder.onProgressReady)
        builder.onProgressReady?(Progress(totalUnitCount: 1))
        XCTAssertTrue(progressSeen)
    }

    func testAddHeaderIgnoresEmptyValues() {
        let builder = RequestBuilder<Data>(
            method: "GET",
            URLString: "https://example.com/v4.0/thing",
            parameters: nil,
            requiresAuthentication: false,
            apiConfiguration: AsposeBarcodeCloudAPIConfiguration()
        )

        _ = builder.addHeader(name: "X-Present", value: "1")
        _ = builder.addHeader(name: "X-Empty", value: "")

        XCTAssertEqual(builder.headers["X-Present"], "1")
        XCTAssertNil(builder.headers["X-Empty"])
    }

    func testBaseExecuteStubReturnsRequestTaskWithoutCallingCompletion() {
        let builder = RequestBuilder<Data>(
            method: "GET",
            URLString: "https://example.com/v4.0/thing",
            parameters: nil,
            requiresAuthentication: false,
            apiConfiguration: AsposeBarcodeCloudAPIConfiguration()
        )

        // The base stub returns its request task (non-optional) without ever
        // invoking the completion; an inverted expectation fails if it does.
        let completionCalled = expectation(description: "completion must not be called")
        completionCalled.isInverted = true
        builder.execute { _ in completionCalled.fulfill() }
        wait(for: [completionCalled], timeout: 0.2)
    }
}
