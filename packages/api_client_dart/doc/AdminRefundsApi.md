# api_client_dart.api.AdminRefundsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminRefundControllerGet**](AdminRefundsApi.md#adminrefundcontrollerget) | **GET** /v1/admin/refunds/{refundId} | 
[**adminRefundControllerList**](AdminRefundsApi.md#adminrefundcontrollerlist) | **GET** /v1/admin/refunds | 
[**adminRefundControllerRefundPayment**](AdminRefundsApi.md#adminrefundcontrollerrefundpayment) | **POST** /v1/admin/payments/{paymentId}/refunds | 
[**adminRefundControllerResolve**](AdminRefundsApi.md#adminrefundcontrollerresolve) | **POST** /v1/admin/refunds/{refundId}/resolve | 
[**adminRefundControllerRetry**](AdminRefundsApi.md#adminrefundcontrollerretry) | **POST** /v1/admin/refunds/{refundId}/retry | 


# **adminRefundControllerGet**
> AdminRefundDetailDtoOutput adminRefundControllerGet(refundId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRefundsApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminRefundControllerGet(refundId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRefundsApi->adminRefundControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 

### Return type

[**AdminRefundDetailDtoOutput**](AdminRefundDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundControllerList**
> AdminRefundPageDtoOutput adminRefundControllerList(from, to, operatorId, source_, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRefundsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String source_ = source__example; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminRefundControllerList(from, to, operatorId, source_, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRefundsApi->adminRefundControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **source_** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**AdminRefundPageDtoOutput**](AdminRefundPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundControllerRefundPayment**
> AdminRefundDetailDtoOutput adminRefundControllerRefundPayment(paymentId, refundReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRefundsApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundReasonInputDto refundReasonInputDto = ; // RefundReasonInputDto | 

try {
    final response = api.adminRefundControllerRefundPayment(paymentId, refundReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRefundsApi->adminRefundControllerRefundPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  | 
 **refundReasonInputDto** | [**RefundReasonInputDto**](RefundReasonInputDto.md)|  | 

### Return type

[**AdminRefundDetailDtoOutput**](AdminRefundDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundControllerResolve**
> AdminRefundDetailDtoOutput adminRefundControllerResolve(refundId, refundResolveInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRefundsApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundResolveInputDto refundResolveInputDto = ; // RefundResolveInputDto | 

try {
    final response = api.adminRefundControllerResolve(refundId, refundResolveInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRefundsApi->adminRefundControllerResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 
 **refundResolveInputDto** | [**RefundResolveInputDto**](RefundResolveInputDto.md)|  | 

### Return type

[**AdminRefundDetailDtoOutput**](AdminRefundDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundControllerRetry**
> AdminRefundDetailDtoOutput adminRefundControllerRetry(refundId, refundReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRefundsApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundReasonInputDto refundReasonInputDto = ; // RefundReasonInputDto | 

try {
    final response = api.adminRefundControllerRetry(refundId, refundReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRefundsApi->adminRefundControllerRetry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 
 **refundReasonInputDto** | [**RefundReasonInputDto**](RefundReasonInputDto.md)|  | 

### Return type

[**AdminRefundDetailDtoOutput**](AdminRefundDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

