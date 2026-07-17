import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for the generated enum types: every enum
/// round-trips through the coding helpers and falls back to its last case
/// (unknown_default_open_api) for unrecognized raw values. No network access.
final class GeneratedEnumCoverageTests: XCTestCase {
    func testAllEnumsRoundTripAndFallBackToLastCase() throws {
        try exerciseEnum(EncodeBarcodeType.self)
        try exerciseEnum(DecodeBarcodeType.self)
        try exerciseEnum(EncodeDataType.self)
        try exerciseEnum(BarcodeImageFormat.self)
        try exerciseEnum(CodeLocation.self)
        try exerciseEnum(GraphicsUnit.self)
        try exerciseEnum(Code128EncodeMode.self)
        try exerciseEnum(QREncodeMode.self)
        try exerciseEnum(QRErrorLevel.self)
        try exerciseEnum(QRVersion.self)
        try exerciseEnum(MicroQRVersion.self)
        try exerciseEnum(RectMicroQRVersion.self)
        try exerciseEnum(ECIEncodings.self)
        try exerciseEnum(MacroCharacter.self)
        try exerciseEnum(Pdf417EncodeMode.self)
        try exerciseEnum(Pdf417ErrorLevel.self)
        try exerciseEnum(RecognitionMode.self)
        try exerciseEnum(RecognitionImageKind.self)
    }

    private func exerciseEnum<T: CaseIterableDefaultsLast & Codable & Equatable>(
        _: T.Type,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws where T.RawValue == String {
        let helper = CodableHelper()

        for value in T.allCases {
            XCTAssertFalse(value.rawValue.isEmpty, file: file, line: line)
            let data = try helper.encode([value]).get()
            let decoded = try helper.decode([T].self, from: data).get()
            XCTAssertEqual(decoded, [value], file: file, line: line)
        }

        // Unknown raw values decode to the last case (unknown_default_open_api).
        let unknownData = Data("[\"__unknown_raw_value__\"]".utf8)
        let decodedUnknown = try helper.decode([T].self, from: unknownData).get()
        XCTAssertEqual(decodedUnknown.first, T.allCases.last, file: file, line: line)
    }
}
