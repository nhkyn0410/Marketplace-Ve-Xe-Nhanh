# api_client_dart.api.DisputesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**customerDisputeControllerGet**](DisputesApi.md#customerdisputecontrollerget) | **GET** /v1/bookings/{bookingId}/disputes/{disputeId} | 
[**customerDisputeControllerList**](DisputesApi.md#customerdisputecontrollerlist) | **GET** /v1/bookings/{bookingId}/disputes | 
[**customerDisputeControllerRespond**](DisputesApi.md#customerdisputecontrollerrespond) | **POST** /v1/bookings/{bookingId}/disputes/{disputeId}/responses | 


# **customerDisputeControllerGet**
> DisputeDetailDtoOutput customerDisputeControllerGet(bookingId, disputeId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getDisputesApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerDisputeControllerGet(bookingId, disputeId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DisputesApi->customerDisputeControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **disputeId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerDisputeControllerList**
> CustomerDisputeListDtoOutput customerDisputeControllerList(bookingId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getDisputesApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerDisputeControllerList(bookingId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DisputesApi->customerDisputeControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**CustomerDisputeListDtoOutput**](CustomerDisputeListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerDisputeControllerRespond**
> DisputeDetailDtoOutput customerDisputeControllerRespond(bookingId, disputeId, evidenceInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getDisputesApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final EvidenceInputDto evidenceInputDto = ; // EvidenceInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerDisputeControllerRespond(bookingId, disputeId, evidenceInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DisputesApi->customerDisputeControllerRespond: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **disputeId** | **String**|  | 
 **evidenceInputDto** | [**EvidenceInputDto**](EvidenceInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

