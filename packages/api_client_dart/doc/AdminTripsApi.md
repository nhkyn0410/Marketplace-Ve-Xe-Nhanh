# api_client_dart.api.AdminTripsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminTripControllerDetail**](AdminTripsApi.md#admintripcontrollerdetail) | **GET** /v1/admin/trips/{id} | 
[**adminTripControllerList**](AdminTripsApi.md#admintripcontrollerlist) | **GET** /v1/admin/trips | 


# **adminTripControllerDetail**
> AdminTripDetailDtoOutput adminTripControllerDetail(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminTripsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminTripControllerDetail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminTripsApi->adminTripControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminTripDetailDtoOutput**](AdminTripDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminTripControllerList**
> AdminTripPageDtoOutput adminTripControllerList(from, to, operatorId, routeId, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminTripsApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String routeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminTripControllerList(from, to, operatorId, routeId, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminTripsApi->adminTripControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **operatorId** | **String**|  | [optional] 
 **routeId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminTripPageDtoOutput**](AdminTripPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

