# api_client_dart.model.OperatorBookingDetailDtoOutput

## Load the model package
```dart
import 'package:api_client_dart/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**bookingId** | **String** |  | 
**bookingCode** | **String** |  | 
**status** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**contactName** | **String** |  | 
**contactPhoneMasked** | **String** |  | 
**guest** | **bool** |  | 
**trip** | [**OperatorBookingPageDtoOutputItemsInnerTrip**](OperatorBookingPageDtoOutputItemsInnerTrip.md) |  | 
**seatCodes** | **BuiltList&lt;String&gt;** |  | 
**cancelledTicketCount** | **int** |  | 
**total** | **int** |  | 
**payment** | [**OperatorBookingPageDtoOutputItemsInnerPayment**](OperatorBookingPageDtoOutputItemsInnerPayment.md) |  | 
**contactEmailMasked** | **String** |  | 
**note** | **String** |  | 
**pickup** | [**TripSearchResponseDtoOutputItemsInnerPickup**](TripSearchResponseDtoOutputItemsInnerPickup.md) |  | 
**dropoff** | [**TripSearchResponseDtoOutputItemsInnerPickup**](TripSearchResponseDtoOutputItemsInnerPickup.md) |  | 
**seats** | [**BuiltList&lt;OperatorBookingDetailDtoOutputSeatsInner&gt;**](OperatorBookingDetailDtoOutputSeatsInner.md) |  | 
**subtotal** | **int** |  | 
**serviceFee** | **int** |  | 
**discount** | **int** |  | 
**discountFunding** | **String** |  | 
**cancellationPolicy** | [**PublicTripDtoOutputCancellationPolicy**](PublicTripDtoOutputCancellationPolicy.md) |  | 
**histories** | [**BuiltList&lt;OperatorBookingDetailDtoOutputHistoriesInner&gt;**](OperatorBookingDetailDtoOutputHistoriesInner.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


