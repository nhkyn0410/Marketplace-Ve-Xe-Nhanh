// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_category_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminArticleCategoryDtoOutputStatusEnum
    _$adminArticleCategoryDtoOutputStatusEnum_ACTIVE =
    const AdminArticleCategoryDtoOutputStatusEnum._('ACTIVE');
const AdminArticleCategoryDtoOutputStatusEnum
    _$adminArticleCategoryDtoOutputStatusEnum_INACTIVE =
    const AdminArticleCategoryDtoOutputStatusEnum._('INACTIVE');

AdminArticleCategoryDtoOutputStatusEnum
    _$adminArticleCategoryDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminArticleCategoryDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminArticleCategoryDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminArticleCategoryDtoOutputStatusEnum>
    _$adminArticleCategoryDtoOutputStatusEnumValues = BuiltSet<
        AdminArticleCategoryDtoOutputStatusEnum>(const <AdminArticleCategoryDtoOutputStatusEnum>[
  _$adminArticleCategoryDtoOutputStatusEnum_ACTIVE,
  _$adminArticleCategoryDtoOutputStatusEnum_INACTIVE,
]);

Serializer<AdminArticleCategoryDtoOutputStatusEnum>
    _$adminArticleCategoryDtoOutputStatusEnumSerializer =
    _$AdminArticleCategoryDtoOutputStatusEnumSerializer();

class _$AdminArticleCategoryDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminArticleCategoryDtoOutputStatusEnum> {
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
    AdminArticleCategoryDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminArticleCategoryDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminArticleCategoryDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminArticleCategoryDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminArticleCategoryDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminArticleCategoryDtoOutput extends AdminArticleCategoryDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final int displayOrder;
  @override
  final AdminArticleCategoryDtoOutputStatusEnum status;
  @override
  final int articleCount;

  factory _$AdminArticleCategoryDtoOutput(
          [void Function(AdminArticleCategoryDtoOutputBuilder)? updates]) =>
      (AdminArticleCategoryDtoOutputBuilder()..update(updates))._build();

  _$AdminArticleCategoryDtoOutput._(
      {required this.id,
      required this.name,
      required this.slug,
      required this.displayOrder,
      required this.status,
      required this.articleCount})
      : super._();
  @override
  AdminArticleCategoryDtoOutput rebuild(
          void Function(AdminArticleCategoryDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleCategoryDtoOutputBuilder toBuilder() =>
      AdminArticleCategoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleCategoryDtoOutput &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        displayOrder == other.displayOrder &&
        status == other.status &&
        articleCount == other.articleCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, articleCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticleCategoryDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('displayOrder', displayOrder)
          ..add('status', status)
          ..add('articleCount', articleCount))
        .toString();
  }
}

class AdminArticleCategoryDtoOutputBuilder
    implements
        Builder<AdminArticleCategoryDtoOutput,
            AdminArticleCategoryDtoOutputBuilder> {
  _$AdminArticleCategoryDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  AdminArticleCategoryDtoOutputStatusEnum? _status;
  AdminArticleCategoryDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminArticleCategoryDtoOutputStatusEnum? status) =>
      _$this._status = status;

  int? _articleCount;
  int? get articleCount => _$this._articleCount;
  set articleCount(int? articleCount) => _$this._articleCount = articleCount;

  AdminArticleCategoryDtoOutputBuilder() {
    AdminArticleCategoryDtoOutput._defaults(this);
  }

  AdminArticleCategoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _displayOrder = $v.displayOrder;
      _status = $v.status;
      _articleCount = $v.articleCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleCategoryDtoOutput other) {
    _$v = other as _$AdminArticleCategoryDtoOutput;
  }

  @override
  void update(void Function(AdminArticleCategoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleCategoryDtoOutput build() => _build();

  _$AdminArticleCategoryDtoOutput _build() {
    final _$result = _$v ??
        _$AdminArticleCategoryDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminArticleCategoryDtoOutput', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminArticleCategoryDtoOutput', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AdminArticleCategoryDtoOutput', 'slug'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'AdminArticleCategoryDtoOutput', 'displayOrder'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminArticleCategoryDtoOutput', 'status'),
          articleCount: BuiltValueNullFieldError.checkNotNull(
              articleCount, r'AdminArticleCategoryDtoOutput', 'articleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
