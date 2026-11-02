# api_client_dart.api.AdminRoutesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminRouteControllerDetail**](AdminRoutesApi.md#adminroutecontrollerdetail) | **GET** /v1/admin/routes/{id} | 
[**adminRouteControllerList**](AdminRoutesApi.md#adminroutecontrollerlist) | **GET** /v1/admin/routes | 


# **adminRouteControllerDetail**
> AdminRouteDetailDtoOutput adminRouteControllerDetail(id, from, to)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRoutesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 

try {
    final response = api.adminRouteControllerDetail(id, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRoutesApi->adminRouteControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 

### Return type

[**AdminRouteDetailDtoOutput**](AdminRouteDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRouteControllerList**
> AdminRoutePageDtoOutput adminRouteControllerList(q, operatorId, status, originProvinceId, destinationProvinceId, from, to, sort, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminRoutesApi();
final String q = q_example; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String originProvinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String destinationProvinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String sort = sort_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminRouteControllerList(q, operatorId, status, originProvinceId, destinationProvinceId, from, to, sort, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRoutesApi->adminRouteControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **originProvinceId** | **String**|  | [optional] 
 **destinationProvinceId** | **String**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **sort** | **String**|  | [optional] [default to 'sold']
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminRoutePageDtoOutput**](AdminRoutePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

