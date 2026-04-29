# RecognizeAPI

All URIs are relative to *https://api.aspose.cloud/v4.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**recognize**](RecognizeAPI.md#recognize) | **GET** /barcode/recognize | Recognize barcode from file on server in the Internet using GET requests with parameter in query string. For recognizing files from your hard drive use &#x60;recognize-body&#x60; or &#x60;recognize-multipart&#x60; endpoints instead.
[**recognizeBase64**](RecognizeAPI.md#recognizebase64) | **POST** /barcode/recognize-body | Recognize barcode from file in request body using POST requests with parameters in body in json or xml format.
[**recognizeMultipart**](RecognizeAPI.md#recognizemultipart) | **POST** /barcode/recognize-multipart | Recognize barcode from file in request body using POST requests with parameters in multipart form.


# **recognize**
```swift
    open class func recognize(barcodeType: DecodeBarcodeType, fileUrl: String, recognitionMode: RecognitionMode? = nil, recognitionImageKind: RecognitionImageKind? = nil, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Recognize barcode from file on server in the Internet using GET requests with parameter in query string. For recognizing files from your hard drive use `recognize-body` or `recognize-multipart` endpoints instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = DecodeBarcodeType() // DecodeBarcodeType | Type of barcode to recognize
let fileUrl = "fileUrl_example" // String | Url to barcode image
let recognitionMode = RecognitionMode() // RecognitionMode | Recognition mode (optional)
let recognitionImageKind = RecognitionImageKind() // RecognitionImageKind | Image kind for recognition (optional)

// Recognize barcode from file on server in the Internet using GET requests with parameter in query string. For recognizing files from your hard drive use `recognize-body` or `recognize-multipart` endpoints instead.
RecognizeAPI.recognize(barcodeType: barcodeType, fileUrl: fileUrl, recognitionMode: recognitionMode, recognitionImageKind: recognitionImageKind) { (response, error) in
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
 **barcodeType** | [**DecodeBarcodeType**](.md) | Type of barcode to recognize | 
 **fileUrl** | **String** | Url to barcode image | 
 **recognitionMode** | [**RecognitionMode**](.md) | Recognition mode | [optional] 
 **recognitionImageKind** | [**RecognitionImageKind**](.md) | Image kind for recognition | [optional] 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recognizeBase64**
```swift
    open class func recognizeBase64(recognizeBase64Request: RecognizeBase64Request, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Recognize barcode from file in request body using POST requests with parameters in body in json or xml format.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let recognizeBase64Request = RecognizeBase64Request(barcodeTypes: [DecodeBarcodeType()], fileBase64: "fileBase64_example", recognitionMode: RecognitionMode(), recognitionImageKind: RecognitionImageKind()) // RecognizeBase64Request | Barcode recognition request

// Recognize barcode from file in request body using POST requests with parameters in body in json or xml format.
RecognizeAPI.recognizeBase64(recognizeBase64Request: recognizeBase64Request) { (response, error) in
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
 **recognizeBase64Request** | [**RecognizeBase64Request**](RecognizeBase64Request.md) | Barcode recognition request | 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json, application/xml
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recognizeMultipart**
```swift
    open class func recognizeMultipart(barcodeType: DecodeBarcodeType, file: Data, recognitionMode: RecognitionMode? = nil, recognitionImageKind: RecognitionImageKind? = nil, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Recognize barcode from file in request body using POST requests with parameters in multipart form.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let barcodeType = DecodeBarcodeType() // DecodeBarcodeType | 
let file = Data([9, 8, 7]) // Data | Barcode image file
let recognitionMode = RecognitionMode() // RecognitionMode |  (optional)
let recognitionImageKind = RecognitionImageKind() // RecognitionImageKind |  (optional)

// Recognize barcode from file in request body using POST requests with parameters in multipart form.
RecognizeAPI.recognizeMultipart(barcodeType: barcodeType, file: file, recognitionMode: recognitionMode, recognitionImageKind: recognitionImageKind) { (response, error) in
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
 **barcodeType** | [**DecodeBarcodeType**](DecodeBarcodeType.md) |  | 
 **file** | **Data** | Barcode image file | 
 **recognitionMode** | [**RecognitionMode**](RecognitionMode.md) |  | [optional] 
 **recognitionImageKind** | [**RecognitionImageKind**](RecognitionImageKind.md) |  | [optional] 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

