import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generateMultipart(
    barcodeType: .pdf417,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .gif,
        foregroundColor: "DarkGreen",
        backgroundColor: "LightYellow"
    ),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "colored-pdf417.gif"))
print("File 'colored-pdf417.gif' generated.")
