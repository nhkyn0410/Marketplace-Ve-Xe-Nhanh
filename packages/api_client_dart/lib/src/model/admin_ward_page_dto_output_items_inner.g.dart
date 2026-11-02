// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ward_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminWardPageDtoOutputItemsInnerStatusEnum
    _$adminWardPageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminWardPageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminWardPageDtoOutputItemsInnerStatusEnum
    _$adminWardPageDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminWardPageDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminWardPageDtoOutputItemsInnerStatusEnum
    _$adminWardPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminWardPageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminWardPageDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminWardPageDtoOutputItemsInnerStatusEnum>
    _$adminWardPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminWardPageDtoOutputItemsInnerStatusEnum>(const <AdminWardPageDtoOutputItemsInnerStatusEnum>[
  _$adminWardPageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminWardPageDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminWardPageDtoOutputItemsInnerStatusEnum>
    _$adminWardPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminWardPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminWardPageDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<AdminWardPageDtoOutputItemsInnerStatusEnum> {
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
    AdminWardPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminWardPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminWardPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminWardPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminWardPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminWardPageDtoOutputItemsInner
    extends AdminWardPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminWardPageDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String provinceId;
  @override
  final String provinceName;
  @override
  final int stopPointCount;

  factory _$AdminWardPageDtoOutputItemsInner(
          [void Function(AdminWardPageDtoOutputItemsInnerBuilder)? updates]) =>
      (AdminWardPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminWardPageDtoOutputItemsInner._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.provinceId,
      required this.provinceName,
      required this.stopPointCount})
      : super._();
  @override
  AdminWardPageDtoOutputItemsInner rebuild(
          void Function(AdminWardPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminWardPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminWardPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWardPageDtoOutputItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        provinceId == other.provinceId &&
        provinceName == other.provinceName &&
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
    _$hash = $jc(_$hash, provinceId.hashCode);
    _$hash = $jc(_$hash, provinceName.hashCode);
    _$hash = $jc(_$hash, stopPointCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminWardPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('provinceId', provinceId)
          ..add('provinceName', provinceName)
          ..add('stopPointCount', stopPointCount))
        .toString();
  }
}

class AdminWardPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminWardPageDtoOutputItemsInner,
            AdminWardPageDtoOutputItemsInnerBuilder> {
  _$AdminWardPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminWardPageDtoOutputItemsInnerStatusEnum? _status;
  AdminWardPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminWardPageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _provinceId;
  String? get provinceId => _$this._provinceId;
  set provinceId(String? provinceId) => _$this._provinceId = provinceId;

  String? _provinceName;
  String? get provinceName => _$this._provinceName;
  set provinceName(String? provinceName) => _$this._provinceName = provinceName;

  int? _stopPointCount;
  int? get stopPointCount => _$this._stopPointCount;
  set stopPointCount(int? stopPointCount) =>
      _$this._stopPointCount = stopPointCount;

  AdminWardPageDtoOutputItemsInnerBuilder() {
    AdminWardPageDtoOutputItemsInner._defaults(this);
  }

  AdminWardPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _provinceId = $v.provinceId;
      _provinceName = $v.provinceName;
      _stopPointCount = $v.stopPointCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminWardPageDtoOutputItemsInner other) {
    _$v = other as _$AdminWardPageDtoOutputItemsInner;
  }

  @override
  void update(void Function(AdminWardPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWardPageDtoOutputItemsInner build() => _build();

  _$AdminWardPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminWardPageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminWardPageDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminWardPageDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminWardPageDtoOutputItemsInner', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminWardPageDtoOutputItemsInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminWardPageDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminWardPageDtoOutputItemsInner', 'updatedAt'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminWardPageDtoOutputItemsInner', 'provinceId'),
          provinceName: BuiltValueNullFieldError.checkNotNull(provinceName,
              r'AdminWardPageDtoOutputItemsInner', 'provinceName'),
          stopPointCount: BuiltValueNullFieldError.checkNotNull(stopPointCount,
              r'AdminWardPageDtoOutputItemsInner', 'stopPointCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
