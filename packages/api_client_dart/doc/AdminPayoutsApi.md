# api_client_dart.api.AdminPayoutsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPayoutControllerCancel**](AdminPayoutsApi.md#adminpayoutcontrollercancel) | **POST** /v1/admin/payouts/{payoutId}/cancel | 
[**adminPayoutControllerConfirm**](AdminPayoutsApi.md#adminpayoutcontrollerconfirm) | **POST** /v1/admin/payouts/{payoutId}/confirm | 
[**adminPayoutControllerGet**](AdminPayoutsApi.md#adminpayoutcontrollerget) | **GET** /v1/admin/payouts/{payoutId} | 
[**adminPayoutControllerHold**](AdminPayoutsApi.md#adminpayoutcontrollerhold) | **POST** /v1/admin/payouts/{payoutId}/hold | 
[**adminPayoutControllerList**](AdminPayoutsApi.md#adminpayoutcontrollerlist) | **GET** /v1/admin/payouts | 
[**adminPayoutControllerRelease**](AdminPayoutsApi.md#adminpayoutcontrollerrelease) | **POST** /v1/admin/payouts/{payoutId}/release | 
[**adminPayoutControllerRevealBank**](AdminPayoutsApi.md#adminpayoutcontrollerrevealbank) | **POST** /v1/admin/payouts/{payoutId}/bank-reveal | 
[**adminPayoutControllerReview**](AdminPayoutsApi.md#adminpayoutcontrollerreview) | **POST** /v1/admin/payouts/{payoutId}/review | 
[**adminPayoutControllerStats**](AdminPayoutsApi.md#adminpayoutcontrollerstats) | **GET** /v1/admin/payouts/stats | 


# **adminPayoutControllerCancel**
> PayoutDetailDtoOutput adminPayoutControllerCancel(payoutId, payoutReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PayoutReasonInputDto payoutReasonInputDto = ; // PayoutReasonInputDto | 

try {
    final response = api.adminPayoutControllerCancel(payoutId, payoutReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 
 **payoutReasonInputDto** | [**PayoutReasonInputDto**](PayoutReasonInputDto.md)|  | 

### Return type

[**PayoutDetailDtoOutput**](PayoutDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPayoutControllerConfirm**
> PayoutDetailDtoOutput adminPayoutControllerConfirm(payoutId, payoutConfirmInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PayoutConfirmInputDto payoutConfirmInputDto = ; // PayoutConfirmInputDto | 

try {
    final response = api.adminPayoutControllerConfirm(payoutId, payoutConfirmInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerConfirm: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 
 **payoutConfirmInputDto** | [**PayoutConfirmInputDto**](PayoutConfirmInputDto.md)|  | 

### Return type

[**PayoutDetailDtoOutput**](PayoutDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPayoutControllerGet**
> PayoutDetailDtoOutput adminPayoutControllerGet(payoutId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPayoutControllerGet(payoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerGet: $e\n');
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

# **adminPayoutControllerHold**
> PayoutDetailDtoOutput adminPayoutControllerHold(payoutId, payoutReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PayoutReasonInputDto payoutReasonInputDto = ; // PayoutReasonInputDto | 

try {
    final response = api.adminPayoutControllerHold(payoutId, payoutReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerHold: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 
 **payoutReasonInputDto** | [**PayoutReasonInputDto**](PayoutReasonInputDto.md)|  | 

### Return type

[**PayoutDetailDtoOutput**](PayoutDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPayoutControllerList**
> PayoutPageDtoOutput adminPayoutControllerList(period, operatorId, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final Date period = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminPayoutControllerList(period, operatorId, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **Date**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
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

# **adminPayoutControllerRelease**
> PayoutDetailDtoOutput adminPayoutControllerRelease(payoutId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPayoutControllerRelease(payoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerRelease: $e\n');
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

# **adminPayoutControllerRevealBank**
> PayoutBankAccountDtoOutput adminPayoutControllerRevealBank(payoutId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPayoutControllerRevealBank(payoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerRevealBank: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 

### Return type

[**PayoutBankAccountDtoOutput**](PayoutBankAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPayoutControllerReview**
> PayoutDetailDtoOutput adminPayoutControllerReview(payoutId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();
final String payoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPayoutControllerReview(payoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerReview: $e\n');
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

# **adminPayoutControllerStats**
> AdminPayoutStatsDtoOutput adminPayoutControllerStats()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPayoutsApi();

try {
    final response = api.adminPayoutControllerStats();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPayoutsApi->adminPayoutControllerStats: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminPayoutStatsDtoOutput**](AdminPayoutStatsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

