# api_client_dart.api.TripsApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publicTripControllerGet**](TripsApi.md#publictripcontrollerget) | **GET** /v1/trips/{tripId} | 
[**publicTripControllerSearch**](TripsApi.md#publictripcontrollersearch) | **GET** /v1/trips/search | 


# **publicTripControllerGet**
> PublicTripDtoOutput publicTripControllerGet(tripId, pickupSequence, dropoffSequence)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTripsApi();
final String tripId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final num pickupSequence = 8.14; // num | 
final num dropoffSequence = 8.14; // num | 

try {
    final response = api.publicTripControllerGet(tripId, pickupSequence, dropoffSequence);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TripsApi->publicTripControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tripId** | **String**|  | 
 **pickupSequence** | **num**|  | [optional] 
 **dropoffSequence** | **num**|  | [optional] 

### Return type

[**PublicTripDtoOutput**](PublicTripDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicTripControllerSearch**
> TripSearchResponseDtoOutput publicTripControllerSearch(fromProvinceId, fromWardId, fromAreaId, fromStopPointId, toProvinceId, toWardId, toAreaId, toStopPointId, date, passengers, operatorId, vehicleForm, vehicleClass, departureFrom, departureTo, priceMin, priceMax, amenityIds, sort, page, limit)



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getTripsApi();
final String fromProvinceId = fromProvinceId_example; // String | 
final String fromWardId = fromWardId_example; // String | 
final String fromAreaId = fromAreaId_example; // String | 
final String fromStopPointId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String toProvinceId = toProvinceId_example; // String | 
final String toWardId = toWardId_example; // String | 
final String toAreaId = toAreaId_example; // String | 
final String toStopPointId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final Date date = 2013-10-20; // Date | 
final int passengers = 56; // int | 
final String operatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String vehicleForm = vehicleForm_example; // String | 
final String vehicleClass = vehicleClass_example; // String | 
final String departureFrom = departureFrom_example; // String | 
final String departureTo = departureTo_example; // String | 
final int priceMin = 56; // int | 
final int priceMax = 56; // int | 
final String amenityIds = amenityIds_example; // String | 
final String sort = sort_example; // String | 
final int page = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.publicTripControllerSearch(fromProvinceId, fromWardId, fromAreaId, fromStopPointId, toProvinceId, toWardId, toAreaId, toStopPointId, date, passengers, operatorId, vehicleForm, vehicleClass, departureFrom, departureTo, priceMin, priceMax, amenityIds, sort, page, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TripsApi->publicTripControllerSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromProvinceId** | **String**|  | [optional] 
 **fromWardId** | **String**|  | [optional] 
 **fromAreaId** | **String**|  | [optional] 
 **fromStopPointId** | **String**|  | [optional] 
 **toProvinceId** | **String**|  | [optional] 
 **toWardId** | **String**|  | [optional] 
 **toAreaId** | **String**|  | [optional] 
 **toStopPointId** | **String**|  | [optional] 
 **date** | **Date**|  | [optional] 
 **passengers** | **int**|  | [optional] [default to 1]
 **operatorId** | **String**|  | [optional] 
 **vehicleForm** | **String**|  | [optional] 
 **vehicleClass** | **String**|  | [optional] 
 **departureFrom** | **String**|  | [optional] 
 **departureTo** | **String**|  | [optional] 
 **priceMin** | **int**|  | [optional] 
 **priceMax** | **int**|  | [optional] 
 **amenityIds** | **String**|  | [optional] 
 **sort** | **String**|  | [optional] [default to 'departure']
 **page** | **int**|  | [optional] [default to 1]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**TripSearchResponseDtoOutput**](TripSearchResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

