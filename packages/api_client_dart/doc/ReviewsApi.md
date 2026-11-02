# api_client_dart.api.ReviewsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**customerReviewControllerCreate**](ReviewsApi.md#customerreviewcontrollercreate) | **POST** /v1/bookings/{bookingId}/review | 
[**customerReviewControllerGet**](ReviewsApi.md#customerreviewcontrollerget) | **GET** /v1/bookings/{bookingId}/review | 


# **customerReviewControllerCreate**
> ReviewDtoOutput customerReviewControllerCreate(bookingId, reviewInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getReviewsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReviewInputDto reviewInputDto = ; // ReviewInputDto | 

try {
    final response = api.customerReviewControllerCreate(bookingId, reviewInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->customerReviewControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **reviewInputDto** | [**ReviewInputDto**](ReviewInputDto.md)|  | 

### Return type

[**ReviewDtoOutput**](ReviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerReviewControllerGet**
> CustomerReviewDtoOutput customerReviewControllerGet(bookingId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getReviewsApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.customerReviewControllerGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->customerReviewControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**CustomerReviewDtoOutput**](CustomerReviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

