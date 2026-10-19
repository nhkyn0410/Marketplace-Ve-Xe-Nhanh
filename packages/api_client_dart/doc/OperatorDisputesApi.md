# api_client_dart.api.OperatorDisputesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorDisputeControllerGet**](OperatorDisputesApi.md#operatordisputecontrollerget) | **GET** /v1/operator/disputes/{disputeId} | 
[**operatorDisputeControllerList**](OperatorDisputesApi.md#operatordisputecontrollerlist) | **GET** /v1/operator/disputes | 
[**operatorDisputeControllerRespond**](OperatorDisputesApi.md#operatordisputecontrollerrespond) | **POST** /v1/operator/disputes/{disputeId}/responses | 


# **operatorDisputeControllerGet**
> DisputeDetailDtoOutput operatorDisputeControllerGet(disputeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorDisputeControllerGet(disputeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorDisputesApi->operatorDisputeControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorDisputeControllerList**
> DisputePageDtoOutput operatorDisputeControllerList(cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorDisputesApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.operatorDisputeControllerList(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorDisputesApi->operatorDisputeControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**DisputePageDtoOutput**](DisputePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorDisputeControllerRespond**
> DisputeDetailDtoOutput operatorDisputeControllerRespond(disputeId, evidenceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final EvidenceInputDto evidenceInputDto = ; // EvidenceInputDto | 

try {
    final response = api.operatorDisputeControllerRespond(disputeId, evidenceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorDisputesApi->operatorDisputeControllerRespond: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 
 **evidenceInputDto** | [**EvidenceInputDto**](EvidenceInputDto.md)|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

