# api_client_dart.api.AdminDisputesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminDisputeControllerDecide**](AdminDisputesApi.md#admindisputecontrollerdecide) | **POST** /v1/admin/disputes/{disputeId}/decision | 
[**adminDisputeControllerEscalate**](AdminDisputesApi.md#admindisputecontrollerescalate) | **POST** /v1/admin/support-tickets/{ticketId}/escalate | 
[**adminDisputeControllerGet**](AdminDisputesApi.md#admindisputecontrollerget) | **GET** /v1/admin/disputes/{disputeId} | 
[**adminDisputeControllerList**](AdminDisputesApi.md#admindisputecontrollerlist) | **GET** /v1/admin/disputes | 
[**adminDisputeControllerRequestEvidence**](AdminDisputesApi.md#admindisputecontrollerrequestevidence) | **POST** /v1/admin/disputes/{disputeId}/evidence-requests | 
[**adminDisputeControllerSetStatus**](AdminDisputesApi.md#admindisputecontrollersetstatus) | **POST** /v1/admin/disputes/{disputeId}/status | 
[**adminDisputeControllerUpload**](AdminDisputesApi.md#admindisputecontrollerupload) | **POST** /v1/admin/disputes/{disputeId}/attachments/upload-url | 


# **adminDisputeControllerDecide**
> DisputeDetailDtoOutput adminDisputeControllerDecide(disputeId, disputeDecisionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DisputeDecisionInputDto disputeDecisionInputDto = ; // DisputeDecisionInputDto | 

try {
    final response = api.adminDisputeControllerDecide(disputeId, disputeDecisionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerDecide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 
 **disputeDecisionInputDto** | [**DisputeDecisionInputDto**](DisputeDecisionInputDto.md)|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDisputeControllerEscalate**
> DisputeDetailDtoOutput adminDisputeControllerEscalate(ticketId, escalateInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final EscalateInputDto escalateInputDto = ; // EscalateInputDto | 

try {
    final response = api.adminDisputeControllerEscalate(ticketId, escalateInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerEscalate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **escalateInputDto** | [**EscalateInputDto**](EscalateInputDto.md)|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDisputeControllerGet**
> DisputeDetailDtoOutput adminDisputeControllerGet(disputeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminDisputeControllerGet(disputeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerGet: $e\n');
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

# **adminDisputeControllerList**
> DisputePageDtoOutput adminDisputeControllerList(status, operatorId, due, assigneeId, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String status = status_example; // String | Trạng thái hoặc `open`.
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String due = due_example; // String | 
final String assigneeId = assigneeId_example; // String | UUID tài khoản nền tảng hoặc `none`.
final String q = q_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminDisputeControllerList(status, operatorId, due, assigneeId, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**| Trạng thái hoặc `open`. | [optional] 
 **operatorId** | **String**|  | [optional] 
 **due** | **String**|  | [optional] 
 **assigneeId** | **String**| UUID tài khoản nền tảng hoặc `none`. | [optional] 
 **q** | **String**|  | [optional] 
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

# **adminDisputeControllerRequestEvidence**
> DisputeDetailDtoOutput adminDisputeControllerRequestEvidence(disputeId, requestEvidenceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RequestEvidenceInputDto requestEvidenceInputDto = ; // RequestEvidenceInputDto | 

try {
    final response = api.adminDisputeControllerRequestEvidence(disputeId, requestEvidenceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerRequestEvidence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 
 **requestEvidenceInputDto** | [**RequestEvidenceInputDto**](RequestEvidenceInputDto.md)|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDisputeControllerSetStatus**
> DisputeDetailDtoOutput adminDisputeControllerSetStatus(disputeId, disputeStatusInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DisputeStatusInputDto disputeStatusInputDto = ; // DisputeStatusInputDto | 

try {
    final response = api.adminDisputeControllerSetStatus(disputeId, disputeStatusInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerSetStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 
 **disputeStatusInputDto** | [**DisputeStatusInputDto**](DisputeStatusInputDto.md)|  | 

### Return type

[**DisputeDetailDtoOutput**](DisputeDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDisputeControllerUpload**
> AttachmentUploadResponseDtoOutput adminDisputeControllerUpload(disputeId, attachmentUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminDisputesApi();
final String disputeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AttachmentUploadInputDto attachmentUploadInputDto = ; // AttachmentUploadInputDto | 

try {
    final response = api.adminDisputeControllerUpload(disputeId, attachmentUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->adminDisputeControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeId** | **String**|  | 
 **attachmentUploadInputDto** | [**AttachmentUploadInputDto**](AttachmentUploadInputDto.md)|  | 

### Return type

[**AttachmentUploadResponseDtoOutput**](AttachmentUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

