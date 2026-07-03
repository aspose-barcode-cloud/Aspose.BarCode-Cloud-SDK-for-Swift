import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generate(
    barcodeType: .qr,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .png,
        foregroundColor: "#FF0000",
        backgroundColor: "#FFFF00"
    ),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "colored-qr.png"))
print("File 'colored-qr.png' generated.")
