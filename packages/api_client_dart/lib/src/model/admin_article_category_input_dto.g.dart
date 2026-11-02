// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_category_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminArticleCategoryInputDtoStatusEnum
    _$adminArticleCategoryInputDtoStatusEnum_ACTIVE =
    const AdminArticleCategoryInputDtoStatusEnum._('ACTIVE');
const AdminArticleCategoryInputDtoStatusEnum
    _$adminArticleCategoryInputDtoStatusEnum_INACTIVE =
    const AdminArticleCategoryInputDtoStatusEnum._('INACTIVE');

AdminArticleCategoryInputDtoStatusEnum
    _$adminArticleCategoryInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminArticleCategoryInputDtoStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminArticleCategoryInputDtoStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminArticleCategoryInputDtoStatusEnum>
    _$adminArticleCategoryInputDtoStatusEnumValues = BuiltSet<
        AdminArticleCategoryInputDtoStatusEnum>(const <AdminArticleCategoryInputDtoStatusEnum>[
  _$adminArticleCategoryInputDtoStatusEnum_ACTIVE,
  _$adminArticleCategoryInputDtoStatusEnum_INACTIVE,
]);

Serializer<AdminArticleCategoryInputDtoStatusEnum>
    _$adminArticleCategoryInputDtoStatusEnumSerializer =
    _$AdminArticleCategoryInputDtoStatusEnumSerializer();

class _$AdminArticleCategoryInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminArticleCategoryInputDtoStatusEnum> {
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
    AdminArticleCategoryInputDtoStatusEnum
  ];
  @override
  final String wireName = 'AdminArticleCategoryInputDtoStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminArticleCategoryInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminArticleCategoryInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminArticleCategoryInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminArticleCategoryInputDto extends AdminArticleCategoryInputDto {
  @override
  final String name;
  @override
  final String slug;
  @override
  final int displayOrder;
  @override
  final AdminArticleCategoryInputDtoStatusEnum status;

  factory _$AdminArticleCategoryInputDto(
          [void Function(AdminArticleCategoryInputDtoBuilder)? updates]) =>
      (AdminArticleCategoryInputDtoBuilder()..update(updates))._build();

  _$AdminArticleCategoryInputDto._(
      {required this.name,
      required this.slug,
      required this.displayOrder,
      required this.status})
      : super._();
  @override
  AdminArticleCategoryInputDto rebuild(
          void Function(AdminArticleCategoryInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleCategoryInputDtoBuilder toBuilder() =>
      AdminArticleCategoryInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleCategoryInputDto &&
        name == other.name &&
        slug == other.slug &&
        displayOrder == other.displayOrder &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticleCategoryInputDto')
          ..add('name', name)
          ..add('slug', slug)
          ..add('displayOrder', displayOrder)
          ..add('status', status))
        .toString();
  }
}

class AdminArticleCategoryInputDtoBuilder
    implements
        Builder<AdminArticleCategoryInputDto,
            AdminArticleCategoryInputDtoBuilder> {
  _$AdminArticleCategoryInputDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  AdminArticleCategoryInputDtoStatusEnum? _status;
  AdminArticleCategoryInputDtoStatusEnum? get status => _$this._status;
  set status(AdminArticleCategoryInputDtoStatusEnum? status) =>
      _$this._status = status;

  AdminArticleCategoryInputDtoBuilder() {
    AdminArticleCategoryInputDto._defaults(this);
  }

  AdminArticleCategoryInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _slug = $v.slug;
      _displayOrder = $v.displayOrder;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleCategoryInputDto other) {
    _$v = other as _$AdminArticleCategoryInputDto;
  }

  @override
  void update(void Function(AdminArticleCategoryInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleCategoryInputDto build() => _build();

  _$AdminArticleCategoryInputDto _build() {
    final _$result = _$v ??
        _$AdminArticleCategoryInputDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminArticleCategoryInputDto', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AdminArticleCategoryInputDto', 'slug'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'AdminArticleCategoryInputDto', 'displayOrder'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminArticleCategoryInputDto', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
