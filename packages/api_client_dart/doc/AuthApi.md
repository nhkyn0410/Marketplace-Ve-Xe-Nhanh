# api_client_dart.api.AuthApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLogout**](AuthApi.md#authcontrollerlogout) | **POST** /v1/auth/logout | 
[**authControllerOauth**](AuthApi.md#authcontrolleroauth) | **POST** /v1/auth/oauth/{provider} | 
[**authControllerOauthSession**](AuthApi.md#authcontrolleroauthsession) | **POST** /v1/auth/oauth/session | 
[**authControllerOperatorLogin**](AuthApi.md#authcontrolleroperatorlogin) | **POST** /v1/auth/operator/login | 
[**authControllerPlatformLogin**](AuthApi.md#authcontrollerplatformlogin) | **POST** /v1/auth/platform/login | 
[**authControllerReauth**](AuthApi.md#authcontrollerreauth) | **POST** /v1/auth/re-auth | 
[**authControllerRefresh**](AuthApi.md#authcontrollerrefresh) | **POST** /v1/auth/refresh | 
[**authControllerRegister**](AuthApi.md#authcontrollerregister) | **POST** /v1/auth/register | 
[**authControllerRequestOtp**](AuthApi.md#authcontrollerrequestotp) | **POST** /v1/auth/otp/request | 
[**authControllerVerifyOtp**](AuthApi.md#authcontrollerverifyotp) | **POST** /v1/auth/otp/verify | 


# **authControllerLogout**
> MessageResponseDtoOutput authControllerLogout()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();

try {
    final response = api.authControllerLogout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MessageResponseDtoOutput**](MessageResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerOauth**
> OAuthRedirectResponseDtoOutput authControllerOauth(provider, oAuthInitDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final String provider = provider_example; // String | OAuth provider (v1: google).
final OAuthInitDto oAuthInitDto = ; // OAuthInitDto | 

try {
    final response = api.authControllerOauth(provider, oAuthInitDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerOauth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider** | **String**| OAuth provider (v1: google). | 
 **oAuthInitDto** | [**OAuthInitDto**](OAuthInitDto.md)|  | 

### Return type

[**OAuthRedirectResponseDtoOutput**](OAuthRedirectResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerOauthSession**
> AuthTokenResponseDtoOutput authControllerOauthSession()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();

try {
    final response = api.authControllerOauthSession();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerOauthSession: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthTokenResponseDtoOutput**](AuthTokenResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerOperatorLogin**
> AuthTokenResponseDtoOutput authControllerOperatorLogin(credentialLoginDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final CredentialLoginDto credentialLoginDto = ; // CredentialLoginDto | 

try {
    final response = api.authControllerOperatorLogin(credentialLoginDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerOperatorLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **credentialLoginDto** | [**CredentialLoginDto**](CredentialLoginDto.md)|  | 

### Return type

[**AuthTokenResponseDtoOutput**](AuthTokenResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerPlatformLogin**
> AuthTokenResponseDtoOutput authControllerPlatformLogin(credentialLoginDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final CredentialLoginDto credentialLoginDto = ; // CredentialLoginDto | 

try {
    final response = api.authControllerPlatformLogin(credentialLoginDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerPlatformLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **credentialLoginDto** | [**CredentialLoginDto**](CredentialLoginDto.md)|  | 

### Return type

[**AuthTokenResponseDtoOutput**](AuthTokenResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerReauth**
> MessageResponseDtoOutput authControllerReauth(reauthDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final ReauthDto reauthDto = ; // ReauthDto | 

try {
    final response = api.authControllerReauth(reauthDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerReauth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reauthDto** | [**ReauthDto**](ReauthDto.md)|  | 

### Return type

[**MessageResponseDtoOutput**](MessageResponseDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefresh**
> AuthTokenResponseDtoOutput authControllerRefresh(refreshTokenDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final RefreshTokenDto refreshTokenDto = ; // RefreshTokenDto | 

try {
    final response = api.authControllerRefresh(refreshTokenDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenDto** | [**RefreshTokenDto**](RefreshTokenDto.md)|  | 

### Return type

[**AuthTokenResponseDtoOutput**](AuthTokenResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegister**
> MessageResponseDtoOutput authControllerRegister(registerDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final RegisterDto registerDto = ; // RegisterDto | 

try {
    final response = api.authControllerRegister(registerDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDto** | [**RegisterDto**](RegisterDto.md)|  | 

### Return type

[**MessageResponseDtoOutput**](MessageResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRequestOtp**
> MessageResponseDtoOutput authControllerRequestOtp(otpRequestDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final OtpRequestDto otpRequestDto = ; // OtpRequestDto | 

try {
    final response = api.authControllerRequestOtp(otpRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerRequestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpRequestDto** | [**OtpRequestDto**](OtpRequestDto.md)|  | 

### Return type

[**MessageResponseDtoOutput**](MessageResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerVerifyOtp**
> AuthTokenResponseDtoOutput authControllerVerifyOtp(otpVerifyDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getAuthApi();
final OtpVerifyDto otpVerifyDto = ; // OtpVerifyDto | 

try {
    final response = api.authControllerVerifyOtp(otpVerifyDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerVerifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpVerifyDto** | [**OtpVerifyDto**](OtpVerifyDto.md)|  | 

### Return type

[**AuthTokenResponseDtoOutput**](AuthTokenResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

