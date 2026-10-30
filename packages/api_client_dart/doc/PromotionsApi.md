# api_client_dart.api.PromotionsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publicPromotionControllerCheck**](PromotionsApi.md#publicpromotioncontrollercheck) | **POST** /v1/promotions/check | 
[**publicPromotionControllerList**](PromotionsApi.md#publicpromotioncontrollerlist) | **GET** /v1/promotions | 


# **publicPromotionControllerCheck**
> PromotionCheckDtoOutput publicPromotionControllerCheck(promotionCheckInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPromotionsApi();
final PromotionCheckInputDto promotionCheckInputDto = ; // PromotionCheckInputDto | 

try {
    final response = api.publicPromotionControllerCheck(promotionCheckInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PromotionsApi->publicPromotionControllerCheck: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionCheckInputDto** | [**PromotionCheckInputDto**](PromotionCheckInputDto.md)|  | 

### Return type

[**PromotionCheckDtoOutput**](PromotionCheckDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicPromotionControllerList**
> PublicPromotionListDtoOutput publicPromotionControllerList(limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getPromotionsApi();
final int limit = 56; // int | 

try {
    final response = api.publicPromotionControllerList(limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PromotionsApi->publicPromotionControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 10]

### Return type

[**PublicPromotionListDtoOutput**](PublicPromotionListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

