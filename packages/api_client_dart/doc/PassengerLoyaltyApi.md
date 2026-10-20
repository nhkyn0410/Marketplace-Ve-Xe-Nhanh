# api_client_dart.api.PassengerLoyaltyApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**passengerLoyaltyControllerMember**](PassengerLoyaltyApi.md#passengerloyaltycontrollermember) | **GET** /v1/me/loyalty | 
[**passengerLoyaltyControllerRedeem**](PassengerLoyaltyApi.md#passengerloyaltycontrollerredeem) | **POST** /v1/me/loyalty/redemptions | 
[**passengerLoyaltyControllerSave**](PassengerLoyaltyApi.md#passengerloyaltycontrollersave) | **POST** /v1/me/vouchers | 
[**passengerLoyaltyControllerTransactions**](PassengerLoyaltyApi.md#passengerloyaltycontrollertransactions) | **GET** /v1/me/loyalty/transactions | 
[**passengerLoyaltyControllerVouchers**](PassengerLoyaltyApi.md#passengerloyaltycontrollervouchers) | **GET** /v1/me/vouchers | 


# **passengerLoyaltyControllerMember**
> PassengerLoyaltyDtoOutput passengerLoyaltyControllerMember()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerLoyaltyApi();

try {
    final response = api.passengerLoyaltyControllerMember();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerLoyaltyApi->passengerLoyaltyControllerMember: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PassengerLoyaltyDtoOutput**](PassengerLoyaltyDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerLoyaltyControllerRedeem**
> UserVoucherDtoOutput passengerLoyaltyControllerRedeem(idempotencyKey, loyaltyRedemptionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerLoyaltyApi();
final String idempotencyKey = idempotencyKey_example; // String | 8–128 ký tự chữ, số, gạch ngang hoặc gạch dưới.
final LoyaltyRedemptionInputDto loyaltyRedemptionInputDto = ; // LoyaltyRedemptionInputDto | 

try {
    final response = api.passengerLoyaltyControllerRedeem(idempotencyKey, loyaltyRedemptionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerLoyaltyApi->passengerLoyaltyControllerRedeem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| 8–128 ký tự chữ, số, gạch ngang hoặc gạch dưới. | 
 **loyaltyRedemptionInputDto** | [**LoyaltyRedemptionInputDto**](LoyaltyRedemptionInputDto.md)|  | 

### Return type

[**UserVoucherDtoOutput**](UserVoucherDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerLoyaltyControllerSave**
> UserVoucherDtoOutput passengerLoyaltyControllerSave(saveVoucherInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerLoyaltyApi();
final SaveVoucherInputDto saveVoucherInputDto = ; // SaveVoucherInputDto | 

try {
    final response = api.passengerLoyaltyControllerSave(saveVoucherInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerLoyaltyApi->passengerLoyaltyControllerSave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **saveVoucherInputDto** | [**SaveVoucherInputDto**](SaveVoucherInputDto.md)|  | 

### Return type

[**UserVoucherDtoOutput**](UserVoucherDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerLoyaltyControllerTransactions**
> PassengerLoyaltyTransactionsDtoOutput passengerLoyaltyControllerTransactions(offset, limit, type, from, to)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerLoyaltyApi();
final int offset = 56; // int | 
final int limit = 56; // int | 
final String type = type_example; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.passengerLoyaltyControllerTransactions(offset, limit, type, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerLoyaltyApi->passengerLoyaltyControllerTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **offset** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 20]
 **type** | **String**|  | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**PassengerLoyaltyTransactionsDtoOutput**](PassengerLoyaltyTransactionsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **passengerLoyaltyControllerVouchers**
> UserVoucherPageDtoOutput passengerLoyaltyControllerVouchers(status, offset, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPassengerLoyaltyApi();
final String status = status_example; // String | 
final int offset = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.passengerLoyaltyControllerVouchers(status, offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PassengerLoyaltyApi->passengerLoyaltyControllerVouchers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **offset** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**UserVoucherPageDtoOutput**](UserVoucherPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

