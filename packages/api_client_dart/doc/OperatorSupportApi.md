# api_client_dart.api.OperatorSupportApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorSupportControllerDownload**](OperatorSupportApi.md#operatorsupportcontrollerdownload) | **POST** /v1/operator/support-attachments/{attachmentId}/download-url | 
[**operatorSupportControllerGet**](OperatorSupportApi.md#operatorsupportcontrollerget) | **GET** /v1/operator/support-tickets/{ticketId} | 
[**operatorSupportControllerList**](OperatorSupportApi.md#operatorsupportcontrollerlist) | **GET** /v1/operator/support-tickets | 
[**operatorSupportControllerReply**](OperatorSupportApi.md#operatorsupportcontrollerreply) | **POST** /v1/operator/support-tickets/{ticketId}/messages | 
[**operatorSupportControllerUpload**](OperatorSupportApi.md#operatorsupportcontrollerupload) | **POST** /v1/operator/support-attachments/upload-url | 


# **operatorSupportControllerDownload**
> DownloadUrlResponseDtoOutput operatorSupportControllerDownload(attachmentId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorSupportApi();
final String attachmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorSupportControllerDownload(attachmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorSupportApi->operatorSupportControllerDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **attachmentId** | **String**|  | 

### Return type

[**DownloadUrlResponseDtoOutput**](DownloadUrlResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorSupportControllerGet**
> TicketDetailDtoOutput operatorSupportControllerGet(ticketId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorSupportControllerGet(ticketId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorSupportApi->operatorSupportControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorSupportControllerList**
> TicketPageDtoOutput operatorSupportControllerList(status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorSupportApi();
final String status = status_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorSupportControllerList(status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorSupportApi->operatorSupportControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**TicketPageDtoOutput**](TicketPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorSupportControllerReply**
> TicketDetailDtoOutput operatorSupportControllerReply(ticketId, messageInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final MessageInputDto messageInputDto = ; // MessageInputDto | 

try {
    final response = api.operatorSupportControllerReply(ticketId, messageInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorSupportApi->operatorSupportControllerReply: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **messageInputDto** | [**MessageInputDto**](MessageInputDto.md)|  | 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorSupportControllerUpload**
> AttachmentUploadResponseDtoOutput operatorSupportControllerUpload(attachmentUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorSupportApi();
final AttachmentUploadInputDto attachmentUploadInputDto = ; // AttachmentUploadInputDto | 

try {
    final response = api.operatorSupportControllerUpload(attachmentUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorSupportApi->operatorSupportControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **attachmentUploadInputDto** | [**AttachmentUploadInputDto**](AttachmentUploadInputDto.md)|  | 

### Return type

[**AttachmentUploadResponseDtoOutput**](AttachmentUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

