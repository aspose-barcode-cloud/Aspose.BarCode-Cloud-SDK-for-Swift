import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generate(
    barcodeType: .qr,
    data: "Aspose.BarCode.Cloud",
    dataType: .stringData,
    barcodeImageParams: BarcodeImageParams(imageFormat: .png),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "qr.png"))
print("File 'qr.png' generated.")
