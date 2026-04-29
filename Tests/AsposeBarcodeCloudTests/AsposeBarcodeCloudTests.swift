import XCTest
@testable import AsposeBarcodeCloud

final class AsposeBarcodeCloudTests: XCTestCase {
    func testSdkMetadata() {
        XCTAssertEqual(AsposeBarcodeCloud.sdkName, "swift sdk")
        XCTAssertFalse(AsposeBarcodeCloud.sdkVersion.isEmpty)
    }
}
