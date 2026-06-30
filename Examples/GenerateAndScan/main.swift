import AsposeBarcodeCloud
import Foundation

private enum ExampleConfiguration {
    private static let defaultConfigPath = "Tests/configuration.json"

    static func load() throws -> AsposeBarcodeCloudConfiguration? {
        if let configuration = loadFromEnvironment(ProcessInfo.processInfo.environment) {
            return configuration
        }

        return try loadFromFile(defaultConfigPath)
    }

    private static func loadFromEnvironment(_ environment: [String: String]) -> AsposeBarcodeCloudConfiguration? {
        let payload = Payload(
            accessToken: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_ACCESS_TOKEN",
            ]),
            clientId: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_CLIENT_ID",
                "ASPOSE_CLIENT_ID",
            ]),
            clientSecret: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_CLIENT_SECRET",
                "ASPOSE_CLIENT_SECRET",
            ]),
            host: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_HOST",
                "TEST_CONFIGURATION_BASE_URL",
            ]),
            tokenURL: firstValue(in: environment, names: [
                "TEST_CONFIGURATION_TOKEN_URL",
            ])
        )

        return payload.makeConfiguration()
    }

    private static func loadFromFile(_ path: String) throws -> AsposeBarcodeCloudConfiguration? {
        guard FileManager.default.fileExists(atPath: path),
              let data = FileManager.default.contents(atPath: path)
        else {
            return nil
        }

        let payload = try JSONDecoder().decode(Payload.self, from: data)
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

        enum CodingKeys: String, CodingKey {
            case accessToken
            case clientId
            case clientSecret
            case host
            case baseUrl
            case tokenURL
            case tokenUrl
        }

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
            if let accessToken, !accessToken.isEmpty {
                return AsposeBarcodeCloudConfiguration(
                    accessToken: accessToken,
                    host: host ?? AsposeBarcodeCloudConfiguration.defaultHost,
                    tokenURL: tokenURL ?? AsposeBarcodeCloudConfiguration.defaultTokenURL
                )
            }

            guard let clientId, !clientId.isEmpty,
                  let clientSecret, !clientSecret.isEmpty
            else {
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

guard let configuration = try ExampleConfiguration.load() else {
    print("Set TEST_CONFIGURATION_ACCESS_TOKEN or TEST_CONFIGURATION_CLIENT_ID/TEST_CONFIGURATION_CLIENT_SECRET.")
    exit(1)
}

let client = AsposeBarcodeCloudClient(configuration: configuration)
let barcodeValue = CommandLine.arguments.dropFirst().first ?? "Aspose.BarCode Cloud Swift example"

print("Generating QR barcode...")
let imageData = try await GenerateAPI.generate(
    barcodeType: .qr,
    data: barcodeValue,
    barcodeImageParams: BarcodeImageParams(imageFormat: .png),
    qrParams: QrParams(
        qrEncodeMode: .auto,
        qrErrorLevel: .levelM,
        qrVersion: .auto,
        qrAspectRatio: 0.75
    ),
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
