# api_client_dart.api.BookingsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookingControllerCreate**](BookingsApi.md#bookingcontrollercreate) | **POST** /v1/bookings | 
[**bookingControllerGet**](BookingsApi.md#bookingcontrollerget) | **GET** /v1/bookings/{bookingId} | 


# **bookingControllerCreate**
> CreatedBookingDtoOutput bookingControllerCreate(bookingInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getBookingsApi();
final BookingInputDto bookingInputDto = ; // BookingInputDto | 

try {
    final response = api.bookingControllerCreate(bookingInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->bookingControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingInputDto** | [**BookingInputDto**](BookingInputDto.md)|  | 

### Return type

[**CreatedBookingDtoOutput**](CreatedBookingDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bookingControllerGet**
> BookingResponseDtoOutput bookingControllerGet(bookingId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getBookingsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập trả lúc tạo booking (khách vãng lai).

try {
    final response = api.bookingControllerGet(bookingId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->bookingControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập trả lúc tạo booking (khách vãng lai). | [optional] 

### Return type

[**BookingResponseDtoOutput**](BookingResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

