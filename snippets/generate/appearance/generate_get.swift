import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let imageData = try await GenerateAPI.generate(
    barcodeType: .code128,
    data: "Aspose.BarCode Cloud",
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .png,
        textLocation: .above,
        rotationAngle: 90
    ),
    code128Params: Code128Params(code128EncodeMode: .codeB),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "code128-appearance.png"))
print("File 'code128-appearance.png' generated.")
