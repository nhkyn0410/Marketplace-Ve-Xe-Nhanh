# api_client_dart.api.OperatorTripAssignmentsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeeAssignmentControllerAssignDriver**](OperatorTripAssignmentsApi.md#employeeassignmentcontrollerassigndriver) | **PUT** /v1/operator/trips/{tripId}/driver | 
[**employeeAssignmentControllerList**](OperatorTripAssignmentsApi.md#employeeassignmentcontrollerlist) | **GET** /v1/operator/trip-assignments | 


# **employeeAssignmentControllerAssignDriver**
> TripAssignmentDtoOutput employeeAssignmentControllerAssignDriver(tripId, driverAssignmentInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripAssignmentsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DriverAssignmentInputDto driverAssignmentInputDto = ; // DriverAssignmentInputDto | 

try {
    final response = api.employeeAssignmentControllerAssignDriver(tripId, driverAssignmentInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripAssignmentsApi->employeeAssignmentControllerAssignDriver: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 
 **driverAssignmentInputDto** | [**DriverAssignmentInputDto**](DriverAssignmentInputDto.md)|  | 

### Return type

[**TripAssignmentDtoOutput**](TripAssignmentDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeAssignmentControllerList**
> TripAssignmentPageDtoOutput employeeAssignmentControllerList(date, routeId, state, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorTripAssignmentsApi();
final Date date = 2013-10-20; // Date | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String state = state_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.employeeAssignmentControllerList(date, routeId, state, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorTripAssignmentsApi->employeeAssignmentControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **Date**|  | 
 **routeId** | **String**|  | [optional] 
 **state** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**TripAssignmentPageDtoOutput**](TripAssignmentPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

