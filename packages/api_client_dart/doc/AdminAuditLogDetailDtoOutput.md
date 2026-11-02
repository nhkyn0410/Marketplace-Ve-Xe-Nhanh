# api_client_dart.model.AdminAuditLogDetailDtoOutput

## Load the model package
```dart
import 'package:api_client_dart/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**actorId** | **String** |  | 
**actorName** | **String** |  | 
**actorRole** | **String** |  | 
**actorType** | **String** |  | 
**action** | **String** |  | 
**module** | **String** |  | 
**result** | **String** |  | 
**targetType** | **String** |  | 
**targetId** | **String** |  | 
**operator_** | [**AdminAuditLogListDtoOutputItemsInnerOperator**](AdminAuditLogListDtoOutputItemsInnerOperator.md) |  | 
**reason** | **String** |  | 
**before** | [**BuiltMap&lt;String, JsonObject?&gt;**](JsonObject.md) |  | 
**after** | [**BuiltMap&lt;String, JsonObject?&gt;**](JsonObject.md) |  | 
**ip** | **String** |  | 
**device** | **String** |  | 
**requestId** | **String** |  | 
**related** | [**BuiltList&lt;AdminAuditLogListDtoOutputItemsInner&gt;**](AdminAuditLogListDtoOutputItemsInner.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


