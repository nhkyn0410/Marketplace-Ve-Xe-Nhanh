# api_client_dart.api.TicketsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ticketControllerGet**](TicketsApi.md#ticketcontrollerget) | **GET** /v1/tickets/{ticketId} | 
[**ticketControllerGrantBookingAccess**](TicketsApi.md#ticketcontrollergrantbookingaccess) | **POST** /v1/guest/ticket-lookup/booking-access | 
[**ticketControllerListBookings**](TicketsApi.md#ticketcontrollerlistbookings) | **POST** /v1/guest/ticket-lookup/bookings | 
[**ticketControllerLookup**](TicketsApi.md#ticketcontrollerlookup) | **POST** /v1/guest/ticket-lookup | 
[**ticketControllerRequestOtp**](TicketsApi.md#ticketcontrollerrequestotp) | **POST** /v1/guest/ticket-lookup/otp | 
[**ticketControllerVerifyOtp**](TicketsApi.md#ticketcontrollerverifyotp) | **POST** /v1/guest/ticket-lookup/verify | 


# **ticketControllerGet**
> TicketResponseDtoOutput ticketControllerGet(ticketId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.ticketControllerGet(ticketId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**TicketResponseDtoOutput**](TicketResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ticketControllerGrantBookingAccess**
> TicketLookupAccessDtoOutput ticketControllerGrantBookingAccess(ticketLookupInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final TicketLookupInputDto ticketLookupInputDto = ; // TicketLookupInputDto | 

try {
    final response = api.ticketControllerGrantBookingAccess(ticketLookupInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerGrantBookingAccess: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketLookupInputDto** | [**TicketLookupInputDto**](TicketLookupInputDto.md)|  | 

### Return type

[**TicketLookupAccessDtoOutput**](TicketLookupAccessDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ticketControllerListBookings**
> TicketLookupBookingListDtoOutput ticketControllerListBookings(ticketLookupSessionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final TicketLookupSessionInputDto ticketLookupSessionInputDto = ; // TicketLookupSessionInputDto | 

try {
    final response = api.ticketControllerListBookings(ticketLookupSessionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerListBookings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketLookupSessionInputDto** | [**TicketLookupSessionInputDto**](TicketLookupSessionInputDto.md)|  | 

### Return type

[**TicketLookupBookingListDtoOutput**](TicketLookupBookingListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ticketControllerLookup**
> BookingResponseDtoOutput ticketControllerLookup(ticketLookupInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final TicketLookupInputDto ticketLookupInputDto = ; // TicketLookupInputDto | 

try {
    final response = api.ticketControllerLookup(ticketLookupInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerLookup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketLookupInputDto** | [**TicketLookupInputDto**](TicketLookupInputDto.md)|  | 

### Return type

[**BookingResponseDtoOutput**](BookingResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ticketControllerRequestOtp**
> TicketLookupOtpResponseDtoOutput ticketControllerRequestOtp(ticketLookupOtpInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final TicketLookupOtpInputDto ticketLookupOtpInputDto = ; // TicketLookupOtpInputDto | 

try {
    final response = api.ticketControllerRequestOtp(ticketLookupOtpInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerRequestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketLookupOtpInputDto** | [**TicketLookupOtpInputDto**](TicketLookupOtpInputDto.md)|  | 

### Return type

[**TicketLookupOtpResponseDtoOutput**](TicketLookupOtpResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ticketControllerVerifyOtp**
> TicketLookupSessionDtoOutput ticketControllerVerifyOtp(ticketLookupVerifyInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTicketsApi();
final TicketLookupVerifyInputDto ticketLookupVerifyInputDto = ; // TicketLookupVerifyInputDto | 

try {
    final response = api.ticketControllerVerifyOtp(ticketLookupVerifyInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TicketsApi->ticketControllerVerifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketLookupVerifyInputDto** | [**TicketLookupVerifyInputDto**](TicketLookupVerifyInputDto.md)|  | 

### Return type

[**TicketLookupSessionDtoOutput**](TicketLookupSessionDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

