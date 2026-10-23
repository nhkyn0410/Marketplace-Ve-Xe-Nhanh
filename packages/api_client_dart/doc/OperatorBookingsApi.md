# api_client_dart.api.OperatorBookingsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorBookingControllerExportPassengers**](OperatorBookingsApi.md#operatorbookingcontrollerexportpassengers) | **GET** /v1/operator/trips/{tripId}/passengers/export | 
[**operatorBookingControllerGet**](OperatorBookingsApi.md#operatorbookingcontrollerget) | **GET** /v1/operator/bookings/{bookingId} | 
[**operatorBookingControllerList**](OperatorBookingsApi.md#operatorbookingcontrollerlist) | **GET** /v1/operator/bookings | 
[**operatorBookingControllerPassengers**](OperatorBookingsApi.md#operatorbookingcontrollerpassengers) | **GET** /v1/operator/trips/{tripId}/passengers | 
[**operatorBookingControllerRevealContact**](OperatorBookingsApi.md#operatorbookingcontrollerrevealcontact) | **POST** /v1/operator/bookings/{bookingId}/contact-reveal | 


# **operatorBookingControllerExportPassengers**
> String operatorBookingControllerExportPassengers(tripId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorBookingsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorBookingControllerExportPassengers(tripId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorBookingsApi->operatorBookingControllerExportPassengers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorBookingControllerGet**
> OperatorBookingDetailDtoOutput operatorBookingControllerGet(bookingId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorBookingsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorBookingControllerGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorBookingsApi->operatorBookingControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**OperatorBookingDetailDtoOutput**](OperatorBookingDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorBookingControllerList**
> OperatorBookingPageDtoOutput operatorBookingControllerList(date, tripId, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorBookingsApi();
final Date date = 2013-10-20; // Date | 
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorBookingControllerList(date, tripId, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorBookingsApi->operatorBookingControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **Date**|  | 
 **tripId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**OperatorBookingPageDtoOutput**](OperatorBookingPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorBookingControllerPassengers**
> TripPassengerListDtoOutput operatorBookingControllerPassengers(tripId, pickupSequence, ticketStatus, q)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorBookingsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num pickupSequence = 8.14; // num | 
final String ticketStatus = ticketStatus_example; // String | 
final String q = q_example; // String | 

try {
    final response = api.operatorBookingControllerPassengers(tripId, pickupSequence, ticketStatus, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorBookingsApi->operatorBookingControllerPassengers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 
 **pickupSequence** | **num**|  | [optional] 
 **ticketStatus** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 

### Return type

[**TripPassengerListDtoOutput**](TripPassengerListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorBookingControllerRevealContact**
> BookingContactDtoOutput operatorBookingControllerRevealContact(bookingId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorBookingsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorBookingControllerRevealContact(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorBookingsApi->operatorBookingControllerRevealContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**BookingContactDtoOutput**](BookingContactDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

