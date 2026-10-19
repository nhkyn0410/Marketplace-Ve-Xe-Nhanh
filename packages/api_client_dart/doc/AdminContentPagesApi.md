# api_client_dart.api.AdminContentPagesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminContentPageControllerCreate**](AdminContentPagesApi.md#admincontentpagecontrollercreate) | **POST** /v1/admin/content-pages | 
[**adminContentPageControllerCreateImageUploadUrl**](AdminContentPagesApi.md#admincontentpagecontrollercreateimageuploadurl) | **POST** /v1/admin/content-pages/image-upload-url | 
[**adminContentPageControllerGet**](AdminContentPagesApi.md#admincontentpagecontrollerget) | **GET** /v1/admin/content-pages/{id} | 
[**adminContentPageControllerList**](AdminContentPagesApi.md#admincontentpagecontrollerlist) | **GET** /v1/admin/content-pages | 
[**adminContentPageControllerSetStatus**](AdminContentPagesApi.md#admincontentpagecontrollersetstatus) | **PUT** /v1/admin/content-pages/{id}/status | 
[**adminContentPageControllerUpdate**](AdminContentPagesApi.md#admincontentpagecontrollerupdate) | **PUT** /v1/admin/content-pages/{id} | 


# **adminContentPageControllerCreate**
> ContentPageDetailDtoOutput adminContentPageControllerCreate(contentPageInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final ContentPageInputDto contentPageInputDto = ; // ContentPageInputDto | 

try {
    final response = api.adminContentPageControllerCreate(contentPageInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contentPageInputDto** | [**ContentPageInputDto**](ContentPageInputDto.md)|  | 

### Return type

[**ContentPageDetailDtoOutput**](ContentPageDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminContentPageControllerCreateImageUploadUrl**
> ContentImageUploadResponseDtoOutput adminContentPageControllerCreateImageUploadUrl(contentImageUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final ContentImageUploadInputDto contentImageUploadInputDto = ; // ContentImageUploadInputDto | 

try {
    final response = api.adminContentPageControllerCreateImageUploadUrl(contentImageUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerCreateImageUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contentImageUploadInputDto** | [**ContentImageUploadInputDto**](ContentImageUploadInputDto.md)|  | 

### Return type

[**ContentImageUploadResponseDtoOutput**](ContentImageUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminContentPageControllerGet**
> ContentPageDetailDtoOutput adminContentPageControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminContentPageControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ContentPageDetailDtoOutput**](ContentPageDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminContentPageControllerList**
> ContentPagePageDtoOutput adminContentPageControllerList(type, status, q, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final String type = type_example; // String | 
final String status = status_example; // String | 
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.adminContentPageControllerList(type, status, q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**ContentPagePageDtoOutput**](ContentPagePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminContentPageControllerSetStatus**
> ContentPageDetailDtoOutput adminContentPageControllerSetStatus(id, contentPageStatusInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ContentPageStatusInputDto contentPageStatusInputDto = ; // ContentPageStatusInputDto | 

try {
    final response = api.adminContentPageControllerSetStatus(id, contentPageStatusInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerSetStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **contentPageStatusInputDto** | [**ContentPageStatusInputDto**](ContentPageStatusInputDto.md)|  | 

### Return type

[**ContentPageDetailDtoOutput**](ContentPageDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminContentPageControllerUpdate**
> ContentPageDetailDtoOutput adminContentPageControllerUpdate(id, contentPageInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminContentPagesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ContentPageInputDto contentPageInputDto = ; // ContentPageInputDto | 

try {
    final response = api.adminContentPageControllerUpdate(id, contentPageInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminContentPagesApi->adminContentPageControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **contentPageInputDto** | [**ContentPageInputDto**](ContentPageInputDto.md)|  | 

### Return type

[**ContentPageDetailDtoOutput**](ContentPageDetailDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

