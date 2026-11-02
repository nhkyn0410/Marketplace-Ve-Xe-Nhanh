# api_client_dart.api.OperatorTripSchedulesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tripScheduleControllerCreate**](OperatorTripSchedulesApi.md#tripschedulecontrollercreate) | **POST** /v1/operator/trip-schedules | 
[**tripScheduleControllerGenerate**](OperatorTripSchedulesApi.md#tripschedulecontrollergenerate) | **POST** /v1/operator/trip-schedules/{scheduleId}/generate | 
[**tripScheduleControllerGet**](OperatorTripSchedulesApi.md#tripschedulecontrollerget) | **GET** /v1/operator/trip-schedules/{scheduleId} | 
[**tripScheduleControllerList**](OperatorTripSchedulesApi.md#tripschedulecontrollerlist) | **GET** /v1/operator/trip-schedules | 
[**tripScheduleControllerUpdate**](OperatorTripSchedulesApi.md#tripschedulecontrollerupdate) | **PUT** /v1/operator/trip-schedules/{scheduleId} | 


# **tripScheduleControllerCreate**
> TripScheduleResponseDtoOutput tripScheduleControllerCreate(tripScheduleInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripSchedulesApi();
final TripScheduleInputDto tripScheduleInputDto = ; // TripScheduleInputDto | 

try {
    final response = api.tripScheduleControllerCreate(tripScheduleInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripSchedulesApi->tripScheduleControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripScheduleInputDto** | [**TripScheduleInputDto**](TripScheduleInputDto.md)|  | 

### Return type

[**TripScheduleResponseDtoOutput**](TripScheduleResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tripScheduleControllerGenerate**
> TripScheduleGenerateResponseDtoOutput tripScheduleControllerGenerate(scheduleId, tripScheduleGenerateInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripSchedulesApi();
final String scheduleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TripScheduleGenerateInputDto tripScheduleGenerateInputDto = ; // TripScheduleGenerateInputDto | 

try {
    final response = api.tripScheduleControllerGenerate(scheduleId, tripScheduleGenerateInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripSchedulesApi->tripScheduleControllerGenerate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scheduleId** | **String**|  | 
 **tripScheduleGenerateInputDto** | [**TripScheduleGenerateInputDto**](TripScheduleGenerateInputDto.md)|  | 

### Return type

[**TripScheduleGenerateResponseDtoOutput**](TripScheduleGenerateResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tripScheduleControllerGet**
> TripScheduleResponseDtoOutput tripScheduleControllerGet(scheduleId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripSchedulesApi();
final String scheduleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.tripScheduleControllerGet(scheduleId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripSchedulesApi->tripScheduleControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scheduleId** | **String**|  | 

### Return type

[**TripScheduleResponseDtoOutput**](TripScheduleResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tripScheduleControllerList**
> TripScheduleListResponseDtoOutput tripScheduleControllerList()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripSchedulesApi();

try {
    final response = api.tripScheduleControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripSchedulesApi->tripScheduleControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**TripScheduleListResponseDtoOutput**](TripScheduleListResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tripScheduleControllerUpdate**
> TripScheduleResponseDtoOutput tripScheduleControllerUpdate(scheduleId, tripScheduleInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripSchedulesApi();
final String scheduleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TripScheduleInputDto tripScheduleInputDto = ; // TripScheduleInputDto | 

try {
    final response = api.tripScheduleControllerUpdate(scheduleId, tripScheduleInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripSchedulesApi->tripScheduleControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scheduleId** | **String**|  | 
 **tripScheduleInputDto** | [**TripScheduleInputDto**](TripScheduleInputDto.md)|  | 

### Return type

[**TripScheduleResponseDtoOutput**](TripScheduleResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

