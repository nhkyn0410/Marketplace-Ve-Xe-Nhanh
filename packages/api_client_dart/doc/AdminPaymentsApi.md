# api_client_dart.api.AdminPaymentsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPaymentControllerGet**](AdminPaymentsApi.md#adminpaymentcontrollerget) | **GET** /v1/admin/payments/{paymentId} | 
[**adminPaymentControllerList**](AdminPaymentsApi.md#adminpaymentcontrollerlist) | **GET** /v1/admin/payments | 


# **adminPaymentControllerGet**
> AdminPaymentDetailDtoOutput adminPaymentControllerGet(paymentId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPaymentsApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPaymentControllerGet(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPaymentsApi->adminPaymentControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  | 

### Return type

[**AdminPaymentDetailDtoOutput**](AdminPaymentDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPaymentControllerList**
> AdminPaymentPageDtoOutput adminPaymentControllerList(from, to, operatorId, provider, status, reconcile, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPaymentsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String provider = provider_example; // String | 
final String status = status_example; // String | 
final String reconcile = reconcile_example; // String | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminPaymentControllerList(from, to, operatorId, provider, status, reconcile, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPaymentsApi->adminPaymentControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **provider** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **reconcile** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**AdminPaymentPageDtoOutput**](AdminPaymentPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

