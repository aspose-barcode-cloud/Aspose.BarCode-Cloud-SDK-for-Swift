import Foundation
import AsposeBarcodeCloud

enum ExampleError: Error, CustomStringConvertible {
    case missingCredentials
    case emptyGenerateResponse
    case emptyScanResponse

    var description: String {
        switch self {
        case .missingCredentials:
            return "Set Tests/configuration.json, TEST_CONFIGURATION_ACCESS_TOKEN, or TEST_CONFIGURATION_CLIENT_ID/TEST_CONFIGURATION_CLIENT_SECRET."
        case .emptyGenerateResponse:
            return "Generate API returned no image bytes."
        case .emptyScanResponse:
            return "Scan API returned no barcode values."
        }
    }
}

final class ThreadSafeBox<Value>: @unchecked Sendable {
    private let lock = NSLock()
    private var storedValue: Value?

    var value: Value? {
        lock.withLock { storedValue }
    }

    func set(_ value: Value) {
        lock.withLock { storedValue = value }
    }
}

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
    if let configuration = ExampleConfiguration.load() {
        let client = AsposeBarcodeCloudClient(configuration: configuration)
        try client.authorize()
        return
    }

    throw ExampleError.missingCredentials
}

enum ExampleConfiguration {
    private static let defaultConfigPath = "Tests/configuration.json"

    static func load() -> AsposeBarcodeCloudConfiguration? {
        if let configuration = loadFromFile(defaultConfigPath) {
            return configuration
        }

        return loadFromEnvironment(ProcessInfo.processInfo.environment)
    }

    private static func loadFromFile(_ path: String) -> AsposeBarcodeCloudConfiguration? {
        guard FileManager.default.fileExists(atPath: path),
              let data = FileManager.default.contents(atPath: path),
              let payload = try? JSONDecoder().decode(Payload.self, from: data) else {
            return nil
        }

        return payload.makeConfiguration()
    }

    private static func loadFromEnvironment(_ environment: [String: String]) -> AsposeBarcodeCloudConfiguration? {
        let payload = Payload(
            accessToken: firstValue(in: environment, names: ["TEST_CONFIGURATION_ACCESS_TOKEN"]),
            clientId: firstValue(in: environment, names: ["TEST_CONFIGURATION_CLIENT_ID", "ASPOSE_CLIENT_ID"]),
            clientSecret: firstValue(in: environment, names: ["TEST_CONFIGURATION_CLIENT_SECRET", "ASPOSE_CLIENT_SECRET"]),
            host: firstValue(in: environment, names: ["TEST_CONFIGURATION_HOST", "TEST_CONFIGURATION_BASE_URL"]),
            tokenURL: firstValue(in: environment, names: ["TEST_CONFIGURATION_TOKEN_URL"])
        )

        return payload.makeConfiguration()
    }

    private static func firstValue(in environment: [String: String], names: [String]) -> String? {
        for name in names {
            if let value = environment[name], !value.isEmpty {
                return value
            }
        }

        return nil
    }

    private struct Payload: Decodable {
        let accessToken: String?
        let clientId: String?
        let clientSecret: String?
        let host: String?
        let tokenURL: String?

        init(
            accessToken: String? = nil,
            clientId: String? = nil,
            clientSecret: String? = nil,
            host: String? = nil,
            tokenURL: String? = nil
        ) {
            self.accessToken = accessToken
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.host = host
            self.tokenURL = tokenURL
        }

        enum CodingKeys: String, CodingKey {
            case accessToken
            case clientId
            case clientSecret
            case host
            case baseUrl
            case tokenURL
            case tokenUrl
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
            clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
            clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret)
            host = try container.decodeIfPresent(String.self, forKey: .host)
                ?? container.decodeIfPresent(String.self, forKey: .baseUrl)
            tokenURL = try container.decodeIfPresent(String.self, forKey: .tokenURL)
                ?? container.decodeIfPresent(String.self, forKey: .tokenUrl)
        }

        func makeConfiguration() -> AsposeBarcodeCloudConfiguration? {
            if let accessToken = accessToken, !accessToken.isEmpty {
                return AsposeBarcodeCloudConfiguration(
                    accessToken: accessToken,
                    host: host ?? AsposeBarcodeCloudConfiguration.defaultHost,
                    tokenURL: tokenURL ?? AsposeBarcodeCloudConfiguration.defaultTokenURL
                )
            }

            guard let clientId = clientId, !clientId.isEmpty,
                  let clientSecret = clientSecret, !clientSecret.isEmpty else {
                return nil
            }

            return AsposeBarcodeCloudConfiguration(
                clientId: clientId,
                clientSecret: clientSecret,
                host: host ?? AsposeBarcodeCloudConfiguration.defaultHost,
                tokenURL: tokenURL ?? AsposeBarcodeCloudConfiguration.defaultTokenURL
            )
        }
    }
}

func generateBarcodeData(_ value: String) throws -> Data {
    let semaphore = DispatchSemaphore(value: 0)
    let result = ThreadSafeBox<Result<Data, Error>>()

    GenerateAPI.generate(
        barcodeType: .qr,
        data: value,
        imageFormat: .png
    ) { data, error in
        if let error = error {
            result.set(.failure(error))
        } else if let data = data, !data.isEmpty {
            result.set(.success(data))
        } else {
            result.set(.failure(ExampleError.emptyGenerateResponse))
        }

        semaphore.signal()
    }

    semaphore.wait()
    guard let result = result.value else {
        throw ExampleError.emptyGenerateResponse
    }

    return try result.get()
}

func scanBarcodeData(_ imageData: Data) throws -> [BarcodeResponse] {
    let semaphore = DispatchSemaphore(value: 0)
    let result = ThreadSafeBox<Result<[BarcodeResponse], Error>>()
    let request = ScanBase64Request(fileBase64: imageData.base64EncodedString())

    ScanAPI.scanBase64(scanBase64Request: request) { response, error in
        if let error = error {
            result.set(.failure(error))
        } else {
            result.set(.success(response?.barcodes ?? []))
        }

        semaphore.signal()
    }

    semaphore.wait()
    guard let result = result.value else {
        return []
    }

    return try result.get()
}
