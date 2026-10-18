# api_client_dart.api.TicketsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ticketControllerGet**](TicketsApi.md#ticketcontrollerget) | **GET** /v1/tickets/{ticketId} | 
[**ticketControllerLookup**](TicketsApi.md#ticketcontrollerlookup) | **POST** /v1/guest/ticket-lookup | 


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

