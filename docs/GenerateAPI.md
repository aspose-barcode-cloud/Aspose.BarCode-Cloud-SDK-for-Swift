# GenerateAPI

All URIs are relative to *https://api.aspose.cloud/v4.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**generate**](GenerateAPI.md#generate) | **GET** /barcode/generate/{barcodeType} | Generate barcode using GET request with parameters in route and query string.
[**generateBody**](GenerateAPI.md#generatebody) | **POST** /barcode/generate-body | Generate barcode using POST request with parameters in body in json or xml format.
[**generateMultipart**](GenerateAPI.md#generatemultipart) | **POST** /barcode/generate-multipart | Generate barcode using POST request with parameters in multipart form.


# **generate**
```swift
    open class func generate(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, imageFormat: BarcodeImageFormat? = nil, textLocation: CodeLocation? = nil, foregroundColor: String? = nil, backgroundColor: String? = nil, units: GraphicsUnit? = nil, resolution: Float? = nil, imageHeight: Float? = nil, imageWidth: Float? = nil, rotationAngle: Int? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate barcode using GET request with parameters in route and query string.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType() // EncodeBarcodeType | Type of barcode to generate.
let data = "data_example" // String | String represents data to encode
let dataType = EncodeDataType() // EncodeDataType | Type of data to encode. Default value: StringData. (optional)
let imageFormat = BarcodeImageFormat() // BarcodeImageFormat | Barcode output image format. Default value: png (optional)
let textLocation = CodeLocation() // CodeLocation | Specify the displaying Text Location, set to CodeLocation.None to hide CodeText. Default value: Depends on BarcodeType. CodeLocation.Below for 1D Barcodes. CodeLocation.None for 2D Barcodes. (optional)
let foregroundColor = "foregroundColor_example" // String | Specify the displaying bars and content Color. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: Black. (optional) (default to "Black")
let backgroundColor = "backgroundColor_example" // String | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: White. (optional) (default to "White")
let units = GraphicsUnit() // GraphicsUnit | Common Units for all measuring in query. Default units: pixel. (optional)
let resolution = 987 // Float | Resolution of the BarCode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is dot. (optional)
let imageHeight = 987 // Float | Height of the barcode image in given units. Default units: pixel. Decimal separator is dot. (optional)
let imageWidth = 987 // Float | Width of the barcode image in given units. Default units: pixel. Decimal separator is dot. (optional)
let rotationAngle = 987 // Int | BarCode image rotation angle, measured in degree, e.g. RotationAngle = 0 or RotationAngle = 360 means no rotation. If RotationAngle NOT equal to 90, 180, 270 or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. (optional)

// Generate barcode using GET request with parameters in route and query string.
GenerateAPI.generate(barcodeType: barcodeType, data: data, dataType: dataType, imageFormat: imageFormat, textLocation: textLocation, foregroundColor: foregroundColor, backgroundColor: backgroundColor, units: units, resolution: resolution, imageHeight: imageHeight, imageWidth: imageWidth, rotationAngle: rotationAngle) { (response, error) in
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
 **data** | **String** | String represents data to encode | 
 **dataType** | [**EncodeDataType**](.md) | Type of data to encode. Default value: StringData. | [optional] 
 **imageFormat** | [**BarcodeImageFormat**](.md) | Barcode output image format. Default value: png | [optional] 
 **textLocation** | [**CodeLocation**](.md) | Specify the displaying Text Location, set to CodeLocation.None to hide CodeText. Default value: Depends on BarcodeType. CodeLocation.Below for 1D Barcodes. CodeLocation.None for 2D Barcodes. | [optional] 
 **foregroundColor** | **String** | Specify the displaying bars and content Color. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: Black. | [optional] [default to &quot;Black&quot;]
 **backgroundColor** | **String** | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: White. | [optional] [default to &quot;White&quot;]
 **units** | [**GraphicsUnit**](.md) | Common Units for all measuring in query. Default units: pixel. | [optional] 
 **resolution** | **Float** | Resolution of the BarCode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is dot. | [optional] 
 **imageHeight** | **Float** | Height of the barcode image in given units. Default units: pixel. Decimal separator is dot. | [optional] 
 **imageWidth** | **Float** | Width of the barcode image in given units. Default units: pixel. Decimal separator is dot. | [optional] 
 **rotationAngle** | **Int** | BarCode image rotation angle, measured in degree, e.g. RotationAngle &#x3D; 0 or RotationAngle &#x3D; 360 means no rotation. If RotationAngle NOT equal to 90, 180, 270 or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. | [optional] 

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

Generate barcode using POST request with parameters in body in json or xml format.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let generateParams = GenerateParams(barcodeType: EncodeBarcodeType(), encodeData: EncodeData(dataType: EncodeDataType(), data: "data_example"), barcodeImageParams: BarcodeImageParams(imageFormat: BarcodeImageFormat(), textLocation: CodeLocation(), foregroundColor: "foregroundColor_example", backgroundColor: "backgroundColor_example", units: GraphicsUnit(), resolution: 123, imageHeight: 123, imageWidth: 123, rotationAngle: 123)) // GenerateParams | Parameters of generation

// Generate barcode using POST request with parameters in body in json or xml format.
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
 **generateParams** | [**GenerateParams**](GenerateParams.md) | Parameters of generation | 

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
    open class func generateMultipart(barcodeType: EncodeBarcodeType, data: String, dataType: EncodeDataType? = nil, imageFormat: BarcodeImageFormat? = nil, textLocation: CodeLocation? = nil, foregroundColor: String? = nil, backgroundColor: String? = nil, units: GraphicsUnit? = nil, resolution: Float? = nil, imageHeight: Float? = nil, imageWidth: Float? = nil, rotationAngle: Int? = nil, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
```

Generate barcode using POST request with parameters in multipart form.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = EncodeBarcodeType() // EncodeBarcodeType | 
let data = "data_example" // String | String represents data to encode
let dataType = EncodeDataType() // EncodeDataType |  (optional)
let imageFormat = BarcodeImageFormat() // BarcodeImageFormat |  (optional)
let textLocation = CodeLocation() // CodeLocation |  (optional)
let foregroundColor = "foregroundColor_example" // String | Specify the displaying bars and content Color. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: Black. (optional) (default to "Black")
let backgroundColor = "backgroundColor_example" // String | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: White. (optional) (default to "White")
let units = GraphicsUnit() // GraphicsUnit |  (optional)
let resolution = 987 // Float | Resolution of the BarCode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is dot. (optional)
let imageHeight = 987 // Float | Height of the barcode image in given units. Default units: pixel. Decimal separator is dot. (optional)
let imageWidth = 987 // Float | Width of the barcode image in given units. Default units: pixel. Decimal separator is dot. (optional)
let rotationAngle = 987 // Int | BarCode image rotation angle, measured in degree, e.g. RotationAngle = 0 or RotationAngle = 360 means no rotation. If RotationAngle NOT equal to 90, 180, 270 or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. (optional)

// Generate barcode using POST request with parameters in multipart form.
GenerateAPI.generateMultipart(barcodeType: barcodeType, data: data, dataType: dataType, imageFormat: imageFormat, textLocation: textLocation, foregroundColor: foregroundColor, backgroundColor: backgroundColor, units: units, resolution: resolution, imageHeight: imageHeight, imageWidth: imageWidth, rotationAngle: rotationAngle) { (response, error) in
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
 **barcodeType** | [**EncodeBarcodeType**](EncodeBarcodeType.md) |  | 
 **data** | **String** | String represents data to encode | 
 **dataType** | [**EncodeDataType**](EncodeDataType.md) |  | [optional] 
 **imageFormat** | [**BarcodeImageFormat**](BarcodeImageFormat.md) |  | [optional] 
 **textLocation** | [**CodeLocation**](CodeLocation.md) |  | [optional] 
 **foregroundColor** | **String** | Specify the displaying bars and content Color. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: Black. | [optional] [default to &quot;Black&quot;]
 **backgroundColor** | **String** | Background color of the barcode image. Value: Color name from https://reference.aspose.com/drawing/net/system.drawing/color/ or ARGB value started with #. For example: AliceBlue or #FF000000 Default value: White. | [optional] [default to &quot;White&quot;]
 **units** | [**GraphicsUnit**](GraphicsUnit.md) |  | [optional] 
 **resolution** | **Float** | Resolution of the BarCode image. One value for both dimensions. Default value: 96 dpi. Decimal separator is dot. | [optional] 
 **imageHeight** | **Float** | Height of the barcode image in given units. Default units: pixel. Decimal separator is dot. | [optional] 
 **imageWidth** | **Float** | Width of the barcode image in given units. Default units: pixel. Decimal separator is dot. | [optional] 
 **rotationAngle** | **Int** | BarCode image rotation angle, measured in degree, e.g. RotationAngle &#x3D; 0 or RotationAngle &#x3D; 360 means no rotation. If RotationAngle NOT equal to 90, 180, 270 or 0, it may increase the difficulty for the scanner to read the image. Default value: 0. | [optional] 

### Return type

**Data**

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: image/png, image/bmp, image/gif, image/jpeg, image/svg+xml, image/tiff, application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

