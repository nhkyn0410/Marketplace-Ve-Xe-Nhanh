# api_client_dart.api.AdminAuditLogsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAuditLogControllerGet**](AdminAuditLogsApi.md#adminauditlogcontrollerget) | **GET** /v1/admin/audit-logs/{id} | 
[**adminAuditLogControllerList**](AdminAuditLogsApi.md#adminauditlogcontrollerlist) | **GET** /v1/admin/audit-logs | 


# **adminAuditLogControllerGet**
> AdminAuditLogDetailDtoOutput adminAuditLogControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminAuditLogsApi();
final String id = id_example; // String | ObjectId (hex 24 ký tự).

try {
    final response = api.adminAuditLogControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminAuditLogsApi->adminAuditLogControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectId (hex 24 ký tự). | 

### Return type

[**AdminAuditLogDetailDtoOutput**](AdminAuditLogDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuditLogControllerList**
> AdminAuditLogListDtoOutput adminAuditLogControllerList(from, to, actorType, module, result, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminAuditLogsApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String actorType = actorType_example; // String | 
final String module = module_example; // String | 
final String result = result_example; // String | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminAuditLogControllerList(from, to, actorType, module, result, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminAuditLogsApi->adminAuditLogControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **actorType** | **String**|  | [optional] 
 **module** | **String**|  | [optional] 
 **result** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminAuditLogListDtoOutput**](AdminAuditLogListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

