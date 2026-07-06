import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generateMultipart(
    barcodeType: .code128,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .png,
        units: .pixel,
        resolution: 200,
        imageHeight: 160,
        imageWidth: 420
    ),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "code128.png"))
print("File 'code128.png' generated.")
