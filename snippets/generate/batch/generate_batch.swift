import AsposeBarcodeCloud
import Foundation

let client = AsposeBarcodeCloudClient(
    accessToken: ProcessInfo.processInfo.environment["TEST_CONFIGURATION_ACCESS_TOKEN"] ?? ""
)
let batch = BatchGenerateRequest(archiveFormat: .zip, items: [
    BatchGenerateItem(fileName: "qr.png", generation: GenerateParams(
        barcodeType: .qr, encodeData: EncodeData(data: "Batch example")
    )),
])
let data = try await GenerateAPI.generateBatch(
    batchGenerateRequest: batch, apiConfiguration: client.apiConfiguration
)
try data.write(to: URL(fileURLWithPath: "barcodes.zip"))
