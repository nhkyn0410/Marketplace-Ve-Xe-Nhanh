// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_amenity_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAmenityListDtoOutputItemsInnerStatusEnum
    _$adminAmenityListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminAmenityListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminAmenityListDtoOutputItemsInnerStatusEnum
    _$adminAmenityListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminAmenityListDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminAmenityListDtoOutputItemsInnerStatusEnum
    _$adminAmenityListDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminAmenityListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminAmenityListDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAmenityListDtoOutputItemsInnerStatusEnum>
    _$adminAmenityListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminAmenityListDtoOutputItemsInnerStatusEnum>(const <AdminAmenityListDtoOutputItemsInnerStatusEnum>[
  _$adminAmenityListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminAmenityListDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminAmenityListDtoOutputItemsInnerStatusEnum>
    _$adminAmenityListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminAmenityListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminAmenityListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminAmenityListDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminAmenityListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminAmenityListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminAmenityListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAmenityListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAmenityListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAmenityListDtoOutputItemsInner
    extends AdminAmenityListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminAmenityListDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int vehicleCount;

  factory _$AdminAmenityListDtoOutputItemsInner(
          [void Function(AdminAmenityListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminAmenityListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminAmenityListDtoOutputItemsInner._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.vehicleCount})
      : super._();
  @override
  AdminAmenityListDtoOutputItemsInner rebuild(
          void Function(AdminAmenityListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAmenityListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminAmenityListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAmenityListDtoOutputItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        vehicleCount == other.vehicleCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, vehicleCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAmenityListDtoOutputItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('vehicleCount', vehicleCount))
        .toString();
  }
}

class AdminAmenityListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminAmenityListDtoOutputItemsInner,
            AdminAmenityListDtoOutputItemsInnerBuilder> {
  _$AdminAmenityListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminAmenityListDtoOutputItemsInnerStatusEnum? _status;
  AdminAmenityListDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminAmenityListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _vehicleCount;
  int? get vehicleCount => _$this._vehicleCount;
  set vehicleCount(int? vehicleCount) => _$this._vehicleCount = vehicleCount;

  AdminAmenityListDtoOutputItemsInnerBuilder() {
    AdminAmenityListDtoOutputItemsInner._defaults(this);
  }

  AdminAmenityListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _vehicleCount = $v.vehicleCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAmenityListDtoOutputItemsInner other) {
    _$v = other as _$AdminAmenityListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminAmenityListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAmenityListDtoOutputItemsInner build() => _build();

  _$AdminAmenityListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminAmenityListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminAmenityListDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminAmenityListDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminAmenityListDtoOutputItemsInner', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminAmenityListDtoOutputItemsInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminAmenityListDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminAmenityListDtoOutputItemsInner', 'updatedAt'),
          vehicleCount: BuiltValueNullFieldError.checkNotNull(vehicleCount,
              r'AdminAmenityListDtoOutputItemsInner', 'vehicleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
