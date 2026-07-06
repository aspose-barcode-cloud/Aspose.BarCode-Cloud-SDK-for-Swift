import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let hexText = "4173706F73652E426172436F64652E436C6F7564"
let imageData = try await GenerateAPI.generateMultipart(
    barcodeType: .qr,
    data: hexText,
    dataType: .hexBytes,
    barcodeImageParams: BarcodeImageParams(imageFormat: .png),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "qr.png"))
print("File 'qr.png' generated.")
