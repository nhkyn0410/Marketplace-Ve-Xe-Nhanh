# api_client_dart.api.AdminOperatorApplicationsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorApplicationReviewControllerApprove**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerapprove) | **POST** /v1/admin/operator-applications/{applicationId}/approve | 
[**operatorApplicationReviewControllerCreateDocumentDownload**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollercreatedocumentdownload) | **POST** /v1/admin/operator-applications/{applicationId}/documents/{type}/download-url | 
[**operatorApplicationReviewControllerGet**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerget) | **GET** /v1/admin/operator-applications/{applicationId} | 
[**operatorApplicationReviewControllerList**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerlist) | **GET** /v1/admin/operator-applications | 
[**operatorApplicationReviewControllerReject**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerreject) | **POST** /v1/admin/operator-applications/{applicationId}/reject | 
[**operatorApplicationReviewControllerRequestInfo**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerrequestinfo) | **POST** /v1/admin/operator-applications/{applicationId}/request-info | 
[**operatorApplicationReviewControllerResendOwnerCredentials**](AdminOperatorApplicationsApi.md#operatorapplicationreviewcontrollerresendownercredentials) | **POST** /v1/admin/operator-applications/{applicationId}/resend-owner-credentials | 


# **operatorApplicationReviewControllerApprove**
> ApprovalResponseDtoOutput operatorApplicationReviewControllerApprove(applicationId, idempotencyKey, approvalInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idempotencyKey = idempotencyKey_example; // String | 8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa trả lại kết quả lần đầu.
final ApprovalInputDto approvalInputDto = ; // ApprovalInputDto | 

try {
    final response = api.operatorApplicationReviewControllerApprove(applicationId, idempotencyKey, approvalInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **idempotencyKey** | **String**| 8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa trả lại kết quả lần đầu. | 
 **approvalInputDto** | [**ApprovalInputDto**](ApprovalInputDto.md)|  | 

### Return type

[**ApprovalResponseDtoOutput**](ApprovalResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerCreateDocumentDownload**
> DocumentDownloadResponseDtoOutput operatorApplicationReviewControllerCreateDocumentDownload(applicationId, type)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String type = type_example; // String | 

try {
    final response = api.operatorApplicationReviewControllerCreateDocumentDownload(applicationId, type);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerCreateDocumentDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **type** | **String**|  | 

### Return type

[**DocumentDownloadResponseDtoOutput**](DocumentDownloadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerGet**
> AdminApplicationDetailDtoOutput operatorApplicationReviewControllerGet(applicationId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorApplicationReviewControllerGet(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**AdminApplicationDetailDtoOutput**](AdminApplicationDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerList**
> AdminApplicationListResponseDtoOutput operatorApplicationReviewControllerList(status, q, submittedSince, duplicatesOnly, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String status = status_example; // String | 
final String q = q_example; // String | 
final DateTime submittedSince = 2013-10-20T19:20:30+01:00; // DateTime | 
final String duplicatesOnly = duplicatesOnly_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.operatorApplicationReviewControllerList(status, q, submittedSince, duplicatesOnly, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **submittedSince** | **DateTime**|  | [optional] 
 **duplicatesOnly** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminApplicationListResponseDtoOutput**](AdminApplicationListResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerReject**
> DecisionResponseDtoOutput operatorApplicationReviewControllerReject(applicationId, decisionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DecisionInputDto decisionInputDto = ; // DecisionInputDto | 

try {
    final response = api.operatorApplicationReviewControllerReject(applicationId, decisionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **decisionInputDto** | [**DecisionInputDto**](DecisionInputDto.md)|  | 

### Return type

[**DecisionResponseDtoOutput**](DecisionResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerRequestInfo**
> DecisionResponseDtoOutput operatorApplicationReviewControllerRequestInfo(applicationId, decisionInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DecisionInputDto decisionInputDto = ; // DecisionInputDto | 

try {
    final response = api.operatorApplicationReviewControllerRequestInfo(applicationId, decisionInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerRequestInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **decisionInputDto** | [**DecisionInputDto**](DecisionInputDto.md)|  | 

### Return type

[**DecisionResponseDtoOutput**](DecisionResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorApplicationReviewControllerResendOwnerCredentials**
> ApprovalResponseDtoOutput operatorApplicationReviewControllerResendOwnerCredentials(applicationId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminOperatorApplicationsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.operatorApplicationReviewControllerResendOwnerCredentials(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOperatorApplicationsApi->operatorApplicationReviewControllerResendOwnerCredentials: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**ApprovalResponseDtoOutput**](ApprovalResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

