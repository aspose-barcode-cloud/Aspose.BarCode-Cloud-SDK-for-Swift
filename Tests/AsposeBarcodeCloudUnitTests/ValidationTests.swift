import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for the `Validator` rules in
/// `Infrastructure/Validation.swift`: string, integer, float, and array
/// validation. No network access.
final class ValidationTests: XCTestCase {
    func testStringValidation() {
        let rule = StringRule(minLength: 2, maxLength: 5, pattern: "^[a-z]+$")
        XCTAssertEqual(try Validator.validate("abc", against: rule), "abc")

        assertStringValidationFails("1", against: rule, expected: [.minLength, .pattern])
        assertStringValidationFails("abcdef", against: rule, expected: [.maxLength])
        assertStringValidationFails("123", against: StringRule(minLength: nil, maxLength: nil, pattern: "^[a-z]+$"), expected: [.pattern])
    }

    private func assertStringValidationFails(
        _ value: String,
        against rule: StringRule,
        expected: Set<StringValidationErrorKind>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            _ = try Validator.validate(value, against: rule)
            XCTFail("Expected validation failure", file: file, line: line)
        } catch {
            XCTAssertEqual(error.kinds, expected, file: file, line: line)
        }
    }

    func testIntegerValidation() throws {
        let inclusive = NumericRule<Int>(minimum: 0, exclusiveMinimum: false, maximum: 10, exclusiveMaximum: false, multipleOf: 2)
        XCTAssertEqual(try Validator.validate(4, against: inclusive), 4)

        assertIntValidationFails(-1, against: inclusive, expected: [.minimum, .multipleOf])
        assertIntValidationFails(11, against: inclusive, expected: [.maximum, .multipleOf])

        let exclusive = NumericRule<Int>(minimum: 0, exclusiveMinimum: true, maximum: 10, exclusiveMaximum: true, multipleOf: nil)
        assertIntValidationFails(0, against: exclusive, expected: [.minimum])
        assertIntValidationFails(10, against: exclusive, expected: [.maximum])
        XCTAssertEqual(try Validator.validate(5, against: exclusive), 5)
    }

    private func assertIntValidationFails(
        _ value: Int,
        against rule: NumericRule<Int>,
        expected: Set<NumericValidationErrorKind>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            _ = try Validator.validate(value, against: rule)
            XCTFail("Expected validation failure", file: file, line: line)
        } catch {
            XCTAssertEqual(error.kinds, expected, file: file, line: line)
        }
    }

    func testFloatValidation() throws {
        let inclusive = NumericRule<Double>(minimum: 0, exclusiveMinimum: false, maximum: 10, exclusiveMaximum: false, multipleOf: 2)
        XCTAssertEqual(try Validator.validate(4.0, against: inclusive), 4.0)

        assertFloatValidationFails(-1, against: inclusive, expected: [.minimum, .multipleOf])
        assertFloatValidationFails(11, against: inclusive, expected: [.maximum, .multipleOf])

        let exclusive = NumericRule<Double>(minimum: 0, exclusiveMinimum: true, maximum: 10, exclusiveMaximum: true, multipleOf: nil)
        assertFloatValidationFails(0, against: exclusive, expected: [.minimum])
        assertFloatValidationFails(10, against: exclusive, expected: [.maximum])
    }

    private func assertFloatValidationFails(
        _ value: Double,
        against rule: NumericRule<Double>,
        expected: Set<NumericValidationErrorKind>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            _ = try Validator.validate(value, against: rule)
            XCTFail("Expected validation failure", file: file, line: line)
        } catch {
            XCTAssertEqual(error.kinds, expected, file: file, line: line)
        }
    }

    func testArrayValidation() throws {
        let rule = ArrayRule(minItems: 1, maxItems: 3, uniqueItems: true)
        XCTAssertEqual(try Validator.validate([1, 2, 3], against: rule), [1, 2, 3])

        do {
            _ = try Validator.validate([], against: rule)
            XCTFail("Expected minItems failure")
        } catch {
            XCTAssertEqual(error.kinds, [.minItems])
        }

        do {
            _ = try Validator.validate([1, 2, 3, 4], against: rule)
            XCTFail("Expected maxItems failure")
        } catch {
            XCTAssertEqual(error.kinds, [.maxItems])
        }

        do {
            _ = try Validator.validate([1, 1], against: rule)
            XCTFail("Expected uniqueItems failure")
        } catch {
            XCTAssertEqual(error.kinds, [.uniqueItems])
        }
    }
}
