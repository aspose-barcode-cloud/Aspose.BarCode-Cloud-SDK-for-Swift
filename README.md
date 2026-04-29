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
AsposeBarcodeCloudAPI.customHeaders["Authorization"] = "Bearer <access-token>"
AsposeBarcodeCloudAPI.customHeaders["x-aspose-client"] = "swift sdk"
AsposeBarcodeCloudAPI.customHeaders["x-aspose-client-version"] = "26.4.0"

GenerateAPI.generate(barcodeType: .qr, data: "Aspose.BarCode Cloud") { data, error in
    if let error = error {
        print(error)
        return
    }

    // Generated barcode bytes are available in data.
    print(data?.count ?? 0)
}
```

Automatic OAuth token retrieval is the next runtime layer to add on top of this generated surface.

## Development

The generated source is maintained from the `aspose-barcode-cloud-codegen` repository:

```bash
cd ../aspose-barcode-cloud-codegen
make swift
```
