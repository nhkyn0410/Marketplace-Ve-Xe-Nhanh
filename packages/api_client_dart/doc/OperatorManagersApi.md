# api_client_dart.api.OperatorManagersApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorManagerControllerCreate**](OperatorManagersApi.md#operatormanagercontrollercreate) | **POST** /v1/operator/managers | 
[**operatorManagerControllerList**](OperatorManagersApi.md#operatormanagercontrollerlist) | **GET** /v1/operator/managers | 
[**operatorManagerControllerResetMfa**](OperatorManagersApi.md#operatormanagercontrollerresetmfa) | **POST** /v1/operator/managers/{managerId}/mfa-reset | 
[**operatorManagerControllerResetPassword**](OperatorManagersApi.md#operatormanagercontrollerresetpassword) | **POST** /v1/operator/managers/{managerId}/password-reset | 
[**operatorManagerControllerUpdate**](OperatorManagersApi.md#operatormanagercontrollerupdate) | **PATCH** /v1/operator/managers/{managerId} | 


# **operatorManagerControllerCreate**
> ManagerAccountDtoOutput operatorManagerControllerCreate(managerCreateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorManagersApi();
final ManagerCreateDto managerCreateDto = ; // ManagerCreateDto | 

try {
    final response = api.operatorManagerControllerCreate(managerCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorManagersApi->operatorManagerControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **managerCreateDto** | [**ManagerCreateDto**](ManagerCreateDto.md)|  | 

### Return type

[**ManagerAccountDtoOutput**](ManagerAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorManagerControllerList**
> ManagerListDtoOutput operatorManagerControllerList()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorManagersApi();

try {
    final response = api.operatorManagerControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorManagersApi->operatorManagerControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ManagerListDtoOutput**](ManagerListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorManagerControllerResetMfa**
> ManagerAccountDtoOutput operatorManagerControllerResetMfa(managerId, managerReasonDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorManagersApi();
final String managerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ManagerReasonDto managerReasonDto = ; // ManagerReasonDto | 

try {
    final response = api.operatorManagerControllerResetMfa(managerId, managerReasonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorManagersApi->operatorManagerControllerResetMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **managerId** | **String**|  | 
 **managerReasonDto** | [**ManagerReasonDto**](ManagerReasonDto.md)|  | 

### Return type

[**ManagerAccountDtoOutput**](ManagerAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorManagerControllerResetPassword**
> ManagerAccountDtoOutput operatorManagerControllerResetPassword(managerId, managerReasonDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorManagersApi();
final String managerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ManagerReasonDto managerReasonDto = ; // ManagerReasonDto | 

try {
    final response = api.operatorManagerControllerResetPassword(managerId, managerReasonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorManagersApi->operatorManagerControllerResetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **managerId** | **String**|  | 
 **managerReasonDto** | [**ManagerReasonDto**](ManagerReasonDto.md)|  | 

### Return type

[**ManagerAccountDtoOutput**](ManagerAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorManagerControllerUpdate**
> ManagerAccountDtoOutput operatorManagerControllerUpdate(managerId, managerUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorManagersApi();
final String managerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ManagerUpdateDto managerUpdateDto = ; // ManagerUpdateDto | 

try {
    final response = api.operatorManagerControllerUpdate(managerId, managerUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorManagersApi->operatorManagerControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **managerId** | **String**|  | 
 **managerUpdateDto** | [**ManagerUpdateDto**](ManagerUpdateDto.md)|  | 

### Return type

[**ManagerAccountDtoOutput**](ManagerAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

