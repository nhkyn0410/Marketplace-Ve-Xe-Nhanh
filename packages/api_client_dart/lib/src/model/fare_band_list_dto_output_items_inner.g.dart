// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FareBandListDtoOutputItemsInnerStatusEnum
    _$fareBandListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const FareBandListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const FareBandListDtoOutputItemsInnerStatusEnum
    _$fareBandListDtoOutputItemsInnerStatusEnum_CANCELLED =
    const FareBandListDtoOutputItemsInnerStatusEnum._('CANCELLED');

FareBandListDtoOutputItemsInnerStatusEnum
    _$fareBandListDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$fareBandListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'CANCELLED':
      return _$fareBandListDtoOutputItemsInnerStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FareBandListDtoOutputItemsInnerStatusEnum>
    _$fareBandListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        FareBandListDtoOutputItemsInnerStatusEnum>(const <FareBandListDtoOutputItemsInnerStatusEnum>[
  _$fareBandListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$fareBandListDtoOutputItemsInnerStatusEnum_CANCELLED,
]);

const FareBandListDtoOutputItemsInnerStateEnum
    _$fareBandListDtoOutputItemsInnerStateEnum_SCHEDULED =
    const FareBandListDtoOutputItemsInnerStateEnum._('SCHEDULED');
const FareBandListDtoOutputItemsInnerStateEnum
    _$fareBandListDtoOutputItemsInnerStateEnum_ACTIVE =
    const FareBandListDtoOutputItemsInnerStateEnum._('ACTIVE');
const FareBandListDtoOutputItemsInnerStateEnum
    _$fareBandListDtoOutputItemsInnerStateEnum_EXPIRED =
    const FareBandListDtoOutputItemsInnerStateEnum._('EXPIRED');
const FareBandListDtoOutputItemsInnerStateEnum
    _$fareBandListDtoOutputItemsInnerStateEnum_CANCELLED =
    const FareBandListDtoOutputItemsInnerStateEnum._('CANCELLED');

FareBandListDtoOutputItemsInnerStateEnum
    _$fareBandListDtoOutputItemsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$fareBandListDtoOutputItemsInnerStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$fareBandListDtoOutputItemsInnerStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$fareBandListDtoOutputItemsInnerStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$fareBandListDtoOutputItemsInnerStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FareBandListDtoOutputItemsInnerStateEnum>
    _$fareBandListDtoOutputItemsInnerStateEnumValues = BuiltSet<
        FareBandListDtoOutputItemsInnerStateEnum>(const <FareBandListDtoOutputItemsInnerStateEnum>[
  _$fareBandListDtoOutputItemsInnerStateEnum_SCHEDULED,
  _$fareBandListDtoOutputItemsInnerStateEnum_ACTIVE,
  _$fareBandListDtoOutputItemsInnerStateEnum_EXPIRED,
  _$fareBandListDtoOutputItemsInnerStateEnum_CANCELLED,
]);

Serializer<FareBandListDtoOutputItemsInnerStatusEnum>
    _$fareBandListDtoOutputItemsInnerStatusEnumSerializer =
    _$FareBandListDtoOutputItemsInnerStatusEnumSerializer();
Serializer<FareBandListDtoOutputItemsInnerStateEnum>
    _$fareBandListDtoOutputItemsInnerStateEnumSerializer =
    _$FareBandListDtoOutputItemsInnerStateEnumSerializer();

class _$FareBandListDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<FareBandListDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FareBandListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'FareBandListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          FareBandListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FareBandListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FareBandListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FareBandListDtoOutputItemsInnerStateEnumSerializer
    implements PrimitiveSerializer<FareBandListDtoOutputItemsInnerStateEnum> {
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
  final Iterable<Type> types = const <Type>[
    FareBandListDtoOutputItemsInnerStateEnum
  ];
  @override
  final String wireName = 'FareBandListDtoOutputItemsInnerStateEnum';

  @override
  Object serialize(Serializers serializers,
          FareBandListDtoOutputItemsInnerStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FareBandListDtoOutputItemsInnerStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FareBandListDtoOutputItemsInnerStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FareBandListDtoOutputItemsInner
    extends FareBandListDtoOutputItemsInner {
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
  final FareBandListDtoOutputItemsInnerStatusEnum status;
  @override
  final FareBandListDtoOutputItemsInnerStateEnum state;
  @override
  final String? cancelReason;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;

  factory _$FareBandListDtoOutputItemsInner(
          [void Function(FareBandListDtoOutputItemsInnerBuilder)? updates]) =>
      (FareBandListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$FareBandListDtoOutputItemsInner._(
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
  FareBandListDtoOutputItemsInner rebuild(
          void Function(FareBandListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FareBandListDtoOutputItemsInnerBuilder toBuilder() =>
      FareBandListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FareBandListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(r'FareBandListDtoOutputItemsInner')
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

class FareBandListDtoOutputItemsInnerBuilder
    implements
        Builder<FareBandListDtoOutputItemsInner,
            FareBandListDtoOutputItemsInnerBuilder> {
  _$FareBandListDtoOutputItemsInner? _$v;

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

  FareBandListDtoOutputItemsInnerStatusEnum? _status;
  FareBandListDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(FareBandListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  FareBandListDtoOutputItemsInnerStateEnum? _state;
  FareBandListDtoOutputItemsInnerStateEnum? get state => _$this._state;
  set state(FareBandListDtoOutputItemsInnerStateEnum? state) =>
      _$this._state = state;

  String? _cancelReason;
  String? get cancelReason => _$this._cancelReason;
  set cancelReason(String? cancelReason) => _$this._cancelReason = cancelReason;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  FareBandListDtoOutputItemsInnerBuilder() {
    FareBandListDtoOutputItemsInner._defaults(this);
  }

  FareBandListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(FareBandListDtoOutputItemsInner other) {
    _$v = other as _$FareBandListDtoOutputItemsInner;
  }

  @override
  void update(void Function(FareBandListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FareBandListDtoOutputItemsInner build() => _build();

  _$FareBandListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$FareBandListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FareBandListDtoOutputItemsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FareBandListDtoOutputItemsInner', 'name'),
          minPrice: minPrice,
          maxPrice: maxPrice,
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(effectiveFrom,
              r'FareBandListDtoOutputItemsInner', 'effectiveFrom'),
          effectiveTo: BuiltValueNullFieldError.checkNotNull(
              effectiveTo, r'FareBandListDtoOutputItemsInner', 'effectiveTo'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'FareBandListDtoOutputItemsInner', 'message'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FareBandListDtoOutputItemsInner', 'reason'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FareBandListDtoOutputItemsInner', 'status'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'FareBandListDtoOutputItemsInner', 'state'),
          cancelReason: cancelReason,
          createdBy: createdBy,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'FareBandListDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
