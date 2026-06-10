# ScanAPI

All URIs are relative to *https://api.aspose.cloud/v4.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**scan**](ScanAPI.md#scan) | **GET** /barcode/scan | Scan a barcode from a file on an Internet server using a GET request with a query string parameter. For scanning files from your hard drive, use &#x60;scan-body&#x60; or &#x60;scan-multipart&#x60; endpoints instead.
[**scanBase64**](ScanAPI.md#scanbase64) | **POST** /barcode/scan-body | Scan a barcode from a file in the request body using a POST request with a JSON or XML body parameter.
[**scanMultipart**](ScanAPI.md#scanmultipart) | **POST** /barcode/scan-multipart | Scan a barcode from a file in the request body using a POST request with a multipart form parameter.


# **scan**
```swift
    open class func scan(fileUrl: String, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Scan a barcode from a file on an Internet server using a GET request with a query string parameter. For scanning files from your hard drive, use `scan-body` or `scan-multipart` endpoints instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let fileUrl = "fileUrl_example" // String | URL to the barcode image.

// Scan a barcode from a file on an Internet server using a GET request with a query string parameter. For scanning files from your hard drive, use `scan-body` or `scan-multipart` endpoints instead.
ScanAPI.scan(fileUrl: fileUrl) { (response, error) in
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
 **fileUrl** | **String** | URL to the barcode image. | 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **scanBase64**
```swift
    open class func scanBase64(scanBase64Request: ScanBase64Request, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Scan a barcode from a file in the request body using a POST request with a JSON or XML body parameter.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let scanBase64Request = ScanBase64Request(fileBase64: "fileBase64_example") // ScanBase64Request | Barcode scan request.

// Scan a barcode from a file in the request body using a POST request with a JSON or XML body parameter.
ScanAPI.scanBase64(scanBase64Request: scanBase64Request) { (response, error) in
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
 **scanBase64Request** | [**ScanBase64Request**](ScanBase64Request.md) | Barcode scan request. | 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json, application/xml
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **scanMultipart**
```swift
    open class func scanMultipart(file: Data, completion: @escaping (_ data: BarcodeResponseList?, _ error: Error?) -> Void)
```

Scan a barcode from a file in the request body using a POST request with a multipart form parameter.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import AsposeBarcodeCloud

let file = Data([9, 8, 7]) // Data | Barcode image file.

// Scan a barcode from a file in the request body using a POST request with a multipart form parameter.
ScanAPI.scanMultipart(file: file) { (response, error) in
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
 **file** | **Data** | Barcode image file. | 

### Return type

[**BarcodeResponseList**](BarcodeResponseList.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

