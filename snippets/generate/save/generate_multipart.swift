import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generateMultipart(
    barcodeType: .pdf417,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: BarcodeImageParams(imageFormat: .png),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "pdf417.png"))
print("File 'pdf417.png' generated.")
