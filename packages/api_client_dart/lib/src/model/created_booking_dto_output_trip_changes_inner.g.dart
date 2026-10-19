// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_trip_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputTripChangesInnerKindsEnum
    _$createdBookingDtoOutputTripChangesInnerKindsEnum_SCHEDULE =
    const CreatedBookingDtoOutputTripChangesInnerKindsEnum._('SCHEDULE');
const CreatedBookingDtoOutputTripChangesInnerKindsEnum
    _$createdBookingDtoOutputTripChangesInnerKindsEnum_VEHICLE =
    const CreatedBookingDtoOutputTripChangesInnerKindsEnum._('VEHICLE');
const CreatedBookingDtoOutputTripChangesInnerKindsEnum
    _$createdBookingDtoOutputTripChangesInnerKindsEnum_STOP =
    const CreatedBookingDtoOutputTripChangesInnerKindsEnum._('STOP');
const CreatedBookingDtoOutputTripChangesInnerKindsEnum
    _$createdBookingDtoOutputTripChangesInnerKindsEnum_CANCEL =
    const CreatedBookingDtoOutputTripChangesInnerKindsEnum._('CANCEL');

CreatedBookingDtoOutputTripChangesInnerKindsEnum
    _$createdBookingDtoOutputTripChangesInnerKindsEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULE':
      return _$createdBookingDtoOutputTripChangesInnerKindsEnum_SCHEDULE;
    case 'VEHICLE':
      return _$createdBookingDtoOutputTripChangesInnerKindsEnum_VEHICLE;
    case 'STOP':
      return _$createdBookingDtoOutputTripChangesInnerKindsEnum_STOP;
    case 'CANCEL':
      return _$createdBookingDtoOutputTripChangesInnerKindsEnum_CANCEL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputTripChangesInnerKindsEnum>
    _$createdBookingDtoOutputTripChangesInnerKindsEnumValues = BuiltSet<
        CreatedBookingDtoOutputTripChangesInnerKindsEnum>(const <CreatedBookingDtoOutputTripChangesInnerKindsEnum>[
  _$createdBookingDtoOutputTripChangesInnerKindsEnum_SCHEDULE,
  _$createdBookingDtoOutputTripChangesInnerKindsEnum_VEHICLE,
  _$createdBookingDtoOutputTripChangesInnerKindsEnum_STOP,
  _$createdBookingDtoOutputTripChangesInnerKindsEnum_CANCEL,
]);

Serializer<CreatedBookingDtoOutputTripChangesInnerKindsEnum>
    _$createdBookingDtoOutputTripChangesInnerKindsEnumSerializer =
    _$CreatedBookingDtoOutputTripChangesInnerKindsEnumSerializer();

class _$CreatedBookingDtoOutputTripChangesInnerKindsEnumSerializer
    implements
        PrimitiveSerializer<CreatedBookingDtoOutputTripChangesInnerKindsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULE': 'SCHEDULE',
    'VEHICLE': 'VEHICLE',
    'STOP': 'STOP',
    'CANCEL': 'CANCEL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULE': 'SCHEDULE',
    'VEHICLE': 'VEHICLE',
    'STOP': 'STOP',
    'CANCEL': 'CANCEL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreatedBookingDtoOutputTripChangesInnerKindsEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputTripChangesInnerKindsEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputTripChangesInnerKindsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputTripChangesInnerKindsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputTripChangesInnerKindsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputTripChangesInner
    extends CreatedBookingDtoOutputTripChangesInner {
  @override
  final BuiltList<CreatedBookingDtoOutputTripChangesInnerKindsEnum> kinds;
  @override
  final TripSalesDtoOutputChangesInnerBefore before;
  @override
  final TripSalesDtoOutputChangesInnerBefore after;
  @override
  final String reason;
  @override
  final DateTime createdAt;

  factory _$CreatedBookingDtoOutputTripChangesInner(
          [void Function(CreatedBookingDtoOutputTripChangesInnerBuilder)?
              updates]) =>
      (CreatedBookingDtoOutputTripChangesInnerBuilder()..update(updates))
          ._build();

  _$CreatedBookingDtoOutputTripChangesInner._(
      {required this.kinds,
      required this.before,
      required this.after,
      required this.reason,
      required this.createdAt})
      : super._();
  @override
  CreatedBookingDtoOutputTripChangesInner rebuild(
          void Function(CreatedBookingDtoOutputTripChangesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputTripChangesInnerBuilder toBuilder() =>
      CreatedBookingDtoOutputTripChangesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputTripChangesInner &&
        kinds == other.kinds &&
        before == other.before &&
        after == other.after &&
        reason == other.reason &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kinds.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CreatedBookingDtoOutputTripChangesInner')
          ..add('kinds', kinds)
          ..add('before', before)
          ..add('after', after)
          ..add('reason', reason)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CreatedBookingDtoOutputTripChangesInnerBuilder
    implements
        Builder<CreatedBookingDtoOutputTripChangesInner,
            CreatedBookingDtoOutputTripChangesInnerBuilder> {
  _$CreatedBookingDtoOutputTripChangesInner? _$v;

  ListBuilder<CreatedBookingDtoOutputTripChangesInnerKindsEnum>? _kinds;
  ListBuilder<CreatedBookingDtoOutputTripChangesInnerKindsEnum> get kinds =>
      _$this._kinds ??=
          ListBuilder<CreatedBookingDtoOutputTripChangesInnerKindsEnum>();
  set kinds(
          ListBuilder<CreatedBookingDtoOutputTripChangesInnerKindsEnum>?
              kinds) =>
      _$this._kinds = kinds;

  TripSalesDtoOutputChangesInnerBeforeBuilder? _before;
  TripSalesDtoOutputChangesInnerBeforeBuilder get before =>
      _$this._before ??= TripSalesDtoOutputChangesInnerBeforeBuilder();
  set before(TripSalesDtoOutputChangesInnerBeforeBuilder? before) =>
      _$this._before = before;

  TripSalesDtoOutputChangesInnerBeforeBuilder? _after;
  TripSalesDtoOutputChangesInnerBeforeBuilder get after =>
      _$this._after ??= TripSalesDtoOutputChangesInnerBeforeBuilder();
  set after(TripSalesDtoOutputChangesInnerBeforeBuilder? after) =>
      _$this._after = after;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CreatedBookingDtoOutputTripChangesInnerBuilder() {
    CreatedBookingDtoOutputTripChangesInner._defaults(this);
  }

  CreatedBookingDtoOutputTripChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kinds = $v.kinds.toBuilder();
      _before = $v.before.toBuilder();
      _after = $v.after.toBuilder();
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputTripChangesInner other) {
    _$v = other as _$CreatedBookingDtoOutputTripChangesInner;
  }

  @override
  void update(
      void Function(CreatedBookingDtoOutputTripChangesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputTripChangesInner build() => _build();

  _$CreatedBookingDtoOutputTripChangesInner _build() {
    _$CreatedBookingDtoOutputTripChangesInner _$result;
    try {
      _$result = _$v ??
          _$CreatedBookingDtoOutputTripChangesInner._(
            kinds: kinds.build(),
            before: before.build(),
            after: after.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'CreatedBookingDtoOutputTripChangesInner', 'reason'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'CreatedBookingDtoOutputTripChangesInner', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kinds';
        kinds.build();
        _$failedField = 'before';
        before.build();
        _$failedField = 'after';
        after.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreatedBookingDtoOutputTripChangesInner',
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
