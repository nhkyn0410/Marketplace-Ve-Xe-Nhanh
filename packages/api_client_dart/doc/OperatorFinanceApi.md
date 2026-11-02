# api_client_dart.api.OperatorFinanceApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorFinanceControllerBookings**](OperatorFinanceApi.md#operatorfinancecontrollerbookings) | **GET** /v1/operator/finance/bookings | 
[**operatorFinanceControllerPayout**](OperatorFinanceApi.md#operatorfinancecontrollerpayout) | **GET** /v1/operator/payouts/{payoutId} | 
[**operatorFinanceControllerPayouts**](OperatorFinanceApi.md#operatorfinancecontrollerpayouts) | **GET** /v1/operator/payouts | 
[**operatorFinanceControllerSummary**](OperatorFinanceApi.md#operatorfinancecontrollersummary) | **GET** /v1/operator/finance/summary | 


# **operatorFinanceControllerBookings**
> FinanceBookingPageDtoOutput operatorFinanceControllerBookings(from, to, routeId, state, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorFinanceApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String state = state_example; // String | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorFinanceControllerBookings(from, to, routeId, state, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorFinanceApi->operatorFinanceControllerBookings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **routeId** | **String**|  | [optional] 
 **state** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**FinanceBookingPageDtoOutput**](FinanceBookingPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorFinanceControllerPayout**
> PayoutDetailDtoOutput operatorFinanceControllerPayout(payoutId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorFinanceApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorFinanceControllerPayout(payoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorFinanceApi->operatorFinanceControllerPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 

### Return type

[**PayoutDetailDtoOutput**](PayoutDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorFinanceControllerPayouts**
> PayoutPageDtoOutput operatorFinanceControllerPayouts(month, status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorFinanceApi();
final String month = month_example; // String | `YYYY-MM`
final String status = status_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorFinanceControllerPayouts(month, status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorFinanceApi->operatorFinanceControllerPayouts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **month** | **String**| `YYYY-MM` | [optional] 
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PayoutPageDtoOutput**](PayoutPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorFinanceControllerSummary**
> FinanceSummaryDtoOutput operatorFinanceControllerSummary()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorFinanceApi();

try {
    final response = api.operatorFinanceControllerSummary();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorFinanceApi->operatorFinanceControllerSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FinanceSummaryDtoOutput**](FinanceSummaryDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

