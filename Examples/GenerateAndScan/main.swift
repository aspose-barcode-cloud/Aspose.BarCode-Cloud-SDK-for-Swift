import AsposeBarcodeCloud
import Foundation

let environment = ProcessInfo.processInfo.environment

let client: AsposeBarcodeCloudClient
if let accessToken = environment["TEST_CONFIGURATION_ACCESS_TOKEN"], !accessToken.isEmpty {
    client = AsposeBarcodeCloudClient(accessToken: accessToken)
} else if let clientId = environment["TEST_CONFIGURATION_CLIENT_ID"],
          let clientSecret = environment["TEST_CONFIGURATION_CLIENT_SECRET"],
          !clientId.isEmpty, !clientSecret.isEmpty
{
    client = AsposeBarcodeCloudClient(clientId: clientId, clientSecret: clientSecret)
} else {
    print("Set TEST_CONFIGURATION_ACCESS_TOKEN or TEST_CONFIGURATION_CLIENT_ID/TEST_CONFIGURATION_CLIENT_SECRET.")
    exit(1)
}

let barcodeValue = CommandLine.arguments.dropFirst().first ?? "Aspose.BarCode Cloud Swift example"

print("Generating QR barcode...")
let imageData = try await GenerateAPI.generate(
    barcodeType: .qr,
    data: barcodeValue,
    imageFormat: .png,
    apiConfiguration: client.apiConfiguration
)
try imageData.write(to: URL(fileURLWithPath: "QR.png"))
print("Generated image saved to QR.png")

print("Scanning generated barcode...")
let response = try await ScanAPI.scanBase64(
    scanBase64Request: ScanBase64Request(fileBase64: imageData.base64EncodedString()),
    apiConfiguration: client.apiConfiguration
)

if let first = response.barcodes?.first {
    print("Recognized type: \(first.type ?? "")")
    print("Recognized value: \(first.barcodeValue ?? "")")
} else {
    print("No barcodes recognized.")
}
