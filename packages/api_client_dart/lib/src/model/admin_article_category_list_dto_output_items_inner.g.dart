// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_category_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum
    _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum
    _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminArticleCategoryListDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminArticleCategoryListDtoOutputItemsInnerStatusEnum
    _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminArticleCategoryListDtoOutputItemsInnerStatusEnum>
    _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminArticleCategoryListDtoOutputItemsInnerStatusEnum>(const <AdminArticleCategoryListDtoOutputItemsInnerStatusEnum>[
  _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminArticleCategoryListDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminArticleCategoryListDtoOutputItemsInnerStatusEnum>
    _$adminArticleCategoryListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminArticleCategoryListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminArticleCategoryListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminArticleCategoryListDtoOutputItemsInnerStatusEnum> {
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
    AdminArticleCategoryListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminArticleCategoryListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminArticleCategoryListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminArticleCategoryListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminArticleCategoryListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminArticleCategoryListDtoOutputItemsInner
    extends AdminArticleCategoryListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final int displayOrder;
  @override
  final AdminArticleCategoryListDtoOutputItemsInnerStatusEnum status;
  @override
  final int articleCount;

  factory _$AdminArticleCategoryListDtoOutputItemsInner(
          [void Function(AdminArticleCategoryListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminArticleCategoryListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminArticleCategoryListDtoOutputItemsInner._(
      {required this.id,
      required this.name,
      required this.slug,
      required this.displayOrder,
      required this.status,
      required this.articleCount})
      : super._();
  @override
  AdminArticleCategoryListDtoOutputItemsInner rebuild(
          void Function(AdminArticleCategoryListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleCategoryListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminArticleCategoryListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleCategoryListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminArticleCategoryListDtoOutputItemsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('displayOrder', displayOrder)
          ..add('status', status)
          ..add('articleCount', articleCount))
        .toString();
  }
}

class AdminArticleCategoryListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminArticleCategoryListDtoOutputItemsInner,
            AdminArticleCategoryListDtoOutputItemsInnerBuilder> {
  _$AdminArticleCategoryListDtoOutputItemsInner? _$v;

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

  AdminArticleCategoryListDtoOutputItemsInnerStatusEnum? _status;
  AdminArticleCategoryListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminArticleCategoryListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _articleCount;
  int? get articleCount => _$this._articleCount;
  set articleCount(int? articleCount) => _$this._articleCount = articleCount;

  AdminArticleCategoryListDtoOutputItemsInnerBuilder() {
    AdminArticleCategoryListDtoOutputItemsInner._defaults(this);
  }

  AdminArticleCategoryListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminArticleCategoryListDtoOutputItemsInner other) {
    _$v = other as _$AdminArticleCategoryListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminArticleCategoryListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleCategoryListDtoOutputItemsInner build() => _build();

  _$AdminArticleCategoryListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminArticleCategoryListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminArticleCategoryListDtoOutputItemsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminArticleCategoryListDtoOutputItemsInner', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AdminArticleCategoryListDtoOutputItemsInner', 'slug'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(displayOrder,
              r'AdminArticleCategoryListDtoOutputItemsInner', 'displayOrder'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminArticleCategoryListDtoOutputItemsInner', 'status'),
          articleCount: BuiltValueNullFieldError.checkNotNull(articleCount,
              r'AdminArticleCategoryListDtoOutputItemsInner', 'articleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
