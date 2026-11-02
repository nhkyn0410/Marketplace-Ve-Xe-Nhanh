# api_client_dart.model.PayoutDetailDtoOutput

## Load the model package
```dart
import 'package:api_client_dart/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**payoutId** | **String** |  | 
**payoutCode** | **String** |  | 
**operatorId** | **String** |  | 
**operatorName** | **String** |  | 
**period** | [**Date**](Date.md) |  | 
**status** | **String** |  | 
**grossAmount** | **int** |  | 
**commissionAmount** | **int** |  | 
**refundAmount** | **int** |  | 
**adjustmentAmount** | **int** |  | 
**amount** | **int** |  | 
**commissionRateBps** | **int** |  | 
**holdReason** | **String** |  | 
**bank** | [**PayoutPageDtoOutputItemsInnerBank**](PayoutPageDtoOutputItemsInnerBank.md) |  | 
**paidAt** | [**DateTime**](DateTime.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**trips** | [**BuiltList&lt;PayoutDetailDtoOutputTripsInner&gt;**](PayoutDetailDtoOutputTripsInner.md) |  | 
**checks** | [**PayoutDetailDtoOutputChecks**](PayoutDetailDtoOutputChecks.md) |  | 
**bankReference** | **String** |  | 
**transferredAt** | [**DateTime**](DateTime.md) |  | 
**confirmationNote** | **String** |  | 
**cancelReason** | **String** |  | 
**histories** | [**BuiltList&lt;PayoutDetailDtoOutputHistoriesInner&gt;**](PayoutDetailDtoOutputHistoriesInner.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


