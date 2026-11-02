# api_client_dart.api.AdminArticlesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminArticleCategoryControllerCreate**](AdminArticlesApi.md#adminarticlecategorycontrollercreate) | **POST** /v1/admin/article-categories | 
[**adminArticleCategoryControllerList**](AdminArticlesApi.md#adminarticlecategorycontrollerlist) | **GET** /v1/admin/article-categories | 
[**adminArticleCategoryControllerUpdate**](AdminArticlesApi.md#adminarticlecategorycontrollerupdate) | **PUT** /v1/admin/article-categories/{id} | 
[**adminArticleControllerArchive**](AdminArticlesApi.md#adminarticlecontrollerarchive) | **POST** /v1/admin/articles/{id}/archive | 
[**adminArticleControllerCreate**](AdminArticlesApi.md#adminarticlecontrollercreate) | **POST** /v1/admin/articles | 
[**adminArticleControllerCreateImageUploadUrl**](AdminArticlesApi.md#adminarticlecontrollercreateimageuploadurl) | **POST** /v1/admin/articles/images | 
[**adminArticleControllerGet**](AdminArticlesApi.md#adminarticlecontrollerget) | **GET** /v1/admin/articles/{id} | 
[**adminArticleControllerList**](AdminArticlesApi.md#adminarticlecontrollerlist) | **GET** /v1/admin/articles | 
[**adminArticleControllerPublish**](AdminArticlesApi.md#adminarticlecontrollerpublish) | **POST** /v1/admin/articles/{id}/publish | 
[**adminArticleControllerUpdate**](AdminArticlesApi.md#adminarticlecontrollerupdate) | **PUT** /v1/admin/articles/{id} | 


# **adminArticleCategoryControllerCreate**
> AdminArticleCategoryDtoOutput adminArticleCategoryControllerCreate(adminArticleCategoryInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final AdminArticleCategoryInputDto adminArticleCategoryInputDto = ; // AdminArticleCategoryInputDto | 

try {
    final response = api.adminArticleCategoryControllerCreate(adminArticleCategoryInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleCategoryControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminArticleCategoryInputDto** | [**AdminArticleCategoryInputDto**](AdminArticleCategoryInputDto.md)|  | 

### Return type

[**AdminArticleCategoryDtoOutput**](AdminArticleCategoryDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleCategoryControllerList**
> AdminArticleCategoryListDtoOutput adminArticleCategoryControllerList()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();

try {
    final response = api.adminArticleCategoryControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleCategoryControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminArticleCategoryListDtoOutput**](AdminArticleCategoryListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleCategoryControllerUpdate**
> AdminArticleCategoryDtoOutput adminArticleCategoryControllerUpdate(id, adminArticleCategoryInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminArticleCategoryInputDto adminArticleCategoryInputDto = ; // AdminArticleCategoryInputDto | 

try {
    final response = api.adminArticleCategoryControllerUpdate(id, adminArticleCategoryInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleCategoryControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminArticleCategoryInputDto** | [**AdminArticleCategoryInputDto**](AdminArticleCategoryInputDto.md)|  | 

### Return type

[**AdminArticleCategoryDtoOutput**](AdminArticleCategoryDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerArchive**
> AdminArticleDtoOutput adminArticleControllerArchive(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminArticleControllerArchive(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerArchive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminArticleDtoOutput**](AdminArticleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerCreate**
> AdminArticleDtoOutput adminArticleControllerCreate(adminArticleInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final AdminArticleInputDto adminArticleInputDto = ; // AdminArticleInputDto | 

try {
    final response = api.adminArticleControllerCreate(adminArticleInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminArticleInputDto** | [**AdminArticleInputDto**](AdminArticleInputDto.md)|  | 

### Return type

[**AdminArticleDtoOutput**](AdminArticleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerCreateImageUploadUrl**
> AdminArticleImageUploadResponseDtoOutput adminArticleControllerCreateImageUploadUrl(adminArticleImageUploadInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final AdminArticleImageUploadInputDto adminArticleImageUploadInputDto = ; // AdminArticleImageUploadInputDto | 

try {
    final response = api.adminArticleControllerCreateImageUploadUrl(adminArticleImageUploadInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerCreateImageUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminArticleImageUploadInputDto** | [**AdminArticleImageUploadInputDto**](AdminArticleImageUploadInputDto.md)|  | 

### Return type

[**AdminArticleImageUploadResponseDtoOutput**](AdminArticleImageUploadResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerGet**
> AdminArticleDtoOutput adminArticleControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminArticleControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminArticleDtoOutput**](AdminArticleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerList**
> AdminArticlePageDtoOutput adminArticleControllerList(q, status, categoryId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String q = q_example; // String | 
final String status = status_example; // String | 
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminArticleControllerList(q, status, categoryId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **categoryId** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminArticlePageDtoOutput**](AdminArticlePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerPublish**
> AdminArticleDtoOutput adminArticleControllerPublish(id, adminArticlePublishDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminArticlePublishDto adminArticlePublishDto = ; // AdminArticlePublishDto | 

try {
    final response = api.adminArticleControllerPublish(id, adminArticlePublishDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerPublish: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminArticlePublishDto** | [**AdminArticlePublishDto**](AdminArticlePublishDto.md)|  | 

### Return type

[**AdminArticleDtoOutput**](AdminArticleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminArticleControllerUpdate**
> AdminArticleDtoOutput adminArticleControllerUpdate(id, adminArticleInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminArticlesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminArticleInputDto adminArticleInputDto = ; // AdminArticleInputDto | 

try {
    final response = api.adminArticleControllerUpdate(id, adminArticleInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminArticlesApi->adminArticleControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminArticleInputDto** | [**AdminArticleInputDto**](AdminArticleInputDto.md)|  | 

### Return type

[**AdminArticleDtoOutput**](AdminArticleDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

