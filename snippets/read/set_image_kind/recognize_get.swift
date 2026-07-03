import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let response = try await RecognizeAPI.recognize(
    barcodeType: .qr,
    fileUrl: "https://products.aspose.app/barcode/scan/img/how-to/scan/step2.png",
    recognitionImageKind: .clearImage,
    apiConfiguration: client.apiConfiguration
)

print(response.barcodes?.first?.barcodeValue ?? "No barcode found")
