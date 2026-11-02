// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_verify_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_OK =
    const TicketVerifyResultDtoOutputResultEnum._('OK');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_WRONG_TRIP =
    const TicketVerifyResultDtoOutputResultEnum._('WRONG_TRIP');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_ALREADY_CHECKED_IN =
    const TicketVerifyResultDtoOutputResultEnum._('ALREADY_CHECKED_IN');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_CANCELLED =
    const TicketVerifyResultDtoOutputResultEnum._('CANCELLED');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_REFUNDED =
    const TicketVerifyResultDtoOutputResultEnum._('REFUNDED');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_NO_SHOW =
    const TicketVerifyResultDtoOutputResultEnum._('NO_SHOW');
const TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnum_USED =
    const TicketVerifyResultDtoOutputResultEnum._('USED');

TicketVerifyResultDtoOutputResultEnum
    _$ticketVerifyResultDtoOutputResultEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$ticketVerifyResultDtoOutputResultEnum_OK;
    case 'WRONG_TRIP':
      return _$ticketVerifyResultDtoOutputResultEnum_WRONG_TRIP;
    case 'ALREADY_CHECKED_IN':
      return _$ticketVerifyResultDtoOutputResultEnum_ALREADY_CHECKED_IN;
    case 'CANCELLED':
      return _$ticketVerifyResultDtoOutputResultEnum_CANCELLED;
    case 'REFUNDED':
      return _$ticketVerifyResultDtoOutputResultEnum_REFUNDED;
    case 'NO_SHOW':
      return _$ticketVerifyResultDtoOutputResultEnum_NO_SHOW;
    case 'USED':
      return _$ticketVerifyResultDtoOutputResultEnum_USED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketVerifyResultDtoOutputResultEnum>
    _$ticketVerifyResultDtoOutputResultEnumValues = BuiltSet<
        TicketVerifyResultDtoOutputResultEnum>(const <TicketVerifyResultDtoOutputResultEnum>[
  _$ticketVerifyResultDtoOutputResultEnum_OK,
  _$ticketVerifyResultDtoOutputResultEnum_WRONG_TRIP,
  _$ticketVerifyResultDtoOutputResultEnum_ALREADY_CHECKED_IN,
  _$ticketVerifyResultDtoOutputResultEnum_CANCELLED,
  _$ticketVerifyResultDtoOutputResultEnum_REFUNDED,
  _$ticketVerifyResultDtoOutputResultEnum_NO_SHOW,
  _$ticketVerifyResultDtoOutputResultEnum_USED,
]);

Serializer<TicketVerifyResultDtoOutputResultEnum>
    _$ticketVerifyResultDtoOutputResultEnumSerializer =
    _$TicketVerifyResultDtoOutputResultEnumSerializer();

class _$TicketVerifyResultDtoOutputResultEnumSerializer
    implements PrimitiveSerializer<TicketVerifyResultDtoOutputResultEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'WRONG_TRIP': 'WRONG_TRIP',
    'ALREADY_CHECKED_IN': 'ALREADY_CHECKED_IN',
    'CANCELLED': 'CANCELLED',
    'REFUNDED': 'REFUNDED',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'WRONG_TRIP': 'WRONG_TRIP',
    'ALREADY_CHECKED_IN': 'ALREADY_CHECKED_IN',
    'CANCELLED': 'CANCELLED',
    'REFUNDED': 'REFUNDED',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TicketVerifyResultDtoOutputResultEnum
  ];
  @override
  final String wireName = 'TicketVerifyResultDtoOutputResultEnum';

  @override
  Object serialize(
          Serializers serializers, TicketVerifyResultDtoOutputResultEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketVerifyResultDtoOutputResultEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketVerifyResultDtoOutputResultEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketVerifyResultDtoOutput extends TicketVerifyResultDtoOutput {
  @override
  final TicketVerifyResultDtoOutputResultEnum result;
  @override
  final TicketVerifyResultDtoOutputTicket? ticket;
  @override
  final String ticketCode;
  @override
  final TicketVerifyResultDtoOutputTicketTrip? ticketTrip;

  factory _$TicketVerifyResultDtoOutput(
          [void Function(TicketVerifyResultDtoOutputBuilder)? updates]) =>
      (TicketVerifyResultDtoOutputBuilder()..update(updates))._build();

  _$TicketVerifyResultDtoOutput._(
      {required this.result,
      this.ticket,
      required this.ticketCode,
      this.ticketTrip})
      : super._();
  @override
  TicketVerifyResultDtoOutput rebuild(
          void Function(TicketVerifyResultDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketVerifyResultDtoOutputBuilder toBuilder() =>
      TicketVerifyResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketVerifyResultDtoOutput &&
        result == other.result &&
        ticket == other.ticket &&
        ticketCode == other.ticketCode &&
        ticketTrip == other.ticketTrip;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, ticket.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, ticketTrip.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketVerifyResultDtoOutput')
          ..add('result', result)
          ..add('ticket', ticket)
          ..add('ticketCode', ticketCode)
          ..add('ticketTrip', ticketTrip))
        .toString();
  }
}

class TicketVerifyResultDtoOutputBuilder
    implements
        Builder<TicketVerifyResultDtoOutput,
            TicketVerifyResultDtoOutputBuilder> {
  _$TicketVerifyResultDtoOutput? _$v;

  TicketVerifyResultDtoOutputResultEnum? _result;
  TicketVerifyResultDtoOutputResultEnum? get result => _$this._result;
  set result(TicketVerifyResultDtoOutputResultEnum? result) =>
      _$this._result = result;

  TicketVerifyResultDtoOutputTicketBuilder? _ticket;
  TicketVerifyResultDtoOutputTicketBuilder get ticket =>
      _$this._ticket ??= TicketVerifyResultDtoOutputTicketBuilder();
  set ticket(TicketVerifyResultDtoOutputTicketBuilder? ticket) =>
      _$this._ticket = ticket;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  TicketVerifyResultDtoOutputTicketTripBuilder? _ticketTrip;
  TicketVerifyResultDtoOutputTicketTripBuilder get ticketTrip =>
      _$this._ticketTrip ??= TicketVerifyResultDtoOutputTicketTripBuilder();
  set ticketTrip(TicketVerifyResultDtoOutputTicketTripBuilder? ticketTrip) =>
      _$this._ticketTrip = ticketTrip;

  TicketVerifyResultDtoOutputBuilder() {
    TicketVerifyResultDtoOutput._defaults(this);
  }

  TicketVerifyResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _result = $v.result;
      _ticket = $v.ticket?.toBuilder();
      _ticketCode = $v.ticketCode;
      _ticketTrip = $v.ticketTrip?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketVerifyResultDtoOutput other) {
    _$v = other as _$TicketVerifyResultDtoOutput;
  }

  @override
  void update(void Function(TicketVerifyResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketVerifyResultDtoOutput build() => _build();

  _$TicketVerifyResultDtoOutput _build() {
    _$TicketVerifyResultDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TicketVerifyResultDtoOutput._(
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'TicketVerifyResultDtoOutput', 'result'),
            ticket: _ticket?.build(),
            ticketCode: BuiltValueNullFieldError.checkNotNull(
                ticketCode, r'TicketVerifyResultDtoOutput', 'ticketCode'),
            ticketTrip: _ticketTrip?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticket';
        _ticket?.build();

        _$failedField = 'ticketTrip';
        _ticketTrip?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TicketVerifyResultDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
