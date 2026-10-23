# api_client_dart.api.PaymentsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**paymentControllerCreate**](PaymentsApi.md#paymentcontrollercreate) | **POST** /v1/bookings/{bookingId}/payments | 


# **paymentControllerCreate**
> PaymentResponseDtoOutput paymentControllerCreate(bookingId, paymentInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPaymentsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PaymentInputDto paymentInputDto = ; // PaymentInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập trả lúc tạo booking (khách vãng lai).

try {
    final response = api.paymentControllerCreate(bookingId, paymentInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->paymentControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **paymentInputDto** | [**PaymentInputDto**](PaymentInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập trả lúc tạo booking (khách vãng lai). | [optional] 

### Return type

[**PaymentResponseDtoOutput**](PaymentResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

