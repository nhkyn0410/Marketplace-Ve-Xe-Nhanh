// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FareBandDtoOutputStatusEnum _$fareBandDtoOutputStatusEnum_ACTIVE =
    const FareBandDtoOutputStatusEnum._('ACTIVE');
const FareBandDtoOutputStatusEnum _$fareBandDtoOutputStatusEnum_CANCELLED =
    const FareBandDtoOutputStatusEnum._('CANCELLED');

FareBandDtoOutputStatusEnum _$fareBandDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$fareBandDtoOutputStatusEnum_ACTIVE;
    case 'CANCELLED':
      return _$fareBandDtoOutputStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FareBandDtoOutputStatusEnum>
    _$fareBandDtoOutputStatusEnumValues =
    BuiltSet<FareBandDtoOutputStatusEnum>(const <FareBandDtoOutputStatusEnum>[
  _$fareBandDtoOutputStatusEnum_ACTIVE,
  _$fareBandDtoOutputStatusEnum_CANCELLED,
]);

const FareBandDtoOutputStateEnum _$fareBandDtoOutputStateEnum_SCHEDULED =
    const FareBandDtoOutputStateEnum._('SCHEDULED');
const FareBandDtoOutputStateEnum _$fareBandDtoOutputStateEnum_ACTIVE =
    const FareBandDtoOutputStateEnum._('ACTIVE');
const FareBandDtoOutputStateEnum _$fareBandDtoOutputStateEnum_EXPIRED =
    const FareBandDtoOutputStateEnum._('EXPIRED');
const FareBandDtoOutputStateEnum _$fareBandDtoOutputStateEnum_CANCELLED =
    const FareBandDtoOutputStateEnum._('CANCELLED');

FareBandDtoOutputStateEnum _$fareBandDtoOutputStateEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$fareBandDtoOutputStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$fareBandDtoOutputStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$fareBandDtoOutputStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$fareBandDtoOutputStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FareBandDtoOutputStateEnum> _$fareBandDtoOutputStateEnumValues =
    BuiltSet<FareBandDtoOutputStateEnum>(const <FareBandDtoOutputStateEnum>[
  _$fareBandDtoOutputStateEnum_SCHEDULED,
  _$fareBandDtoOutputStateEnum_ACTIVE,
  _$fareBandDtoOutputStateEnum_EXPIRED,
  _$fareBandDtoOutputStateEnum_CANCELLED,
]);

Serializer<FareBandDtoOutputStatusEnum>
    _$fareBandDtoOutputStatusEnumSerializer =
    _$FareBandDtoOutputStatusEnumSerializer();
Serializer<FareBandDtoOutputStateEnum> _$fareBandDtoOutputStateEnumSerializer =
    _$FareBandDtoOutputStateEnumSerializer();

class _$FareBandDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<FareBandDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[FareBandDtoOutputStatusEnum];
  @override
  final String wireName = 'FareBandDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers, FareBandDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FareBandDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FareBandDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FareBandDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<FareBandDtoOutputStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[FareBandDtoOutputStateEnum];
  @override
  final String wireName = 'FareBandDtoOutputStateEnum';

  @override
  Object serialize(Serializers serializers, FareBandDtoOutputStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FareBandDtoOutputStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FareBandDtoOutputStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FareBandDtoOutput extends FareBandDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final int? minPrice;
  @override
  final int? maxPrice;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime effectiveTo;
  @override
  final String message;
  @override
  final String reason;
  @override
  final FareBandDtoOutputStatusEnum status;
  @override
  final FareBandDtoOutputStateEnum state;
  @override
  final String? cancelReason;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;

  factory _$FareBandDtoOutput(
          [void Function(FareBandDtoOutputBuilder)? updates]) =>
      (FareBandDtoOutputBuilder()..update(updates))._build();

  _$FareBandDtoOutput._(
      {required this.id,
      required this.name,
      this.minPrice,
      this.maxPrice,
      required this.effectiveFrom,
      required this.effectiveTo,
      required this.message,
      required this.reason,
      required this.status,
      required this.state,
      this.cancelReason,
      this.createdBy,
      required this.createdAt})
      : super._();
  @override
  FareBandDtoOutput rebuild(void Function(FareBandDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FareBandDtoOutputBuilder toBuilder() =>
      FareBandDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FareBandDtoOutput &&
        id == other.id &&
        name == other.name &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        message == other.message &&
        reason == other.reason &&
        status == other.status &&
        state == other.state &&
        cancelReason == other.cancelReason &&
        createdBy == other.createdBy &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, maxPrice.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, cancelReason.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FareBandDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('minPrice', minPrice)
          ..add('maxPrice', maxPrice)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('message', message)
          ..add('reason', reason)
          ..add('status', status)
          ..add('state', state)
          ..add('cancelReason', cancelReason)
          ..add('createdBy', createdBy)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class FareBandDtoOutputBuilder
    implements Builder<FareBandDtoOutput, FareBandDtoOutputBuilder> {
  _$FareBandDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minPrice;
  int? get minPrice => _$this._minPrice;
  set minPrice(int? minPrice) => _$this._minPrice = minPrice;

  int? _maxPrice;
  int? get maxPrice => _$this._maxPrice;
  set maxPrice(int? maxPrice) => _$this._maxPrice = maxPrice;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  DateTime? _effectiveTo;
  DateTime? get effectiveTo => _$this._effectiveTo;
  set effectiveTo(DateTime? effectiveTo) => _$this._effectiveTo = effectiveTo;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  FareBandDtoOutputStatusEnum? _status;
  FareBandDtoOutputStatusEnum? get status => _$this._status;
  set status(FareBandDtoOutputStatusEnum? status) => _$this._status = status;

  FareBandDtoOutputStateEnum? _state;
  FareBandDtoOutputStateEnum? get state => _$this._state;
  set state(FareBandDtoOutputStateEnum? state) => _$this._state = state;

  String? _cancelReason;
  String? get cancelReason => _$this._cancelReason;
  set cancelReason(String? cancelReason) => _$this._cancelReason = cancelReason;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  FareBandDtoOutputBuilder() {
    FareBandDtoOutput._defaults(this);
  }

  FareBandDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _minPrice = $v.minPrice;
      _maxPrice = $v.maxPrice;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _message = $v.message;
      _reason = $v.reason;
      _status = $v.status;
      _state = $v.state;
      _cancelReason = $v.cancelReason;
      _createdBy = $v.createdBy;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FareBandDtoOutput other) {
    _$v = other as _$FareBandDtoOutput;
  }

  @override
  void update(void Function(FareBandDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FareBandDtoOutput build() => _build();

  _$FareBandDtoOutput _build() {
    final _$result = _$v ??
        _$FareBandDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FareBandDtoOutput', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FareBandDtoOutput', 'name'),
          minPrice: minPrice,
          maxPrice: maxPrice,
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'FareBandDtoOutput', 'effectiveFrom'),
          effectiveTo: BuiltValueNullFieldError.checkNotNull(
              effectiveTo, r'FareBandDtoOutput', 'effectiveTo'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'FareBandDtoOutput', 'message'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FareBandDtoOutput', 'reason'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FareBandDtoOutput', 'status'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'FareBandDtoOutput', 'state'),
          cancelReason: cancelReason,
          createdBy: createdBy,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'FareBandDtoOutput', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
