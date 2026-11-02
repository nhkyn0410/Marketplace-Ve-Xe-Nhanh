# api_client_dart.api.CancellationsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancellationControllerCancel**](CancellationsApi.md#cancellationcontrollercancel) | **POST** /v1/bookings/{bookingId}/cancellations | 
[**cancellationControllerQuote**](CancellationsApi.md#cancellationcontrollerquote) | **GET** /v1/bookings/{bookingId}/cancellation-quote | 


# **cancellationControllerCancel**
> CancellationResultDtoOutput cancellationControllerCancel(bookingId, cancellationInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCancellationsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CancellationInputDto cancellationInputDto = ; // CancellationInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.cancellationControllerCancel(bookingId, cancellationInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CancellationsApi->cancellationControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **cancellationInputDto** | [**CancellationInputDto**](CancellationInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**CancellationResultDtoOutput**](CancellationResultDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancellationControllerQuote**
> CancellationQuoteDtoOutput cancellationControllerQuote(bookingId, ticketIds, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCancellationsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String ticketIds = ticketIds_example; // String | Mã vé, phân tách bằng dấu phẩy.
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.cancellationControllerQuote(bookingId, ticketIds, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CancellationsApi->cancellationControllerQuote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **ticketIds** | **String**| Mã vé, phân tách bằng dấu phẩy. | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**CancellationQuoteDtoOutput**](CancellationQuoteDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

