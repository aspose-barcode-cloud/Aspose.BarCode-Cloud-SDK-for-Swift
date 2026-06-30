# CHANGELOG

## v26.6.0

* Added barcode-type-specific encoding parameters for QR, PDF417, and Code128 to the generate endpoints, with new `QrParams`, `Pdf417Params`, and `Code128Params` models and supporting enums (`QREncodeMode`, `QRErrorLevel`, `QRVersion`, `ECIEncodings`, `MicroQRVersion`, `RectMicroQRVersion`, `Code128EncodeMode`, `Pdf417EncodeMode`, `Pdf417ErrorLevel`, `MacroCharacter`).
* **Breaking:** grouped the `generate` and `generateMultipart` parameters into typed objects (`barcodeImageParams`, `qrParams`, `code128Params`, `pdf417Params`); existing flat-argument calls must be updated.
* Updated generated client version for the Aspose.BarCode Cloud 26.6 release.

## v26.5.0

* Updated SDK package metadata and generated client version for the Aspose.BarCode Cloud 26.5 release.

## v26.4.0

* Initial Swift SDK bootstrap for Aspose.BarCode Cloud API v4.0.
* Added generated Generate, Recognize, and Scan API surfaces with models and documentation.
* Added OAuth client credentials and access token configuration helpers.
* Added Linux-compatible Swift Package Manager build support.
* Added offline request-shape tests and optional live integration smoke tests.
