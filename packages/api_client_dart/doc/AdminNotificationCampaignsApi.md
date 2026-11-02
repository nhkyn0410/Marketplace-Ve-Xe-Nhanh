# api_client_dart.api.AdminNotificationCampaignsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminNotificationCampaignControllerCancel**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollercancel) | **POST** /v1/admin/notification-campaigns/{campaignId}/cancel | 
[**adminNotificationCampaignControllerCreate**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollercreate) | **POST** /v1/admin/notification-campaigns | 
[**adminNotificationCampaignControllerDetail**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollerdetail) | **GET** /v1/admin/notification-campaigns/{campaignId} | 
[**adminNotificationCampaignControllerEstimate**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollerestimate) | **POST** /v1/admin/notification-campaigns/estimate | 
[**adminNotificationCampaignControllerList**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollerlist) | **GET** /v1/admin/notification-campaigns | 
[**adminNotificationCampaignControllerOptions**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrolleroptions) | **GET** /v1/admin/notification-campaigns/options | 
[**adminNotificationCampaignControllerSend**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollersend) | **POST** /v1/admin/notification-campaigns/{campaignId}/send | 
[**adminNotificationCampaignControllerTest**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollertest) | **POST** /v1/admin/notification-campaigns/{campaignId}/test | 
[**adminNotificationCampaignControllerUpdate**](AdminNotificationCampaignsApi.md#adminnotificationcampaigncontrollerupdate) | **PUT** /v1/admin/notification-campaigns/{campaignId} | 


# **adminNotificationCampaignControllerCancel**
> CampaignDtoOutput adminNotificationCampaignControllerCancel(campaignId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminNotificationCampaignControllerCancel(campaignId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

[**CampaignDtoOutput**](CampaignDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerCreate**
> CampaignDtoOutput adminNotificationCampaignControllerCreate(campaignInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final CampaignInputDto campaignInputDto = ; // CampaignInputDto | 

try {
    final response = api.adminNotificationCampaignControllerCreate(campaignInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignInputDto** | [**CampaignInputDto**](CampaignInputDto.md)|  | 

### Return type

[**CampaignDtoOutput**](CampaignDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerDetail**
> CampaignDetailDtoOutput adminNotificationCampaignControllerDetail(campaignId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminNotificationCampaignControllerDetail(campaignId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 

### Return type

[**CampaignDetailDtoOutput**](CampaignDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerEstimate**
> AudienceEstimateDtoOutput adminNotificationCampaignControllerEstimate(audienceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final AudienceInputDto audienceInputDto = ; // AudienceInputDto | 

try {
    final response = api.adminNotificationCampaignControllerEstimate(audienceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerEstimate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audienceInputDto** | [**AudienceInputDto**](AudienceInputDto.md)|  | 

### Return type

[**AudienceEstimateDtoOutput**](AudienceEstimateDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerList**
> CampaignPageDtoOutput adminNotificationCampaignControllerList(status, offset, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String status = status_example; // String | 
final int offset = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.adminNotificationCampaignControllerList(status, offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **offset** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**CampaignPageDtoOutput**](CampaignPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerOptions**
> CampaignOptionsDtoOutput adminNotificationCampaignControllerOptions()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();

try {
    final response = api.adminNotificationCampaignControllerOptions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerOptions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CampaignOptionsDtoOutput**](CampaignOptionsDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerSend**
> CampaignDtoOutput adminNotificationCampaignControllerSend(campaignId, campaignSendInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CampaignSendInputDto campaignSendInputDto = ; // CampaignSendInputDto | 

try {
    final response = api.adminNotificationCampaignControllerSend(campaignId, campaignSendInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 
 **campaignSendInputDto** | [**CampaignSendInputDto**](CampaignSendInputDto.md)|  | 

### Return type

[**CampaignDtoOutput**](CampaignDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerTest**
> CampaignTestResultDtoOutput adminNotificationCampaignControllerTest(campaignId, campaignTestInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CampaignTestInputDto campaignTestInputDto = ; // CampaignTestInputDto | 

try {
    final response = api.adminNotificationCampaignControllerTest(campaignId, campaignTestInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerTest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 
 **campaignTestInputDto** | [**CampaignTestInputDto**](CampaignTestInputDto.md)|  | 

### Return type

[**CampaignTestResultDtoOutput**](CampaignTestResultDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationCampaignControllerUpdate**
> CampaignDtoOutput adminNotificationCampaignControllerUpdate(campaignId, campaignInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminNotificationCampaignsApi();
final String campaignId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CampaignInputDto campaignInputDto = ; // CampaignInputDto | 

try {
    final response = api.adminNotificationCampaignControllerUpdate(campaignId, campaignInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminNotificationCampaignsApi->adminNotificationCampaignControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **String**|  | 
 **campaignInputDto** | [**CampaignInputDto**](CampaignInputDto.md)|  | 

### Return type

[**CampaignDtoOutput**](CampaignDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

