import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try Data(contentsOf: URL(fileURLWithPath: "qr.png"))
let request = RecognizeBase64Request(
    barcodeTypes: [.qr],
    fileBase64: imageData.base64EncodedString()
)

let response = try await RecognizeAPI.recognizeBase64(
    recognizeBase64Request: request,
    apiConfiguration: client.apiConfiguration
)

print(response.barcodes?.first?.barcodeValue ?? "No barcode found")
