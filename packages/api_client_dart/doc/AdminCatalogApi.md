# api_client_dart.api.AdminCatalogApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminCatalogControllerActivate**](AdminCatalogApi.md#admincatalogcontrolleractivate) | **POST** /v1/admin/catalog/{kind}/{id}/activate | 
[**adminCatalogControllerCreateAmenity**](AdminCatalogApi.md#admincatalogcontrollercreateamenity) | **POST** /v1/admin/catalog/amenities | 
[**adminCatalogControllerCreateProvince**](AdminCatalogApi.md#admincatalogcontrollercreateprovince) | **POST** /v1/admin/catalog/provinces | 
[**adminCatalogControllerCreateVehicleType**](AdminCatalogApi.md#admincatalogcontrollercreatevehicletype) | **POST** /v1/admin/catalog/vehicle-types | 
[**adminCatalogControllerCreateWard**](AdminCatalogApi.md#admincatalogcontrollercreateward) | **POST** /v1/admin/catalog/wards | 
[**adminCatalogControllerDeactivate**](AdminCatalogApi.md#admincatalogcontrollerdeactivate) | **POST** /v1/admin/catalog/{kind}/{id}/deactivate | 
[**adminCatalogControllerListAmenities**](AdminCatalogApi.md#admincatalogcontrollerlistamenities) | **GET** /v1/admin/catalog/amenities | 
[**adminCatalogControllerListProvinces**](AdminCatalogApi.md#admincatalogcontrollerlistprovinces) | **GET** /v1/admin/catalog/provinces | 
[**adminCatalogControllerListVehicleTypes**](AdminCatalogApi.md#admincatalogcontrollerlistvehicletypes) | **GET** /v1/admin/catalog/vehicle-types | 
[**adminCatalogControllerListWards**](AdminCatalogApi.md#admincatalogcontrollerlistwards) | **GET** /v1/admin/catalog/wards | 
[**adminCatalogControllerRenameAmenity**](AdminCatalogApi.md#admincatalogcontrollerrenameamenity) | **PUT** /v1/admin/catalog/amenities/{id} | 
[**adminCatalogControllerRenameProvince**](AdminCatalogApi.md#admincatalogcontrollerrenameprovince) | **PUT** /v1/admin/catalog/provinces/{id} | 
[**adminCatalogControllerRenameWard**](AdminCatalogApi.md#admincatalogcontrollerrenameward) | **PUT** /v1/admin/catalog/wards/{id} | 
[**adminCatalogControllerUpdateVehicleType**](AdminCatalogApi.md#admincatalogcontrollerupdatevehicletype) | **PUT** /v1/admin/catalog/vehicle-types/{id} | 


# **adminCatalogControllerActivate**
> adminCatalogControllerActivate(kind, id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String kind = kind_example; // String | 
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.adminCatalogControllerActivate(kind, id);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerActivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerCreateAmenity**
> AdminAmenityDtoOutput adminCatalogControllerCreateAmenity(adminAmenityInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final AdminAmenityInputDto adminAmenityInputDto = ; // AdminAmenityInputDto | 

try {
    final response = api.adminCatalogControllerCreateAmenity(adminAmenityInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerCreateAmenity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminAmenityInputDto** | [**AdminAmenityInputDto**](AdminAmenityInputDto.md)|  | 

### Return type

[**AdminAmenityDtoOutput**](AdminAmenityDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerCreateProvince**
> AdminProvinceDtoOutput adminCatalogControllerCreateProvince(adminProvinceInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final AdminProvinceInputDto adminProvinceInputDto = ; // AdminProvinceInputDto | 

try {
    final response = api.adminCatalogControllerCreateProvince(adminProvinceInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerCreateProvince: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminProvinceInputDto** | [**AdminProvinceInputDto**](AdminProvinceInputDto.md)|  | 

### Return type

[**AdminProvinceDtoOutput**](AdminProvinceDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerCreateVehicleType**
> AdminVehicleTypeDtoOutput adminCatalogControllerCreateVehicleType(adminVehicleTypeInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final AdminVehicleTypeInputDto adminVehicleTypeInputDto = ; // AdminVehicleTypeInputDto | 

try {
    final response = api.adminCatalogControllerCreateVehicleType(adminVehicleTypeInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerCreateVehicleType: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminVehicleTypeInputDto** | [**AdminVehicleTypeInputDto**](AdminVehicleTypeInputDto.md)|  | 

### Return type

[**AdminVehicleTypeDtoOutput**](AdminVehicleTypeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerCreateWard**
> AdminWardDtoOutput adminCatalogControllerCreateWard(adminWardInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final AdminWardInputDto adminWardInputDto = ; // AdminWardInputDto | 

try {
    final response = api.adminCatalogControllerCreateWard(adminWardInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerCreateWard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminWardInputDto** | [**AdminWardInputDto**](AdminWardInputDto.md)|  | 

### Return type

[**AdminWardDtoOutput**](AdminWardDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerDeactivate**
> adminCatalogControllerDeactivate(kind, id, adminCatalogDeactivateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String kind = kind_example; // String | 
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCatalogDeactivateDto adminCatalogDeactivateDto = ; // AdminCatalogDeactivateDto | 

try {
    api.adminCatalogControllerDeactivate(kind, id, adminCatalogDeactivateDto);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 
 **id** | **String**|  | 
 **adminCatalogDeactivateDto** | [**AdminCatalogDeactivateDto**](AdminCatalogDeactivateDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerListAmenities**
> AdminAmenityListDtoOutput adminCatalogControllerListAmenities(status)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String status = status_example; // String | 

try {
    final response = api.adminCatalogControllerListAmenities(status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerListAmenities: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 

### Return type

[**AdminAmenityListDtoOutput**](AdminAmenityListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerListProvinces**
> AdminProvincePageDtoOutput adminCatalogControllerListProvinces(q, status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String q = q_example; // String | 
final String status = status_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminCatalogControllerListProvinces(q, status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerListProvinces: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminProvincePageDtoOutput**](AdminProvincePageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerListVehicleTypes**
> AdminVehicleTypeListDtoOutput adminCatalogControllerListVehicleTypes(status)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String status = status_example; // String | 

try {
    final response = api.adminCatalogControllerListVehicleTypes(status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerListVehicleTypes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 

### Return type

[**AdminVehicleTypeListDtoOutput**](AdminVehicleTypeListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerListWards**
> AdminWardPageDtoOutput adminCatalogControllerListWards(provinceId, q, status, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String provinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String q = q_example; // String | 
final String status = status_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.adminCatalogControllerListWards(provinceId, q, status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerListWards: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provinceId** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdminWardPageDtoOutput**](AdminWardPageDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerRenameAmenity**
> AdminAmenityDtoOutput adminCatalogControllerRenameAmenity(id, adminCatalogRenameDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCatalogRenameDto adminCatalogRenameDto = ; // AdminCatalogRenameDto | 

try {
    final response = api.adminCatalogControllerRenameAmenity(id, adminCatalogRenameDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerRenameAmenity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminCatalogRenameDto** | [**AdminCatalogRenameDto**](AdminCatalogRenameDto.md)|  | 

### Return type

[**AdminAmenityDtoOutput**](AdminAmenityDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerRenameProvince**
> AdminProvinceDtoOutput adminCatalogControllerRenameProvince(id, adminCatalogRenameDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCatalogRenameDto adminCatalogRenameDto = ; // AdminCatalogRenameDto | 

try {
    final response = api.adminCatalogControllerRenameProvince(id, adminCatalogRenameDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerRenameProvince: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminCatalogRenameDto** | [**AdminCatalogRenameDto**](AdminCatalogRenameDto.md)|  | 

### Return type

[**AdminProvinceDtoOutput**](AdminProvinceDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerRenameWard**
> AdminWardDtoOutput adminCatalogControllerRenameWard(id, adminCatalogRenameDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCatalogRenameDto adminCatalogRenameDto = ; // AdminCatalogRenameDto | 

try {
    final response = api.adminCatalogControllerRenameWard(id, adminCatalogRenameDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerRenameWard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminCatalogRenameDto** | [**AdminCatalogRenameDto**](AdminCatalogRenameDto.md)|  | 

### Return type

[**AdminWardDtoOutput**](AdminWardDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCatalogControllerUpdateVehicleType**
> AdminVehicleTypeDtoOutput adminCatalogControllerUpdateVehicleType(id, adminVehicleTypeUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminCatalogApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminVehicleTypeUpdateDto adminVehicleTypeUpdateDto = ; // AdminVehicleTypeUpdateDto | 

try {
    final response = api.adminCatalogControllerUpdateVehicleType(id, adminVehicleTypeUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminCatalogApi->adminCatalogControllerUpdateVehicleType: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminVehicleTypeUpdateDto** | [**AdminVehicleTypeUpdateDto**](AdminVehicleTypeUpdateDto.md)|  | 

### Return type

[**AdminVehicleTypeDtoOutput**](AdminVehicleTypeDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

