# api_client_dart.api.JourneyLogsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminJourneyLogControllerList**](JourneyLogsApi.md#adminjourneylogcontrollerlist) | **GET** /v1/admin/journey-logs | 
[**employeeJourneyLogControllerCreate**](JourneyLogsApi.md#employeejourneylogcontrollercreate) | **POST** /v1/employee/journey-logs | 
[**employeeJourneyLogControllerList**](JourneyLogsApi.md#employeejourneylogcontrollerlist) | **GET** /v1/employee/journey-logs | 
[**operatorJourneyLogControllerList**](JourneyLogsApi.md#operatorjourneylogcontrollerlist) | **GET** /v1/operator/journey-logs | 


# **adminJourneyLogControllerList**
> JourneyLogPageDtoOutput adminJourneyLogControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyLogsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminJourneyLogControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyLogsApi->adminJourneyLogControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**JourneyLogPageDtoOutput**](JourneyLogPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeJourneyLogControllerCreate**
> JourneyLogDtoOutput employeeJourneyLogControllerCreate(journeyLogInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyLogsApi();
final JourneyLogInputDto journeyLogInputDto = ; // JourneyLogInputDto | 

try {
    final response = api.employeeJourneyLogControllerCreate(journeyLogInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyLogsApi->employeeJourneyLogControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **journeyLogInputDto** | [**JourneyLogInputDto**](JourneyLogInputDto.md)|  | 

### Return type

[**JourneyLogDtoOutput**](JourneyLogDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeJourneyLogControllerList**
> JourneyLogPageDtoOutput employeeJourneyLogControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyLogsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.employeeJourneyLogControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyLogsApi->employeeJourneyLogControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**JourneyLogPageDtoOutput**](JourneyLogPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorJourneyLogControllerList**
> JourneyLogPageDtoOutput operatorJourneyLogControllerList(tripId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyLogsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int limit = 56; // int | 

try {
    final response = api.operatorJourneyLogControllerList(tripId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyLogsApi->operatorJourneyLogControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**JourneyLogPageDtoOutput**](JourneyLogPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

