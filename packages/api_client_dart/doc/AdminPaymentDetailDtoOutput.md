# api_client_dart.model.AdminPaymentDetailDtoOutput

## Load the model package
```dart
import 'package:api_client_dart/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**paymentId** | **String** |  | 
**paymentCode** | **String** |  | 
**bookingId** | **String** |  | 
**bookingCode** | **String** |  | 
**operatorId** | **String** |  | 
**operatorName** | **String** |  | 
**provider** | **String** |  | 
**amount** | **int** |  | 
**status** | **String** |  | 
**reconcileReason** | **String** |  | 
**failureCode** | **String** |  | 
**reconcileResolved** | **bool** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**paidAt** | [**DateTime**](DateTime.md) |  | 
**providerTxnId** | **String** |  | 
**expiresAt** | [**DateTime**](DateTime.md) |  | 
**lastCallbackAt** | [**DateTime**](DateTime.md) |  | 
**amountMatches** | **bool** |  | 
**booking** | [**AdminPaymentDetailDtoOutputBooking**](AdminPaymentDetailDtoOutputBooking.md) |  | 
**allocation** | [**AdminPaymentDetailDtoOutputAllocation**](AdminPaymentDetailDtoOutputAllocation.md) |  | 
**histories** | [**BuiltList&lt;AdminPaymentDetailDtoOutputHistoriesInner&gt;**](AdminPaymentDetailDtoOutputHistoriesInner.md) |  | 
**tickets** | [**BuiltList&lt;AdminPaymentDetailDtoOutputTicketsInner&gt;**](AdminPaymentDetailDtoOutputTicketsInner.md) |  | 
**ledger** | [**BuiltList&lt;AdminPaymentDetailDtoOutputLedgerInner&gt;**](AdminPaymentDetailDtoOutputLedgerInner.md) |  | 
**refunds** | [**BuiltList&lt;AdminPaymentDetailDtoOutputRefundsInner&gt;**](AdminPaymentDetailDtoOutputRefundsInner.md) |  | 
**canRefund** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


