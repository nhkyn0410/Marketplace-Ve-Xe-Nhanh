# api_client_dart.api.AdminReviewsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminReviewControllerList**](AdminReviewsApi.md#adminreviewcontrollerlist) | **GET** /v1/admin/reviews | 
[**adminReviewControllerModerate**](AdminReviewsApi.md#adminreviewcontrollermoderate) | **POST** /v1/admin/reviews/{reviewId}/moderation | 


# **adminReviewControllerList**
> ReviewPageDtoOutput adminReviewControllerList(status, operatorId, rating, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminReviewsApi();
final String status = status_example; // String | VISIBLE / HELD / HIDDEN hoặc `attention`.
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num rating = 8.14; // num | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminReviewControllerList(status, operatorId, rating, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewsApi->adminReviewControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**| VISIBLE / HELD / HIDDEN hoặc `attention`. | [optional] 
 **operatorId** | **String**|  | [optional] 
 **rating** | **num**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**ReviewPageDtoOutput**](ReviewPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReviewControllerModerate**
> ReviewDtoOutput adminReviewControllerModerate(reviewId, moderationInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ModerationInputDto moderationInputDto = ; // ModerationInputDto | 

try {
    final response = api.adminReviewControllerModerate(reviewId, moderationInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewsApi->adminReviewControllerModerate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  | 
 **moderationInputDto** | [**ModerationInputDto**](ModerationInputDto.md)|  | 

### Return type

[**ReviewDtoOutput**](ReviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

