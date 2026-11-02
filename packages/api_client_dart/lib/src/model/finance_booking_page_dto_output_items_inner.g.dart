// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_booking_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_WAITING_TRIP =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('WAITING_TRIP');
const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_ON_HOLD =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('ON_HOLD');
const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_ELIGIBLE =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('ELIGIBLE');
const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_IN_PAYOUT =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('IN_PAYOUT');
const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_PAID =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('PAID');
const FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnum_REFUNDED =
    const FinanceBookingPageDtoOutputItemsInnerStateEnum._('REFUNDED');

FinanceBookingPageDtoOutputItemsInnerStateEnum
    _$financeBookingPageDtoOutputItemsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'WAITING_TRIP':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_WAITING_TRIP;
    case 'ON_HOLD':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_ON_HOLD;
    case 'ELIGIBLE':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_ELIGIBLE;
    case 'IN_PAYOUT':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_IN_PAYOUT;
    case 'PAID':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_PAID;
    case 'REFUNDED':
      return _$financeBookingPageDtoOutputItemsInnerStateEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinanceBookingPageDtoOutputItemsInnerStateEnum>
    _$financeBookingPageDtoOutputItemsInnerStateEnumValues = BuiltSet<
        FinanceBookingPageDtoOutputItemsInnerStateEnum>(const <FinanceBookingPageDtoOutputItemsInnerStateEnum>[
  _$financeBookingPageDtoOutputItemsInnerStateEnum_WAITING_TRIP,
  _$financeBookingPageDtoOutputItemsInnerStateEnum_ON_HOLD,
  _$financeBookingPageDtoOutputItemsInnerStateEnum_ELIGIBLE,
  _$financeBookingPageDtoOutputItemsInnerStateEnum_IN_PAYOUT,
  _$financeBookingPageDtoOutputItemsInnerStateEnum_PAID,
  _$financeBookingPageDtoOutputItemsInnerStateEnum_REFUNDED,
]);

Serializer<FinanceBookingPageDtoOutputItemsInnerStateEnum>
    _$financeBookingPageDtoOutputItemsInnerStateEnumSerializer =
    _$FinanceBookingPageDtoOutputItemsInnerStateEnumSerializer();

class _$FinanceBookingPageDtoOutputItemsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<FinanceBookingPageDtoOutputItemsInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WAITING_TRIP': 'WAITING_TRIP',
    'ON_HOLD': 'ON_HOLD',
    'ELIGIBLE': 'ELIGIBLE',
    'IN_PAYOUT': 'IN_PAYOUT',
    'PAID': 'PAID',
    'REFUNDED': 'REFUNDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WAITING_TRIP': 'WAITING_TRIP',
    'ON_HOLD': 'ON_HOLD',
    'ELIGIBLE': 'ELIGIBLE',
    'IN_PAYOUT': 'IN_PAYOUT',
    'PAID': 'PAID',
    'REFUNDED': 'REFUNDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FinanceBookingPageDtoOutputItemsInnerStateEnum
  ];
  @override
  final String wireName = 'FinanceBookingPageDtoOutputItemsInnerStateEnum';

  @override
  Object serialize(Serializers serializers,
          FinanceBookingPageDtoOutputItemsInnerStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinanceBookingPageDtoOutputItemsInnerStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinanceBookingPageDtoOutputItemsInnerStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinanceBookingPageDtoOutputItemsInner
    extends FinanceBookingPageDtoOutputItemsInner {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final FinanceBookingPageDtoOutputItemsInnerTrip trip;
  @override
  final int grossAmount;
  @override
  final int commissionAmount;
  @override
  final int refundAdjustmentAmount;
  @override
  final int netAmount;
  @override
  final FinanceBookingPageDtoOutputItemsInnerStateEnum state;
  @override
  final DateTime eligibleAt;

  factory _$FinanceBookingPageDtoOutputItemsInner(
          [void Function(FinanceBookingPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (FinanceBookingPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$FinanceBookingPageDtoOutputItemsInner._(
      {required this.bookingId,
      required this.bookingCode,
      required this.trip,
      required this.grossAmount,
      required this.commissionAmount,
      required this.refundAdjustmentAmount,
      required this.netAmount,
      required this.state,
      required this.eligibleAt})
      : super._();
  @override
  FinanceBookingPageDtoOutputItemsInner rebuild(
          void Function(FinanceBookingPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceBookingPageDtoOutputItemsInnerBuilder toBuilder() =>
      FinanceBookingPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceBookingPageDtoOutputItemsInner &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        trip == other.trip &&
        grossAmount == other.grossAmount &&
        commissionAmount == other.commissionAmount &&
        refundAdjustmentAmount == other.refundAdjustmentAmount &&
        netAmount == other.netAmount &&
        state == other.state &&
        eligibleAt == other.eligibleAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, grossAmount.hashCode);
    _$hash = $jc(_$hash, commissionAmount.hashCode);
    _$hash = $jc(_$hash, refundAdjustmentAmount.hashCode);
    _$hash = $jc(_$hash, netAmount.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, eligibleAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'FinanceBookingPageDtoOutputItemsInner')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('trip', trip)
          ..add('grossAmount', grossAmount)
          ..add('commissionAmount', commissionAmount)
          ..add('refundAdjustmentAmount', refundAdjustmentAmount)
          ..add('netAmount', netAmount)
          ..add('state', state)
          ..add('eligibleAt', eligibleAt))
        .toString();
  }
}

class FinanceBookingPageDtoOutputItemsInnerBuilder
    implements
        Builder<FinanceBookingPageDtoOutputItemsInner,
            FinanceBookingPageDtoOutputItemsInnerBuilder> {
  _$FinanceBookingPageDtoOutputItemsInner? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  FinanceBookingPageDtoOutputItemsInnerTripBuilder? _trip;
  FinanceBookingPageDtoOutputItemsInnerTripBuilder get trip =>
      _$this._trip ??= FinanceBookingPageDtoOutputItemsInnerTripBuilder();
  set trip(FinanceBookingPageDtoOutputItemsInnerTripBuilder? trip) =>
      _$this._trip = trip;

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

  int? _netAmount;
  int? get netAmount => _$this._netAmount;
  set netAmount(int? netAmount) => _$this._netAmount = netAmount;

  FinanceBookingPageDtoOutputItemsInnerStateEnum? _state;
  FinanceBookingPageDtoOutputItemsInnerStateEnum? get state => _$this._state;
  set state(FinanceBookingPageDtoOutputItemsInnerStateEnum? state) =>
      _$this._state = state;

  DateTime? _eligibleAt;
  DateTime? get eligibleAt => _$this._eligibleAt;
  set eligibleAt(DateTime? eligibleAt) => _$this._eligibleAt = eligibleAt;

  FinanceBookingPageDtoOutputItemsInnerBuilder() {
    FinanceBookingPageDtoOutputItemsInner._defaults(this);
  }

  FinanceBookingPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _trip = $v.trip.toBuilder();
      _grossAmount = $v.grossAmount;
      _commissionAmount = $v.commissionAmount;
      _refundAdjustmentAmount = $v.refundAdjustmentAmount;
      _netAmount = $v.netAmount;
      _state = $v.state;
      _eligibleAt = $v.eligibleAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceBookingPageDtoOutputItemsInner other) {
    _$v = other as _$FinanceBookingPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(FinanceBookingPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceBookingPageDtoOutputItemsInner build() => _build();

  _$FinanceBookingPageDtoOutputItemsInner _build() {
    _$FinanceBookingPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$FinanceBookingPageDtoOutputItemsInner._(
            bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
                r'FinanceBookingPageDtoOutputItemsInner', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
                r'FinanceBookingPageDtoOutputItemsInner', 'bookingCode'),
            trip: trip.build(),
            grossAmount: BuiltValueNullFieldError.checkNotNull(grossAmount,
                r'FinanceBookingPageDtoOutputItemsInner', 'grossAmount'),
            commissionAmount: BuiltValueNullFieldError.checkNotNull(
                commissionAmount,
                r'FinanceBookingPageDtoOutputItemsInner',
                'commissionAmount'),
            refundAdjustmentAmount: BuiltValueNullFieldError.checkNotNull(
                refundAdjustmentAmount,
                r'FinanceBookingPageDtoOutputItemsInner',
                'refundAdjustmentAmount'),
            netAmount: BuiltValueNullFieldError.checkNotNull(netAmount,
                r'FinanceBookingPageDtoOutputItemsInner', 'netAmount'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'FinanceBookingPageDtoOutputItemsInner', 'state'),
            eligibleAt: BuiltValueNullFieldError.checkNotNull(eligibleAt,
                r'FinanceBookingPageDtoOutputItemsInner', 'eligibleAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trip';
        trip.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FinanceBookingPageDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
