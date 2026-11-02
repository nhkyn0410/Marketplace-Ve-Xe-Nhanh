# api_client_dart.api.SupportApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**customerSupportControllerCreate**](SupportApi.md#customersupportcontrollercreate) | **POST** /v1/bookings/{bookingId}/support-tickets | 
[**customerSupportControllerDownload**](SupportApi.md#customersupportcontrollerdownload) | **POST** /v1/bookings/{bookingId}/support-attachments/{attachmentId}/download-url | 
[**customerSupportControllerGet**](SupportApi.md#customersupportcontrollerget) | **GET** /v1/bookings/{bookingId}/support-tickets/{ticketId} | 
[**customerSupportControllerList**](SupportApi.md#customersupportcontrollerlist) | **GET** /v1/bookings/{bookingId}/support-tickets | 
[**customerSupportControllerReply**](SupportApi.md#customersupportcontrollerreply) | **POST** /v1/bookings/{bookingId}/support-tickets/{ticketId}/messages | 
[**customerSupportControllerUpload**](SupportApi.md#customersupportcontrollerupload) | **POST** /v1/bookings/{bookingId}/support-attachments/upload-url | 


# **customerSupportControllerCreate**
> TicketDetailDtoOutput customerSupportControllerCreate(bookingId, customerTicketInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CustomerTicketInputDto customerTicketInputDto = ; // CustomerTicketInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerCreate(bookingId, customerTicketInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **customerTicketInputDto** | [**CustomerTicketInputDto**](CustomerTicketInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerSupportControllerDownload**
> DownloadUrlResponseDtoOutput customerSupportControllerDownload(bookingId, attachmentId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String attachmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerDownload(bookingId, attachmentId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerDownload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **attachmentId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**DownloadUrlResponseDtoOutput**](DownloadUrlResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerSupportControllerGet**
> TicketDetailDtoOutput customerSupportControllerGet(bookingId, ticketId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerGet(bookingId, ticketId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **ticketId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerSupportControllerList**
> CustomerTicketListDtoOutput customerSupportControllerList(bookingId, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerList(bookingId, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**CustomerTicketListDtoOutput**](CustomerTicketListDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerSupportControllerReply**
> TicketDetailDtoOutput customerSupportControllerReply(bookingId, ticketId, messageInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final MessageInputDto messageInputDto = ; // MessageInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerReply(bookingId, ticketId, messageInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerReply: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **ticketId** | **String**|  | 
 **messageInputDto** | [**MessageInputDto**](MessageInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**TicketDetailDtoOutput**](TicketDetailDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customerSupportControllerUpload**
> AttachmentUploadResponseDtoOutput customerSupportControllerUpload(bookingId, attachmentUploadInputDto, xBookingToken)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getSupportApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AttachmentUploadInputDto attachmentUploadInputDto = ; // AttachmentUploadInputDto | 
final String xBookingToken = xBookingToken_example; // String | Mã truy cập booking (khách vãng lai).

try {
    final response = api.customerSupportControllerUpload(bookingId, attachmentUploadInputDto, xBookingToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->customerSupportControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **attachmentUploadInputDto** | [**AttachmentUploadInputDto**](AttachmentUploadInputDto.md)|  | 
 **xBookingToken** | **String**| Mã truy cập booking (khách vãng lai). | [optional] 

### Return type

[**AttachmentUploadResponseDtoOutput**](AttachmentUploadResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

