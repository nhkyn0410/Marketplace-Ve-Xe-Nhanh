# api_client_dart.api.EmployeeOperationsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeeOperationsControllerAssignments**](EmployeeOperationsApi.md#employeeoperationscontrollerassignments) | **GET** /v1/employee/assignments | 
[**employeeOperationsControllerCheckIn**](EmployeeOperationsApi.md#employeeoperationscontrollercheckin) | **POST** /v1/employee/check-ins | 
[**employeeOperationsControllerOperate**](EmployeeOperationsApi.md#employeeoperationscontrolleroperate) | **POST** /v1/employee/trips/{tripId}/status | 
[**employeeOperationsControllerPassengers**](EmployeeOperationsApi.md#employeeoperationscontrollerpassengers) | **GET** /v1/employee/trips/{tripId}/passengers | 
[**employeeOperationsControllerVerify**](EmployeeOperationsApi.md#employeeoperationscontrollerverify) | **POST** /v1/employee/tickets/verify | 


# **employeeOperationsControllerAssignments**
> EmployeeAssignmentListDtoOutput employeeOperationsControllerAssignments(from, to)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getEmployeeOperationsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 

try {
    final response = api.employeeOperationsControllerAssignments(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmployeeOperationsApi->employeeOperationsControllerAssignments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 

### Return type

[**EmployeeAssignmentListDtoOutput**](EmployeeAssignmentListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeOperationsControllerCheckIn**
> CheckInResultDtoOutput employeeOperationsControllerCheckIn(checkInInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getEmployeeOperationsApi();
final CheckInInputDto checkInInputDto = ; // CheckInInputDto | 

try {
    final response = api.employeeOperationsControllerCheckIn(checkInInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmployeeOperationsApi->employeeOperationsControllerCheckIn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkInInputDto** | [**CheckInInputDto**](CheckInInputDto.md)|  | 

### Return type

[**CheckInResultDtoOutput**](CheckInResultDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeOperationsControllerOperate**
> EmployeeAssignmentDtoOutput employeeOperationsControllerOperate(tripId, tripOperationInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getEmployeeOperationsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TripOperationInputDto tripOperationInputDto = ; // TripOperationInputDto | 

try {
    final response = api.employeeOperationsControllerOperate(tripId, tripOperationInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmployeeOperationsApi->employeeOperationsControllerOperate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 
 **tripOperationInputDto** | [**TripOperationInputDto**](TripOperationInputDto.md)|  | 

### Return type

[**EmployeeAssignmentDtoOutput**](EmployeeAssignmentDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeOperationsControllerPassengers**
> TripManifestDtoOutput employeeOperationsControllerPassengers(tripId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getEmployeeOperationsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.employeeOperationsControllerPassengers(tripId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmployeeOperationsApi->employeeOperationsControllerPassengers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 

### Return type

[**TripManifestDtoOutput**](TripManifestDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeOperationsControllerVerify**
> TicketVerifyResultDtoOutput employeeOperationsControllerVerify(ticketVerifyInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getEmployeeOperationsApi();
final TicketVerifyInputDto ticketVerifyInputDto = ; // TicketVerifyInputDto | 

try {
    final response = api.employeeOperationsControllerVerify(ticketVerifyInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmployeeOperationsApi->employeeOperationsControllerVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketVerifyInputDto** | [**TicketVerifyInputDto**](TicketVerifyInputDto.md)|  | 

### Return type

[**TicketVerifyResultDtoOutput**](TicketVerifyResultDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

