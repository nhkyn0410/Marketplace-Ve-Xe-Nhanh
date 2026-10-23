# api_client_dart.api.AdminNotificationApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminNotificationControllerHistory**](AdminNotificationApi.md#adminnotificationcontrollerhistory) | **GET** /v1/admin/system/notifications | 


# **adminNotificationControllerHistory**
> NotificationLogDtoOutput adminNotificationControllerHistory(offset, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationApi();
final int offset = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.adminNotificationControllerHistory(offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationApi->adminNotificationControllerHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **offset** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**NotificationLogDtoOutput**](NotificationLogDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

