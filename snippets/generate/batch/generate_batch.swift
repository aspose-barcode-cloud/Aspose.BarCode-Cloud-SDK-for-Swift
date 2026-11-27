import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    clientId: "Client Id from https://dashboard.aspose.cloud/applications",
    clientSecret: "Client Secret from https://dashboard.aspose.cloud/applications"
)

let batch = BatchGenerateRequest(archiveFormat: .zip, items: [
    BatchGenerateItem(fileName: "qr.png", generation: GenerateParams(
        barcodeType: .qr, encodeData: EncodeData(data: "Batch example")
    )),
])

let archiveData = try await GenerateAPI.generateBatch(
    batchGenerateRequest: batch,
    apiConfiguration: client.apiConfiguration
)

try archiveData.write(to: URL(fileURLWithPath: "barcodes.zip"))
print("File 'barcodes.zip' generated.")
