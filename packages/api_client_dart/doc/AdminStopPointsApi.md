# api_client_dart.api.AdminStopPointsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminOperatorStopPointControllerList**](AdminStopPointsApi.md#adminoperatorstoppointcontrollerlist) | **GET** /v1/admin/operator-stop-points | 
[**adminOperatorStopPointControllerSuspend**](AdminStopPointsApi.md#adminoperatorstoppointcontrollersuspend) | **POST** /v1/admin/operator-stop-points/{id}/suspend | 
[**adminOperatorStopPointControllerUnsuspend**](AdminStopPointsApi.md#adminoperatorstoppointcontrollerunsuspend) | **POST** /v1/admin/operator-stop-points/{id}/unsuspend | 
[**adminSharedStopPointControllerCreate**](AdminStopPointsApi.md#adminsharedstoppointcontrollercreate) | **POST** /v1/admin/stop-points | 
[**adminSharedStopPointControllerGet**](AdminStopPointsApi.md#adminsharedstoppointcontrollerget) | **GET** /v1/admin/stop-points/{id} | 
[**adminSharedStopPointControllerList**](AdminStopPointsApi.md#adminsharedstoppointcontrollerlist) | **GET** /v1/admin/stop-points | 
[**adminSharedStopPointControllerUpdate**](AdminStopPointsApi.md#adminsharedstoppointcontrollerupdate) | **PUT** /v1/admin/stop-points/{id} | 
[**adminStopPointProposalControllerApprove**](AdminStopPointsApi.md#adminstoppointproposalcontrollerapprove) | **POST** /v1/admin/stop-point-proposals/{id}/approve | 
[**adminStopPointProposalControllerGet**](AdminStopPointsApi.md#adminstoppointproposalcontrollerget) | **GET** /v1/admin/stop-point-proposals/{id} | 
[**adminStopPointProposalControllerList**](AdminStopPointsApi.md#adminstoppointproposalcontrollerlist) | **GET** /v1/admin/stop-point-proposals | 
[**adminStopPointProposalControllerReject**](AdminStopPointsApi.md#adminstoppointproposalcontrollerreject) | **POST** /v1/admin/stop-point-proposals/{id}/reject | 


# **adminOperatorStopPointControllerList**
> AdminOperatorStopPointListDtoOutput adminOperatorStopPointControllerList(operatorId, type, provinceId, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String type = type_example; // String | 
final String provinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminOperatorStopPointControllerList(operatorId, type, provinceId, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminOperatorStopPointControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorId** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 
 **provinceId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminOperatorStopPointListDtoOutput**](AdminOperatorStopPointListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorStopPointControllerSuspend**
> AdminOperatorStopPointDtoOutput adminOperatorStopPointControllerSuspend(id, stopPointReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StopPointReasonInputDto stopPointReasonInputDto = ; // StopPointReasonInputDto | 

try {
    final response = api.adminOperatorStopPointControllerSuspend(id, stopPointReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminOperatorStopPointControllerSuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **stopPointReasonInputDto** | [**StopPointReasonInputDto**](StopPointReasonInputDto.md)|  | 

### Return type

[**AdminOperatorStopPointDtoOutput**](AdminOperatorStopPointDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminOperatorStopPointControllerUnsuspend**
> AdminOperatorStopPointDtoOutput adminOperatorStopPointControllerUnsuspend(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminOperatorStopPointControllerUnsuspend(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminOperatorStopPointControllerUnsuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminOperatorStopPointDtoOutput**](AdminOperatorStopPointDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSharedStopPointControllerCreate**
> AdminSharedStopPointDtoOutput adminSharedStopPointControllerCreate(adminSharedStopPointInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final AdminSharedStopPointInputDto adminSharedStopPointInputDto = ; // AdminSharedStopPointInputDto | 

try {
    final response = api.adminSharedStopPointControllerCreate(adminSharedStopPointInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminSharedStopPointControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminSharedStopPointInputDto** | [**AdminSharedStopPointInputDto**](AdminSharedStopPointInputDto.md)|  | 

### Return type

[**AdminSharedStopPointDtoOutput**](AdminSharedStopPointDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSharedStopPointControllerGet**
> AdminSharedStopPointDtoOutput adminSharedStopPointControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminSharedStopPointControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminSharedStopPointControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminSharedStopPointDtoOutput**](AdminSharedStopPointDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSharedStopPointControllerList**
> AdminSharedStopPointListDtoOutput adminSharedStopPointControllerList(type, provinceId, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String type = type_example; // String | 
final String provinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminSharedStopPointControllerList(type, provinceId, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminSharedStopPointControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | [optional] 
 **provinceId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminSharedStopPointListDtoOutput**](AdminSharedStopPointListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSharedStopPointControllerUpdate**
> AdminSharedStopPointDtoOutput adminSharedStopPointControllerUpdate(id, adminSharedStopPointInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminSharedStopPointInputDto adminSharedStopPointInputDto = ; // AdminSharedStopPointInputDto | 

try {
    final response = api.adminSharedStopPointControllerUpdate(id, adminSharedStopPointInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminSharedStopPointControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminSharedStopPointInputDto** | [**AdminSharedStopPointInputDto**](AdminSharedStopPointInputDto.md)|  | 

### Return type

[**AdminSharedStopPointDtoOutput**](AdminSharedStopPointDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStopPointProposalControllerApprove**
> AdminStopPointProposalDtoOutput adminStopPointProposalControllerApprove(id, adminStopPointProposalApprovalDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminStopPointProposalApprovalDto adminStopPointProposalApprovalDto = ; // AdminStopPointProposalApprovalDto | 

try {
    final response = api.adminStopPointProposalControllerApprove(id, adminStopPointProposalApprovalDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminStopPointProposalControllerApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminStopPointProposalApprovalDto** | [**AdminStopPointProposalApprovalDto**](AdminStopPointProposalApprovalDto.md)|  | 

### Return type

[**AdminStopPointProposalDtoOutput**](AdminStopPointProposalDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStopPointProposalControllerGet**
> AdminStopPointProposalDtoOutput adminStopPointProposalControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminStopPointProposalControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminStopPointProposalControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminStopPointProposalDtoOutput**](AdminStopPointProposalDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStopPointProposalControllerList**
> AdminStopPointProposalListDtoOutput adminStopPointProposalControllerList(status, type, operatorId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String status = status_example; // String | 
final String type = type_example; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminStopPointProposalControllerList(status, type, operatorId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminStopPointProposalControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminStopPointProposalListDtoOutput**](AdminStopPointProposalListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStopPointProposalControllerReject**
> AdminStopPointProposalDtoOutput adminStopPointProposalControllerReject(id, stopPointReasonInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminStopPointsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StopPointReasonInputDto stopPointReasonInputDto = ; // StopPointReasonInputDto | 

try {
    final response = api.adminStopPointProposalControllerReject(id, stopPointReasonInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStopPointsApi->adminStopPointProposalControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **stopPointReasonInputDto** | [**StopPointReasonInputDto**](StopPointReasonInputDto.md)|  | 

### Return type

[**AdminStopPointProposalDtoOutput**](AdminStopPointProposalDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

