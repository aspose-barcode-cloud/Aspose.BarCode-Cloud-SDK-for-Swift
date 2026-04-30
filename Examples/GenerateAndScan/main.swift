import Foundation
import AsposeBarcodeCloud

enum ExampleError: Error, CustomStringConvertible {
    case missingCredentials
    case emptyGenerateResponse
    case emptyScanResponse

    var description: String {
        switch self {
        case .missingCredentials:
            return "Set TEST_CONFIGURATION_ACCESS_TOKEN or ASPOSE_CLIENT_ID/ASPOSE_CLIENT_SECRET."
        case .emptyGenerateResponse:
            return "Generate API returned no image bytes."
        case .emptyScanResponse:
            return "Scan API returned no barcode values."
        }
    }
}

let callbackQueue = DispatchQueue.global(qos: .userInitiated)
let barcodeValue = CommandLine.arguments.dropFirst().first ?? "Aspose.BarCode Cloud Swift example"

do {
    try configureClient()

    print("Generating QR barcode...")
    let imageData = try generateBarcodeData(barcodeValue)
    try imageData.write(to: URL(fileURLWithPath: "QR.png"))
    print("Generated image saved to QR.png")

    print("Scanning generated barcode...")
    let barcodes = try scanBarcodeData(imageData)
    guard let firstBarcode = barcodes.first else {
        throw ExampleError.emptyScanResponse
    }

    print("Recognized type: \(firstBarcode.type ?? "")")
    print("Recognized value: \(firstBarcode.barcodeValue ?? "")")
} catch {
    print("Error: \(error)")
    exit(1)
}

func configureClient() throws {
    let environment = ProcessInfo.processInfo.environment

    if let token = environment["TEST_CONFIGURATION_ACCESS_TOKEN"], !token.isEmpty {
        AsposeBarcodeCloudClient(accessToken: token).apply()
        return
    }

    if let clientId = environment["ASPOSE_CLIENT_ID"], !clientId.isEmpty,
       let clientSecret = environment["ASPOSE_CLIENT_SECRET"], !clientSecret.isEmpty {
        let client = AsposeBarcodeCloudClient(clientId: clientId, clientSecret: clientSecret)
        try client.authorize()
        return
    }

    throw ExampleError.missingCredentials
}

func generateBarcodeData(_ value: String) throws -> Data {
    let semaphore = DispatchSemaphore(value: 0)
    var result: Result<Data, Error>?

    GenerateAPI.generate(
        barcodeType: .qr,
        data: value,
        imageFormat: .png,
        apiResponseQueue: callbackQueue
    ) { data, error in
        if let error = error {
            result = .failure(error)
        } else if let data = data, !data.isEmpty {
            result = .success(data)
        } else {
            result = .failure(ExampleError.emptyGenerateResponse)
        }

        semaphore.signal()
    }

    semaphore.wait()
    guard let result = result else {
        throw ExampleError.emptyGenerateResponse
    }

    return try result.get()
}

func scanBarcodeData(_ imageData: Data) throws -> [BarcodeResponse] {
    let semaphore = DispatchSemaphore(value: 0)
    var result: Result<[BarcodeResponse], Error>?
    let request = ScanBase64Request(fileBase64: imageData.base64EncodedString())

    ScanAPI.scanBase64(scanBase64Request: request, apiResponseQueue: callbackQueue) { response, error in
        if let error = error {
            result = .failure(error)
        } else {
            result = .success(response?.barcodes ?? [])
        }

        semaphore.signal()
    }

    semaphore.wait()
    guard let result = result else {
        return []
    }

    return try result.get()
}
