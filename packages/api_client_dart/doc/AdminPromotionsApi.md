# api_client_dart.api.AdminPromotionsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPromotionControllerCreate**](AdminPromotionsApi.md#adminpromotioncontrollercreate) | **POST** /v1/admin/promotions | 
[**adminPromotionControllerGet**](AdminPromotionsApi.md#adminpromotioncontrollerget) | **GET** /v1/admin/promotions/{promotionId} | 
[**adminPromotionControllerList**](AdminPromotionsApi.md#adminpromotioncontrollerlist) | **GET** /v1/admin/promotions | 
[**adminPromotionControllerPermissions**](AdminPromotionsApi.md#adminpromotioncontrollerpermissions) | **GET** /v1/admin/promotion-permissions | 
[**adminPromotionControllerSetPermission**](AdminPromotionsApi.md#adminpromotioncontrollersetpermission) | **PUT** /v1/admin/promotion-permissions/{operatorId} | 
[**adminPromotionControllerSetStatus**](AdminPromotionsApi.md#adminpromotioncontrollersetstatus) | **POST** /v1/admin/promotions/{promotionId}/status | 
[**adminPromotionControllerUpdate**](AdminPromotionsApi.md#adminpromotioncontrollerupdate) | **PUT** /v1/admin/promotions/{promotionId} | 


# **adminPromotionControllerCreate**
> PromotionDtoOutput adminPromotionControllerCreate(promotionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final PromotionInputDto promotionInputDto = ; // PromotionInputDto | 

try {
    final response = api.adminPromotionControllerCreate(promotionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionInputDto** | [**PromotionInputDto**](PromotionInputDto.md)|  | 

### Return type

[**PromotionDtoOutput**](PromotionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerGet**
> PromotionDtoOutput adminPromotionControllerGet(promotionId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPromotionControllerGet(promotionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionId** | **String**|  | 

### Return type

[**PromotionDtoOutput**](PromotionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerList**
> PromotionPageDtoOutput adminPromotionControllerList(scope, display, q, routeId, operatorId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String scope = scope_example; // String | 
final String display = display_example; // String | 
final String q = q_example; // String | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminPromotionControllerList(scope, display, q, routeId, operatorId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scope** | **String**|  | [optional] 
 **display** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **routeId** | **String**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PromotionPageDtoOutput**](PromotionPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerPermissions**
> PermissionPageDtoOutput adminPromotionControllerPermissions(q, enabled, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String q = q_example; // String | 
final String enabled = enabled_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminPromotionControllerPermissions(q, enabled, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerPermissions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **enabled** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PermissionPageDtoOutput**](PermissionPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerSetPermission**
> PermissionDtoOutput adminPromotionControllerSetPermission(operatorId, permissionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PermissionInputDto permissionInputDto = ; // PermissionInputDto | 

try {
    final response = api.adminPromotionControllerSetPermission(operatorId, permissionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerSetPermission: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorId** | **String**|  | 
 **permissionInputDto** | [**PermissionInputDto**](PermissionInputDto.md)|  | 

### Return type

[**PermissionDtoOutput**](PermissionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerSetStatus**
> PromotionDtoOutput adminPromotionControllerSetStatus(promotionId, promotionStatusInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PromotionStatusInputDto promotionStatusInputDto = ; // PromotionStatusInputDto | 

try {
    final response = api.adminPromotionControllerSetStatus(promotionId, promotionStatusInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerSetStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionId** | **String**|  | 
 **promotionStatusInputDto** | [**PromotionStatusInputDto**](PromotionStatusInputDto.md)|  | 

### Return type

[**PromotionDtoOutput**](PromotionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPromotionControllerUpdate**
> PromotionDtoOutput adminPromotionControllerUpdate(promotionId, promotionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PromotionInputDto promotionInputDto = ; // PromotionInputDto | 

try {
    final response = api.adminPromotionControllerUpdate(promotionId, promotionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPromotionsApi->adminPromotionControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionId** | **String**|  | 
 **promotionInputDto** | [**PromotionInputDto**](PromotionInputDto.md)|  | 

### Return type

[**PromotionDtoOutput**](PromotionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

