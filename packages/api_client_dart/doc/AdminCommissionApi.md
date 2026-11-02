# api_client_dart.api.AdminCommissionApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminCommissionControllerCancel**](AdminCommissionApi.md#admincommissioncontrollercancel) | **POST** /v1/admin/commission-rules/{id}/cancel | 
[**adminCommissionControllerCreate**](AdminCommissionApi.md#admincommissioncontrollercreate) | **POST** /v1/admin/commission-rules | 
[**adminCommissionControllerOverview**](AdminCommissionApi.md#admincommissioncontrolleroverview) | **GET** /v1/admin/commission-rules | 
[**adminCommissionControllerUpdate**](AdminCommissionApi.md#admincommissioncontrollerupdate) | **PUT** /v1/admin/commission-rules/{id} | 


# **adminCommissionControllerCancel**
> CommissionRuleDtoOutput adminCommissionControllerCancel(id, commissionRuleCancelDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCommissionApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CommissionRuleCancelDto commissionRuleCancelDto = ; // CommissionRuleCancelDto | 

try {
    final response = api.adminCommissionControllerCancel(id, commissionRuleCancelDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCommissionApi->adminCommissionControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **commissionRuleCancelDto** | [**CommissionRuleCancelDto**](CommissionRuleCancelDto.md)|  | 

### Return type

[**CommissionRuleDtoOutput**](CommissionRuleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCommissionControllerCreate**
> CommissionRuleDtoOutput adminCommissionControllerCreate(commissionRuleCreateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCommissionApi();
final CommissionRuleCreateDto commissionRuleCreateDto = ; // CommissionRuleCreateDto | 

try {
    final response = api.adminCommissionControllerCreate(commissionRuleCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCommissionApi->adminCommissionControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **commissionRuleCreateDto** | [**CommissionRuleCreateDto**](CommissionRuleCreateDto.md)|  | 

### Return type

[**CommissionRuleDtoOutput**](CommissionRuleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCommissionControllerOverview**
> CommissionOverviewDtoOutput adminCommissionControllerOverview()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCommissionApi();

try {
    final response = api.adminCommissionControllerOverview();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCommissionApi->adminCommissionControllerOverview: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CommissionOverviewDtoOutput**](CommissionOverviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCommissionControllerUpdate**
> CommissionRuleDtoOutput adminCommissionControllerUpdate(id, commissionRuleUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCommissionApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CommissionRuleUpdateDto commissionRuleUpdateDto = ; // CommissionRuleUpdateDto | 

try {
    final response = api.adminCommissionControllerUpdate(id, commissionRuleUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCommissionApi->adminCommissionControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **commissionRuleUpdateDto** | [**CommissionRuleUpdateDto**](CommissionRuleUpdateDto.md)|  | 

### Return type

[**CommissionRuleDtoOutput**](CommissionRuleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

