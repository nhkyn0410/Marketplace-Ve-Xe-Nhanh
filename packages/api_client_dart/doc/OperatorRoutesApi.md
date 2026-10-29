# api_client_dart.api.OperatorRoutesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**routeControllerCreate**](OperatorRoutesApi.md#routecontrollercreate) | **POST** /v1/operator/routes | 
[**routeControllerCreateSubRoute**](OperatorRoutesApi.md#routecontrollercreatesubroute) | **POST** /v1/operator/routes/{routeId}/sub-routes | 
[**routeControllerGet**](OperatorRoutesApi.md#routecontrollerget) | **GET** /v1/operator/routes/{routeId} | 
[**routeControllerList**](OperatorRoutesApi.md#routecontrollerlist) | **GET** /v1/operator/routes | 
[**routeControllerPreviewName**](OperatorRoutesApi.md#routecontrollerpreviewname) | **POST** /v1/operator/routes/name-suggestion | 
[**routeControllerSubRouteSuggestions**](OperatorRoutesApi.md#routecontrollersubroutesuggestions) | **GET** /v1/operator/routes/{routeId}/sub-route-suggestions | 
[**routeControllerUpdate**](OperatorRoutesApi.md#routecontrollerupdate) | **PUT** /v1/operator/routes/{routeId} | 
[**routeControllerUpdateSubRoute**](OperatorRoutesApi.md#routecontrollerupdatesubroute) | **PUT** /v1/operator/routes/{routeId}/sub-routes/{subRouteId} | 


# **routeControllerCreate**
> RouteResponseDtoOutput routeControllerCreate(routeInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final RouteInputDto routeInputDto = ; // RouteInputDto | 

try {
    final response = api.routeControllerCreate(routeInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeInputDto** | [**RouteInputDto**](RouteInputDto.md)|  | 

### Return type

[**RouteResponseDtoOutput**](RouteResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerCreateSubRoute**
> RouteResponseDtoOutput routeControllerCreateSubRoute(routeId, subRouteInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SubRouteInputDto subRouteInputDto = ; // SubRouteInputDto | 

try {
    final response = api.routeControllerCreateSubRoute(routeId, subRouteInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerCreateSubRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | 
 **subRouteInputDto** | [**SubRouteInputDto**](SubRouteInputDto.md)|  | 

### Return type

[**RouteResponseDtoOutput**](RouteResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerGet**
> RouteResponseDtoOutput routeControllerGet(routeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.routeControllerGet(routeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | 

### Return type

[**RouteResponseDtoOutput**](RouteResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerList**
> RouteListResponseDtoOutput routeControllerList(status, cursor, limit, includeSubRoutes)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String status = status_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 
final String includeSubRoutes = includeSubRoutes_example; // String | 

try {
    final response = api.routeControllerList(status, cursor, limit, includeSubRoutes);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]
 **includeSubRoutes** | **String**|  | [optional] 

### Return type

[**RouteListResponseDtoOutput**](RouteListResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerPreviewName**
> RouteNamePreviewDtoOutput routeControllerPreviewName(routeNamePreviewInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final RouteNamePreviewInputDto routeNamePreviewInputDto = ; // RouteNamePreviewInputDto | 

try {
    final response = api.routeControllerPreviewName(routeNamePreviewInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerPreviewName: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeNamePreviewInputDto** | [**RouteNamePreviewInputDto**](RouteNamePreviewInputDto.md)|  | 

### Return type

[**RouteNamePreviewDtoOutput**](RouteNamePreviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerSubRouteSuggestions**
> SubRouteSuggestionListDtoOutput routeControllerSubRouteSuggestions(routeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.routeControllerSubRouteSuggestions(routeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerSubRouteSuggestions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | 

### Return type

[**SubRouteSuggestionListDtoOutput**](SubRouteSuggestionListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerUpdate**
> RouteResponseDtoOutput routeControllerUpdate(routeId, routeInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RouteInputDto routeInputDto = ; // RouteInputDto | 

try {
    final response = api.routeControllerUpdate(routeId, routeInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | 
 **routeInputDto** | [**RouteInputDto**](RouteInputDto.md)|  | 

### Return type

[**RouteResponseDtoOutput**](RouteResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerUpdateSubRoute**
> RouteResponseDtoOutput routeControllerUpdateSubRoute(routeId, subRouteId, subRouteInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorRoutesApi();
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String subRouteId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SubRouteInputDto subRouteInputDto = ; // SubRouteInputDto | 

try {
    final response = api.routeControllerUpdateSubRoute(routeId, subRouteId, subRouteInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorRoutesApi->routeControllerUpdateSubRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeId** | **String**|  | 
 **subRouteId** | **String**|  | 
 **subRouteInputDto** | [**SubRouteInputDto**](SubRouteInputDto.md)|  | 

### Return type

[**RouteResponseDtoOutput**](RouteResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

