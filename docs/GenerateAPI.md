# GenerateAPI

All URIs are relative to *https://api.aspose.cloud/v4.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**generate**](GenerateAPI.md#generate) | **GET** /barcode/generate/{barcodeType} | Generate a barcode using a GET request with parameters in the route and query string.
[**generateBatch**](GenerateAPI.md#generatebatch) | **POST** /barcode/generate-batch | Generate multiple barcodes and return them in a ZIP, TAR, or TAR.GZ archive.
[**generateBody**](GenerateAPI.md#generatebody) | **POST** /barcode/generate-body | Generate a barcode using a POST request with parameters in the request body in JSON or XML format.
[**generateMultipart**](GenerateAPI.md#generatemultipart) | **POST** /barcode/generate-multipart | Generate a barcode using a POST request with parameters in a multipart form.


# **generate**
```swift
    open class func generate(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, barcodeImageParams: BarcodeImageParams? = nil, qrParams: QrParams? = nil, code128Params: Code128Params? = nil, pdf417Params: Pdf417Params? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate a barcode using a GET request with parameters in the route and query string.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType.qr // EncodeBarcodeType | Type of barcode to generate.
let data = "data_example" // String | String that represents the data to encode.
let dataType = EncodeDataType.stringData // EncodeDataType | Type of data to encode. Default value: StringData. (optional)
let barcodeImageParams = BarcodeImageParams() // BarcodeImageParams (optional)
let qrParams = QrParams() // QrParams (optional)
let code128Params = Code128Params() // Code128Params (optional)
let pdf417Params = Pdf417Params() // Pdf417Params (optional)

// Generate a barcode using a GET request with parameters in the route and query string.
GenerateAPI.generate(barcodeType: barcodeType, data: data, dataType: dataType, barcodeImageParams: barcodeImageParams, qrParams: qrParams, code128Params: code128Params, pdf417Params: pdf417Params) { (response, error) in
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
 **barcodeImageParams** | [**BarcodeImageParams**](BarcodeImageParams.md) | Grouped barcodeImageParams parameters. | [optional]
 **qrParams** | [**QrParams**](QrParams.md) | Grouped qrParams parameters. | [optional]
 **code128Params** | [**Code128Params**](Code128Params.md) | Grouped code128Params parameters. | [optional]
 **pdf417Params** | [**Pdf417Params**](Pdf417Params.md) | Grouped pdf417Params parameters. | [optional]

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateBatch**
```swift
    open class func generateBatch(batchGenerateRequest: BatchGenerateRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate multiple barcodes and return them in a ZIP, TAR, or TAR.GZ archive.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let batchGenerateRequest = BatchGenerateRequest(archiveFormat: BatchArchiveFormat.zip, items: [BatchGenerateItem(fileName: "fileName_example", generation: GenerateParams(barcodeType: EncodeBarcodeType.qr, encodeData: EncodeData(dataType: EncodeDataType.stringData, data: "data_example"), barcodeImageParams: BarcodeImageParams(imageFormat: BarcodeImageFormat.png, textLocation: CodeLocation.below, foregroundColor: "foregroundColor_example", backgroundColor: "backgroundColor_example", units: GraphicsUnit.pixel, resolution: 123, imageHeight: 123, imageWidth: 123, rotationAngle: 123), qrParams: QrParams(qrEncodeMode: QREncodeMode.auto, qrErrorLevel: QRErrorLevel.levelL, qrVersion: QRVersion.auto, qrECIEncoding: ECIEncodings._none, qrAspectRatio: 123, microQRVersion: MicroQRVersion.auto, rectMicroQrVersion: RectMicroQRVersion.auto), code128Params: Code128Params(code128EncodeMode: Code128EncodeMode.auto), pdf417Params: Pdf417Params(pdf417EncodeMode: Pdf417EncodeMode.auto, pdf417ErrorLevel: Pdf417ErrorLevel.level0, pdf417Truncate: false, pdf417Columns: 123, pdf417Rows: 123, pdf417AspectRatio: 123, pdf417ECIEncoding: nil, pdf417IsReaderInitialization: false, pdf417MacroCharacters: MacroCharacter._none, pdf417IsLinked: false, pdf417IsCode128Emulation: false)))]) // BatchGenerateRequest | Batch generation request in JSON or XML format.

// Generate multiple barcodes and return them in a ZIP, TAR, or TAR.GZ archive.
GenerateAPI.generateBatch(batchGenerateRequest: batchGenerateRequest) { (response, error) in
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
 **batchGenerateRequest** | [**BatchGenerateRequest**](BatchGenerateRequest.md) | Batch generation request in JSON or XML format. | 

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json, application/xml
 - **Accept**: application/zip, application/x-tar, application/gzip, application/json, application/xml

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

let generateParams = GenerateParams(barcodeType: EncodeBarcodeType.qr, encodeData: EncodeData(dataType: EncodeDataType.stringData, data: "data_example"), barcodeImageParams: BarcodeImageParams(imageFormat: BarcodeImageFormat.png, textLocation: CodeLocation.below, foregroundColor: "foregroundColor_example", backgroundColor: "backgroundColor_example", units: GraphicsUnit.pixel, resolution: 123, imageHeight: 123, imageWidth: 123, rotationAngle: 123), qrParams: QrParams(qrEncodeMode: QREncodeMode.auto, qrErrorLevel: QRErrorLevel.levelL, qrVersion: QRVersion.auto, qrECIEncoding: ECIEncodings._none, qrAspectRatio: 123, microQRVersion: MicroQRVersion.auto, rectMicroQrVersion: RectMicroQRVersion.auto), code128Params: Code128Params(code128EncodeMode: Code128EncodeMode.auto), pdf417Params: Pdf417Params(pdf417EncodeMode: Pdf417EncodeMode.auto, pdf417ErrorLevel: Pdf417ErrorLevel.level0, pdf417Truncate: false, pdf417Columns: 123, pdf417Rows: 123, pdf417AspectRatio: 123, pdf417ECIEncoding: nil, pdf417IsReaderInitialization: false, pdf417MacroCharacters: MacroCharacter._none, pdf417IsLinked: false, pdf417IsCode128Emulation: false)) // GenerateParams | Generation parameters.

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
    open class func generateMultipart(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, barcodeImageParams: BarcodeImageParams? = nil, qrParams: QrParams? = nil, code128Params: Code128Params? = nil, pdf417Params: Pdf417Params? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate a barcode using a POST request with parameters in a multipart form.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType.qr // EncodeBarcodeType | See https://reference.aspose.com/barcode/net/aspose.barcode.generation/encodetypes/
let data = "data_example" // String | String that represents the data to encode.
let dataType = EncodeDataType.stringData // EncodeDataType | Type of data to encode. Default value: StringData. (optional)
let barcodeImageParams = BarcodeImageParams() // BarcodeImageParams (optional)
let qrParams = QrParams() // QrParams (optional)
let code128Params = Code128Params() // Code128Params (optional)
let pdf417Params = Pdf417Params() // Pdf417Params (optional)

// Generate a barcode using a POST request with parameters in a multipart form.
GenerateAPI.generateMultipart(barcodeType: barcodeType, data: data, dataType: dataType, barcodeImageParams: barcodeImageParams, qrParams: qrParams, code128Params: code128Params, pdf417Params: pdf417Params) { (response, error) in
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
 **barcodeImageParams** | [**BarcodeImageParams**](BarcodeImageParams.md) | Grouped barcodeImageParams parameters. | [optional]
 **qrParams** | [**QrParams**](QrParams.md) | Grouped qrParams parameters. | [optional]
 **code128Params** | [**Code128Params**](Code128Params.md) | Grouped code128Params parameters. | [optional]
 **pdf417Params** | [**Pdf417Params**](Pdf417Params.md) | Grouped pdf417Params parameters. | [optional]

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

