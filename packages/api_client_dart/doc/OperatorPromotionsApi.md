# api_client_dart.api.OperatorPromotionsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorPromotionControllerCreate**](OperatorPromotionsApi.md#operatorpromotioncontrollercreate) | **POST** /v1/operator/promotions | 
[**operatorPromotionControllerGet**](OperatorPromotionsApi.md#operatorpromotioncontrollerget) | **GET** /v1/operator/promotions/{promotionId} | 
[**operatorPromotionControllerList**](OperatorPromotionsApi.md#operatorpromotioncontrollerlist) | **GET** /v1/operator/promotions | 
[**operatorPromotionControllerParticipate**](OperatorPromotionsApi.md#operatorpromotioncontrollerparticipate) | **PUT** /v1/operator/promotions/{promotionId}/participation | 
[**operatorPromotionControllerPermission**](OperatorPromotionsApi.md#operatorpromotioncontrollerpermission) | **GET** /v1/operator/promotion-permission | 
[**operatorPromotionControllerSetStatus**](OperatorPromotionsApi.md#operatorpromotioncontrollersetstatus) | **POST** /v1/operator/promotions/{promotionId}/status | 
[**operatorPromotionControllerUpdate**](OperatorPromotionsApi.md#operatorpromotioncontrollerupdate) | **PUT** /v1/operator/promotions/{promotionId} | 


# **operatorPromotionControllerCreate**
> PromotionDtoOutput operatorPromotionControllerCreate(promotionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final PromotionInputDto promotionInputDto = ; // PromotionInputDto | 

try {
    final response = api.operatorPromotionControllerCreate(promotionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerCreate: $e\n');
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

# **operatorPromotionControllerGet**
> PromotionDtoOutput operatorPromotionControllerGet(promotionId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorPromotionControllerGet(promotionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerGet: $e\n');
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

# **operatorPromotionControllerList**
> PromotionPageDtoOutput operatorPromotionControllerList(scope, display, q, routeId, operatorId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final String scope = scope_example; // String | 
final String display = display_example; // String | 
final String q = q_example; // String | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorPromotionControllerList(scope, display, q, routeId, operatorId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerList: $e\n');
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

# **operatorPromotionControllerParticipate**
> PromotionDtoOutput operatorPromotionControllerParticipate(promotionId, participationInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ParticipationInputDto participationInputDto = ; // ParticipationInputDto | 

try {
    final response = api.operatorPromotionControllerParticipate(promotionId, participationInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerParticipate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionId** | **String**|  | 
 **participationInputDto** | [**ParticipationInputDto**](ParticipationInputDto.md)|  | 

### Return type

[**PromotionDtoOutput**](PromotionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorPromotionControllerPermission**
> PermissionDtoOutput operatorPromotionControllerPermission()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();

try {
    final response = api.operatorPromotionControllerPermission();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerPermission: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PermissionDtoOutput**](PermissionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorPromotionControllerSetStatus**
> PromotionDtoOutput operatorPromotionControllerSetStatus(promotionId, promotionStatusInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PromotionStatusInputDto promotionStatusInputDto = ; // PromotionStatusInputDto | 

try {
    final response = api.operatorPromotionControllerSetStatus(promotionId, promotionStatusInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerSetStatus: $e\n');
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

# **operatorPromotionControllerUpdate**
> PromotionDtoOutput operatorPromotionControllerUpdate(promotionId, promotionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorPromotionsApi();
final String promotionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PromotionInputDto promotionInputDto = ; // PromotionInputDto | 

try {
    final response = api.operatorPromotionControllerUpdate(promotionId, promotionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorPromotionsApi->operatorPromotionControllerUpdate: $e\n');
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

