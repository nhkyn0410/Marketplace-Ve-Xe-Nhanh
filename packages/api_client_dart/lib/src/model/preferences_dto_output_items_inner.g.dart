// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED =
    const PreferencesDtoOutputItemsInnerKindEnum._('BOOKING_CONFIRMED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED =
    const PreferencesDtoOutputItemsInnerKindEnum._('TICKETS_CANCELLED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED =
    const PreferencesDtoOutputItemsInnerKindEnum._('REFUND_SUCCEEDED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CHANGED =
    const PreferencesDtoOutputItemsInnerKindEnum._('TRIP_CHANGED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CANCELLED =
    const PreferencesDtoOutputItemsInnerKindEnum._('TRIP_CANCELLED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_MANUAL_REFUND =
    const PreferencesDtoOutputItemsInnerKindEnum._('MANUAL_REFUND');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_CASE_UPDATED =
    const PreferencesDtoOutputItemsInnerKindEnum._('CASE_UPDATED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT =
    const PreferencesDtoOutputItemsInnerKindEnum._('OPERATIONS_ALERT');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED =
    const PreferencesDtoOutputItemsInnerKindEnum._('LOYALTY_UPDATED');
const PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnum_PROMOTION =
    const PreferencesDtoOutputItemsInnerKindEnum._('PROMOTION');

PreferencesDtoOutputItemsInnerKindEnum
    _$preferencesDtoOutputItemsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'BOOKING_CONFIRMED':
      return _$preferencesDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED;
    case 'TICKETS_CANCELLED':
      return _$preferencesDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED;
    case 'REFUND_SUCCEEDED':
      return _$preferencesDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED;
    case 'TRIP_CHANGED':
      return _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CHANGED;
    case 'TRIP_CANCELLED':
      return _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CANCELLED;
    case 'MANUAL_REFUND':
      return _$preferencesDtoOutputItemsInnerKindEnum_MANUAL_REFUND;
    case 'CASE_UPDATED':
      return _$preferencesDtoOutputItemsInnerKindEnum_CASE_UPDATED;
    case 'OPERATIONS_ALERT':
      return _$preferencesDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT;
    case 'LOYALTY_UPDATED':
      return _$preferencesDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED;
    case 'PROMOTION':
      return _$preferencesDtoOutputItemsInnerKindEnum_PROMOTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PreferencesDtoOutputItemsInnerKindEnum>
    _$preferencesDtoOutputItemsInnerKindEnumValues = BuiltSet<
        PreferencesDtoOutputItemsInnerKindEnum>(const <PreferencesDtoOutputItemsInnerKindEnum>[
  _$preferencesDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED,
  _$preferencesDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED,
  _$preferencesDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED,
  _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CHANGED,
  _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CANCELLED,
  _$preferencesDtoOutputItemsInnerKindEnum_MANUAL_REFUND,
  _$preferencesDtoOutputItemsInnerKindEnum_CASE_UPDATED,
  _$preferencesDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT,
  _$preferencesDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED,
  _$preferencesDtoOutputItemsInnerKindEnum_PROMOTION,
]);

Serializer<PreferencesDtoOutputItemsInnerKindEnum>
    _$preferencesDtoOutputItemsInnerKindEnumSerializer =
    _$PreferencesDtoOutputItemsInnerKindEnumSerializer();

class _$PreferencesDtoOutputItemsInnerKindEnumSerializer
    implements PrimitiveSerializer<PreferencesDtoOutputItemsInnerKindEnum> {
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
  final Iterable<Type> types = const <Type>[
    PreferencesDtoOutputItemsInnerKindEnum
  ];
  @override
  final String wireName = 'PreferencesDtoOutputItemsInnerKindEnum';

  @override
  Object serialize(Serializers serializers,
          PreferencesDtoOutputItemsInnerKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PreferencesDtoOutputItemsInnerKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PreferencesDtoOutputItemsInnerKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PreferencesDtoOutputItemsInner extends PreferencesDtoOutputItemsInner {
  @override
  final PreferencesDtoOutputItemsInnerKindEnum kind;
  @override
  final bool email;
  @override
  final bool push;
  @override
  final bool mandatory;

  factory _$PreferencesDtoOutputItemsInner(
          [void Function(PreferencesDtoOutputItemsInnerBuilder)? updates]) =>
      (PreferencesDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$PreferencesDtoOutputItemsInner._(
      {required this.kind,
      required this.email,
      required this.push,
      required this.mandatory})
      : super._();
  @override
  PreferencesDtoOutputItemsInner rebuild(
          void Function(PreferencesDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreferencesDtoOutputItemsInnerBuilder toBuilder() =>
      PreferencesDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PreferencesDtoOutputItemsInner &&
        kind == other.kind &&
        email == other.email &&
        push == other.push &&
        mandatory == other.mandatory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, push.hashCode);
    _$hash = $jc(_$hash, mandatory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PreferencesDtoOutputItemsInner')
          ..add('kind', kind)
          ..add('email', email)
          ..add('push', push)
          ..add('mandatory', mandatory))
        .toString();
  }
}

class PreferencesDtoOutputItemsInnerBuilder
    implements
        Builder<PreferencesDtoOutputItemsInner,
            PreferencesDtoOutputItemsInnerBuilder> {
  _$PreferencesDtoOutputItemsInner? _$v;

  PreferencesDtoOutputItemsInnerKindEnum? _kind;
  PreferencesDtoOutputItemsInnerKindEnum? get kind => _$this._kind;
  set kind(PreferencesDtoOutputItemsInnerKindEnum? kind) => _$this._kind = kind;

  bool? _email;
  bool? get email => _$this._email;
  set email(bool? email) => _$this._email = email;

  bool? _push;
  bool? get push => _$this._push;
  set push(bool? push) => _$this._push = push;

  bool? _mandatory;
  bool? get mandatory => _$this._mandatory;
  set mandatory(bool? mandatory) => _$this._mandatory = mandatory;

  PreferencesDtoOutputItemsInnerBuilder() {
    PreferencesDtoOutputItemsInner._defaults(this);
  }

  PreferencesDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _email = $v.email;
      _push = $v.push;
      _mandatory = $v.mandatory;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PreferencesDtoOutputItemsInner other) {
    _$v = other as _$PreferencesDtoOutputItemsInner;
  }

  @override
  void update(void Function(PreferencesDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PreferencesDtoOutputItemsInner build() => _build();

  _$PreferencesDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PreferencesDtoOutputItemsInner._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'PreferencesDtoOutputItemsInner', 'kind'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'PreferencesDtoOutputItemsInner', 'email'),
          push: BuiltValueNullFieldError.checkNotNull(
              push, r'PreferencesDtoOutputItemsInner', 'push'),
          mandatory: BuiltValueNullFieldError.checkNotNull(
              mandatory, r'PreferencesDtoOutputItemsInner', 'mandatory'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
