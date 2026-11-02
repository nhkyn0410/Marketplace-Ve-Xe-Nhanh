# api_client_dart.model.BookingResponseDtoOutput

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
**tripId** | **String** |  | 
**trip** | [**CreatedBookingDtoOutputTrip**](CreatedBookingDtoOutputTrip.md) |  | 
**pickup** | [**TripSearchResponseDtoOutputItemsInnerPickup**](TripSearchResponseDtoOutputItemsInnerPickup.md) |  | 
**dropoff** | [**TripSearchResponseDtoOutputItemsInnerPickup**](TripSearchResponseDtoOutputItemsInnerPickup.md) |  | 
**contact** | [**CreatedBookingDtoOutputContact**](CreatedBookingDtoOutputContact.md) |  | 
**passengers** | [**BuiltList&lt;CreatedBookingDtoOutputPassengersInner&gt;**](CreatedBookingDtoOutputPassengersInner.md) |  | 
**note** | **String** |  | 
**subtotal** | **int** |  | 
**serviceFee** | **int** |  | 
**discount** | **int** |  | 
**discountFunding** | **String** |  | 
**total** | **int** |  | 
**cancellationPolicy** | [**PublicTripDtoOutputCancellationPolicy**](PublicTripDtoOutputCancellationPolicy.md) |  | 
**expiresAt** | [**DateTime**](DateTime.md) |  | 
**payment** | [**CreatedBookingDtoOutputPayment**](CreatedBookingDtoOutputPayment.md) |  | 
**tickets** | [**BuiltList&lt;CreatedBookingDtoOutputTicketsInner&gt;**](CreatedBookingDtoOutputTicketsInner.md) |  | 
**refunds** | [**BuiltList&lt;CreatedBookingDtoOutputRefundsInner&gt;**](CreatedBookingDtoOutputRefundsInner.md) |  | 
**tripChanges** | [**BuiltList&lt;CreatedBookingDtoOutputTripChangesInner&gt;**](CreatedBookingDtoOutputTripChangesInner.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


