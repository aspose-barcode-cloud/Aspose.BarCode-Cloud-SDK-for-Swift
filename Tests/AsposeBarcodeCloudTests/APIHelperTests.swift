import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for `APIHelper` in
/// `Infrastructure/APIHelper.swift`: nil rejection, header flattening, value
/// conversions, and path/query item mapping. No network access.
final class APIHelperTests: XCTestCase {
    func testAPIHelperRejectNilAndHeaders() {
        XCTAssertNil(APIHelper.rejectNil(["a": nil, "b": nil]))

        let rejected = APIHelper.rejectNil(["a": 1, "b": nil])
        XCTAssertEqual(rejected?.count, 1)
        XCTAssertEqual(rejected?["a"] as? Int, 1)

        let headers = APIHelper.rejectNilHeaders([
            "single": "value",
            "list": ["x", nil, "y"] as [String?],
            "missing": nil,
        ])
        XCTAssertEqual(headers["single"], "value")
        XCTAssertEqual(headers["list"], "x,y")
        XCTAssertNil(headers["missing"])
    }

    func testAPIHelperConversions() {
        XCTAssertNil(APIHelper.convertBoolToString(nil))
        let converted = APIHelper.convertBoolToString(["flag": true, "count": 3])
        XCTAssertEqual(converted?["flag"] as? String, "true")
        XCTAssertEqual(converted?["count"] as? Int, 3)

        XCTAssertNil(APIHelper.convertAnyToString(nil))
        XCTAssertEqual(APIHelper.convertAnyToString("plain"), "plain")
        XCTAssertEqual(APIHelper.convertAnyToString(BarcodeImageFormat.png), "Png")

        XCTAssertEqual(APIHelper.mapValueToPathItem(["a", nil, "b"] as [Any?]) as? String, "a,b")
        XCTAssertEqual(APIHelper.mapValueToPathItem(EncodeDataType.hexBytes) as? String, "HexBytes")
        XCTAssertEqual(APIHelper.mapValueToPathItem(5) as? Int, 5)
    }

    func testAPIHelperQueryItemMapping() {
        XCTAssertNil(APIHelper.mapValuesToQueryItems(["a": Optional<any Sendable>.none]))

        let exploded = APIHelper.mapValuesToQueryItems([
            "single": "value",
            "list": ["a", "b"] as [String?],
            "skip": Optional<any Sendable>.none,
        ])
        XCTAssertEqual(exploded?.filter { $0.name == "list" }.count, 2)
        XCTAssertEqual(exploded?.first { $0.name == "single" }?.value, "value")

        let explodeControlled = APIHelper.mapValuesToQueryItems([
            "joined": (wrappedValue: ["a", "b"] as [String?], isExplode: false),
            "spread": (wrappedValue: ["c", "d"] as [String?], isExplode: true),
            "scalar": (wrappedValue: "z", isExplode: true),
            "skip": (wrappedValue: Optional<any Sendable>.none, isExplode: true),
        ])
        XCTAssertEqual(explodeControlled?.first { $0.name == "joined" }?.value, "a,b")
        XCTAssertEqual(explodeControlled?.filter { $0.name == "spread" }.count, 2)
        XCTAssertEqual(explodeControlled?.first { $0.name == "scalar" }?.value, "z")

        XCTAssertNil(APIHelper.mapValuesToQueryItems([String: (wrappedValue: (any Sendable)?, isExplode: Bool)]()))
    }
}
