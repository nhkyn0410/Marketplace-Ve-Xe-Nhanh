# api_client_dart.api.OperatorReportsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operatorReportingControllerExport**](OperatorReportsApi.md#operatorreportingcontrollerexport) | **GET** /v1/operator/reports/export | 
[**operatorReportingControllerOverview**](OperatorReportsApi.md#operatorreportingcontrolleroverview) | **GET** /v1/operator/overview | 
[**operatorReportingControllerSummary**](OperatorReportsApi.md#operatorreportingcontrollersummary) | **GET** /v1/operator/reports/summary | 


# **operatorReportingControllerExport**
> String operatorReportingControllerExport(from, to, routeId, vehicleId, status)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReportsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String vehicleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 

try {
    final response = api.operatorReportingControllerExport(from, to, routeId, vehicleId, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReportsApi->operatorReportingControllerExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **routeId** | **String**|  | [optional] 
 **vehicleId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

**String**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorReportingControllerOverview**
> OperatorOverviewDtoOutput operatorReportingControllerOverview()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReportsApi();

try {
    final response = api.operatorReportingControllerOverview();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReportsApi->operatorReportingControllerOverview: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OperatorOverviewDtoOutput**](OperatorOverviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **operatorReportingControllerSummary**
> OperatorReportDtoOutput operatorReportingControllerSummary(from, to, routeId, vehicleId, status)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorReportsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String vehicleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 

try {
    final response = api.operatorReportingControllerSummary(from, to, routeId, vehicleId, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorReportsApi->operatorReportingControllerSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 
 **routeId** | **String**|  | [optional] 
 **vehicleId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**OperatorReportDtoOutput**](OperatorReportDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

