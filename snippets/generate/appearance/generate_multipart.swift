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
        imageFormat: .svg,
        foregroundColor: "Black",
        backgroundColor: "White"
    ),
    pdf417Params: Pdf417Params(
        pdf417EncodeMode: .auto,
        pdf417ErrorLevel: .level4,
        pdf417Columns: 6,
        pdf417Rows: 12
    ),
    apiConfiguration: client.apiConfiguration
)

try imageData.write(to: URL(fileURLWithPath: "pdf417-appearance.svg"))
print("File 'pdf417-appearance.svg' generated.")
