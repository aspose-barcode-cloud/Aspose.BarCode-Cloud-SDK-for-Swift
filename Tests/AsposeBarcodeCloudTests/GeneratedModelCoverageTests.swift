import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import XCTest
@testable import AsposeBarcodeCloud

/// Deterministic, offline coverage for the generated model types: every model
/// in `Models/` survives an encode/decode round trip with equality, hashing,
/// and its validation rules intact. No network access.
///
/// Enum round-trip and unknown-default fallback coverage lives in the sibling
/// `GeneratedEnumCoverageTests`.
final class GeneratedModelCoverageTests: XCTestCase {
    func testApiErrorRoundTripAndEquality() throws {
        let inner = ApiError(code: "inner", message: "inner message")
        let error = ApiError(
            code: "42",
            message: "boom",
            description: "detailed description",
            dateTime: Date(timeIntervalSince1970: 1_700_000_000),
            innerError: inner
        )

        let decoded = try roundTrip(error)
        XCTAssertEqual(decoded.code, "42")
        XCTAssertEqual(decoded.innerError?.code, "inner")

        let other = ApiError(code: "different", message: "boom")
        XCTAssertNotEqual(error, other)
    }

    func testApiErrorResponseRoundTrip() throws {
        let response = ApiErrorResponse(
            requestId: "req-1",
            error: ApiError(code: "1", message: "message")
        )
        let decoded = try roundTrip(response)
        XCTAssertEqual(decoded.requestId, "req-1")
        XCTAssertEqual(decoded.error.message, "message")
    }

    func testBarcodeResponseAndListRoundTrip() throws {
        let barcode = BarcodeResponse(
            barcodeValue: "hello",
            type: "QR",
            region: [RegionPoint(x: 1, y: 2), RegionPoint(x: 3, y: 4)],
            checksum: "chk"
        )
        let decodedBarcode = try roundTrip(barcode)
        XCTAssertEqual(decodedBarcode.region?.count, 2)
        XCTAssertEqual(decodedBarcode.region?.first, RegionPoint(x: 1, y: 2))

        let list = BarcodeResponseList(barcodes: [barcode])
        let decodedList = try roundTrip(list)
        XCTAssertEqual(decodedList.barcodes?.count, 1)

        let empty = BarcodeResponseList(barcodes: nil)
        XCTAssertNotEqual(list, empty)
    }

    func testRegionPointRoundTrip() throws {
        let point = RegionPoint(x: 10, y: 20)
        let decoded = try roundTrip(point)
        XCTAssertEqual(decoded.x, 10)
        XCTAssertEqual(decoded.y, 20)
        XCTAssertNotEqual(point, RegionPoint(x: 0, y: 0))
    }

    func testQrParamsRoundTrip() throws {
        let params = QrParams(
            qrEncodeMode: .auto,
            qrErrorLevel: .levelH,
            qrVersion: .version10,
            qrECIEncoding: .utf8,
            qrAspectRatio: 0.5,
            microQRVersion: .m2,
            rectMicroQrVersion: .r7x43
        )
        let decoded = try roundTrip(params)
        XCTAssertEqual(decoded.qrErrorLevel, .levelH)
        XCTAssertEqual(decoded.qrAspectRatio, 0.5)
        XCTAssertNotEqual(params, QrParams())

        // Validation rule is reachable and correct.
        XCTAssertEqual(try Validator.validate(Float(0.5), against: QrParams.qrAspectRatioRule), 0.5)
    }

    func testPdf417ParamsRoundTrip() throws {
        let params = Pdf417Params(
            pdf417EncodeMode: .binary,
            pdf417ErrorLevel: .level4,
            pdf417Truncate: true,
            pdf417Columns: 10,
            pdf417Rows: 20,
            pdf417AspectRatio: 3,
            pdf417ECIEncoding: .iso88591,
            pdf417IsReaderInitialization: false,
            pdf417MacroCharacters: .macro05,
            pdf417IsLinked: true,
            pdf417IsCode128Emulation: false
        )
        let decoded = try roundTrip(params)
        XCTAssertEqual(decoded.pdf417Columns, 10)
        XCTAssertEqual(decoded.pdf417Rows, 20)
        XCTAssertNotEqual(params, Pdf417Params())

        XCTAssertEqual(try Validator.validate(10, against: Pdf417Params.pdf417ColumnsRule), 10)
        XCTAssertEqual(try Validator.validate(20, against: Pdf417Params.pdf417RowsRule), 20)
        XCTAssertEqual(try Validator.validate(Float(3), against: Pdf417Params.pdf417AspectRatioRule), 3)
    }

    func testCode128ParamsRoundTrip() throws {
        let params = Code128Params(code128EncodeMode: .codeC)
        let decoded = try roundTrip(params)
        XCTAssertEqual(decoded.code128EncodeMode, .codeC)
        XCTAssertNotEqual(params, Code128Params(code128EncodeMode: .auto))
    }

    func testBarcodeImageParamsRoundTrip() throws {
        let params = BarcodeImageParams(
            imageFormat: .png,
            textLocation: .below,
            foregroundColor: "#FF000000",
            backgroundColor: "White",
            units: .millimeter,
            resolution: 96,
            imageHeight: 100,
            imageWidth: 200,
            rotationAngle: 90
        )
        let decoded = try roundTrip(params)
        XCTAssertEqual(decoded.imageFormat, .png)
        XCTAssertEqual(decoded.units, .millimeter)
        XCTAssertEqual(decoded.rotationAngle, 90)
        XCTAssertNotEqual(params, BarcodeImageParams())

        XCTAssertEqual(try Validator.validate(Float(96), against: BarcodeImageParams.resolutionRule), 96)
    }

    func testEncodeDataRoundTrip() throws {
        let data = EncodeData(dataType: .base64Bytes, data: "VGVzdA==")
        let decoded = try roundTrip(data)
        XCTAssertEqual(decoded.dataType, .base64Bytes)
        XCTAssertEqual(decoded.data, "VGVzdA==")
        XCTAssertNotEqual(data, EncodeData(data: "other"))

        XCTAssertEqual(try Validator.validate("VGVzdA==", against: EncodeData.dataRule), "VGVzdA==")
    }

    func testGenerateParamsRoundTrip() throws {
        let params = GenerateParams(
            barcodeType: .qr,
            encodeData: EncodeData(dataType: .stringData, data: "payload"),
            barcodeImageParams: BarcodeImageParams(imageFormat: .png),
            qrParams: QrParams(qrErrorLevel: .levelM),
            code128Params: Code128Params(code128EncodeMode: .auto),
            pdf417Params: Pdf417Params(pdf417Columns: 5)
        )
        let decoded = try roundTrip(params)
        XCTAssertEqual(decoded.barcodeType, .qr)
        XCTAssertEqual(decoded.encodeData.data, "payload")
        XCTAssertEqual(decoded.qrParams?.qrErrorLevel, .levelM)

        let minimal = GenerateParams(barcodeType: .code128, encodeData: EncodeData(data: "x"))
        XCTAssertNotEqual(params, minimal)
    }

    func testRecognizeBase64RequestRoundTrip() throws {
        let request = RecognizeBase64Request(
            barcodeTypes: [.qr, .code128],
            fileBase64: "aGVsbG8=",
            recognitionMode: .excellent,
            recognitionImageKind: .photo
        )
        let decoded = try roundTrip(request)
        XCTAssertEqual(decoded.barcodeTypes, [.qr, .code128])
        XCTAssertEqual(decoded.recognitionMode, .excellent)
        XCTAssertNotEqual(request, RecognizeBase64Request(barcodeTypes: [.qr], fileBase64: "aGVsbG8="))

        XCTAssertEqual(
            try Validator.validate("aGVsbG8=", against: RecognizeBase64Request.fileBase64Rule),
            "aGVsbG8="
        )
    }

    func testScanBase64RequestRoundTrip() throws {
        let request = ScanBase64Request(fileBase64: "aGVsbG8=")
        let decoded = try roundTrip(request)
        XCTAssertEqual(decoded.fileBase64, "aGVsbG8=")
        XCTAssertNotEqual(request, ScanBase64Request(fileBase64: "other"))

        XCTAssertEqual(
            try Validator.validate("aGVsbG8=", against: ScanBase64Request.fileBase64Rule),
            "aGVsbG8="
        )
    }

    private func roundTrip<T: Codable & Hashable>(
        _ value: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> T {
        let helper = CodableHelper()
        let data = try helper.encode(value).get()
        let decoded = try helper.decode(T.self, from: data).get()
        XCTAssertEqual(decoded, value, file: file, line: line)
        XCTAssertEqual(decoded.hashValue, value.hashValue, file: file, line: line)
        return decoded
    }
}
