// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_sales_dto_output_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripSalesDtoOutputChangesInnerKindsEnum
    _$tripSalesDtoOutputChangesInnerKindsEnum_SCHEDULE =
    const TripSalesDtoOutputChangesInnerKindsEnum._('SCHEDULE');
const TripSalesDtoOutputChangesInnerKindsEnum
    _$tripSalesDtoOutputChangesInnerKindsEnum_VEHICLE =
    const TripSalesDtoOutputChangesInnerKindsEnum._('VEHICLE');
const TripSalesDtoOutputChangesInnerKindsEnum
    _$tripSalesDtoOutputChangesInnerKindsEnum_STOP =
    const TripSalesDtoOutputChangesInnerKindsEnum._('STOP');
const TripSalesDtoOutputChangesInnerKindsEnum
    _$tripSalesDtoOutputChangesInnerKindsEnum_CANCEL =
    const TripSalesDtoOutputChangesInnerKindsEnum._('CANCEL');

TripSalesDtoOutputChangesInnerKindsEnum
    _$tripSalesDtoOutputChangesInnerKindsEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULE':
      return _$tripSalesDtoOutputChangesInnerKindsEnum_SCHEDULE;
    case 'VEHICLE':
      return _$tripSalesDtoOutputChangesInnerKindsEnum_VEHICLE;
    case 'STOP':
      return _$tripSalesDtoOutputChangesInnerKindsEnum_STOP;
    case 'CANCEL':
      return _$tripSalesDtoOutputChangesInnerKindsEnum_CANCEL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripSalesDtoOutputChangesInnerKindsEnum>
    _$tripSalesDtoOutputChangesInnerKindsEnumValues = BuiltSet<
        TripSalesDtoOutputChangesInnerKindsEnum>(const <TripSalesDtoOutputChangesInnerKindsEnum>[
  _$tripSalesDtoOutputChangesInnerKindsEnum_SCHEDULE,
  _$tripSalesDtoOutputChangesInnerKindsEnum_VEHICLE,
  _$tripSalesDtoOutputChangesInnerKindsEnum_STOP,
  _$tripSalesDtoOutputChangesInnerKindsEnum_CANCEL,
]);

Serializer<TripSalesDtoOutputChangesInnerKindsEnum>
    _$tripSalesDtoOutputChangesInnerKindsEnumSerializer =
    _$TripSalesDtoOutputChangesInnerKindsEnumSerializer();

class _$TripSalesDtoOutputChangesInnerKindsEnumSerializer
    implements PrimitiveSerializer<TripSalesDtoOutputChangesInnerKindsEnum> {
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
    TripSalesDtoOutputChangesInnerKindsEnum
  ];
  @override
  final String wireName = 'TripSalesDtoOutputChangesInnerKindsEnum';

  @override
  Object serialize(Serializers serializers,
          TripSalesDtoOutputChangesInnerKindsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripSalesDtoOutputChangesInnerKindsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripSalesDtoOutputChangesInnerKindsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripSalesDtoOutputChangesInner extends TripSalesDtoOutputChangesInner {
  @override
  final String id;
  @override
  final BuiltList<TripSalesDtoOutputChangesInnerKindsEnum> kinds;
  @override
  final TripSalesDtoOutputChangesInnerBefore before;
  @override
  final TripSalesDtoOutputChangesInnerBefore after;
  @override
  final String reason;
  @override
  final int affectedBookings;
  @override
  final String? actor;
  @override
  final DateTime createdAt;

  factory _$TripSalesDtoOutputChangesInner(
          [void Function(TripSalesDtoOutputChangesInnerBuilder)? updates]) =>
      (TripSalesDtoOutputChangesInnerBuilder()..update(updates))._build();

  _$TripSalesDtoOutputChangesInner._(
      {required this.id,
      required this.kinds,
      required this.before,
      required this.after,
      required this.reason,
      required this.affectedBookings,
      this.actor,
      required this.createdAt})
      : super._();
  @override
  TripSalesDtoOutputChangesInner rebuild(
          void Function(TripSalesDtoOutputChangesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSalesDtoOutputChangesInnerBuilder toBuilder() =>
      TripSalesDtoOutputChangesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSalesDtoOutputChangesInner &&
        id == other.id &&
        kinds == other.kinds &&
        before == other.before &&
        after == other.after &&
        reason == other.reason &&
        affectedBookings == other.affectedBookings &&
        actor == other.actor &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kinds.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, affectedBookings.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripSalesDtoOutputChangesInner')
          ..add('id', id)
          ..add('kinds', kinds)
          ..add('before', before)
          ..add('after', after)
          ..add('reason', reason)
          ..add('affectedBookings', affectedBookings)
          ..add('actor', actor)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class TripSalesDtoOutputChangesInnerBuilder
    implements
        Builder<TripSalesDtoOutputChangesInner,
            TripSalesDtoOutputChangesInnerBuilder> {
  _$TripSalesDtoOutputChangesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ListBuilder<TripSalesDtoOutputChangesInnerKindsEnum>? _kinds;
  ListBuilder<TripSalesDtoOutputChangesInnerKindsEnum> get kinds =>
      _$this._kinds ??= ListBuilder<TripSalesDtoOutputChangesInnerKindsEnum>();
  set kinds(ListBuilder<TripSalesDtoOutputChangesInnerKindsEnum>? kinds) =>
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

  int? _affectedBookings;
  int? get affectedBookings => _$this._affectedBookings;
  set affectedBookings(int? affectedBookings) =>
      _$this._affectedBookings = affectedBookings;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  TripSalesDtoOutputChangesInnerBuilder() {
    TripSalesDtoOutputChangesInner._defaults(this);
  }

  TripSalesDtoOutputChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kinds = $v.kinds.toBuilder();
      _before = $v.before.toBuilder();
      _after = $v.after.toBuilder();
      _reason = $v.reason;
      _affectedBookings = $v.affectedBookings;
      _actor = $v.actor;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSalesDtoOutputChangesInner other) {
    _$v = other as _$TripSalesDtoOutputChangesInner;
  }

  @override
  void update(void Function(TripSalesDtoOutputChangesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSalesDtoOutputChangesInner build() => _build();

  _$TripSalesDtoOutputChangesInner _build() {
    _$TripSalesDtoOutputChangesInner _$result;
    try {
      _$result = _$v ??
          _$TripSalesDtoOutputChangesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'TripSalesDtoOutputChangesInner', 'id'),
            kinds: kinds.build(),
            before: before.build(),
            after: after.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'TripSalesDtoOutputChangesInner', 'reason'),
            affectedBookings: BuiltValueNullFieldError.checkNotNull(
                affectedBookings,
                r'TripSalesDtoOutputChangesInner',
                'affectedBookings'),
            actor: actor,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'TripSalesDtoOutputChangesInner', 'createdAt'),
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
            r'TripSalesDtoOutputChangesInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
