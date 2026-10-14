# api_client_dart.api.OperatorApplicationsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorApplicationControllerCreate**](OperatorApplicationsApi.md#operatorapplicationcontrollercreate) | **POST** /v1/operator-applications | 
[**operatorApplicationControllerCreateDocumentDownload**](OperatorApplicationsApi.md#operatorapplicationcontrollercreatedocumentdownload) | **POST** /v1/operator-applications/current/documents/{type}/download-url | 
[**operatorApplicationControllerCreateDocumentUpload**](OperatorApplicationsApi.md#operatorapplicationcontrollercreatedocumentupload) | **POST** /v1/operator-applications/current/documents | 
[**operatorApplicationControllerGet**](OperatorApplicationsApi.md#operatorapplicationcontrollerget) | **GET** /v1/operator-applications/current | 
[**operatorApplicationControllerRequestAccessLink**](OperatorApplicationsApi.md#operatorapplicationcontrollerrequestaccesslink) | **POST** /v1/operator-applications/access-link | 
[**operatorApplicationControllerSubmit**](OperatorApplicationsApi.md#operatorapplicationcontrollersubmit) | **POST** /v1/operator-applications/current/submit | 
[**operatorApplicationControllerUpdate**](OperatorApplicationsApi.md#operatorapplicationcontrollerupdate) | **PUT** /v1/operator-applications/current | 


# **operatorApplicationControllerCreate**
> operatorApplicationControllerCreate(applicationCreateInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final ApplicationCreateInputDto applicationCreateInputDto = ; // ApplicationCreateInputDto | 

try {
    api.operatorApplicationControllerCreate(applicationCreateInputDto);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationCreateInputDto** | [**ApplicationCreateInputDto**](ApplicationCreateInputDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerCreateDocumentDownload**
> DocumentDownloadResponseDtoOutput operatorApplicationControllerCreateDocumentDownload(type, xApplicationToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final String type = type_example; // String | 
final String xApplicationToken = xApplicationToken_example; // String | Token trong link bảo mật gửi email.

try {
    final response = api.operatorApplicationControllerCreateDocumentDownload(type, xApplicationToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerCreateDocumentDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **xApplicationToken** | **String**| Token trong link bảo mật gửi email. | 

### Return type

[**DocumentDownloadResponseDtoOutput**](DocumentDownloadResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerCreateDocumentUpload**
> DocumentUploadResponseDtoOutput operatorApplicationControllerCreateDocumentUpload(xApplicationToken, documentUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final String xApplicationToken = xApplicationToken_example; // String | Token trong link bảo mật gửi email.
final DocumentUploadInputDto documentUploadInputDto = ; // DocumentUploadInputDto | 

try {
    final response = api.operatorApplicationControllerCreateDocumentUpload(xApplicationToken, documentUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerCreateDocumentUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xApplicationToken** | **String**| Token trong link bảo mật gửi email. | 
 **documentUploadInputDto** | [**DocumentUploadInputDto**](DocumentUploadInputDto.md)|  | 

### Return type

[**DocumentUploadResponseDtoOutput**](DocumentUploadResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerGet**
> ApplicationResponseDtoOutput operatorApplicationControllerGet(xApplicationToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final String xApplicationToken = xApplicationToken_example; // String | Token trong link bảo mật gửi email.

try {
    final response = api.operatorApplicationControllerGet(xApplicationToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xApplicationToken** | **String**| Token trong link bảo mật gửi email. | 

### Return type

[**ApplicationResponseDtoOutput**](ApplicationResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerRequestAccessLink**
> operatorApplicationControllerRequestAccessLink(applicationAccessLinkInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final ApplicationAccessLinkInputDto applicationAccessLinkInputDto = ; // ApplicationAccessLinkInputDto | 

try {
    api.operatorApplicationControllerRequestAccessLink(applicationAccessLinkInputDto);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerRequestAccessLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationAccessLinkInputDto** | [**ApplicationAccessLinkInputDto**](ApplicationAccessLinkInputDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerSubmit**
> ApplicationResponseDtoOutput operatorApplicationControllerSubmit(xApplicationToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final String xApplicationToken = xApplicationToken_example; // String | Token trong link bảo mật gửi email.

try {
    final response = api.operatorApplicationControllerSubmit(xApplicationToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerSubmit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xApplicationToken** | **String**| Token trong link bảo mật gửi email. | 

### Return type

[**ApplicationResponseDtoOutput**](ApplicationResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationControllerUpdate**
> ApplicationResponseDtoOutput operatorApplicationControllerUpdate(xApplicationToken, applicationUpdateInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorApplicationsApi();
final String xApplicationToken = xApplicationToken_example; // String | Token trong link bảo mật gửi email.
final ApplicationUpdateInputDto applicationUpdateInputDto = ; // ApplicationUpdateInputDto | 

try {
    final response = api.operatorApplicationControllerUpdate(xApplicationToken, applicationUpdateInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorApplicationsApi->operatorApplicationControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xApplicationToken** | **String**| Token trong link bảo mật gửi email. | 
 **applicationUpdateInputDto** | [**ApplicationUpdateInputDto**](ApplicationUpdateInputDto.md)|  | 

### Return type

[**ApplicationResponseDtoOutput**](ApplicationResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

