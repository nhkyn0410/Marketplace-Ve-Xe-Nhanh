# api_client_dart.api.AdminPoliciesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPolicyControllerCancel**](AdminPoliciesApi.md#adminpolicycontrollercancel) | **POST** /v1/admin/policy-versions/{id}/cancel | 
[**adminPolicyControllerCancelFareBand**](AdminPoliciesApi.md#adminpolicycontrollercancelfareband) | **POST** /v1/admin/fare-bands/{id}/cancel | 
[**adminPolicyControllerCreateDraft**](AdminPoliciesApi.md#adminpolicycontrollercreatedraft) | **POST** /v1/admin/policies/{type}/versions | 
[**adminPolicyControllerCreateFareBand**](AdminPoliciesApi.md#adminpolicycontrollercreatefareband) | **POST** /v1/admin/fare-bands | 
[**adminPolicyControllerGet**](AdminPoliciesApi.md#adminpolicycontrollerget) | **GET** /v1/admin/policy-versions/{id} | 
[**adminPolicyControllerListFareBands**](AdminPoliciesApi.md#adminpolicycontrollerlistfarebands) | **GET** /v1/admin/fare-bands | 
[**adminPolicyControllerOverview**](AdminPoliciesApi.md#adminpolicycontrolleroverview) | **GET** /v1/admin/policies/{type} | 
[**adminPolicyControllerPublish**](AdminPoliciesApi.md#adminpolicycontrollerpublish) | **POST** /v1/admin/policy-versions/{id}/publish | 
[**adminPolicyControllerUpdateDraft**](AdminPoliciesApi.md#adminpolicycontrollerupdatedraft) | **PUT** /v1/admin/policy-versions/{id} | 


# **adminPolicyControllerCancel**
> PolicyVersionDtoOutput adminPolicyControllerCancel(id, policyCancelDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PolicyCancelDto policyCancelDto = ; // PolicyCancelDto | 

try {
    final response = api.adminPolicyControllerCancel(id, policyCancelDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **policyCancelDto** | [**PolicyCancelDto**](PolicyCancelDto.md)|  | 

### Return type

[**PolicyVersionDtoOutput**](PolicyVersionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerCancelFareBand**
> FareBandDtoOutput adminPolicyControllerCancelFareBand(id, policyCancelDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PolicyCancelDto policyCancelDto = ; // PolicyCancelDto | 

try {
    final response = api.adminPolicyControllerCancelFareBand(id, policyCancelDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerCancelFareBand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **policyCancelDto** | [**PolicyCancelDto**](PolicyCancelDto.md)|  | 

### Return type

[**FareBandDtoOutput**](FareBandDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerCreateDraft**
> PolicyVersionDtoOutput adminPolicyControllerCreateDraft(type, policyDraftCreateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String type = type_example; // String | 
final PolicyDraftCreateDto policyDraftCreateDto = ; // PolicyDraftCreateDto | 

try {
    final response = api.adminPolicyControllerCreateDraft(type, policyDraftCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerCreateDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **policyDraftCreateDto** | [**PolicyDraftCreateDto**](PolicyDraftCreateDto.md)|  | 

### Return type

[**PolicyVersionDtoOutput**](PolicyVersionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerCreateFareBand**
> FareBandDtoOutput adminPolicyControllerCreateFareBand(fareBandCreateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final FareBandCreateDto fareBandCreateDto = ; // FareBandCreateDto | 

try {
    final response = api.adminPolicyControllerCreateFareBand(fareBandCreateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerCreateFareBand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fareBandCreateDto** | [**FareBandCreateDto**](FareBandCreateDto.md)|  | 

### Return type

[**FareBandDtoOutput**](FareBandDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerGet**
> PolicyVersionDtoOutput adminPolicyControllerGet(id)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPolicyControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PolicyVersionDtoOutput**](PolicyVersionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerListFareBands**
> FareBandListDtoOutput adminPolicyControllerListFareBands()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();

try {
    final response = api.adminPolicyControllerListFareBands();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerListFareBands: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FareBandListDtoOutput**](FareBandListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerOverview**
> PolicyOverviewDtoOutput adminPolicyControllerOverview(type, operatorId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String type = type_example; // String | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPolicyControllerOverview(type, operatorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | 
 **operatorId** | **String**|  | [optional] 

### Return type

[**PolicyOverviewDtoOutput**](PolicyOverviewDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerPublish**
> PolicyVersionDtoOutput adminPolicyControllerPublish(id, policyPublishDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PolicyPublishDto policyPublishDto = ; // PolicyPublishDto | 

try {
    final response = api.adminPolicyControllerPublish(id, policyPublishDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerPublish: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **policyPublishDto** | [**PolicyPublishDto**](PolicyPublishDto.md)|  | 

### Return type

[**PolicyVersionDtoOutput**](PolicyVersionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPolicyControllerUpdateDraft**
> PolicyVersionDtoOutput adminPolicyControllerUpdateDraft(id, policyDraftUpdateDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAdminPoliciesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PolicyDraftUpdateDto policyDraftUpdateDto = ; // PolicyDraftUpdateDto | 

try {
    final response = api.adminPolicyControllerUpdateDraft(id, policyDraftUpdateDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPoliciesApi->adminPolicyControllerUpdateDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **policyDraftUpdateDto** | [**PolicyDraftUpdateDto**](PolicyDraftUpdateDto.md)|  | 

### Return type

[**PolicyVersionDtoOutput**](PolicyVersionDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

