import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let generateParams = GenerateParams(
    barcodeType: .code128,
    encodeData: EncodeData(data: "Aspose.BarCode Cloud"),
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .png,
        units: .millimeter,
        imageHeight: 30,
        imageWidth: 80
    )
)

let imageData = try await GenerateAPI.generateBody(
    generateParams: generateParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "code128.png"))
print("File 'code128.png' generated.")
