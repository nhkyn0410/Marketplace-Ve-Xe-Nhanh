# api_client_dart.api.OperatorOfficesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**salesOfficeControllerAssignments**](OperatorOfficesApi.md#salesofficecontrollerassignments) | **GET** /v1/operator/offices/{officeId}/assignments | 
[**salesOfficeControllerCreate**](OperatorOfficesApi.md#salesofficecontrollercreate) | **POST** /v1/operator/offices | 
[**salesOfficeControllerGet**](OperatorOfficesApi.md#salesofficecontrollerget) | **GET** /v1/operator/offices/{officeId} | 
[**salesOfficeControllerList**](OperatorOfficesApi.md#salesofficecontrollerlist) | **GET** /v1/operator/offices | 
[**salesOfficeControllerReplaceAssignments**](OperatorOfficesApi.md#salesofficecontrollerreplaceassignments) | **PUT** /v1/operator/offices/{officeId}/assignments | 
[**salesOfficeControllerUpdate**](OperatorOfficesApi.md#salesofficecontrollerupdate) | **PATCH** /v1/operator/offices/{officeId} | 


# **salesOfficeControllerAssignments**
> SalesOfficeAssignmentsDtoOutput salesOfficeControllerAssignments(officeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.salesOfficeControllerAssignments(officeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerAssignments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 

### Return type

[**SalesOfficeAssignmentsDtoOutput**](SalesOfficeAssignmentsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **salesOfficeControllerCreate**
> SalesOfficeDtoOutput salesOfficeControllerCreate(salesOfficeInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();
final SalesOfficeInputDto salesOfficeInputDto = ; // SalesOfficeInputDto | 

try {
    final response = api.salesOfficeControllerCreate(salesOfficeInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salesOfficeInputDto** | [**SalesOfficeInputDto**](SalesOfficeInputDto.md)|  | 

### Return type

[**SalesOfficeDtoOutput**](SalesOfficeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **salesOfficeControllerGet**
> SalesOfficeDtoOutput salesOfficeControllerGet(officeId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.salesOfficeControllerGet(officeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 

### Return type

[**SalesOfficeDtoOutput**](SalesOfficeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **salesOfficeControllerList**
> SalesOfficeListDtoOutput salesOfficeControllerList()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();

try {
    final response = api.salesOfficeControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SalesOfficeListDtoOutput**](SalesOfficeListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **salesOfficeControllerReplaceAssignments**
> SalesOfficeDtoOutput salesOfficeControllerReplaceAssignments(officeId, salesOfficeAssignmentsInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SalesOfficeAssignmentsInputDto salesOfficeAssignmentsInputDto = ; // SalesOfficeAssignmentsInputDto | 

try {
    final response = api.salesOfficeControllerReplaceAssignments(officeId, salesOfficeAssignmentsInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerReplaceAssignments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 
 **salesOfficeAssignmentsInputDto** | [**SalesOfficeAssignmentsInputDto**](SalesOfficeAssignmentsInputDto.md)|  | 

### Return type

[**SalesOfficeDtoOutput**](SalesOfficeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **salesOfficeControllerUpdate**
> SalesOfficeDtoOutput salesOfficeControllerUpdate(officeId, salesOfficeUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getOperatorOfficesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SalesOfficeUpdateDto salesOfficeUpdateDto = ; // SalesOfficeUpdateDto | 

try {
    final response = api.salesOfficeControllerUpdate(officeId, salesOfficeUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OperatorOfficesApi->salesOfficeControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 
 **salesOfficeUpdateDto** | [**SalesOfficeUpdateDto**](SalesOfficeUpdateDto.md)|  | 

### Return type

[**SalesOfficeDtoOutput**](SalesOfficeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

