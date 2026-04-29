# Aspose.BarCode Cloud SDK for Swift

This repository contains the Swift SDK for Aspose.BarCode Cloud. It is currently bootstrapped locally while the public GitHub repository is being prepared.

## Requirements

- Swift Package Manager
- iOS 11.0 or later
- macOS 10.13 or later

## Usage

Add the package to your SwiftPM dependencies after the repository is published:

```swift
.package(url: "https://github.com/aspose-barcode-cloud/Aspose.BarCode-Cloud-SDK-for-Swift.git", from: "26.4.0")
```

Then import the module:

```swift
import AsposeBarcodeCloud
```

The first generated API surface includes `GenerateAPI`, `RecognizeAPI`, `ScanAPI`, and the corresponding models.

```swift
let client = AsposeBarcodeCloudClient(
    clientId: "your-client-id",
    clientSecret: "your-client-secret"
)

try client.authorize()

GenerateAPI.generate(barcodeType: .qr, data: "Aspose.BarCode Cloud") { data, error in
    if let error = error {
        print(error)
        return
    }

    // Generated barcode bytes are available in data.
    print(data?.count ?? 0)
}
```

If you already have an access token, configure the SDK directly:

```swift
let client = AsposeBarcodeCloudClient(accessToken: "your-access-token")
client.apply()
```

`AsposeBarcodeCloudClient` sets `Authorization`, `x-aspose-client`, and `x-aspose-client-version` headers for generated requests.

## Development

The generated source is maintained from the `aspose-barcode-cloud-codegen` repository:

```bash
cd ../aspose-barcode-cloud-codegen
make swift
```

Run tests from this package directory:

```bash
swift test
```
