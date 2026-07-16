import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for the shared coding helpers:
/// `CodableHelper`, the `ParameterConvertible` and keyed-container extensions
/// in `Infrastructure/Extensions.swift`, `OpenISO8601DateFormatter`, and the
/// JSON encoding helpers. No network access.
final class CodingHelpersTests: XCTestCase {
    // MARK: - CodableHelper

    func testCodableHelperCustomCodersAndDateFormatter() {
        let helper = CodableHelper()

        let customEncoder = JSONEncoder()
        customEncoder.outputFormatting = [.sortedKeys]
        helper.jsonEncoder = customEncoder
        XCTAssertTrue(helper.jsonEncoder === customEncoder)

        let customDecoder = JSONDecoder()
        helper.jsonDecoder = customDecoder
        XCTAssertTrue(helper.jsonDecoder === customDecoder)

        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = "yyyy-MM-dd"
        customDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        helper.dateFormatter = customDateFormatter
        XCTAssertEqual(helper.dateFormatter.dateFormat, "yyyy-MM-dd")

        // decode/encode surface returns failures for bad input rather than crashing.
        let badResult = helper.decode(RegionPoint.self, from: Data("not json".utf8))
        if case .success = badResult {
            XCTFail("Expected decode failure for malformed JSON")
        }
    }

    // MARK: - Extensions (ParameterConvertible)

    func testParameterConvertibleScalars() throws {
        let helper = CodableHelper()
        XCTAssertEqual(true.asParameter(codableHelper: helper) as? Bool, true)
        XCTAssertEqual(Float(1.5).asParameter(codableHelper: helper) as? Float, 1.5)
        XCTAssertEqual(7.asParameter(codableHelper: helper) as? Int, 7)
        XCTAssertEqual(Int32(8).asParameter(codableHelper: helper) as? Int32, 8)
        XCTAssertEqual(Int64(9).asParameter(codableHelper: helper) as? Int64, 9)
        XCTAssertEqual(2.5.asParameter(codableHelper: helper) as? Double, 2.5)
        XCTAssertEqual(Decimal(3).asParameter(codableHelper: helper) as? Decimal, Decimal(3))
        XCTAssertEqual("text".asParameter(codableHelper: helper) as? String, "text")

        let url = try XCTUnwrap(URL(string: "https://example.com"))
        XCTAssertEqual(url.asParameter(codableHelper: helper) as? URL, url)

        let uuid = UUID()
        XCTAssertEqual(uuid.asParameter(codableHelper: helper) as? UUID, uuid)

        // RawRepresentable delegates to its raw value.
        XCTAssertEqual(BarcodeImageFormat.png.asParameter(codableHelper: helper) as? String, "Png")

        // Data base64-encodes.
        XCTAssertEqual(Data([1, 2, 3]).asParameter(codableHelper: helper) as? String, Data([1, 2, 3]).base64EncodedString())

        // Date serializes via the helper's ISO-8601 formatter in UTC. Pin the
        // deterministic prefix; only the zone suffix (Z/+00:00) varies by platform.
        let date = Date(timeIntervalSince1970: 0)
        let dateParam = try XCTUnwrap(date.asParameter(codableHelper: helper) as? String)
        XCTAssertTrue(dateParam.hasPrefix("1970-01-01T00:00:00.000"), "unexpected date serialization: \(dateParam)")
    }

    func testParameterConvertibleCollections() {
        let helper = CodableHelper()

        let array = [1, 2, 3].asParameter(codableHelper: helper) as? [any Sendable]
        XCTAssertEqual(array?.count, 3)

        let set: Set = [1, 2, 3]
        let setParam = set.asParameter(codableHelper: helper) as? [any Sendable]
        XCTAssertEqual(setParam?.count, 3)

        let dictionary = ["a": 1, "b": 2].asParameter(codableHelper: helper) as? [String: any Sendable]
        XCTAssertEqual(dictionary?.count, 2)
        XCTAssertEqual(dictionary?["a"] as? Int, 1)
    }

    func testStringCodingKeyConformance() {
        let key = String(stringValue: "field")
        XCTAssertEqual(key?.stringValue, "field")
        XCTAssertNil("field".intValue)
        XCTAssertNil(String(intValue: 3))
    }

    func testKeyedContainerArrayAndDecimalHelpers() throws {
        let holder = try DecimalHolder(
            decimalValue: XCTUnwrap(Decimal(string: "12.34")),
            optionalDecimal: XCTUnwrap(Decimal(string: "5.6")),
            array: [1, 2, 3],
            optionalArray: [4, 5]
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(holder)

        // Decimal is encoded as a string per the generated extension.
        let raw = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertEqual(raw?["decimalValue"] as? String, "12.34")

        let decoded = try JSONDecoder().decode(DecimalHolder.self, from: data)
        XCTAssertEqual(decoded, holder)

        // Missing optional decimal decodes to nil.
        let noOptional = DecimalHolder(
            decimalValue: Decimal(1),
            optionalDecimal: nil,
            array: [7],
            optionalArray: nil
        )
        let roundTripped = try JSONDecoder().decode(
            DecimalHolder.self,
            from: encoder.encode(noOptional)
        )
        XCTAssertEqual(roundTripped, noOptional)

        // A non-numeric string fails Decimal decoding.
        let bad = Data("{\"decimalValue\":\"not-a-number\",\"array\":[]}".utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(DecimalHolder.self, from: bad))
    }

    func testKeyedContainerMapHelpers() throws {
        let holder = MapHolder(values: ["a": 1, "b": 2])
        let data = try JSONEncoder().encode(holder)
        let decoded = try JSONDecoder().decode(MapHolder.self, from: data)
        XCTAssertEqual(decoded.values, holder.values)
    }

    // MARK: - OpenISO8601DateFormatter

    func testOpenISO8601DateFormatterParsesSupportedFormats() {
        let formatter = OpenISO8601DateFormatter()

        XCTAssertNotNil(formatter.date(from: "2023-11-14T22:13:20.000+00:00"))
        XCTAssertNotNil(formatter.date(from: "2023-11-14T22:13:20+00:00"))
        XCTAssertNotNil(formatter.date(from: "2023-11-14"))
        XCTAssertNil(formatter.date(from: "not a date"))

        // The formatter round-trips a date it produces itself.
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let formatted = formatter.string(from: now)
        XCTAssertEqual(formatter.date(from: formatted), now)
    }

    // MARK: - JSON encoding helpers

    func testJSONEncodingHelperAndDataEncoding() throws {
        let helper = CodableHelper()
        let request = ScanBase64Request(fileBase64: "aGVsbG8=")

        let params = JSONEncodingHelper.encodingParameters(forEncodableObject: request, codableHelper: helper)
        let jsonData = try XCTUnwrap(params?["jsonData"] as? Data)
        let object = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        XCTAssertEqual(object?["fileBase64"] as? String, "aGVsbG8=")

        // Nil object produces no parameters.
        let none: ScanBase64Request? = nil
        XCTAssertNil(JSONEncodingHelper.encodingParameters(forEncodableObject: none, codableHelper: helper))

        // JSONDataEncoding applies the body and content type.
        let encoded = try JSONDataEncoding().encode(
            request: URLRequest(url: XCTUnwrap(URL(string: "https://example.com"))),
            with: params
        )
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(encoded.httpBody, jsonData)

        // Empty parameters leave the request unchanged.
        let unchanged = try JSONDataEncoding().encode(
            request: URLRequest(url: XCTUnwrap(URL(string: "https://example.com"))),
            with: nil
        )
        XCTAssertNil(unchanged.httpBody)

        XCTAssertNil(JSONDataEncoding.encodingParameters(jsonData: nil))
        XCTAssertNil(JSONDataEncoding.encodingParameters(jsonData: Data()))
    }
}

// MARK: - Codable fixtures for KeyedContainer helper coverage

private struct DecimalHolder: Codable, Equatable {
    var decimalValue: Decimal
    var optionalDecimal: Decimal?
    var array: [Int]
    var optionalArray: [Int]?

    enum CodingKeys: String, CodingKey {
        case decimalValue
        case optionalDecimal
        case array
        case optionalArray
    }

    init(decimalValue: Decimal, optionalDecimal: Decimal?, array: [Int], optionalArray: [Int]?) {
        self.decimalValue = decimalValue
        self.optionalDecimal = optionalDecimal
        self.array = array
        self.optionalArray = optionalArray
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        decimalValue = try container.decode(Decimal.self, forKey: .decimalValue)
        optionalDecimal = try container.decodeIfPresent(Decimal.self, forKey: .optionalDecimal)
        array = try container.decodeArray(Int.self, forKey: .array)
        optionalArray = try container.decodeArrayIfPresent(Int.self, forKey: .optionalArray)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(decimalValue, forKey: .decimalValue)
        try container.encodeIfPresent(optionalDecimal, forKey: .optionalDecimal)
        try container.encodeArray(array, forKey: .array)
        try container.encodeArrayIfPresent(optionalArray, forKey: .optionalArray)
    }
}

private struct MapHolder: Codable {
    var values: [String: Int]

    init(values: [String: Int]) {
        self.values = values
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)
        values = try container.decodeMap(Int.self, excludedKeys: [])
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)
        try container.encodeMap(values)
    }
}
