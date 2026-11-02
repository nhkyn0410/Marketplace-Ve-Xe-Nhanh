# api_client_dart.api.SeatHoldsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**seatHoldControllerCreate**](SeatHoldsApi.md#seatholdcontrollercreate) | **POST** /v1/seat-holds | 
[**seatHoldControllerGet**](SeatHoldsApi.md#seatholdcontrollerget) | **GET** /v1/seat-holds/{holdId} | 
[**seatHoldControllerRelease**](SeatHoldsApi.md#seatholdcontrollerrelease) | **DELETE** /v1/seat-holds/{holdId} | 


# **seatHoldControllerCreate**
> SeatHoldResponseDtoOutput seatHoldControllerCreate(seatHoldInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSeatHoldsApi();
final SeatHoldInputDto seatHoldInputDto = ; // SeatHoldInputDto | 

try {
    final response = api.seatHoldControllerCreate(seatHoldInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SeatHoldsApi->seatHoldControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **seatHoldInputDto** | [**SeatHoldInputDto**](SeatHoldInputDto.md)|  | 

### Return type

[**SeatHoldResponseDtoOutput**](SeatHoldResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **seatHoldControllerGet**
> SeatHoldResponseDtoOutput seatHoldControllerGet(holdId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSeatHoldsApi();
final String holdId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.seatHoldControllerGet(holdId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SeatHoldsApi->seatHoldControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **holdId** | **String**|  | 

### Return type

[**SeatHoldResponseDtoOutput**](SeatHoldResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **seatHoldControllerRelease**
> seatHoldControllerRelease(holdId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSeatHoldsApi();
final String holdId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.seatHoldControllerRelease(holdId);
} on DioException catch (e) {
    print('Exception when calling SeatHoldsApi->seatHoldControllerRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **holdId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

