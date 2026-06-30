# GenerateAPI

All URIs are relative to *https://api.aspose.cloud/v4.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**generate**](GenerateAPI.md#generate) | **GET** /barcode/generate/{barcodeType} | Generate a barcode using a GET request with parameters in the route and query string.
[**generateBody**](GenerateAPI.md#generatebody) | **POST** /barcode/generate-body | Generate a barcode using a POST request with parameters in the request body in JSON or XML format.
[**generateMultipart**](GenerateAPI.md#generatemultipart) | **POST** /barcode/generate-multipart | Generate a barcode using a POST request with parameters in a multipart form.


# **generate**
```swift
    open class func generate(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, imageFormat: BarcodeImageFormat? = nil, textLocation: CodeLocation? = nil, foregroundColor: String? = nil, backgroundColor: String? = nil, units: GraphicsUnit? = nil, resolution: Float? = nil, imageHeight: Float? = nil, imageWidth: Float? = nil, rotationAngle: Int? = nil, qrEncodeMode: QREncodeMode? = nil, qrErrorLevel: QRErrorLevel? = nil, qrVersion: QRVersion? = nil, qrECIEncoding: ECIEncodings? = nil, qrAspectRatio: Float? = nil, microQRVersion: MicroQRVersion? = nil, rectMicroQrVersion: RectMicroQRVersion? = nil, code128EncodeMode: Code128EncodeMode? = nil, pdf417EncodeMode: Pdf417EncodeMode? = nil, pdf417ErrorLevel: Pdf417ErrorLevel? = nil, pdf417Truncate: Bool? = nil, pdf417Columns: Int? = nil, pdf417Rows: Int? = nil, pdf417AspectRatio: Float? = nil, pdf417ECIEncoding: ECIEncodings? = nil, pdf417IsReaderInitialization: Bool? = nil, pdf417MacroCharacters: MacroCharacter? = nil, pdf417IsLinked: Bool? = nil, pdf417IsCode128Emulation: Bool? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate a barcode using a GET request with parameters in the route and query string.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType() // EncodeBarcodeType | Type of barcode to generate.
let data = "data_example" // String | String that represents the data to encode.
let dataType = EncodeDataType() // EncodeDataType | Type of data to encode. Default value: StringData. (optional)
let imageFormat = BarcodeImageFormat() // BarcodeImageFormat | Barcode output image format. Default value: png. (optional)
let textLocation = CodeLocation() // CodeLocation | Specify the displayed text location. Set to CodeLocation.None to hide CodeText. Default value depends on BarcodeType: CodeLocation.Below for 1D barcodes and CodeLocation.None for 2D barcodes. (optional)
let foregroundColor = "foregroundColor_example" // String | Specify the display color for bars and content. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: Black. (optional) (default to "Black")
let backgroundColor = "backgroundColor_example" // String | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: White. (optional) (default to "White")
let units = GraphicsUnit() // GraphicsUnit | Common units for all measurements. Default units: pixels. (optional)
let resolution = 987 // Float | Resolution of the barcode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is a dot. (optional)
let imageHeight = 987 // Float | Height of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. (optional)
let imageWidth = 987 // Float | Width of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. (optional)
let rotationAngle = 987 // Int | Barcode image rotation angle, measured in degrees. For example, RotationAngle = 0 or RotationAngle = 360 means no rotation. If RotationAngle is not equal to 90, 180, 270, or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. (optional)
let qrEncodeMode = QREncodeMode() // QREncodeMode | QR barcode encode mode. (optional)
let qrErrorLevel = QRErrorLevel() // QRErrorLevel | QR barcode error correction level. (optional)
let qrVersion = QRVersion() // QRVersion | QR barcode version. Automatically selects the smallest version that fits the data. (optional)
let qrECIEncoding = ECIEncodings() // ECIEncodings | ECI encoding for QR barcode data. (optional)
let qrAspectRatio = 987 // Float | QR barcode aspect ratio. Values: 0 to 1. (optional)
let microQRVersion = MicroQRVersion() // MicroQRVersion | MicroQR barcode version. Used when BarcodeType is MicroQR. (optional)
let rectMicroQrVersion = RectMicroQRVersion() // RectMicroQRVersion | RectMicroQR barcode version. Used when BarcodeType is RectMicroQR. (optional)
let code128EncodeMode = Code128EncodeMode() // Code128EncodeMode | Code128 barcode encode mode. Controls which Code 128 subset (A, B, C, or mix) is used. (optional)
let pdf417EncodeMode = Pdf417EncodeMode() // Pdf417EncodeMode | PDF417 barcode encode mode. (optional)
let pdf417ErrorLevel = Pdf417ErrorLevel() // Pdf417ErrorLevel | PDF417 barcode error correction level. (optional)
let pdf417Truncate = true // Bool | Whether to use truncated PDF417 format (removes right-side stop pattern). (optional)
let pdf417Columns = 987 // Int | Number of columns in the PDF417 barcode. Values between 1 and 30. 0 for auto. (optional)
let pdf417Rows = 987 // Int | Number of rows in the PDF417 barcode. Values between 3 and 90. 0 for automatic. (optional)
let pdf417AspectRatio = 987 // Float | PDF417 barcode aspect ratio (height/width of the barcode module). Values are defined by the standard: 2 to 5 for MicroPdf417; 3 to 5 for Pdf417 and MacroPdf417. (optional)
let pdf417ECIEncoding = ECIEncodings() // ECIEncodings | ECI encoding for PDF417 barcode data. (optional)
let pdf417IsReaderInitialization = true // Bool | Whether the barcode is used for reader initialization (programming). (optional)
let pdf417MacroCharacters = MacroCharacter() // MacroCharacter | Macro character to prepend (structured append). (optional)
let pdf417IsLinked = true // Bool | Whether to use linked mode (for MicroPdf417). (optional)
let pdf417IsCode128Emulation = true // Bool | Whether to use Code128 emulation for MicroPdf417. (optional)

// Generate a barcode using a GET request with parameters in the route and query string.
GenerateAPI.generate(barcodeType: barcodeType, data: data, dataType: dataType, imageFormat: imageFormat, textLocation: textLocation, foregroundColor: foregroundColor, backgroundColor: backgroundColor, units: units, resolution: resolution, imageHeight: imageHeight, imageWidth: imageWidth, rotationAngle: rotationAngle, qrEncodeMode: qrEncodeMode, qrErrorLevel: qrErrorLevel, qrVersion: qrVersion, qrECIEncoding: qrECIEncoding, qrAspectRatio: qrAspectRatio, microQRVersion: microQRVersion, rectMicroQrVersion: rectMicroQrVersion, code128EncodeMode: code128EncodeMode, pdf417EncodeMode: pdf417EncodeMode, pdf417ErrorLevel: pdf417ErrorLevel, pdf417Truncate: pdf417Truncate, pdf417Columns: pdf417Columns, pdf417Rows: pdf417Rows, pdf417AspectRatio: pdf417AspectRatio, pdf417ECIEncoding: pdf417ECIEncoding, pdf417IsReaderInitialization: pdf417IsReaderInitialization, pdf417MacroCharacters: pdf417MacroCharacters, pdf417IsLinked: pdf417IsLinked, pdf417IsCode128Emulation: pdf417IsCode128Emulation) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **barcodeType** | [**EncodeBarcodeType**](.md) | Type of barcode to generate. | 
 **data** | **String** | String that represents the data to encode. | 
 **dataType** | [**EncodeDataType**](.md) | Type of data to encode. Default value: StringData. | [optional] 
 **imageFormat** | [**BarcodeImageFormat**](.md) | Barcode output image format. Default value: png. | [optional] 
 **textLocation** | [**CodeLocation**](.md) | Specify the displayed text location. Set to CodeLocation.None to hide CodeText. Default value depends on BarcodeType: CodeLocation.Below for 1D barcodes and CodeLocation.None for 2D barcodes. | [optional] 
 **foregroundColor** | **String** | Specify the display color for bars and content. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: Black. | [optional] [default to &quot;Black&quot;]
 **backgroundColor** | **String** | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: White. | [optional] [default to &quot;White&quot;]
 **units** | [**GraphicsUnit**](.md) | Common units for all measurements. Default units: pixels. | [optional] 
 **resolution** | **Float** | Resolution of the barcode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is a dot. | [optional] 
 **imageHeight** | **Float** | Height of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. | [optional] 
 **imageWidth** | **Float** | Width of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. | [optional] 
 **rotationAngle** | **Int** | Barcode image rotation angle, measured in degrees. For example, RotationAngle &#x3D; 0 or RotationAngle &#x3D; 360 means no rotation. If RotationAngle is not equal to 90, 180, 270, or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. | [optional] 
 **qrEncodeMode** | [**QREncodeMode**](.md) | QR barcode encode mode. | [optional] 
 **qrErrorLevel** | [**QRErrorLevel**](.md) | QR barcode error correction level. | [optional] 
 **qrVersion** | [**QRVersion**](.md) | QR barcode version. Automatically selects the smallest version that fits the data. | [optional] 
 **qrECIEncoding** | [**ECIEncodings**](.md) | ECI encoding for QR barcode data. | [optional] 
 **qrAspectRatio** | **Float** | QR barcode aspect ratio. Values: 0 to 1. | [optional] 
 **microQRVersion** | [**MicroQRVersion**](.md) | MicroQR barcode version. Used when BarcodeType is MicroQR. | [optional] 
 **rectMicroQrVersion** | [**RectMicroQRVersion**](.md) | RectMicroQR barcode version. Used when BarcodeType is RectMicroQR. | [optional] 
 **code128EncodeMode** | [**Code128EncodeMode**](.md) | Code128 barcode encode mode. Controls which Code 128 subset (A, B, C, or mix) is used. | [optional] 
 **pdf417EncodeMode** | [**Pdf417EncodeMode**](.md) | PDF417 barcode encode mode. | [optional] 
 **pdf417ErrorLevel** | [**Pdf417ErrorLevel**](.md) | PDF417 barcode error correction level. | [optional] 
 **pdf417Truncate** | **Bool** | Whether to use truncated PDF417 format (removes right-side stop pattern). | [optional] 
 **pdf417Columns** | **Int** | Number of columns in the PDF417 barcode. Values between 1 and 30. 0 for auto. | [optional] 
 **pdf417Rows** | **Int** | Number of rows in the PDF417 barcode. Values between 3 and 90. 0 for automatic. | [optional] 
 **pdf417AspectRatio** | **Float** | PDF417 barcode aspect ratio (height/width of the barcode module). Values are defined by the standard: 2 to 5 for MicroPdf417; 3 to 5 for Pdf417 and MacroPdf417. | [optional] 
 **pdf417ECIEncoding** | [**ECIEncodings**](.md) | ECI encoding for PDF417 barcode data. | [optional] 
 **pdf417IsReaderInitialization** | **Bool** | Whether the barcode is used for reader initialization (programming). | [optional] 
 **pdf417MacroCharacters** | [**MacroCharacter**](.md) | Macro character to prepend (structured append). | [optional] 
 **pdf417IsLinked** | **Bool** | Whether to use linked mode (for MicroPdf417). | [optional] 
 **pdf417IsCode128Emulation** | **Bool** | Whether to use Code128 emulation for MicroPdf417. | [optional] 

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateBody**
```swift
    open class func generateBody(generateParams: GenerateParams, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate a barcode using a POST request with parameters in the request body in JSON or XML format.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let generateParams = GenerateParams(barcodeType: EncodeBarcodeType(), encodeData: EncodeData(dataType: EncodeDataType(), data: "data_example"), barcodeImageParams: BarcodeImageParams(imageFormat: BarcodeImageFormat(), textLocation: CodeLocation(), foregroundColor: "foregroundColor_example", backgroundColor: "backgroundColor_example", units: GraphicsUnit(), resolution: 123, imageHeight: 123, imageWidth: 123, rotationAngle: 123), qrParams: QrParams(qrEncodeMode: QREncodeMode(), qrErrorLevel: QRErrorLevel(), qrVersion: QRVersion(), qrECIEncoding: ECIEncodings(), qrAspectRatio: 123, microQRVersion: MicroQRVersion(), rectMicroQrVersion: RectMicroQRVersion()), code128Params: Code128Params(code128EncodeMode: Code128EncodeMode()), pdf417Params: Pdf417Params(pdf417EncodeMode: Pdf417EncodeMode(), pdf417ErrorLevel: Pdf417ErrorLevel(), pdf417Truncate: false, pdf417Columns: 123, pdf417Rows: 123, pdf417AspectRatio: 123, pdf417ECIEncoding: nil, pdf417IsReaderInitialization: false, pdf417MacroCharacters: MacroCharacter(), pdf417IsLinked: false, pdf417IsCode128Emulation: false)) // GenerateParams | Generation parameters.

// Generate a barcode using a POST request with parameters in the request body in JSON or XML format.
GenerateAPI.generateBody(generateParams: generateParams) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **generateParams** | [**GenerateParams**](GenerateParams.md) | Generation parameters. | 

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json, application/xml
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateMultipart**
```swift
    open class func generateMultipart(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, imageFormat: BarcodeImageFormat? = nil, textLocation: CodeLocation? = nil, foregroundColor: String? = nil, backgroundColor: String? = nil, units: GraphicsUnit? = nil, resolution: Float? = nil, imageHeight: Float? = nil, imageWidth: Float? = nil, rotationAngle: Int? = nil, qrEncodeMode: QREncodeMode? = nil, qrErrorLevel: QRErrorLevel? = nil, qrVersion: QRVersion? = nil, qrECIEncoding: ECIEncodings? = nil, qrAspectRatio: Float? = nil, microQRVersion: MicroQRVersion? = nil, rectMicroQrVersion: RectMicroQRVersion? = nil, code128EncodeMode: Code128EncodeMode? = nil, pdf417EncodeMode: Pdf417EncodeMode? = nil, pdf417ErrorLevel: Pdf417ErrorLevel? = nil, pdf417Truncate: Bool? = nil, pdf417Columns: Int? = nil, pdf417Rows: Int? = nil, pdf417AspectRatio: Float? = nil, pdf417ECIEncoding: ECIEncodings? = nil, pdf417IsReaderInitialization: Bool? = nil, pdf417MacroCharacters: MacroCharacter? = nil, pdf417IsLinked: Bool? = nil, pdf417IsCode128Emulation: Bool? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate a barcode using a POST request with parameters in a multipart form.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType() // EncodeBarcodeType | See https://reference.aspose.com/barcode/net/aspose.barcode.generation/encodetypes/
let data = "data_example" // String | String that represents the data to encode.
let dataType = EncodeDataType() // EncodeDataType | Type of data to encode. Default value: StringData. (optional)
let imageFormat = BarcodeImageFormat() // BarcodeImageFormat | Barcode output image format. Default value: png. (optional)
let textLocation = CodeLocation() // CodeLocation | Specify the displayed text location. Set to CodeLocation.None to hide CodeText. Default value depends on BarcodeType: CodeLocation.Below for 1D barcodes and CodeLocation.None for 2D barcodes. (optional)
let foregroundColor = "foregroundColor_example" // String | Specify the display color for bars and content. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: Black. (optional) (default to "Black")
let backgroundColor = "backgroundColor_example" // String | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: White. (optional) (default to "White")
let units = GraphicsUnit() // GraphicsUnit | Common units for all measurements. Default units: pixels. (optional)
let resolution = 987 // Float | Resolution of the barcode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is a dot. (optional)
let imageHeight = 987 // Float | Height of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. (optional)
let imageWidth = 987 // Float | Width of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. (optional)
let rotationAngle = 987 // Int | Barcode image rotation angle, measured in degrees. For example, RotationAngle = 0 or RotationAngle = 360 means no rotation. If RotationAngle is not equal to 90, 180, 270, or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. (optional)
let qrEncodeMode = QREncodeMode() // QREncodeMode | QR barcode encode mode. (optional)
let qrErrorLevel = QRErrorLevel() // QRErrorLevel | QR barcode error correction level. (optional)
let qrVersion = QRVersion() // QRVersion | QR barcode version. Automatically selects the smallest version that fits the data. (optional)
let qrECIEncoding = ECIEncodings() // ECIEncodings | ECI encoding for QR barcode data. (optional)
let qrAspectRatio = 987 // Float | QR barcode aspect ratio. Values: 0 to 1. (optional)
let microQRVersion = MicroQRVersion() // MicroQRVersion | MicroQR barcode version. Used when BarcodeType is MicroQR. (optional)
let rectMicroQrVersion = RectMicroQRVersion() // RectMicroQRVersion | RectMicroQR barcode version. Used when BarcodeType is RectMicroQR. (optional)
let code128EncodeMode = Code128EncodeMode() // Code128EncodeMode | Code128 barcode encode mode. Controls which Code 128 subset (A, B, C, or mix) is used. (optional)
let pdf417EncodeMode = Pdf417EncodeMode() // Pdf417EncodeMode | PDF417 barcode encode mode. (optional)
let pdf417ErrorLevel = Pdf417ErrorLevel() // Pdf417ErrorLevel | PDF417 barcode error correction level. (optional)
let pdf417Truncate = true // Bool | Whether to use truncated PDF417 format (removes right-side stop pattern). (optional)
let pdf417Columns = 987 // Int | Number of columns in the PDF417 barcode. Values between 1 and 30. 0 for auto. (optional)
let pdf417Rows = 987 // Int | Number of rows in the PDF417 barcode. Values between 3 and 90. 0 for automatic. (optional)
let pdf417AspectRatio = 987 // Float | PDF417 barcode aspect ratio (height/width of the barcode module). Values are defined by the standard: 2 to 5 for MicroPdf417; 3 to 5 for Pdf417 and MacroPdf417. (optional)
let pdf417ECIEncoding = ECIEncodings() // ECIEncodings | ECI encoding for PDF417 barcode data. (optional)
let pdf417IsReaderInitialization = true // Bool | Whether the barcode is used for reader initialization (programming). (optional)
let pdf417MacroCharacters = MacroCharacter() // MacroCharacter | Macro character to prepend (structured append). (optional)
let pdf417IsLinked = true // Bool | Whether to use linked mode (for MicroPdf417). (optional)
let pdf417IsCode128Emulation = true // Bool | Whether to use Code128 emulation for MicroPdf417. (optional)

// Generate a barcode using a POST request with parameters in a multipart form.
GenerateAPI.generateMultipart(barcodeType: barcodeType, data: data, dataType: dataType, imageFormat: imageFormat, textLocation: textLocation, foregroundColor: foregroundColor, backgroundColor: backgroundColor, units: units, resolution: resolution, imageHeight: imageHeight, imageWidth: imageWidth, rotationAngle: rotationAngle, qrEncodeMode: qrEncodeMode, qrErrorLevel: qrErrorLevel, qrVersion: qrVersion, qrECIEncoding: qrECIEncoding, qrAspectRatio: qrAspectRatio, microQRVersion: microQRVersion, rectMicroQrVersion: rectMicroQrVersion, code128EncodeMode: code128EncodeMode, pdf417EncodeMode: pdf417EncodeMode, pdf417ErrorLevel: pdf417ErrorLevel, pdf417Truncate: pdf417Truncate, pdf417Columns: pdf417Columns, pdf417Rows: pdf417Rows, pdf417AspectRatio: pdf417AspectRatio, pdf417ECIEncoding: pdf417ECIEncoding, pdf417IsReaderInitialization: pdf417IsReaderInitialization, pdf417MacroCharacters: pdf417MacroCharacters, pdf417IsLinked: pdf417IsLinked, pdf417IsCode128Emulation: pdf417IsCode128Emulation) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **barcodeType** | [**EncodeBarcodeType**](EncodeBarcodeType.md) | See https://reference.aspose.com/barcode/net/aspose.barcode.generation/encodetypes/ | 
 **data** | **String** | String that represents the data to encode. | 
 **dataType** | [**EncodeDataType**](EncodeDataType.md) | Type of data to encode. Default value: StringData. | [optional] 
 **imageFormat** | [**BarcodeImageFormat**](BarcodeImageFormat.md) | Barcode output image format. Default value: png. | [optional] 
 **textLocation** | [**CodeLocation**](CodeLocation.md) | Specify the displayed text location. Set to CodeLocation.None to hide CodeText. Default value depends on BarcodeType: CodeLocation.Below for 1D barcodes and CodeLocation.None for 2D barcodes. | [optional] 
 **foregroundColor** | **String** | Specify the display color for bars and content. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: Black. | [optional] [default to &quot;Black&quot;]
 **backgroundColor** | **String** | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value starting with #. For example: AliceBlue or #FF000000. Default value: White. | [optional] [default to &quot;White&quot;]
 **units** | [**GraphicsUnit**](GraphicsUnit.md) | Common units for all measurements. Default units: pixels. | [optional] 
 **resolution** | **Float** | Resolution of the barcode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is a dot. | [optional] 
 **imageHeight** | **Float** | Height of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. | [optional] 
 **imageWidth** | **Float** | Width of the barcode image in the specified units. Default units: pixels. Decimal separator is a dot. | [optional] 
 **rotationAngle** | **Int** | Barcode image rotation angle, measured in degrees. For example, RotationAngle &#x3D; 0 or RotationAngle &#x3D; 360 means no rotation. If RotationAngle is not equal to 90, 180, 270, or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. | [optional] 
 **qrEncodeMode** | [**QREncodeMode**](QREncodeMode.md) | QR barcode encode mode. | [optional] 
 **qrErrorLevel** | [**QRErrorLevel**](QRErrorLevel.md) | QR barcode error correction level. | [optional] 
 **qrVersion** | [**QRVersion**](QRVersion.md) | QR barcode version. Automatically selects the smallest version that fits the data. | [optional] 
 **qrECIEncoding** | [**ECIEncodings**](ECIEncodings.md) | ECI encoding for QR barcode data. | [optional] 
 **qrAspectRatio** | **Float** | QR barcode aspect ratio. Values: 0 to 1. | [optional] 
 **microQRVersion** | [**MicroQRVersion**](MicroQRVersion.md) | MicroQR barcode version. Used when BarcodeType is MicroQR. | [optional] 
 **rectMicroQrVersion** | [**RectMicroQRVersion**](RectMicroQRVersion.md) | RectMicroQR barcode version. Used when BarcodeType is RectMicroQR. | [optional] 
 **code128EncodeMode** | [**Code128EncodeMode**](Code128EncodeMode.md) | Code128 barcode encode mode. Controls which Code 128 subset (A, B, C, or mix) is used. | [optional] 
 **pdf417EncodeMode** | [**Pdf417EncodeMode**](Pdf417EncodeMode.md) | PDF417 barcode encode mode. | [optional] 
 **pdf417ErrorLevel** | [**Pdf417ErrorLevel**](Pdf417ErrorLevel.md) | PDF417 barcode error correction level. | [optional] 
 **pdf417Truncate** | **Bool** | Whether to use truncated PDF417 format (removes right-side stop pattern). | [optional] 
 **pdf417Columns** | **Int** | Number of columns in the PDF417 barcode. Values between 1 and 30. 0 for auto. | [optional] 
 **pdf417Rows** | **Int** | Number of rows in the PDF417 barcode. Values between 3 and 90. 0 for automatic. | [optional] 
 **pdf417AspectRatio** | **Float** | PDF417 barcode aspect ratio (height/width of the barcode module). Values are defined by the standard: 2 to 5 for MicroPdf417; 3 to 5 for Pdf417 and MacroPdf417. | [optional] 
 **pdf417ECIEncoding** | [**ECIEncodings**](ECIEncodings.md) | ECI encoding for PDF417 barcode data. | [optional] 
 **pdf417IsReaderInitialization** | **Bool** | Whether the barcode is used for reader initialization (programming). | [optional] 
 **pdf417MacroCharacters** | [**MacroCharacter**](MacroCharacter.md) | Macro character to prepend (structured append). | [optional] 
 **pdf417IsLinked** | **Bool** | Whether to use linked mode (for MicroPdf417). | [optional] 
 **pdf417IsCode128Emulation** | **Bool** | Whether to use Code128 emulation for MicroPdf417. | [optional] 

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

