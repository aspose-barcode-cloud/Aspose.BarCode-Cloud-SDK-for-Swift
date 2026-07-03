import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let generateParams = GenerateParams(
    barcodeType: .qr,
    encodeData: EncodeData(dataType: .stringData, data: "Aspose.BarCode Cloud"),
    barcodeImageParams: BarcodeImageParams(imageFormat: .jpeg)
)

let imageData = try await GenerateAPI.generateBody(
    generateParams: generateParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "qrcode.jpeg"))
print("File 'qrcode.jpeg' generated.")
