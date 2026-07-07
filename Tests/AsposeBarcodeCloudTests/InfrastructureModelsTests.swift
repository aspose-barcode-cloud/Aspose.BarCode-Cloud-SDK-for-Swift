import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for the response and error infrastructure:
/// `NullEncodable`, `Response`, `RequestTask`, the infrastructure error
/// enums, and `AsposeBarcodeCloudClientError` descriptions. No network
/// access.
final class InfrastructureModelsTests: XCTestCase {
    // MARK: - Models.swift infrastructure

    func testNullEncodableEncodingVariants() throws {
        struct Holder: Codable, Equatable {
            var value: NullEncodable<Int>
        }

        let encoder = JSONEncoder()

        let withValue = try encoder.encode(Holder(value: .encodeValue(5)))
        XCTAssertEqual(String(data: withValue, encoding: .utf8), "{\"value\":5}")

        let withNull = try encoder.encode(Holder(value: .encodeNull))
        XCTAssertEqual(String(data: withNull, encoding: .utf8), "{\"value\":null}")

        // Inside a synthesized keyed container, encodeNothing yields an empty
        // nested container that still decodes back to .encodeNothing.
        let withNothing = try encoder.encode(Holder(value: .encodeNothing))
        XCTAssertEqual(String(data: withNothing, encoding: .utf8), "{\"value\":{}}")

        // Decoding round-trips value and null.
        XCTAssertEqual(try JSONDecoder().decode(Holder.self, from: withValue).value, .encodeValue(5))
        XCTAssertEqual(try JSONDecoder().decode(Holder.self, from: withNull).value, .encodeNull)
        XCTAssertEqual(try JSONDecoder().decode(Holder.self, from: withNothing).value, .encodeNothing)

        XCTAssertEqual(NullEncodable<Int>.encodeValue(5).hashValue, NullEncodable<Int>.encodeValue(5).hashValue)
    }

    func testResponseInitFromHTTPURLResponse() throws {
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 201,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!

        let response = Response(response: httpResponse, body: "body", bodyData: Data("body".utf8))
        XCTAssertEqual(response.statusCode, 201)
        XCTAssertEqual(response.header["Content-Type"], "application/json")
        XCTAssertEqual(response.body, "body")

        let manual = Response(statusCode: 200, header: [:], body: 5, bodyData: nil)
        XCTAssertEqual(manual.statusCode, 200)
        XCTAssertNil(manual.bodyData)
    }

    func testRequestTaskCancelIsSafe() {
        let task = RequestTask()
        // Cancelling without a set task must not crash.
        task.cancel()
        XCTAssertNil(task.get())
    }

    func testInfrastructureErrorTypesAreConstructible() {
        let errors: [Error] = [
            ErrorResponse.error(400, nil, nil, DecodableRequestBuilderError.emptyDataResponse),
            DownloadException.responseDataMissing,
            DownloadException.responseFailed,
            DownloadException.requestMissing,
            DownloadException.requestMissingPath,
            DownloadException.requestMissingURL,
            DecodableRequestBuilderError.nilHTTPResponse,
            DecodableRequestBuilderError.unsuccessfulHTTPStatusCode,
            DecodableRequestBuilderError.generalError(DownloadException.responseFailed),
        ]
        XCTAssertEqual(errors.count, 9)
    }

    // MARK: - Client error descriptions

    func testClientErrorDescriptions() {
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.missingCredentials.description,
            "Access token or clientId/clientSecret are required"
        )
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.invalidTokenURL("bad url").description,
            "Invalid token URL: bad url"
        )
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.invalidTokenResponse.description,
            "Token response does not contain access_token"
        )
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.tokenRequestFailed(statusCode: 401, body: "denied").description,
            "Token request failed with status 401: denied"
        )
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.tokenRequestFailed(statusCode: 500, body: nil).description,
            "Token request failed with status 500"
        )
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.tokenRequestFailed(statusCode: 500, body: "").description,
            "Token request failed with status 500"
        )

        struct SampleError: LocalizedError {
            var errorDescription: String? { "transport boom" }
        }
        XCTAssertEqual(
            AsposeBarcodeCloudClientError.transportError(SampleError()).description,
            "transport boom"
        )
    }
}
