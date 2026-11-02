# api_client_dart.api.AdminVehicleImagesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminVehicleImageControllerList**](AdminVehicleImagesApi.md#adminvehicleimagecontrollerlist) | **GET** /v1/admin/vehicle-images | 
[**adminVehicleImageControllerRemove**](AdminVehicleImagesApi.md#adminvehicleimagecontrollerremove) | **POST** /v1/admin/vehicle-images/{imageId}/remove | 


# **adminVehicleImageControllerList**
> AdminVehicleImageListDtoOutput adminVehicleImageControllerList(operatorId, uploadedSince, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminVehicleImagesApi();
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime uploadedSince = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminVehicleImageControllerList(operatorId, uploadedSince, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVehicleImagesApi->adminVehicleImageControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **operatorId** | **String**|  | [optional] 
 **uploadedSince** | **DateTime**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 24]

### Return type

[**AdminVehicleImageListDtoOutput**](AdminVehicleImageListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminVehicleImageControllerRemove**
> adminVehicleImageControllerRemove(imageId, adminRemoveVehicleImageInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminVehicleImagesApi();
final String imageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminRemoveVehicleImageInputDto adminRemoveVehicleImageInputDto = ; // AdminRemoveVehicleImageInputDto | 

try {
    api.adminVehicleImageControllerRemove(imageId, adminRemoveVehicleImageInputDto);
} on DioException catch (e) {
    print('Exception when calling AdminVehicleImagesApi->adminVehicleImageControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **String**|  | 
 **adminRemoveVehicleImageInputDto** | [**AdminRemoveVehicleImageInputDto**](AdminRemoveVehicleImageInputDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

