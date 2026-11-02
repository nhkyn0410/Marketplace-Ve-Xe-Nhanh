# api_client_dart.api.ContentPagesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**contentPageControllerGet**](ContentPagesApi.md#contentpagecontrollerget) | **GET** /v1/content-pages/{slug} | 
[**contentPageControllerList**](ContentPagesApi.md#contentpagecontrollerlist) | **GET** /v1/content-pages | 


# **contentPageControllerGet**
> PublicContentItemDtoOutput contentPageControllerGet(slug)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getContentPagesApi();
final String slug = slug_example; // String | 

try {
    final response = api.contentPageControllerGet(slug);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContentPagesApi->contentPageControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**PublicContentItemDtoOutput**](PublicContentItemDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentPageControllerList**
> PublicContentListDtoOutput contentPageControllerList(type, placement)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getContentPagesApi();
final String type = type_example; // String | 
final String placement = placement_example; // String | 

try {
    final response = api.contentPageControllerList(type, placement);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContentPagesApi->contentPageControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **placement** | **String**|  | [optional] 

### Return type

[**PublicContentListDtoOutput**](PublicContentListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

