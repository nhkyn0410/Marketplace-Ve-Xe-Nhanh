# api_client_dart.api.NotificationApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**preferenceControllerDevice**](NotificationApi.md#preferencecontrollerdevice) | **POST** /v1/me/push-devices | 
[**preferenceControllerHistory**](NotificationApi.md#preferencecontrollerhistory) | **GET** /v1/me/notifications | 
[**preferenceControllerPreferences**](NotificationApi.md#preferencecontrollerpreferences) | **GET** /v1/me/notification-preferences | 
[**preferenceControllerRemove**](NotificationApi.md#preferencecontrollerremove) | **DELETE** /v1/me/push-devices/{id} | 
[**preferenceControllerSave**](NotificationApi.md#preferencecontrollersave) | **PUT** /v1/me/notification-preferences | 


# **preferenceControllerDevice**
> DeviceDtoOutput preferenceControllerDevice(deviceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getNotificationApi();
final DeviceInputDto deviceInputDto = ; // DeviceInputDto | 

try {
    final response = api.preferenceControllerDevice(deviceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationApi->preferenceControllerDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceInputDto** | [**DeviceInputDto**](DeviceInputDto.md)|  | 

### Return type

[**DeviceDtoOutput**](DeviceDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **preferenceControllerHistory**
> NotificationLogDtoOutput preferenceControllerHistory(offset, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getNotificationApi();
final int offset = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.preferenceControllerHistory(offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationApi->preferenceControllerHistory: $e\n');
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

# **preferenceControllerPreferences**
> PreferencesDtoOutput preferenceControllerPreferences()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getNotificationApi();

try {
    final response = api.preferenceControllerPreferences();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationApi->preferenceControllerPreferences: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PreferencesDtoOutput**](PreferencesDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **preferenceControllerRemove**
> preferenceControllerRemove(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getNotificationApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.preferenceControllerRemove(id);
} on DioException catch (e) {
    print('Exception when calling NotificationApi->preferenceControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **preferenceControllerSave**
> PreferencesDtoOutput preferenceControllerSave(preferenceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getNotificationApi();
final PreferenceInputDto preferenceInputDto = ; // PreferenceInputDto | 

try {
    final response = api.preferenceControllerSave(preferenceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationApi->preferenceControllerSave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **preferenceInputDto** | [**PreferenceInputDto**](PreferenceInputDto.md)|  | 

### Return type

[**PreferencesDtoOutput**](PreferencesDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

