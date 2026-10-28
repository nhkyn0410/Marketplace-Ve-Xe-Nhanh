# api_client_dart.api.CounterSalesApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**counterSalesControllerCollect**](CounterSalesApi.md#countersalescontrollercollect) | **POST** /v1/operator/counter/bookings/{bookingId}/receipts | 
[**counterSalesControllerCreate**](CounterSalesApi.md#countersalescontrollercreate) | **POST** /v1/operator/counter/bookings | 
[**counterSalesControllerGet**](CounterSalesApi.md#countersalescontrollerget) | **GET** /v1/operator/counter/bookings/{bookingId} | 
[**counterSalesControllerGetHold**](CounterSalesApi.md#countersalescontrollergethold) | **GET** /v1/operator/counter/holds/{holdId} | 
[**counterSalesControllerHold**](CounterSalesApi.md#countersalescontrollerhold) | **POST** /v1/operator/counter/holds | 
[**counterSalesControllerList**](CounterSalesApi.md#countersalescontrollerlist) | **GET** /v1/operator/counter/bookings | 
[**counterSalesControllerRelease**](CounterSalesApi.md#countersalescontrollerrelease) | **DELETE** /v1/operator/counter/holds/{holdId} | 
[**counterSalesControllerReport**](CounterSalesApi.md#countersalescontrollerreport) | **GET** /v1/operator/counter/report | 
[**counterSalesControllerTrips**](CounterSalesApi.md#countersalescontrollertrips) | **GET** /v1/operator/counter/trips | 


# **counterSalesControllerCollect**
> CounterReceiptResultDtoOutput counterSalesControllerCollect(bookingId, counterReceiptInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CounterReceiptInputDto counterReceiptInputDto = ; // CounterReceiptInputDto | 

try {
    final response = api.counterSalesControllerCollect(bookingId, counterReceiptInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerCollect: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **counterReceiptInputDto** | [**CounterReceiptInputDto**](CounterReceiptInputDto.md)|  | 

### Return type

[**CounterReceiptResultDtoOutput**](CounterReceiptResultDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerCreate**
> CounterBookingDtoOutput counterSalesControllerCreate(counterBookingInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final CounterBookingInputDto counterBookingInputDto = ; // CounterBookingInputDto | 

try {
    final response = api.counterSalesControllerCreate(counterBookingInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **counterBookingInputDto** | [**CounterBookingInputDto**](CounterBookingInputDto.md)|  | 

### Return type

[**CounterBookingDtoOutput**](CounterBookingDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerGet**
> CounterBookingDtoOutput counterSalesControllerGet(bookingId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.counterSalesControllerGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**CounterBookingDtoOutput**](CounterBookingDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerGetHold**
> CounterHoldDtoOutput counterSalesControllerGetHold(holdId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String holdId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.counterSalesControllerGetHold(holdId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerGetHold: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **holdId** | **String**|  | 

### Return type

[**CounterHoldDtoOutput**](CounterHoldDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerHold**
> CounterHoldDtoOutput counterSalesControllerHold(counterHoldInputDto)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final CounterHoldInputDto counterHoldInputDto = ; // CounterHoldInputDto | 

try {
    final response = api.counterSalesControllerHold(counterHoldInputDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerHold: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **counterHoldInputDto** | [**CounterHoldInputDto**](CounterHoldInputDto.md)|  | 

### Return type

[**CounterHoldDtoOutput**](CounterHoldDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerList**
> CounterBookingListDtoOutput counterSalesControllerList(officeId, cursor, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num limit = 8.14; // num | 

try {
    final response = api.counterSalesControllerList(officeId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **num**|  | [optional] [default to 50]

### Return type

[**CounterBookingListDtoOutput**](CounterBookingListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerRelease**
> counterSalesControllerRelease(holdId)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String holdId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.counterSalesControllerRelease(holdId);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **holdId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerReport**
> CounterReportDtoOutput counterSalesControllerReport(officeId, date)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date date = 2013-10-20; // Date | 

try {
    final response = api.counterSalesControllerReport(officeId, date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 
 **date** | **Date**|  | 

### Return type

[**CounterReportDtoOutput**](CounterReportDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **counterSalesControllerTrips**
> CounterTripListDtoOutput counterSalesControllerTrips(officeId, date)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getCounterSalesApi();
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date date = 2013-10-20; // Date | 

try {
    final response = api.counterSalesControllerTrips(officeId, date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CounterSalesApi->counterSalesControllerTrips: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **officeId** | **String**|  | 
 **date** | **Date**|  | 

### Return type

[**CounterTripListDtoOutput**](CounterTripListDtoOutput.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

