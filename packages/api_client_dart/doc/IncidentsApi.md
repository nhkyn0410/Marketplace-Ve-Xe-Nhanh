# api_client_dart.api.IncidentsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminIncidentControllerDownload**](IncidentsApi.md#adminincidentcontrollerdownload) | **GET** /v1/admin/incidents/{incidentId}/evidence/{index} | 
[**adminIncidentControllerList**](IncidentsApi.md#adminincidentcontrollerlist) | **GET** /v1/admin/incidents | 
[**employeeIncidentControllerCreate**](IncidentsApi.md#employeeincidentcontrollercreate) | **POST** /v1/employee/incidents | 
[**employeeIncidentControllerList**](IncidentsApi.md#employeeincidentcontrollerlist) | **GET** /v1/employee/incidents | 
[**employeeIncidentControllerUpload**](IncidentsApi.md#employeeincidentcontrollerupload) | **POST** /v1/employee/trips/{tripId}/incident-attachments | 
[**operatorIncidentControllerDownload**](IncidentsApi.md#operatorincidentcontrollerdownload) | **GET** /v1/operator/incidents/{incidentId}/evidence/{index} | 
[**operatorIncidentControllerList**](IncidentsApi.md#operatorincidentcontrollerlist) | **GET** /v1/operator/incidents | 
[**operatorIncidentControllerResolve**](IncidentsApi.md#operatorincidentcontrollerresolve) | **PUT** /v1/operator/incidents/{incidentId}/resolution | 


# **adminIncidentControllerDownload**
> DownloadUrlResponseDtoOutput adminIncidentControllerDownload(incidentId, index)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String incidentId = incidentId_example; // String | 
final num index = 8.14; // num | 

try {
    final response = api.adminIncidentControllerDownload(incidentId, index);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->adminIncidentControllerDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **incidentId** | **String**|  | 
 **index** | **num**|  | 

### Return type

[**DownloadUrlResponseDtoOutput**](DownloadUrlResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminIncidentControllerList**
> IncidentPageDtoOutput adminIncidentControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminIncidentControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->adminIncidentControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**IncidentPageDtoOutput**](IncidentPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeIncidentControllerCreate**
> IncidentDtoOutput employeeIncidentControllerCreate(incidentInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final IncidentInputDto incidentInputDto = ; // IncidentInputDto | 

try {
    final response = api.employeeIncidentControllerCreate(incidentInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->employeeIncidentControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **incidentInputDto** | [**IncidentInputDto**](IncidentInputDto.md)|  | 

### Return type

[**IncidentDtoOutput**](IncidentDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeIncidentControllerList**
> IncidentPageDtoOutput employeeIncidentControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.employeeIncidentControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->employeeIncidentControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**IncidentPageDtoOutput**](IncidentPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeIncidentControllerUpload**
> AttachmentUploadResponseDtoOutput employeeIncidentControllerUpload(tripId, attachmentUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String tripId = tripId_example; // String | 
final AttachmentUploadInputDto attachmentUploadInputDto = ; // AttachmentUploadInputDto | 

try {
    final response = api.employeeIncidentControllerUpload(tripId, attachmentUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->employeeIncidentControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 
 **attachmentUploadInputDto** | [**AttachmentUploadInputDto**](AttachmentUploadInputDto.md)|  | 

### Return type

[**AttachmentUploadResponseDtoOutput**](AttachmentUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorIncidentControllerDownload**
> DownloadUrlResponseDtoOutput operatorIncidentControllerDownload(incidentId, index)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String incidentId = incidentId_example; // String | 
final num index = 8.14; // num | 

try {
    final response = api.operatorIncidentControllerDownload(incidentId, index);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->operatorIncidentControllerDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **incidentId** | **String**|  | 
 **index** | **num**|  | 

### Return type

[**DownloadUrlResponseDtoOutput**](DownloadUrlResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorIncidentControllerList**
> IncidentPageDtoOutput operatorIncidentControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.operatorIncidentControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->operatorIncidentControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**IncidentPageDtoOutput**](IncidentPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorIncidentControllerResolve**
> IncidentDtoOutput operatorIncidentControllerResolve(incidentId, incidentResolutionDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getIncidentsApi();
final String incidentId = incidentId_example; // String | 
final IncidentResolutionDto incidentResolutionDto = ; // IncidentResolutionDto | 

try {
    final response = api.operatorIncidentControllerResolve(incidentId, incidentResolutionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IncidentsApi->operatorIncidentControllerResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **incidentId** | **String**|  | 
 **incidentResolutionDto** | [**IncidentResolutionDto**](IncidentResolutionDto.md)|  | 

### Return type

[**IncidentDtoOutput**](IncidentDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

