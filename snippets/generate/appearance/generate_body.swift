import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let generateParams = GenerateParams(
    barcodeType: .qr,
    encodeData: EncodeData(data: "Aspose.BarCode Cloud"),
    barcodeImageParams: BarcodeImageParams(
        imageFormat: .jpeg,
        foregroundColor: "DarkBlue",
        backgroundColor: "White",
        rotationAngle: 180
    ),
    qrParams: QrParams(
        qrEncodeMode: .auto,
        qrErrorLevel: .levelH,
        qrVersion: .auto
    )
)

let imageData = try await GenerateAPI.generateBody(
    generateParams: generateParams,
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "qr-appearance.jpeg"))
print("File 'qr-appearance.jpeg' generated.")
