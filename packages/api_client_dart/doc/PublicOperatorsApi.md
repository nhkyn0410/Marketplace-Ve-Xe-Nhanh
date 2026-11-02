# api_client_dart.api.PublicOperatorsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publicOperatorProfileControllerGet**](PublicOperatorsApi.md#publicoperatorprofilecontrollerget) | **GET** /v1/operators/{operatorId}/public-profile | 


# **publicOperatorProfileControllerGet**
> PublicOperatorProfileDtoOutput publicOperatorProfileControllerGet(operatorId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPublicOperatorsApi();
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.publicOperatorProfileControllerGet(operatorId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicOperatorsApi->publicOperatorProfileControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorId** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**PublicOperatorProfileDtoOutput**](PublicOperatorProfileDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

