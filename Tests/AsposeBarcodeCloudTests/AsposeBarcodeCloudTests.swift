import Foundation
import XCTest
@testable import AsposeBarcodeCloud

final class AsposeBarcodeCloudTests: XCTestCase {
    override func tearDown() {
        AsposeBarcodeCloudClient.resetGlobalConfiguration()
        super.tearDown()
    }

    func testDefaultBasePath() {
        XCTAssertEqual(AsposeBarcodeCloudAPI.basePath, "https://api.aspose.cloud/v4.0")
    }

    func testTokenRequestUsesClientCredentialsFormBody() throws {
        let configuration = AsposeBarcodeCloudConfiguration(
            clientId: "client id",
            clientSecret: "secret/value",
            tokenURL: "https://id.example.test/connect/token",
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

        XCTAssertEqual(request.url?.absoluteString, "https://id.example.test/connect/token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.timeoutInterval, 42)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(bodyItems["grant_type"], "client_credentials")
        XCTAssertEqual(bodyItems["client_id"], "client id")
        XCTAssertEqual(bodyItems["client_secret"], "secret/value")
    }

    func testAccessTokenConfigurationAppliesHeadersToGeneratedRequests() {
        let client = AsposeBarcodeCloudClient(
            configuration: AsposeBarcodeCloudConfiguration(
                accessToken: "test-token",
                host: "https://api.example.test/v4.0",
                sdkName: "custom swift sdk",
                sdkVersion: "1.2.3"
            )
        )

        client.apply()

        let requestBuilder = GenerateAPI.generateWithRequestBuilder(barcodeType: .qr, data: "hello")
        let headers = (requestBuilder as! URLSessionRequestBuilder<Data>).buildHeaders()

        XCTAssertEqual(AsposeBarcodeCloudAPI.basePath, "https://api.example.test/v4.0")
        XCTAssertEqual(headers["Authorization"], "Bearer test-token")
        XCTAssertEqual(headers["x-aspose-client"], "custom swift sdk")
        XCTAssertEqual(headers["x-aspose-client-version"], "1.2.3")
    }

    func testAuthorizeUsesInjectedTokenFetcher() throws {
        let configuration = AsposeBarcodeCloudConfiguration(
            clientId: "client-id",
            clientSecret: "client-secret"
        )

        let client = AsposeBarcodeCloudClient(configuration: configuration) { configuration, completion in
            XCTAssertEqual(configuration.clientId, "client-id")
            XCTAssertEqual(configuration.clientSecret, "client-secret")
            completion(.success("fetched-token"))
        }

        let token = try client.authorize()

        XCTAssertEqual(token, "fetched-token")
        XCTAssertEqual(configuration.accessToken, "fetched-token")
        XCTAssertEqual(AsposeBarcodeCloudAPI.customHeaders["Authorization"], "Bearer fetched-token")
        XCTAssertEqual(AsposeBarcodeCloudAPI.customHeaders["x-aspose-client"], "swift sdk")
        XCTAssertEqual(AsposeBarcodeCloudAPI.customHeaders["x-aspose-client-version"], "26.4.0")
    }

    func testAuthorizeFailsWithoutTokenOrCredentials() {
        let client = AsposeBarcodeCloudClient(configuration: AsposeBarcodeCloudConfiguration())

        do {
            _ = try client.authorize()
            XCTFail("Expected missing credentials error")
        } catch AsposeBarcodeCloudClientError.missingCredentials {
            // Expected path.
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGenerateSmokeWhenIntegrationEnvironmentIsEnabled() throws {
        guard try applyIntegrationClientIfEnabled() else {
            return
        }

        let (responseData, responseError) = generateBarcodeData("Aspose.BarCode Swift SDK")

        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
        XCTAssertGreaterThan(responseData?.count ?? 0, 0)
    }

    func testGenerateScanAndRecognizeBase64SmokeWhenIntegrationEnvironmentIsEnabled() throws {
        guard try applyIntegrationClientIfEnabled() else {
            return
        }

        let barcodeValue = "Aspose.BarCode Swift SDK live roundtrip"
        let (generatedData, generateError) = generateBarcodeData(barcodeValue)
        XCTAssertNil(generateError)

        let fileBase64 = try XCTUnwrap(generatedData).base64EncodedString()

        let (scanResponse, scanError) = scanBase64(fileBase64)
        XCTAssertNil(scanError)
        XCTAssertEqual(scanResponse?.barcodes?.first?.barcodeValue, barcodeValue)

        let (recognizeResponse, recognizeError) = recognizeBase64(fileBase64, barcodeType: .qr)
        XCTAssertNil(recognizeError)
        XCTAssertEqual(recognizeResponse?.barcodes?.first?.barcodeValue, barcodeValue)
    }

    private func applyIntegrationClientIfEnabled() throws -> Bool {
        let environment = ProcessInfo.processInfo.environment
        guard environment["ASPOSE_RUN_INTEGRATION_TESTS"] == "true" else {
            return false
        }

        if let token = environment["TEST_CONFIGURATION_ACCESS_TOKEN"], !token.isEmpty {
            AsposeBarcodeCloudClient(accessToken: token).apply()
            return true
        }

        if let clientId = environment["ASPOSE_CLIENT_ID"], !clientId.isEmpty,
           let clientSecret = environment["ASPOSE_CLIENT_SECRET"], !clientSecret.isEmpty {
            let client = AsposeBarcodeCloudClient(clientId: clientId, clientSecret: clientSecret)
            try client.authorize()
            return true
        }

        return false
    }

    private func generateBarcodeData(_ value: String) -> (Data?, Error?) {
        let expectation = self.expectation(description: "generate barcode")
        var responseData: Data?
        var responseError: Error?

        GenerateAPI.generate(barcodeType: .qr, data: value, imageFormat: .png) { data, error in
            responseData = data
            responseError = error
            expectation.fulfill()
        }

        waitForExpectations(timeout: 60)

        return (responseData, responseError)
    }

    private func scanBase64(_ fileBase64: String) -> (BarcodeResponseList?, Error?) {
        let expectation = self.expectation(description: "scan barcode")
        var response: BarcodeResponseList?
        var responseError: Error?

        ScanAPI.scanBase64(scanBase64Request: ScanBase64Request(fileBase64: fileBase64)) { data, error in
            response = data
            responseError = error
            expectation.fulfill()
        }

        waitForExpectations(timeout: 60)

        return (response, responseError)
    }

    private func recognizeBase64(_ fileBase64: String, barcodeType: DecodeBarcodeType) -> (BarcodeResponseList?, Error?) {
        let expectation = self.expectation(description: "recognize barcode")
        var response: BarcodeResponseList?
        var responseError: Error?

        let request = RecognizeBase64Request(
            barcodeTypes: [barcodeType],
            fileBase64: fileBase64
        )

        RecognizeAPI.recognizeBase64(recognizeBase64Request: request) { data, error in
            response = data
            responseError = error
            expectation.fulfill()
        }

        waitForExpectations(timeout: 60)

        return (response, responseError)
    }
}
