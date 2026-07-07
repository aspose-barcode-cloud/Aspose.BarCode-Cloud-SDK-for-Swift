import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Offline coverage for small infrastructure utilities: `JSONValue` convenience
/// initializers, numeric validation defaults, `SynchronizedDictionary` reads,
/// `JSONEncodingHelper` failure handling, and token-request construction errors.
final class InfrastructureUtilityTests: XCTestCase {
    // MARK: - JSONValue convenience initializers

    func testJSONValueConvenienceInitializers() {
        // Variables (not literals) select the typed initializers rather than the
        // ExpressibleBy*Literal conformances.
        let string = "hello"
        let int = 7
        let double = 1.5
        let bool = true

        XCTAssertEqual(JSONValue(string), .string("hello"))
        XCTAssertEqual(JSONValue(int), .int(7))
        XCTAssertEqual(JSONValue(double), .double(1.5))
        XCTAssertEqual(JSONValue(bool), .bool(true))
    }

    func testJSONValueIsStringFalseForNonString() {
        XCTAssertFalse(JSONValue.int(1).isString)
        XCTAssertTrue(JSONValue.string("x").isString)
    }

    // MARK: - Numeric validation defaults

    func testNumericRuleUsesDefaultExclusiveFlags() throws {
        // Omitting exclusiveMinimum/exclusiveMaximum exercises their `= false` defaults.
        let rule = NumericRule<Int>(minimum: 0, maximum: 10)
        XCTAssertEqual(try Validator.validate(5, against: rule), 5)
        XCTAssertEqual(try Validator.validate(0, against: rule), 0)
        XCTAssertEqual(try Validator.validate(10, against: rule), 10)
    }

    // MARK: - SynchronizedDictionary

    func testSynchronizedDictionaryReadAndWrite() {
        let dictionary = SynchronizedDictionary<String, Int>()
        dictionary["a"] = 1
        XCTAssertEqual(dictionary["a"], 1)
        XCTAssertNil(dictionary["missing"])
    }

    // MARK: - JSONEncodingHelper failure

    func testEncodingParametersReturnsNilOnEncodingFailure() {
        struct NonFinite: Encodable {
            let value = Double.infinity
        }

        let parameters = JSONEncodingHelper.encodingParameters(
            forEncodableObject: NonFinite(),
            codableHelper: CodableHelper()
        )
        XCTAssertNil(parameters)
    }

    func testEncodingParametersReturnsNilForNilObject() {
        let parameters = JSONEncodingHelper.encodingParameters(
            forEncodableObject: Optional<GenerateParams>.none,
            codableHelper: CodableHelper()
        )
        XCTAssertNil(parameters)
    }

    // MARK: - Token request construction errors

    func testMakeTokenRequestMissingCredentials() {
        let configuration = AsposeBarcodeCloudConfiguration(host: "https://example.com/v4.0")
        XCTAssertThrowsError(try configuration.makeTokenRequest()) { error in
            guard case AsposeBarcodeCloudClientError.missingCredentials = error else {
                return XCTFail("expected missingCredentials, got \(error)")
            }
        }
    }

    func testMakeTokenRequestInvalidTokenURL() {
        let configuration = AsposeBarcodeCloudConfiguration(
            clientId: "id",
            clientSecret: "secret",
            tokenURL: "http://a b c"
        )
        XCTAssertThrowsError(try configuration.makeTokenRequest()) { error in
            guard case AsposeBarcodeCloudClientError.invalidTokenURL = error else {
                return XCTFail("expected invalidTokenURL, got \(error)")
            }
        }
    }
}
