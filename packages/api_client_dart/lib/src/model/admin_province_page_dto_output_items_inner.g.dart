// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_province_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminProvincePageDtoOutputItemsInnerStatusEnum
    _$adminProvincePageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminProvincePageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminProvincePageDtoOutputItemsInnerStatusEnum
    _$adminProvincePageDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminProvincePageDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminProvincePageDtoOutputItemsInnerStatusEnum
    _$adminProvincePageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminProvincePageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminProvincePageDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminProvincePageDtoOutputItemsInnerStatusEnum>
    _$adminProvincePageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminProvincePageDtoOutputItemsInnerStatusEnum>(const <AdminProvincePageDtoOutputItemsInnerStatusEnum>[
  _$adminProvincePageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminProvincePageDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminProvincePageDtoOutputItemsInnerStatusEnum>
    _$adminProvincePageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminProvincePageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminProvincePageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminProvincePageDtoOutputItemsInnerStatusEnum> {
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
    AdminProvincePageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminProvincePageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminProvincePageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminProvincePageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminProvincePageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminProvincePageDtoOutputItemsInner
    extends AdminProvincePageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminProvincePageDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int wardCount;
  @override
  final int stopPointCount;

  factory _$AdminProvincePageDtoOutputItemsInner(
          [void Function(AdminProvincePageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminProvincePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminProvincePageDtoOutputItemsInner._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.wardCount,
      required this.stopPointCount})
      : super._();
  @override
  AdminProvincePageDtoOutputItemsInner rebuild(
          void Function(AdminProvincePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminProvincePageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminProvincePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminProvincePageDtoOutputItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        wardCount == other.wardCount &&
        stopPointCount == other.stopPointCount;
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
    _$hash = $jc(_$hash, wardCount.hashCode);
    _$hash = $jc(_$hash, stopPointCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminProvincePageDtoOutputItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('wardCount', wardCount)
          ..add('stopPointCount', stopPointCount))
        .toString();
  }
}

class AdminProvincePageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminProvincePageDtoOutputItemsInner,
            AdminProvincePageDtoOutputItemsInnerBuilder> {
  _$AdminProvincePageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminProvincePageDtoOutputItemsInnerStatusEnum? _status;
  AdminProvincePageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminProvincePageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _wardCount;
  int? get wardCount => _$this._wardCount;
  set wardCount(int? wardCount) => _$this._wardCount = wardCount;

  int? _stopPointCount;
  int? get stopPointCount => _$this._stopPointCount;
  set stopPointCount(int? stopPointCount) =>
      _$this._stopPointCount = stopPointCount;

  AdminProvincePageDtoOutputItemsInnerBuilder() {
    AdminProvincePageDtoOutputItemsInner._defaults(this);
  }

  AdminProvincePageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _wardCount = $v.wardCount;
      _stopPointCount = $v.stopPointCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminProvincePageDtoOutputItemsInner other) {
    _$v = other as _$AdminProvincePageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminProvincePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminProvincePageDtoOutputItemsInner build() => _build();

  _$AdminProvincePageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminProvincePageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminProvincePageDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminProvincePageDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminProvincePageDtoOutputItemsInner', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminProvincePageDtoOutputItemsInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminProvincePageDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminProvincePageDtoOutputItemsInner', 'updatedAt'),
          wardCount: BuiltValueNullFieldError.checkNotNull(
              wardCount, r'AdminProvincePageDtoOutputItemsInner', 'wardCount'),
          stopPointCount: BuiltValueNullFieldError.checkNotNull(stopPointCount,
              r'AdminProvincePageDtoOutputItemsInner', 'stopPointCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
