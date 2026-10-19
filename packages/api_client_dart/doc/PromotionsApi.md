# api_client_dart.api.PromotionsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publicPromotionControllerCheck**](PromotionsApi.md#publicpromotioncontrollercheck) | **POST** /v1/promotions/check | 


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

