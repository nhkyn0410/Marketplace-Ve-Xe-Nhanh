# api_client_dart.api.AdminSupportApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminSupportControllerAssignees**](AdminSupportApi.md#adminsupportcontrollerassignees) | **GET** /v1/admin/support-assignees | 
[**adminSupportControllerClassify**](AdminSupportApi.md#adminsupportcontrollerclassify) | **PATCH** /v1/admin/support-tickets/{ticketId} | 
[**adminSupportControllerDownload**](AdminSupportApi.md#adminsupportcontrollerdownload) | **POST** /v1/admin/support-attachments/{attachmentId}/download-url | 
[**adminSupportControllerGet**](AdminSupportApi.md#adminsupportcontrollerget) | **GET** /v1/admin/support-tickets/{ticketId} | 
[**adminSupportControllerList**](AdminSupportApi.md#adminsupportcontrollerlist) | **GET** /v1/admin/support-tickets | 
[**adminSupportControllerReply**](AdminSupportApi.md#adminsupportcontrollerreply) | **POST** /v1/admin/support-tickets/{ticketId}/messages | 
[**adminSupportControllerSetStatus**](AdminSupportApi.md#adminsupportcontrollersetstatus) | **POST** /v1/admin/support-tickets/{ticketId}/status | 
[**adminSupportControllerUpload**](AdminSupportApi.md#adminsupportcontrollerupload) | **POST** /v1/admin/support-tickets/{ticketId}/attachments/upload-url | 


# **adminSupportControllerAssignees**
> AssigneeListDtoOutput adminSupportControllerAssignees()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();

try {
    final response = api.adminSupportControllerAssignees();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerAssignees: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AssigneeListDtoOutput**](AssigneeListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSupportControllerClassify**
> TicketDetailDtoOutput adminSupportControllerClassify(ticketId, classifyInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ClassifyInputDto classifyInputDto = ; // ClassifyInputDto | 

try {
    final response = api.adminSupportControllerClassify(ticketId, classifyInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerClassify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **classifyInputDto** | [**ClassifyInputDto**](ClassifyInputDto.md)|  | 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSupportControllerDownload**
> DownloadUrlResponseDtoOutput adminSupportControllerDownload(attachmentId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String attachmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminSupportControllerDownload(attachmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerDownload: $e\n');
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

# **adminSupportControllerGet**
> TicketDetailDtoOutput adminSupportControllerGet(ticketId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminSupportControllerGet(ticketId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerGet: $e\n');
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

# **adminSupportControllerList**
> TicketPageDtoOutput adminSupportControllerList(status, category, operatorId, assigneeId, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String status = status_example; // String | 
final String category = category_example; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String assigneeId = assigneeId_example; // String | UUID tài khoản nền tảng hoặc `none`.
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminSupportControllerList(status, category, operatorId, assigneeId, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **category** | **String**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **assigneeId** | **String**| UUID tài khoản nền tảng hoặc `none`. | [optional] 
 **q** | **String**|  | [optional] 
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

# **adminSupportControllerReply**
> TicketDetailDtoOutput adminSupportControllerReply(ticketId, adminMessageInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminMessageInputDto adminMessageInputDto = ; // AdminMessageInputDto | 

try {
    final response = api.adminSupportControllerReply(ticketId, adminMessageInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerReply: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **adminMessageInputDto** | [**AdminMessageInputDto**](AdminMessageInputDto.md)|  | 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSupportControllerSetStatus**
> TicketDetailDtoOutput adminSupportControllerSetStatus(ticketId, ticketStatusInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TicketStatusInputDto ticketStatusInputDto = ; // TicketStatusInputDto | 

try {
    final response = api.adminSupportControllerSetStatus(ticketId, ticketStatusInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerSetStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **ticketStatusInputDto** | [**TicketStatusInputDto**](TicketStatusInputDto.md)|  | 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSupportControllerUpload**
> AttachmentUploadResponseDtoOutput adminSupportControllerUpload(ticketId, attachmentUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSupportApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AttachmentUploadInputDto attachmentUploadInputDto = ; // AttachmentUploadInputDto | 

try {
    final response = api.adminSupportControllerUpload(ticketId, attachmentUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->adminSupportControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **attachmentUploadInputDto** | [**AttachmentUploadInputDto**](AttachmentUploadInputDto.md)|  | 

### Return type

[**AttachmentUploadResponseDtoOutput**](AttachmentUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

