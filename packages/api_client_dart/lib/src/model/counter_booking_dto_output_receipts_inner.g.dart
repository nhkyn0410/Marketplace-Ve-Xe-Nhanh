// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_dto_output_receipts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterBookingDtoOutputReceiptsInnerMethodEnum
    _$counterBookingDtoOutputReceiptsInnerMethodEnum_CASH =
    const CounterBookingDtoOutputReceiptsInnerMethodEnum._('CASH');
const CounterBookingDtoOutputReceiptsInnerMethodEnum
    _$counterBookingDtoOutputReceiptsInnerMethodEnum_BANK_TRANSFER =
    const CounterBookingDtoOutputReceiptsInnerMethodEnum._('BANK_TRANSFER');

CounterBookingDtoOutputReceiptsInnerMethodEnum
    _$counterBookingDtoOutputReceiptsInnerMethodEnumValueOf(String name) {
  switch (name) {
    case 'CASH':
      return _$counterBookingDtoOutputReceiptsInnerMethodEnum_CASH;
    case 'BANK_TRANSFER':
      return _$counterBookingDtoOutputReceiptsInnerMethodEnum_BANK_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterBookingDtoOutputReceiptsInnerMethodEnum>
    _$counterBookingDtoOutputReceiptsInnerMethodEnumValues = BuiltSet<
        CounterBookingDtoOutputReceiptsInnerMethodEnum>(const <CounterBookingDtoOutputReceiptsInnerMethodEnum>[
  _$counterBookingDtoOutputReceiptsInnerMethodEnum_CASH,
  _$counterBookingDtoOutputReceiptsInnerMethodEnum_BANK_TRANSFER,
]);

const CounterBookingDtoOutputReceiptsInnerStatusEnum
    _$counterBookingDtoOutputReceiptsInnerStatusEnum_COMPLETED =
    const CounterBookingDtoOutputReceiptsInnerStatusEnum._('COMPLETED');
const CounterBookingDtoOutputReceiptsInnerStatusEnum
    _$counterBookingDtoOutputReceiptsInnerStatusEnum_EXCEPTION =
    const CounterBookingDtoOutputReceiptsInnerStatusEnum._('EXCEPTION');

CounterBookingDtoOutputReceiptsInnerStatusEnum
    _$counterBookingDtoOutputReceiptsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'COMPLETED':
      return _$counterBookingDtoOutputReceiptsInnerStatusEnum_COMPLETED;
    case 'EXCEPTION':
      return _$counterBookingDtoOutputReceiptsInnerStatusEnum_EXCEPTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterBookingDtoOutputReceiptsInnerStatusEnum>
    _$counterBookingDtoOutputReceiptsInnerStatusEnumValues = BuiltSet<
        CounterBookingDtoOutputReceiptsInnerStatusEnum>(const <CounterBookingDtoOutputReceiptsInnerStatusEnum>[
  _$counterBookingDtoOutputReceiptsInnerStatusEnum_COMPLETED,
  _$counterBookingDtoOutputReceiptsInnerStatusEnum_EXCEPTION,
]);

Serializer<CounterBookingDtoOutputReceiptsInnerMethodEnum>
    _$counterBookingDtoOutputReceiptsInnerMethodEnumSerializer =
    _$CounterBookingDtoOutputReceiptsInnerMethodEnumSerializer();
Serializer<CounterBookingDtoOutputReceiptsInnerStatusEnum>
    _$counterBookingDtoOutputReceiptsInnerStatusEnumSerializer =
    _$CounterBookingDtoOutputReceiptsInnerStatusEnumSerializer();

class _$CounterBookingDtoOutputReceiptsInnerMethodEnumSerializer
    implements
        PrimitiveSerializer<CounterBookingDtoOutputReceiptsInnerMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CASH': 'CASH',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CASH': 'CASH',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CounterBookingDtoOutputReceiptsInnerMethodEnum
  ];
  @override
  final String wireName = 'CounterBookingDtoOutputReceiptsInnerMethodEnum';

  @override
  Object serialize(Serializers serializers,
          CounterBookingDtoOutputReceiptsInnerMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterBookingDtoOutputReceiptsInnerMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterBookingDtoOutputReceiptsInnerMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterBookingDtoOutputReceiptsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<CounterBookingDtoOutputReceiptsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETED': 'COMPLETED',
    'EXCEPTION': 'EXCEPTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETED': 'COMPLETED',
    'EXCEPTION': 'EXCEPTION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CounterBookingDtoOutputReceiptsInnerStatusEnum
  ];
  @override
  final String wireName = 'CounterBookingDtoOutputReceiptsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CounterBookingDtoOutputReceiptsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterBookingDtoOutputReceiptsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterBookingDtoOutputReceiptsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterBookingDtoOutputReceiptsInner
    extends CounterBookingDtoOutputReceiptsInner {
  @override
  final String id;
  @override
  final CounterBookingDtoOutputReceiptsInnerMethodEnum method;
  @override
  final String amount;
  @override
  final String? reference;
  @override
  final CounterBookingDtoOutputReceiptsInnerStatusEnum status;
  @override
  final String? exceptionReason;
  @override
  final DateTime createdAt;

  factory _$CounterBookingDtoOutputReceiptsInner(
          [void Function(CounterBookingDtoOutputReceiptsInnerBuilder)?
              updates]) =>
      (CounterBookingDtoOutputReceiptsInnerBuilder()..update(updates))._build();

  _$CounterBookingDtoOutputReceiptsInner._(
      {required this.id,
      required this.method,
      required this.amount,
      this.reference,
      required this.status,
      this.exceptionReason,
      required this.createdAt})
      : super._();
  @override
  CounterBookingDtoOutputReceiptsInner rebuild(
          void Function(CounterBookingDtoOutputReceiptsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingDtoOutputReceiptsInnerBuilder toBuilder() =>
      CounterBookingDtoOutputReceiptsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingDtoOutputReceiptsInner &&
        id == other.id &&
        method == other.method &&
        amount == other.amount &&
        reference == other.reference &&
        status == other.status &&
        exceptionReason == other.exceptionReason &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, exceptionReason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterBookingDtoOutputReceiptsInner')
          ..add('id', id)
          ..add('method', method)
          ..add('amount', amount)
          ..add('reference', reference)
          ..add('status', status)
          ..add('exceptionReason', exceptionReason)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CounterBookingDtoOutputReceiptsInnerBuilder
    implements
        Builder<CounterBookingDtoOutputReceiptsInner,
            CounterBookingDtoOutputReceiptsInnerBuilder> {
  _$CounterBookingDtoOutputReceiptsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CounterBookingDtoOutputReceiptsInnerMethodEnum? _method;
  CounterBookingDtoOutputReceiptsInnerMethodEnum? get method => _$this._method;
  set method(CounterBookingDtoOutputReceiptsInnerMethodEnum? method) =>
      _$this._method = method;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  CounterBookingDtoOutputReceiptsInnerStatusEnum? _status;
  CounterBookingDtoOutputReceiptsInnerStatusEnum? get status => _$this._status;
  set status(CounterBookingDtoOutputReceiptsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _exceptionReason;
  String? get exceptionReason => _$this._exceptionReason;
  set exceptionReason(String? exceptionReason) =>
      _$this._exceptionReason = exceptionReason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CounterBookingDtoOutputReceiptsInnerBuilder() {
    CounterBookingDtoOutputReceiptsInner._defaults(this);
  }

  CounterBookingDtoOutputReceiptsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _method = $v.method;
      _amount = $v.amount;
      _reference = $v.reference;
      _status = $v.status;
      _exceptionReason = $v.exceptionReason;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingDtoOutputReceiptsInner other) {
    _$v = other as _$CounterBookingDtoOutputReceiptsInner;
  }

  @override
  void update(
      void Function(CounterBookingDtoOutputReceiptsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingDtoOutputReceiptsInner build() => _build();

  _$CounterBookingDtoOutputReceiptsInner _build() {
    final _$result = _$v ??
        _$CounterBookingDtoOutputReceiptsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CounterBookingDtoOutputReceiptsInner', 'id'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'CounterBookingDtoOutputReceiptsInner', 'method'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CounterBookingDtoOutputReceiptsInner', 'amount'),
          reference: reference,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CounterBookingDtoOutputReceiptsInner', 'status'),
          exceptionReason: exceptionReason,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CounterBookingDtoOutputReceiptsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
