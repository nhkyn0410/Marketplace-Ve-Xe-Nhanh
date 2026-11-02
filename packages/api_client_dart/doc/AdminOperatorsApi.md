# api_client_dart.api.AdminOperatorsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminOperatorControllerApproveBankChange**](AdminOperatorsApi.md#adminoperatorcontrollerapprovebankchange) | **POST** /v1/admin/operators/{id}/bank-account-change/approve | 
[**adminOperatorControllerDetail**](AdminOperatorsApi.md#adminoperatorcontrollerdetail) | **GET** /v1/admin/operators/{id} | 
[**adminOperatorControllerGetBankChange**](AdminOperatorsApi.md#adminoperatorcontrollergetbankchange) | **GET** /v1/admin/operators/{id}/bank-account-change | 
[**adminOperatorControllerList**](AdminOperatorsApi.md#adminoperatorcontrollerlist) | **GET** /v1/admin/operators | 
[**adminOperatorControllerRejectBankChange**](AdminOperatorsApi.md#adminoperatorcontrollerrejectbankchange) | **POST** /v1/admin/operators/{id}/bank-account-change/reject | 
[**adminOperatorControllerSuspend**](AdminOperatorsApi.md#adminoperatorcontrollersuspend) | **POST** /v1/admin/operators/{id}/suspend | 
[**adminOperatorControllerUnsuspend**](AdminOperatorsApi.md#adminoperatorcontrollerunsuspend) | **POST** /v1/admin/operators/{id}/unsuspend | 
[**adminOperatorControllerVehicles**](AdminOperatorsApi.md#adminoperatorcontrollervehicles) | **GET** /v1/admin/operators/{id}/vehicles | 


# **adminOperatorControllerApproveBankChange**
> adminOperatorControllerApproveBankChange(id, adminBankChangeApproveDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminBankChangeApproveDto adminBankChangeApproveDto = ; // AdminBankChangeApproveDto | 

try {
    api.adminOperatorControllerApproveBankChange(id, adminBankChangeApproveDto);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerApproveBankChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminBankChangeApproveDto** | [**AdminBankChangeApproveDto**](AdminBankChangeApproveDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerDetail**
> AdminOperatorDetailDtoOutput adminOperatorControllerDetail(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminOperatorControllerDetail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminOperatorDetailDtoOutput**](AdminOperatorDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerGetBankChange**
> AdminBankChangeDtoOutput adminOperatorControllerGetBankChange(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminOperatorControllerGetBankChange(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerGetBankChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminBankChangeDtoOutput**](AdminBankChangeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerList**
> AdminOperatorPageDtoOutput adminOperatorControllerList(q, status, bankChange, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String q = q_example; // String | 
final String status = status_example; // String | 
final String bankChange = bankChange_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminOperatorControllerList(q, status, bankChange, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **bankChange** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminOperatorPageDtoOutput**](AdminOperatorPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerRejectBankChange**
> adminOperatorControllerRejectBankChange(id, adminBankChangeRejectDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminBankChangeRejectDto adminBankChangeRejectDto = ; // AdminBankChangeRejectDto | 

try {
    api.adminOperatorControllerRejectBankChange(id, adminBankChangeRejectDto);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerRejectBankChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminBankChangeRejectDto** | [**AdminBankChangeRejectDto**](AdminBankChangeRejectDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerSuspend**
> adminOperatorControllerSuspend(id, adminOperatorSuspendDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminOperatorSuspendDto adminOperatorSuspendDto = ; // AdminOperatorSuspendDto | 

try {
    api.adminOperatorControllerSuspend(id, adminOperatorSuspendDto);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerSuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminOperatorSuspendDto** | [**AdminOperatorSuspendDto**](AdminOperatorSuspendDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerUnsuspend**
> adminOperatorControllerUnsuspend(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.adminOperatorControllerUnsuspend(id);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerUnsuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorControllerVehicles**
> AdminOperatorVehicleListDtoOutput adminOperatorControllerVehicles(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminOperatorControllerVehicles(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorsApi->adminOperatorControllerVehicles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminOperatorVehicleListDtoOutput**](AdminOperatorVehicleListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

