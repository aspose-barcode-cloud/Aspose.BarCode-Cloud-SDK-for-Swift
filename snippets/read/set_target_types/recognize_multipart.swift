import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try Data(contentsOf: URL(fileURLWithPath: "pdf417.png"))
let response = try await RecognizeAPI.recognizeMultipart(
    barcodeType: .pdf417,
    file: imageData,
    apiConfiguration: client.apiConfiguration
)

print(response.barcodes?.first?.barcodeValue ?? "No barcode found")
