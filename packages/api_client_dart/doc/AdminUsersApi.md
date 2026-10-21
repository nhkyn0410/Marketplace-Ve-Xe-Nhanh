# api_client_dart.api.AdminUsersApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminEmployeeControllerList**](AdminUsersApi.md#adminemployeecontrollerlist) | **GET** /v1/admin/employees | 
[**adminPassengerControllerList**](AdminUsersApi.md#adminpassengercontrollerlist) | **GET** /v1/admin/passengers | 
[**adminPassengerControllerLock**](AdminUsersApi.md#adminpassengercontrollerlock) | **POST** /v1/admin/passengers/{id}/lock | 
[**adminPassengerControllerUnlock**](AdminUsersApi.md#adminpassengercontrollerunlock) | **POST** /v1/admin/passengers/{id}/unlock | 
[**adminPlatformAccountControllerCreate**](AdminUsersApi.md#adminplatformaccountcontrollercreate) | **POST** /v1/admin/platform-accounts | 
[**adminPlatformAccountControllerList**](AdminUsersApi.md#adminplatformaccountcontrollerlist) | **GET** /v1/admin/platform-accounts | 
[**adminPlatformAccountControllerLock**](AdminUsersApi.md#adminplatformaccountcontrollerlock) | **POST** /v1/admin/platform-accounts/{id}/lock | 
[**adminPlatformAccountControllerResetMfa**](AdminUsersApi.md#adminplatformaccountcontrollerresetmfa) | **POST** /v1/admin/platform-accounts/{id}/reset-mfa | 
[**adminPlatformAccountControllerResetPassword**](AdminUsersApi.md#adminplatformaccountcontrollerresetpassword) | **POST** /v1/admin/platform-accounts/{id}/reset-password | 
[**adminPlatformAccountControllerUnlock**](AdminUsersApi.md#adminplatformaccountcontrollerunlock) | **POST** /v1/admin/platform-accounts/{id}/unlock | 


# **adminEmployeeControllerList**
> AdminEmployeePageDtoOutput adminEmployeeControllerList(q, operatorId, role, status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String q = q_example; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String role = role_example; // String | 
final String status = status_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminEmployeeControllerList(q, operatorId, role, status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminEmployeeControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **role** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminEmployeePageDtoOutput**](AdminEmployeePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPassengerControllerList**
> AdminPassengerPageDtoOutput adminPassengerControllerList(q, status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String q = q_example; // String | 
final String status = status_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminPassengerControllerList(q, status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPassengerControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminPassengerPageDtoOutput**](AdminPassengerPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPassengerControllerLock**
> adminPassengerControllerLock(id, adminAccountLockDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = id_example; // String | 
final AdminAccountLockDto adminAccountLockDto = ; // AdminAccountLockDto | 

try {
    api.adminPassengerControllerLock(id, adminAccountLockDto);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPassengerControllerLock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminAccountLockDto** | [**AdminAccountLockDto**](AdminAccountLockDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPassengerControllerUnlock**
> adminPassengerControllerUnlock(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = id_example; // String | 

try {
    api.adminPassengerControllerUnlock(id);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPassengerControllerUnlock: $e\n');
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

# **adminPlatformAccountControllerCreate**
> AdminPlatformAccountDtoOutput adminPlatformAccountControllerCreate(adminPlatformAccountCreateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final AdminPlatformAccountCreateDto adminPlatformAccountCreateDto = ; // AdminPlatformAccountCreateDto | 

try {
    final response = api.adminPlatformAccountControllerCreate(adminPlatformAccountCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminPlatformAccountCreateDto** | [**AdminPlatformAccountCreateDto**](AdminPlatformAccountCreateDto.md)|  | 

### Return type

[**AdminPlatformAccountDtoOutput**](AdminPlatformAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPlatformAccountControllerList**
> AdminPlatformAccountListDtoOutput adminPlatformAccountControllerList(q, role, status)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String q = q_example; // String | 
final String role = role_example; // String | 
final String status = status_example; // String | 

try {
    final response = api.adminPlatformAccountControllerList(q, role, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **role** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**AdminPlatformAccountListDtoOutput**](AdminPlatformAccountListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPlatformAccountControllerLock**
> adminPlatformAccountControllerLock(id, adminAccountLockDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminAccountLockDto adminAccountLockDto = ; // AdminAccountLockDto | 

try {
    api.adminPlatformAccountControllerLock(id, adminAccountLockDto);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerLock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminAccountLockDto** | [**AdminAccountLockDto**](AdminAccountLockDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPlatformAccountControllerResetMfa**
> AdminPlatformAccountDtoOutput adminPlatformAccountControllerResetMfa(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPlatformAccountControllerResetMfa(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerResetMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminPlatformAccountDtoOutput**](AdminPlatformAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPlatformAccountControllerResetPassword**
> AdminPlatformAccountDtoOutput adminPlatformAccountControllerResetPassword(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPlatformAccountControllerResetPassword(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerResetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminPlatformAccountDtoOutput**](AdminPlatformAccountDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPlatformAccountControllerUnlock**
> adminPlatformAccountControllerUnlock(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminUsersApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.adminPlatformAccountControllerUnlock(id);
} on DioException catch (e) {
    print('Exception when calling AdminUsersApi->adminPlatformAccountControllerUnlock: $e\n');
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

