# api_client_dart.api.AdminReportsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminReportingControllerExport**](AdminReportsApi.md#adminreportingcontrollerexport) | **GET** /v1/admin/reports/export | 
[**adminReportingControllerOverview**](AdminReportsApi.md#adminreportingcontrolleroverview) | **GET** /v1/admin/overview | 
[**adminReportingControllerSummary**](AdminReportsApi.md#adminreportingcontrollersummary) | **GET** /v1/admin/reports/summary | 


# **adminReportingControllerExport**
> String adminReportingControllerExport(from, to, operatorId, provider)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminReportsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String provider = provider_example; // String | 

try {
    final response = api.adminReportingControllerExport(from, to, operatorId, provider);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReportsApi->adminReportingControllerExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **operatorId** | **String**|  | [optional] 
 **provider** | **String**|  | [optional] 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReportingControllerOverview**
> AdminOverviewDtoOutput adminReportingControllerOverview(from, to, operatorId, provider)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminReportsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String provider = provider_example; // String | 

try {
    final response = api.adminReportingControllerOverview(from, to, operatorId, provider);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReportsApi->adminReportingControllerOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **operatorId** | **String**|  | [optional] 
 **provider** | **String**|  | [optional] 

### Return type

[**AdminOverviewDtoOutput**](AdminOverviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReportingControllerSummary**
> AdminReportDtoOutput adminReportingControllerSummary(from, to, operatorId, provider)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminReportsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String provider = provider_example; // String | 

try {
    final response = api.adminReportingControllerSummary(from, to, operatorId, provider);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReportsApi->adminReportingControllerSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **operatorId** | **String**|  | [optional] 
 **provider** | **String**|  | [optional] 

### Return type

[**AdminReportDtoOutput**](AdminReportDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

