import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline tests for `AsposeBarcodeCloudClient` and
/// `AsposeBarcodeCloudConfiguration`: default base path, token request shape,
/// custom headers, and the authorize flow. No network access.
final class ClientConfigurationTests: XCTestCase {
    func testDefaultBasePath() {
        let client = AsposeBarcodeCloudClient(configuration: AsposeBarcodeCloudConfiguration())
        XCTAssertEqual(client.apiConfiguration.basePath, "https://api.aspose.cloud/v4.0")
    }

    func testClientConvenienceInitializers() {
        let credentialsClient = AsposeBarcodeCloudClient(clientId: "id", clientSecret: "secret")
        XCTAssertEqual(credentialsClient.configuration.clientId, "id")
        XCTAssertEqual(credentialsClient.configuration.clientSecret, "secret")

        let tokenClient = AsposeBarcodeCloudClient(accessToken: "token")
        XCTAssertEqual(tokenClient.configuration.accessToken, "token")
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
            request: URLRequest(url: XCTUnwrap(URL(string: "https://example.com/v4.0/barcode/generate/QR"))),
            requestBuilder: XCTUnwrap(requestBuilder as? URLSessionRequestBuilder<Data>),
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

    // MARK: - Helpers

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
}
