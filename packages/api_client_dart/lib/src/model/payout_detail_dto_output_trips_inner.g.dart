// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_detail_dto_output_trips_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutDetailDtoOutputTripsInner
    extends PayoutDetailDtoOutputTripsInner {
  @override
  final String? tripId;
  @override
  final DateTime? departureAt;
  @override
  final String? routeName;
  @override
  final String? vehiclePlateNumber;
  @override
  final int bookingCount;
  @override
  final int grossAmount;
  @override
  final int commissionAmount;
  @override
  final int refundAdjustmentAmount;
  @override
  final int amount;

  factory _$PayoutDetailDtoOutputTripsInner(
          [void Function(PayoutDetailDtoOutputTripsInnerBuilder)? updates]) =>
      (PayoutDetailDtoOutputTripsInnerBuilder()..update(updates))._build();

  _$PayoutDetailDtoOutputTripsInner._(
      {this.tripId,
      this.departureAt,
      this.routeName,
      this.vehiclePlateNumber,
      required this.bookingCount,
      required this.grossAmount,
      required this.commissionAmount,
      required this.refundAdjustmentAmount,
      required this.amount})
      : super._();
  @override
  PayoutDetailDtoOutputTripsInner rebuild(
          void Function(PayoutDetailDtoOutputTripsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutDetailDtoOutputTripsInnerBuilder toBuilder() =>
      PayoutDetailDtoOutputTripsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutDetailDtoOutputTripsInner &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        routeName == other.routeName &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        bookingCount == other.bookingCount &&
        grossAmount == other.grossAmount &&
        commissionAmount == other.commissionAmount &&
        refundAdjustmentAmount == other.refundAdjustmentAmount &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, bookingCount.hashCode);
    _$hash = $jc(_$hash, grossAmount.hashCode);
    _$hash = $jc(_$hash, commissionAmount.hashCode);
    _$hash = $jc(_$hash, refundAdjustmentAmount.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutDetailDtoOutputTripsInner')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('routeName', routeName)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('bookingCount', bookingCount)
          ..add('grossAmount', grossAmount)
          ..add('commissionAmount', commissionAmount)
          ..add('refundAdjustmentAmount', refundAdjustmentAmount)
          ..add('amount', amount))
        .toString();
  }
}

class PayoutDetailDtoOutputTripsInnerBuilder
    implements
        Builder<PayoutDetailDtoOutputTripsInner,
            PayoutDetailDtoOutputTripsInnerBuilder> {
  _$PayoutDetailDtoOutputTripsInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  int? _bookingCount;
  int? get bookingCount => _$this._bookingCount;
  set bookingCount(int? bookingCount) => _$this._bookingCount = bookingCount;

  int? _grossAmount;
  int? get grossAmount => _$this._grossAmount;
  set grossAmount(int? grossAmount) => _$this._grossAmount = grossAmount;

  int? _commissionAmount;
  int? get commissionAmount => _$this._commissionAmount;
  set commissionAmount(int? commissionAmount) =>
      _$this._commissionAmount = commissionAmount;

  int? _refundAdjustmentAmount;
  int? get refundAdjustmentAmount => _$this._refundAdjustmentAmount;
  set refundAdjustmentAmount(int? refundAdjustmentAmount) =>
      _$this._refundAdjustmentAmount = refundAdjustmentAmount;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  PayoutDetailDtoOutputTripsInnerBuilder() {
    PayoutDetailDtoOutputTripsInner._defaults(this);
  }

  PayoutDetailDtoOutputTripsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _routeName = $v.routeName;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _bookingCount = $v.bookingCount;
      _grossAmount = $v.grossAmount;
      _commissionAmount = $v.commissionAmount;
      _refundAdjustmentAmount = $v.refundAdjustmentAmount;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutDetailDtoOutputTripsInner other) {
    _$v = other as _$PayoutDetailDtoOutputTripsInner;
  }

  @override
  void update(void Function(PayoutDetailDtoOutputTripsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutDetailDtoOutputTripsInner build() => _build();

  _$PayoutDetailDtoOutputTripsInner _build() {
    final _$result = _$v ??
        _$PayoutDetailDtoOutputTripsInner._(
          tripId: tripId,
          departureAt: departureAt,
          routeName: routeName,
          vehiclePlateNumber: vehiclePlateNumber,
          bookingCount: BuiltValueNullFieldError.checkNotNull(
              bookingCount, r'PayoutDetailDtoOutputTripsInner', 'bookingCount'),
          grossAmount: BuiltValueNullFieldError.checkNotNull(
              grossAmount, r'PayoutDetailDtoOutputTripsInner', 'grossAmount'),
          commissionAmount: BuiltValueNullFieldError.checkNotNull(
              commissionAmount,
              r'PayoutDetailDtoOutputTripsInner',
              'commissionAmount'),
          refundAdjustmentAmount: BuiltValueNullFieldError.checkNotNull(
              refundAdjustmentAmount,
              r'PayoutDetailDtoOutputTripsInner',
              'refundAdjustmentAmount'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PayoutDetailDtoOutputTripsInner', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
