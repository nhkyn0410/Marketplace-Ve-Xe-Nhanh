# api_client_dart.api.OperatorReviewsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorReviewControllerList**](OperatorReviewsApi.md#operatorreviewcontrollerlist) | **GET** /v1/operator/reviews | 
[**operatorReviewControllerReply**](OperatorReviewsApi.md#operatorreviewcontrollerreply) | **PUT** /v1/operator/reviews/{reviewId}/reply | 
[**operatorReviewControllerReport**](OperatorReviewsApi.md#operatorreviewcontrollerreport) | **POST** /v1/operator/reviews/{reviewId}/report | 


# **operatorReviewControllerList**
> ReviewPageDtoOutput operatorReviewControllerList(routeId, rating, replied, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReviewsApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num rating = 8.14; // num | 
final String replied = replied_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorReviewControllerList(routeId, rating, replied, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReviewsApi->operatorReviewControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | [optional] 
 **rating** | **num**|  | [optional] 
 **replied** | **String**|  | [optional] 
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

# **operatorReviewControllerReply**
> ReviewDtoOutput operatorReviewControllerReply(reviewId, replyInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReplyInputDto replyInputDto = ; // ReplyInputDto | 

try {
    final response = api.operatorReviewControllerReply(reviewId, replyInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReviewsApi->operatorReviewControllerReply: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  | 
 **replyInputDto** | [**ReplyInputDto**](ReplyInputDto.md)|  | 

### Return type

[**ReviewDtoOutput**](ReviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorReviewControllerReport**
> ReviewDtoOutput operatorReviewControllerReport(reviewId, reportInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReportInputDto reportInputDto = ; // ReportInputDto | 

try {
    final response = api.operatorReviewControllerReport(reviewId, reportInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReviewsApi->operatorReviewControllerReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  | 
 **reportInputDto** | [**ReportInputDto**](ReportInputDto.md)|  | 

### Return type

[**ReviewDtoOutput**](ReviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

