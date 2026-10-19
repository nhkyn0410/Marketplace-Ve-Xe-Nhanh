# api_client_dart.model.DisputeDetailDtoOutput

## Load the model package
```dart
import 'package:api_client_dart/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**disputeId** | **String** |  | 
**disputeCode** | **String** |  | 
**title** | **String** |  | 
**bookingId** | **String** |  | 
**bookingCode** | **String** |  | 
**operatorId** | **String** |  | 
**operatorName** | **String** |  | 
**paidAmount** | **int** |  | 
**status** | **String** |  | 
**responseDueAt** | [**DateTime**](DateTime.md) |  | 
**overdue** | **bool** |  | 
**assignee** | [**CustomerTicketListDtoOutputItemsInnerAssignee**](CustomerTicketListDtoOutputItemsInnerAssignee.md) |  | 
**supportTicketId** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**updatedAt** | [**DateTime**](DateTime.md) |  | 
**customerRequest** | **String** |  | 
**supportTicketCode** | **String** |  | 
**bookingTotal** | **int** |  | 
**refundableAmount** | **int** |  | 
**customerName** | **String** |  | 
**trip** | [**DisputeDetailDtoOutputTrip**](DisputeDetailDtoOutputTrip.md) |  | 
**firstCheckInAt** | [**DateTime**](DateTime.md) |  | 
**tripChangeNotified** | **bool** |  | 
**cancellationTiers** | [**BuiltList&lt;DisputeDetailDtoOutputCancellationTiersInner&gt;**](DisputeDetailDtoOutputCancellationTiersInner.md) |  | 
**events** | [**BuiltList&lt;DisputeDetailDtoOutputEventsInner&gt;**](DisputeDetailDtoOutputEventsInner.md) |  | 
**decision** | [**DisputeDetailDtoOutputDecision**](DisputeDetailDtoOutputDecision.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


