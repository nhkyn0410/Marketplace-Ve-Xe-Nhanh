# api_client_dart.api.AdminSystemApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminReconciliationControllerList**](AdminSystemApi.md#adminreconciliationcontrollerlist) | **GET** /v1/admin/system/reconciliation | 
[**adminReconciliationControllerRun**](AdminSystemApi.md#adminreconciliationcontrollerrun) | **POST** /v1/admin/system/reconciliation | 
[**systemStatusControllerIntegrations**](AdminSystemApi.md#systemstatuscontrollerintegrations) | **GET** /v1/admin/system/integrations | 
[**systemStatusControllerJobs**](AdminSystemApi.md#systemstatuscontrollerjobs) | **GET** /v1/admin/system/jobs | 


# **adminReconciliationControllerList**
> ReconciliationPageDtoOutput adminReconciliationControllerList()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSystemApi();

try {
    final response = api.adminReconciliationControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSystemApi->adminReconciliationControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ReconciliationPageDtoOutput**](ReconciliationPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReconciliationControllerRun**
> ReconciliationRecordDtoOutput adminReconciliationControllerRun(reconciliationRequestDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSystemApi();
final ReconciliationRequestDto reconciliationRequestDto = ; // ReconciliationRequestDto | 

try {
    final response = api.adminReconciliationControllerRun(reconciliationRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSystemApi->adminReconciliationControllerRun: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reconciliationRequestDto** | [**ReconciliationRequestDto**](ReconciliationRequestDto.md)|  | 

### Return type

[**ReconciliationRecordDtoOutput**](ReconciliationRecordDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **systemStatusControllerIntegrations**
> SystemIntegrationsDtoOutput systemStatusControllerIntegrations()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSystemApi();

try {
    final response = api.systemStatusControllerIntegrations();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSystemApi->systemStatusControllerIntegrations: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SystemIntegrationsDtoOutput**](SystemIntegrationsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **systemStatusControllerJobs**
> BackgroundJobsDtoOutput systemStatusControllerJobs()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminSystemApi();

try {
    final response = api.systemStatusControllerJobs();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSystemApi->systemStatusControllerJobs: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BackgroundJobsDtoOutput**](BackgroundJobsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

