// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_receipt_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterReceiptResultDtoOutputStatusEnum
    _$counterReceiptResultDtoOutputStatusEnum_COMPLETED =
    const CounterReceiptResultDtoOutputStatusEnum._('COMPLETED');
const CounterReceiptResultDtoOutputStatusEnum
    _$counterReceiptResultDtoOutputStatusEnum_EXCEPTION =
    const CounterReceiptResultDtoOutputStatusEnum._('EXCEPTION');

CounterReceiptResultDtoOutputStatusEnum
    _$counterReceiptResultDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'COMPLETED':
      return _$counterReceiptResultDtoOutputStatusEnum_COMPLETED;
    case 'EXCEPTION':
      return _$counterReceiptResultDtoOutputStatusEnum_EXCEPTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterReceiptResultDtoOutputStatusEnum>
    _$counterReceiptResultDtoOutputStatusEnumValues = BuiltSet<
        CounterReceiptResultDtoOutputStatusEnum>(const <CounterReceiptResultDtoOutputStatusEnum>[
  _$counterReceiptResultDtoOutputStatusEnum_COMPLETED,
  _$counterReceiptResultDtoOutputStatusEnum_EXCEPTION,
]);

Serializer<CounterReceiptResultDtoOutputStatusEnum>
    _$counterReceiptResultDtoOutputStatusEnumSerializer =
    _$CounterReceiptResultDtoOutputStatusEnumSerializer();

class _$CounterReceiptResultDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CounterReceiptResultDtoOutputStatusEnum> {
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
    CounterReceiptResultDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'CounterReceiptResultDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CounterReceiptResultDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterReceiptResultDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterReceiptResultDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterReceiptResultDtoOutput extends CounterReceiptResultDtoOutput {
  @override
  final String receiptId;
  @override
  final CounterReceiptResultDtoOutputStatusEnum status;
  @override
  final String? exceptionReason;
  @override
  final CounterBookingListDtoOutputItemsInner booking;

  factory _$CounterReceiptResultDtoOutput(
          [void Function(CounterReceiptResultDtoOutputBuilder)? updates]) =>
      (CounterReceiptResultDtoOutputBuilder()..update(updates))._build();

  _$CounterReceiptResultDtoOutput._(
      {required this.receiptId,
      required this.status,
      this.exceptionReason,
      required this.booking})
      : super._();
  @override
  CounterReceiptResultDtoOutput rebuild(
          void Function(CounterReceiptResultDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterReceiptResultDtoOutputBuilder toBuilder() =>
      CounterReceiptResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterReceiptResultDtoOutput &&
        receiptId == other.receiptId &&
        status == other.status &&
        exceptionReason == other.exceptionReason &&
        booking == other.booking;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, receiptId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, exceptionReason.hashCode);
    _$hash = $jc(_$hash, booking.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterReceiptResultDtoOutput')
          ..add('receiptId', receiptId)
          ..add('status', status)
          ..add('exceptionReason', exceptionReason)
          ..add('booking', booking))
        .toString();
  }
}

class CounterReceiptResultDtoOutputBuilder
    implements
        Builder<CounterReceiptResultDtoOutput,
            CounterReceiptResultDtoOutputBuilder> {
  _$CounterReceiptResultDtoOutput? _$v;

  String? _receiptId;
  String? get receiptId => _$this._receiptId;
  set receiptId(String? receiptId) => _$this._receiptId = receiptId;

  CounterReceiptResultDtoOutputStatusEnum? _status;
  CounterReceiptResultDtoOutputStatusEnum? get status => _$this._status;
  set status(CounterReceiptResultDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _exceptionReason;
  String? get exceptionReason => _$this._exceptionReason;
  set exceptionReason(String? exceptionReason) =>
      _$this._exceptionReason = exceptionReason;

  CounterBookingListDtoOutputItemsInnerBuilder? _booking;
  CounterBookingListDtoOutputItemsInnerBuilder get booking =>
      _$this._booking ??= CounterBookingListDtoOutputItemsInnerBuilder();
  set booking(CounterBookingListDtoOutputItemsInnerBuilder? booking) =>
      _$this._booking = booking;

  CounterReceiptResultDtoOutputBuilder() {
    CounterReceiptResultDtoOutput._defaults(this);
  }

  CounterReceiptResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receiptId = $v.receiptId;
      _status = $v.status;
      _exceptionReason = $v.exceptionReason;
      _booking = $v.booking.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterReceiptResultDtoOutput other) {
    _$v = other as _$CounterReceiptResultDtoOutput;
  }

  @override
  void update(void Function(CounterReceiptResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterReceiptResultDtoOutput build() => _build();

  _$CounterReceiptResultDtoOutput _build() {
    _$CounterReceiptResultDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterReceiptResultDtoOutput._(
            receiptId: BuiltValueNullFieldError.checkNotNull(
                receiptId, r'CounterReceiptResultDtoOutput', 'receiptId'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CounterReceiptResultDtoOutput', 'status'),
            exceptionReason: exceptionReason,
            booking: booking.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'booking';
        booking.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterReceiptResultDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
