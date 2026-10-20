// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PreferenceInputDtoKindEnum
    _$preferenceInputDtoKindEnum_BOOKING_CONFIRMED =
    const PreferenceInputDtoKindEnum._('BOOKING_CONFIRMED');
const PreferenceInputDtoKindEnum
    _$preferenceInputDtoKindEnum_TICKETS_CANCELLED =
    const PreferenceInputDtoKindEnum._('TICKETS_CANCELLED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_REFUND_SUCCEEDED =
    const PreferenceInputDtoKindEnum._('REFUND_SUCCEEDED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_TRIP_CHANGED =
    const PreferenceInputDtoKindEnum._('TRIP_CHANGED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_TRIP_CANCELLED =
    const PreferenceInputDtoKindEnum._('TRIP_CANCELLED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_MANUAL_REFUND =
    const PreferenceInputDtoKindEnum._('MANUAL_REFUND');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_CASE_UPDATED =
    const PreferenceInputDtoKindEnum._('CASE_UPDATED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_OPERATIONS_ALERT =
    const PreferenceInputDtoKindEnum._('OPERATIONS_ALERT');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_LOYALTY_UPDATED =
    const PreferenceInputDtoKindEnum._('LOYALTY_UPDATED');
const PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnum_PROMOTION =
    const PreferenceInputDtoKindEnum._('PROMOTION');

PreferenceInputDtoKindEnum _$preferenceInputDtoKindEnumValueOf(String name) {
  switch (name) {
    case 'BOOKING_CONFIRMED':
      return _$preferenceInputDtoKindEnum_BOOKING_CONFIRMED;
    case 'TICKETS_CANCELLED':
      return _$preferenceInputDtoKindEnum_TICKETS_CANCELLED;
    case 'REFUND_SUCCEEDED':
      return _$preferenceInputDtoKindEnum_REFUND_SUCCEEDED;
    case 'TRIP_CHANGED':
      return _$preferenceInputDtoKindEnum_TRIP_CHANGED;
    case 'TRIP_CANCELLED':
      return _$preferenceInputDtoKindEnum_TRIP_CANCELLED;
    case 'MANUAL_REFUND':
      return _$preferenceInputDtoKindEnum_MANUAL_REFUND;
    case 'CASE_UPDATED':
      return _$preferenceInputDtoKindEnum_CASE_UPDATED;
    case 'OPERATIONS_ALERT':
      return _$preferenceInputDtoKindEnum_OPERATIONS_ALERT;
    case 'LOYALTY_UPDATED':
      return _$preferenceInputDtoKindEnum_LOYALTY_UPDATED;
    case 'PROMOTION':
      return _$preferenceInputDtoKindEnum_PROMOTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PreferenceInputDtoKindEnum> _$preferenceInputDtoKindEnumValues =
    BuiltSet<PreferenceInputDtoKindEnum>(const <PreferenceInputDtoKindEnum>[
  _$preferenceInputDtoKindEnum_BOOKING_CONFIRMED,
  _$preferenceInputDtoKindEnum_TICKETS_CANCELLED,
  _$preferenceInputDtoKindEnum_REFUND_SUCCEEDED,
  _$preferenceInputDtoKindEnum_TRIP_CHANGED,
  _$preferenceInputDtoKindEnum_TRIP_CANCELLED,
  _$preferenceInputDtoKindEnum_MANUAL_REFUND,
  _$preferenceInputDtoKindEnum_CASE_UPDATED,
  _$preferenceInputDtoKindEnum_OPERATIONS_ALERT,
  _$preferenceInputDtoKindEnum_LOYALTY_UPDATED,
  _$preferenceInputDtoKindEnum_PROMOTION,
]);

Serializer<PreferenceInputDtoKindEnum> _$preferenceInputDtoKindEnumSerializer =
    _$PreferenceInputDtoKindEnumSerializer();

class _$PreferenceInputDtoKindEnumSerializer
    implements PrimitiveSerializer<PreferenceInputDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOOKING_CONFIRMED': 'BOOKING_CONFIRMED',
    'TICKETS_CANCELLED': 'TICKETS_CANCELLED',
    'REFUND_SUCCEEDED': 'REFUND_SUCCEEDED',
    'TRIP_CHANGED': 'TRIP_CHANGED',
    'TRIP_CANCELLED': 'TRIP_CANCELLED',
    'MANUAL_REFUND': 'MANUAL_REFUND',
    'CASE_UPDATED': 'CASE_UPDATED',
    'OPERATIONS_ALERT': 'OPERATIONS_ALERT',
    'LOYALTY_UPDATED': 'LOYALTY_UPDATED',
    'PROMOTION': 'PROMOTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOOKING_CONFIRMED': 'BOOKING_CONFIRMED',
    'TICKETS_CANCELLED': 'TICKETS_CANCELLED',
    'REFUND_SUCCEEDED': 'REFUND_SUCCEEDED',
    'TRIP_CHANGED': 'TRIP_CHANGED',
    'TRIP_CANCELLED': 'TRIP_CANCELLED',
    'MANUAL_REFUND': 'MANUAL_REFUND',
    'CASE_UPDATED': 'CASE_UPDATED',
    'OPERATIONS_ALERT': 'OPERATIONS_ALERT',
    'LOYALTY_UPDATED': 'LOYALTY_UPDATED',
    'PROMOTION': 'PROMOTION',
  };

  @override
  final Iterable<Type> types = const <Type>[PreferenceInputDtoKindEnum];
  @override
  final String wireName = 'PreferenceInputDtoKindEnum';

  @override
  Object serialize(Serializers serializers, PreferenceInputDtoKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PreferenceInputDtoKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PreferenceInputDtoKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PreferenceInputDto extends PreferenceInputDto {
  @override
  final PreferenceInputDtoKindEnum kind;
  @override
  final bool email;
  @override
  final bool push;

  factory _$PreferenceInputDto(
          [void Function(PreferenceInputDtoBuilder)? updates]) =>
      (PreferenceInputDtoBuilder()..update(updates))._build();

  _$PreferenceInputDto._(
      {required this.kind, required this.email, required this.push})
      : super._();
  @override
  PreferenceInputDto rebuild(
          void Function(PreferenceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreferenceInputDtoBuilder toBuilder() =>
      PreferenceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PreferenceInputDto &&
        kind == other.kind &&
        email == other.email &&
        push == other.push;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, push.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PreferenceInputDto')
          ..add('kind', kind)
          ..add('email', email)
          ..add('push', push))
        .toString();
  }
}

class PreferenceInputDtoBuilder
    implements Builder<PreferenceInputDto, PreferenceInputDtoBuilder> {
  _$PreferenceInputDto? _$v;

  PreferenceInputDtoKindEnum? _kind;
  PreferenceInputDtoKindEnum? get kind => _$this._kind;
  set kind(PreferenceInputDtoKindEnum? kind) => _$this._kind = kind;

  bool? _email;
  bool? get email => _$this._email;
  set email(bool? email) => _$this._email = email;

  bool? _push;
  bool? get push => _$this._push;
  set push(bool? push) => _$this._push = push;

  PreferenceInputDtoBuilder() {
    PreferenceInputDto._defaults(this);
  }

  PreferenceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _email = $v.email;
      _push = $v.push;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PreferenceInputDto other) {
    _$v = other as _$PreferenceInputDto;
  }

  @override
  void update(void Function(PreferenceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PreferenceInputDto build() => _build();

  _$PreferenceInputDto _build() {
    final _$result = _$v ??
        _$PreferenceInputDto._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'PreferenceInputDto', 'kind'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'PreferenceInputDto', 'email'),
          push: BuiltValueNullFieldError.checkNotNull(
              push, r'PreferenceInputDto', 'push'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
