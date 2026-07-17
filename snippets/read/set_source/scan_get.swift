import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)
let barcodeImageURL =
    ProcessInfo.processInfo.environment["TEST_CONFIGURATION_BARCODE_IMAGE_URL"]
        ?? "https://raw.githubusercontent.com/aspose-barcode-cloud/Aspose.BarCode-Cloud-SDK-for-Swift/main/testdata/QR_and_Code128.png"

let response = try await ScanAPI.scan(
    fileUrl: barcodeImageURL,
    apiConfiguration: client.apiConfiguration
)

print(response.barcodes?.first?.barcodeValue ?? "No barcode found")
