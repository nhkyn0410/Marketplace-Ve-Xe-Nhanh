# api_client_dart.api.AdminLoyaltyApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminLoyaltyControllerAdjust**](AdminLoyaltyApi.md#adminloyaltycontrolleradjust) | **POST** /v1/admin/loyalty/accounts/{userId}/adjustments | 
[**adminLoyaltyControllerMember**](AdminLoyaltyApi.md#adminloyaltycontrollermember) | **GET** /v1/admin/loyalty/accounts | 
[**adminLoyaltyControllerReport**](AdminLoyaltyApi.md#adminloyaltycontrollerreport) | **GET** /v1/admin/loyalty/reports | 
[**adminLoyaltyControllerTransactions**](AdminLoyaltyApi.md#adminloyaltycontrollertransactions) | **GET** /v1/admin/loyalty/accounts/{userId}/transactions | 


# **adminLoyaltyControllerAdjust**
> LoyaltyMemberDtoOutput adminLoyaltyControllerAdjust(userId, idempotencyKey, pointAdjustInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminLoyaltyApi();
final String userId = userId_example; // String | 
final String idempotencyKey = idempotencyKey_example; // String | 8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa không ghi thêm giao dịch.
final PointAdjustInputDto pointAdjustInputDto = ; // PointAdjustInputDto | 

try {
    final response = api.adminLoyaltyControllerAdjust(userId, idempotencyKey, pointAdjustInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminLoyaltyApi->adminLoyaltyControllerAdjust: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **idempotencyKey** | **String**| 8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa không ghi thêm giao dịch. | 
 **pointAdjustInputDto** | [**PointAdjustInputDto**](PointAdjustInputDto.md)|  | 

### Return type

[**LoyaltyMemberDtoOutput**](LoyaltyMemberDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLoyaltyControllerMember**
> LoyaltyMemberDtoOutput adminLoyaltyControllerMember(email)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminLoyaltyApi();
final String email = email_example; // String | 

try {
    final response = api.adminLoyaltyControllerMember(email);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminLoyaltyApi->adminLoyaltyControllerMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **email** | **String**|  | 

### Return type

[**LoyaltyMemberDtoOutput**](LoyaltyMemberDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLoyaltyControllerReport**
> LoyaltyReportDtoOutput adminLoyaltyControllerReport(year, quarter, tier)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminLoyaltyApi();
final num year = 8.14; // num | 
final num quarter = 8.14; // num | 
final String tier = tier_example; // String | 

try {
    final response = api.adminLoyaltyControllerReport(year, quarter, tier);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminLoyaltyApi->adminLoyaltyControllerReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **year** | **num**|  | 
 **quarter** | **num**|  | 
 **tier** | **String**|  | [optional] 

### Return type

[**LoyaltyReportDtoOutput**](LoyaltyReportDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLoyaltyControllerTransactions**
> LoyaltyTransactionPageDtoOutput adminLoyaltyControllerTransactions(userId, offset, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminLoyaltyApi();
final String userId = userId_example; // String | 
final num offset = 8.14; // num | 
final num limit = 8.14; // num | 

try {
    final response = api.adminLoyaltyControllerTransactions(userId, offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminLoyaltyApi->adminLoyaltyControllerTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **offset** | **num**|  | [optional] [default to 0]
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**LoyaltyTransactionPageDtoOutput**](LoyaltyTransactionPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

