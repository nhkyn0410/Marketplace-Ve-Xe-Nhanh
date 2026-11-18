# api_client_dart.api.JourneyDemoApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**journeyDemoControllerCurrent**](JourneyDemoApi.md#journeydemocontrollercurrent) | **GET** /v1/me/journey-demo | 
[**journeyDemoControllerStart**](JourneyDemoApi.md#journeydemocontrollerstart) | **POST** /v1/me/journey-demo | 
[**journeyDemoControllerStop**](JourneyDemoApi.md#journeydemocontrollerstop) | **DELETE** /v1/me/journey-demo/{sessionId} | 


# **journeyDemoControllerCurrent**
> JourneyDemoCurrentDtoOutput journeyDemoControllerCurrent(deviceId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyDemoApi();
final String deviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.journeyDemoControllerCurrent(deviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyDemoApi->journeyDemoControllerCurrent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**|  | 

### Return type

[**JourneyDemoCurrentDtoOutput**](JourneyDemoCurrentDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **journeyDemoControllerStart**
> JourneyDemoSnapshotDtoOutput journeyDemoControllerStart(journeyDemoStartDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyDemoApi();
final JourneyDemoStartDto journeyDemoStartDto = ; // JourneyDemoStartDto | 

try {
    final response = api.journeyDemoControllerStart(journeyDemoStartDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling JourneyDemoApi->journeyDemoControllerStart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **journeyDemoStartDto** | [**JourneyDemoStartDto**](JourneyDemoStartDto.md)|  | 

### Return type

[**JourneyDemoSnapshotDtoOutput**](JourneyDemoSnapshotDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **journeyDemoControllerStop**
> journeyDemoControllerStop(sessionId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getJourneyDemoApi();
final String sessionId = sessionId_example; // String | 

try {
    api.journeyDemoControllerStop(sessionId);
} on DioException catch (e) {
    print('Exception when calling JourneyDemoApi->journeyDemoControllerStop: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sessionId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

