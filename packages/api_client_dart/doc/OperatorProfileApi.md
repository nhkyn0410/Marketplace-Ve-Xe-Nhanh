# api_client_dart.api.OperatorProfileApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorProfileControllerCreateDownloadUrl**](OperatorProfileApi.md#operatorprofilecontrollercreatedownloadurl) | **POST** /v1/operator/profile/documents/{type}/download-url | 
[**operatorProfileControllerCreateUploadUrl**](OperatorProfileApi.md#operatorprofilecontrollercreateuploadurl) | **POST** /v1/operator/profile/documents/upload-url | 
[**operatorProfileControllerGet**](OperatorProfileApi.md#operatorprofilecontrollerget) | **GET** /v1/operator/profile | 
[**operatorProfileControllerReplaceDocument**](OperatorProfileApi.md#operatorprofilecontrollerreplacedocument) | **PUT** /v1/operator/profile/documents/{type} | 
[**operatorProfileControllerRequestBankChange**](OperatorProfileApi.md#operatorprofilecontrollerrequestbankchange) | **POST** /v1/operator/profile/bank-account-change | 
[**operatorProfileControllerUpdate**](OperatorProfileApi.md#operatorprofilecontrollerupdate) | **PUT** /v1/operator/profile | 


# **operatorProfileControllerCreateDownloadUrl**
> KycDownloadResponseDtoOutput operatorProfileControllerCreateDownloadUrl(type)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();
final String type = type_example; // String | 

try {
    final response = api.operatorProfileControllerCreateDownloadUrl(type);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerCreateDownloadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 

### Return type

[**KycDownloadResponseDtoOutput**](KycDownloadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorProfileControllerCreateUploadUrl**
> KycUploadResponseDtoOutput operatorProfileControllerCreateUploadUrl(kycUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();
final KycUploadInputDto kycUploadInputDto = ; // KycUploadInputDto | 

try {
    final response = api.operatorProfileControllerCreateUploadUrl(kycUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerCreateUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kycUploadInputDto** | [**KycUploadInputDto**](KycUploadInputDto.md)|  | 

### Return type

[**KycUploadResponseDtoOutput**](KycUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorProfileControllerGet**
> OperatorProfileResponseDtoOutput operatorProfileControllerGet()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();

try {
    final response = api.operatorProfileControllerGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OperatorProfileResponseDtoOutput**](OperatorProfileResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorProfileControllerReplaceDocument**
> OperatorProfileResponseDtoOutput operatorProfileControllerReplaceDocument(type, kycReplaceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();
final String type = type_example; // String | 
final KycReplaceInputDto kycReplaceInputDto = ; // KycReplaceInputDto | 

try {
    final response = api.operatorProfileControllerReplaceDocument(type, kycReplaceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerReplaceDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **kycReplaceInputDto** | [**KycReplaceInputDto**](KycReplaceInputDto.md)|  | 

### Return type

[**OperatorProfileResponseDtoOutput**](OperatorProfileResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorProfileControllerRequestBankChange**
> OperatorProfileResponseDtoOutput operatorProfileControllerRequestBankChange(bankChangeInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();
final BankChangeInputDto bankChangeInputDto = ; // BankChangeInputDto | 

try {
    final response = api.operatorProfileControllerRequestBankChange(bankChangeInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerRequestBankChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bankChangeInputDto** | [**BankChangeInputDto**](BankChangeInputDto.md)|  | 

### Return type

[**OperatorProfileResponseDtoOutput**](OperatorProfileResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorProfileControllerUpdate**
> OperatorProfileResponseDtoOutput operatorProfileControllerUpdate(operatorProfileUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorProfileApi();
final OperatorProfileUpdateDto operatorProfileUpdateDto = ; // OperatorProfileUpdateDto | 

try {
    final response = api.operatorProfileControllerUpdate(operatorProfileUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorProfileApi->operatorProfileControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorProfileUpdateDto** | [**OperatorProfileUpdateDto**](OperatorProfileUpdateDto.md)|  | 

### Return type

[**OperatorProfileResponseDtoOutput**](OperatorProfileResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

