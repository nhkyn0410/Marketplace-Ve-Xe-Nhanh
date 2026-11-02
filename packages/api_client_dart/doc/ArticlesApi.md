# api_client_dart.api.ArticlesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**articleControllerGet**](ArticlesApi.md#articlecontrollerget) | **GET** /v1/articles/{slug} | 
[**articleControllerList**](ArticlesApi.md#articlecontrollerlist) | **GET** /v1/articles | 
[**articleControllerListCategories**](ArticlesApi.md#articlecontrollerlistcategories) | **GET** /v1/article-categories | 
[**articleControllerRecordView**](ArticlesApi.md#articlecontrollerrecordview) | **POST** /v1/articles/{slug}/views | 


# **articleControllerGet**
> ArticleDtoOutput articleControllerGet(slug)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getArticlesApi();
final String slug = slug_example; // String | 

try {
    final response = api.articleControllerGet(slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ArticlesApi->articleControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**ArticleDtoOutput**](ArticleDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articleControllerList**
> ArticlePageDtoOutput articleControllerList(category, q, featured, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getArticlesApi();
final String category = category_example; // String | 
final String q = q_example; // String | 
final String featured = featured_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.articleControllerList(category, q, featured, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ArticlesApi->articleControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **featured** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 12]

### Return type

[**ArticlePageDtoOutput**](ArticlePageDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articleControllerListCategories**
> ArticleCategoryListDtoOutput articleControllerListCategories()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getArticlesApi();

try {
    final response = api.articleControllerListCategories();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ArticlesApi->articleControllerListCategories: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ArticleCategoryListDtoOutput**](ArticleCategoryListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articleControllerRecordView**
> articleControllerRecordView(slug)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getArticlesApi();
final String slug = slug_example; // String | 

try {
    api.articleControllerRecordView(slug);
} on DioException catch (e) {
    print('Exception when calling ArticlesApi->articleControllerRecordView: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

