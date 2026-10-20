# api_client_dart.api.PassengerProfileApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**passengerProfileControllerBookings**](PassengerProfileApi.md#passengerprofilecontrollerbookings) | **GET** /v1/me/bookings | 
[**passengerProfileControllerCreateSaved**](PassengerProfileApi.md#passengerprofilecontrollercreatesaved) | **POST** /v1/me/saved-passengers | 
[**passengerProfileControllerDeleteSaved**](PassengerProfileApi.md#passengerprofilecontrollerdeletesaved) | **DELETE** /v1/me/saved-passengers/{passengerId} | 
[**passengerProfileControllerDisputes**](PassengerProfileApi.md#passengerprofilecontrollerdisputes) | **GET** /v1/me/disputes | 
[**passengerProfileControllerGet**](PassengerProfileApi.md#passengerprofilecontrollerget) | **GET** /v1/me/profile | 
[**passengerProfileControllerSaved**](PassengerProfileApi.md#passengerprofilecontrollersaved) | **GET** /v1/me/saved-passengers | 
[**passengerProfileControllerSupportTickets**](PassengerProfileApi.md#passengerprofilecontrollersupporttickets) | **GET** /v1/me/support-tickets | 
[**passengerProfileControllerTickets**](PassengerProfileApi.md#passengerprofilecontrollertickets) | **GET** /v1/me/tickets | 
[**passengerProfileControllerUpdate**](PassengerProfileApi.md#passengerprofilecontrollerupdate) | **PUT** /v1/me/profile | 
[**passengerProfileControllerUpdateSaved**](PassengerProfileApi.md#passengerprofilecontrollerupdatesaved) | **PUT** /v1/me/saved-passengers/{passengerId} | 


# **passengerProfileControllerBookings**
> PassengerBookingPageDtoOutput passengerProfileControllerBookings(cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.passengerProfileControllerBookings(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerBookings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PassengerBookingPageDtoOutput**](PassengerBookingPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerCreateSaved**
> SavedPassengerDtoOutput passengerProfileControllerCreateSaved(savedPassengerInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final SavedPassengerInputDto savedPassengerInputDto = ; // SavedPassengerInputDto | 

try {
    final response = api.passengerProfileControllerCreateSaved(savedPassengerInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerCreateSaved: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **savedPassengerInputDto** | [**SavedPassengerInputDto**](SavedPassengerInputDto.md)|  | 

### Return type

[**SavedPassengerDtoOutput**](SavedPassengerDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerDeleteSaved**
> passengerProfileControllerDeleteSaved(passengerId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String passengerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.passengerProfileControllerDeleteSaved(passengerId);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerDeleteSaved: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passengerId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerDisputes**
> PassengerDisputePageDtoOutput passengerProfileControllerDisputes(cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.passengerProfileControllerDisputes(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerDisputes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PassengerDisputePageDtoOutput**](PassengerDisputePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerGet**
> PassengerProfileDtoOutput passengerProfileControllerGet()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();

try {
    final response = api.passengerProfileControllerGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PassengerProfileDtoOutput**](PassengerProfileDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerSaved**
> SavedPassengerListDtoOutput passengerProfileControllerSaved()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();

try {
    final response = api.passengerProfileControllerSaved();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerSaved: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SavedPassengerListDtoOutput**](SavedPassengerListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerSupportTickets**
> PassengerSupportPageDtoOutput passengerProfileControllerSupportTickets(cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.passengerProfileControllerSupportTickets(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerSupportTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PassengerSupportPageDtoOutput**](PassengerSupportPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerTickets**
> PassengerTicketPageDtoOutput passengerProfileControllerTickets(cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.passengerProfileControllerTickets(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PassengerTicketPageDtoOutput**](PassengerTicketPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerUpdate**
> PassengerProfileDtoOutput passengerProfileControllerUpdate(passengerProfileUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final PassengerProfileUpdateDto passengerProfileUpdateDto = ; // PassengerProfileUpdateDto | 

try {
    final response = api.passengerProfileControllerUpdate(passengerProfileUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passengerProfileUpdateDto** | [**PassengerProfileUpdateDto**](PassengerProfileUpdateDto.md)|  | 

### Return type

[**PassengerProfileDtoOutput**](PassengerProfileDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerProfileControllerUpdateSaved**
> SavedPassengerDtoOutput passengerProfileControllerUpdateSaved(passengerId, savedPassengerInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerProfileApi();
final String passengerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SavedPassengerInputDto savedPassengerInputDto = ; // SavedPassengerInputDto | 

try {
    final response = api.passengerProfileControllerUpdateSaved(passengerId, savedPassengerInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerProfileApi->passengerProfileControllerUpdateSaved: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passengerId** | **String**|  | 
 **savedPassengerInputDto** | [**SavedPassengerInputDto**](SavedPassengerInputDto.md)|  | 

### Return type

[**SavedPassengerDtoOutput**](SavedPassengerDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

