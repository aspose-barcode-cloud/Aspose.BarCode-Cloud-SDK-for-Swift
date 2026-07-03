import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageParams = BarcodeImageParams(
    imageFormat: .png,
    units: .pixel,
    resolution: 300,
    imageHeight: 250,
    imageWidth: 500
)

let imageData = try await GenerateAPI.generate(
    barcodeType: .code128,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: imageParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "code128.png"))
print("File 'code128.png' generated.")
