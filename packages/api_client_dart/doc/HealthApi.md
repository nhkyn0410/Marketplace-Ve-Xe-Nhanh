# api_client_dart.api.HealthApi

## Load the API package
```dart
import 'package:api_client_dart/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appControllerHealth**](HealthApi.md#appcontrollerhealth) | **GET** /v1/health | 
[**appControllerMongo**](HealthApi.md#appcontrollermongo) | **GET** /v1/health/mongo | 
[**appControllerPostgres**](HealthApi.md#appcontrollerpostgres) | **GET** /v1/health/postgres | 
[**appControllerQueues**](HealthApi.md#appcontrollerqueues) | **GET** /v1/health/queues | 
[**appControllerRedis**](HealthApi.md#appcontrollerredis) | **GET** /v1/health/redis | 


# **appControllerHealth**
> HealthResponseDtoOutput appControllerHealth()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getHealthApi();

try {
    final response = api.appControllerHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->appControllerHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthResponseDtoOutput**](HealthResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appControllerMongo**
> MongoHealthResponseDtoOutput appControllerMongo()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getHealthApi();

try {
    final response = api.appControllerMongo();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->appControllerMongo: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MongoHealthResponseDtoOutput**](MongoHealthResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appControllerPostgres**
> PostgresHealthResponseDtoOutput appControllerPostgres()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getHealthApi();

try {
    final response = api.appControllerPostgres();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->appControllerPostgres: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PostgresHealthResponseDtoOutput**](PostgresHealthResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appControllerQueues**
> QueueHealthResponseDtoOutput appControllerQueues()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getHealthApi();

try {
    final response = api.appControllerQueues();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->appControllerQueues: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**QueueHealthResponseDtoOutput**](QueueHealthResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appControllerRedis**
> RedisHealthResponseDtoOutput appControllerRedis()



### Example
```dart
import 'package:api_client_dart/api.dart';

final api = ApiClientDart().getHealthApi();

try {
    final response = api.appControllerRedis();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->appControllerRedis: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RedisHealthResponseDtoOutput**](RedisHealthResponseDtoOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

