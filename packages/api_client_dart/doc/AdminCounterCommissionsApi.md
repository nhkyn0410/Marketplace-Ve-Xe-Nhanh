# api_client_dart.api.AdminCounterCommissionsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**counterCommissionControllerOverview**](AdminCounterCommissionsApi.md#countercommissioncontrolleroverview) | **GET** /v1/admin/counter-commissions | 
[**counterCommissionControllerSettle**](AdminCounterCommissionsApi.md#countercommissioncontrollersettle) | **POST** /v1/admin/counter-commissions/settlements | 


# **counterCommissionControllerOverview**
> CounterCommissionOverviewDtoOutput counterCommissionControllerOverview(operatorId, from, to)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCounterCommissionsApi();
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.counterCommissionControllerOverview(operatorId, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCounterCommissionsApi->counterCommissionControllerOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorId** | **String**|  | 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**CounterCommissionOverviewDtoOutput**](CounterCommissionOverviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterCommissionControllerSettle**
> CounterCommissionSettlementDtoOutput counterCommissionControllerSettle(counterCommissionSettlementInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCounterCommissionsApi();
final CounterCommissionSettlementInputDto counterCommissionSettlementInputDto = ; // CounterCommissionSettlementInputDto | 

try {
    final response = api.counterCommissionControllerSettle(counterCommissionSettlementInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCounterCommissionsApi->counterCommissionControllerSettle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **counterCommissionSettlementInputDto** | [**CounterCommissionSettlementInputDto**](CounterCommissionSettlementInputDto.md)|  | 

### Return type

[**CounterCommissionSettlementDtoOutput**](CounterCommissionSettlementDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

