import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let encodedText = Data("Aspose.BarCode.Cloud".utf8).base64EncodedString()
let generateParams = GenerateParams(
    barcodeType: .qr,
    encodeData: EncodeData(dataType: .base64Bytes, data: encodedText),
    barcodeImageParams: BarcodeImageParams(imageFormat: .png)
)

let imageData = try await GenerateAPI.generateBody(
    generateParams: generateParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "qr.png"))
print("File 'qr.png' generated.")
