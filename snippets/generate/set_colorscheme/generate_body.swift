import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let generateParams = GenerateParams(
    barcodeType: .code39,
    encodeData: EncodeData(data: "Aspose"),
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .jpeg,
        foregroundColor: "Navy",
        backgroundColor: "White"
    )
)

let imageData = try await GenerateAPI.generateBody(
    generateParams: generateParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "colored-code39.jpeg"))
print("File 'colored-code39.jpeg' generated.")
