import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for `JSONValue` in
/// `Infrastructure/JSONValue.swift`: convenience initializers, typed
/// accessors, literals, subscripts, and Codable round trips. No network
/// access.
final class JSONValueTests: XCTestCase {
    func testJSONValueConvenienceInitsAndAccessors() {
        XCTAssertTrue(JSONValue("text").isString)
        XCTAssertEqual(JSONValue("text").stringValue, "text")
        XCTAssertTrue(JSONValue(7).isInt)
        XCTAssertEqual(JSONValue(7).intValue, 7)
        XCTAssertTrue(JSONValue(1.5).isDouble)
        XCTAssertEqual(JSONValue(1.5).doubleValue, 1.5)
        XCTAssertTrue(JSONValue(true).isBool)
        XCTAssertEqual(JSONValue(true).boolValue, true)
        XCTAssertTrue(JSONValue([JSONValue(1)]).isArray)
        XCTAssertEqual(JSONValue([JSONValue(1)]).arrayValue?.count, 1)
        XCTAssertTrue(JSONValue(["k": JSONValue(1)]).isDictionary)
        XCTAssertEqual(JSONValue(["k": JSONValue(1)]).dictionaryValue?["k"], JSONValue(1))
        XCTAssertTrue(JSONValue(nilLiteral: ()).isNull)

        // Wrong-type accessors return nil.
        XCTAssertNil(JSONValue(7).stringValue)
        XCTAssertNil(JSONValue("x").intValue)
        XCTAssertNil(JSONValue("x").doubleValue)
        XCTAssertNil(JSONValue("x").boolValue)
        XCTAssertNil(JSONValue("x").arrayValue)
        XCTAssertNil(JSONValue("x").dictionaryValue)
        XCTAssertFalse(JSONValue("x").isInt)
        XCTAssertFalse(JSONValue("x").isDouble)
        XCTAssertFalse(JSONValue("x").isBool)
        XCTAssertFalse(JSONValue("x").isArray)
        XCTAssertFalse(JSONValue("x").isDictionary)
        XCTAssertFalse(JSONValue("x").isNull)
    }

    func testJSONValueLiteralsAndSubscripts() {
        let literal: JSONValue = [
            "string": "value",
            "int": 3,
            "double": 2.5,
            "bool": true,
            "array": [1, 2, 3],
            "null": nil,
        ]

        XCTAssertEqual(literal["string"], JSONValue("value"))
        XCTAssertEqual(literal["int"]?.intValue, 3)
        XCTAssertEqual(literal["double"]?.doubleValue, 2.5)
        XCTAssertEqual(literal["bool"]?.boolValue, true)
        XCTAssertTrue(literal["null"]?.isNull ?? false)
        XCTAssertNil(literal["missing"])

        let array = literal["array"]
        XCTAssertEqual(array?[0], JSONValue(1))
        XCTAssertEqual(array?[2], JSONValue(3))
        XCTAssertNil(array?[-1])
        XCTAssertNil(array?[10])

        // Subscripts on non-container values return nil.
        XCTAssertNil(JSONValue("scalar")["key"])
        XCTAssertNil(JSONValue("scalar")[0])
    }

    func testJSONValueEncodeDecodeRoundTrip() throws {
        let value: JSONValue = [
            "string": "value",
            "int": 42,
            "double": 3.14,
            "bool": false,
            "nested": ["array": [true, "mixed", 9]],
            "null": nil,
        ]

        let data = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(decoded["string"], JSONValue("value"))
        XCTAssertEqual(decoded["int"]?.intValue, 42)
        XCTAssertTrue(decoded["null"]?.isNull ?? false)
        XCTAssertEqual(decoded["nested"]?["array"]?[1], JSONValue("mixed"))
    }

    func testJSONValueFromCodable() throws {
        let value = try JSONValue(RegionPoint(x: 5, y: 6))
        XCTAssertEqual(value["x"]?.intValue, 5)
        XCTAssertEqual(value["y"]?.intValue, 6)
    }
}
