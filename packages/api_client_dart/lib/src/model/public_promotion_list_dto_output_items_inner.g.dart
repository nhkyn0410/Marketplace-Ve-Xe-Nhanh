// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_promotion_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicPromotionListDtoOutputItemsInnerScopeEnum
    _$publicPromotionListDtoOutputItemsInnerScopeEnum_PLATFORM =
    const PublicPromotionListDtoOutputItemsInnerScopeEnum._('PLATFORM');
const PublicPromotionListDtoOutputItemsInnerScopeEnum
    _$publicPromotionListDtoOutputItemsInnerScopeEnum_OPERATOR =
    const PublicPromotionListDtoOutputItemsInnerScopeEnum._('OPERATOR');

PublicPromotionListDtoOutputItemsInnerScopeEnum
    _$publicPromotionListDtoOutputItemsInnerScopeEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM':
      return _$publicPromotionListDtoOutputItemsInnerScopeEnum_PLATFORM;
    case 'OPERATOR':
      return _$publicPromotionListDtoOutputItemsInnerScopeEnum_OPERATOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicPromotionListDtoOutputItemsInnerScopeEnum>
    _$publicPromotionListDtoOutputItemsInnerScopeEnumValues = BuiltSet<
        PublicPromotionListDtoOutputItemsInnerScopeEnum>(const <PublicPromotionListDtoOutputItemsInnerScopeEnum>[
  _$publicPromotionListDtoOutputItemsInnerScopeEnum_PLATFORM,
  _$publicPromotionListDtoOutputItemsInnerScopeEnum_OPERATOR,
]);

const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum
    _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_PERCENT =
    const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum._('PERCENT');
const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum
    _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_AMOUNT =
    const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum._('AMOUNT');

PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum
    _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'PERCENT':
      return _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_PERCENT;
    case 'AMOUNT':
      return _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_AMOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum>
    _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumValues = BuiltSet<
        PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum>(const <PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum>[
  _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_PERCENT,
  _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_AMOUNT,
]);

Serializer<PublicPromotionListDtoOutputItemsInnerScopeEnum>
    _$publicPromotionListDtoOutputItemsInnerScopeEnumSerializer =
    _$PublicPromotionListDtoOutputItemsInnerScopeEnumSerializer();
Serializer<PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum>
    _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumSerializer =
    _$PublicPromotionListDtoOutputItemsInnerDiscountTypeEnumSerializer();

class _$PublicPromotionListDtoOutputItemsInnerScopeEnumSerializer
    implements
        PrimitiveSerializer<PublicPromotionListDtoOutputItemsInnerScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicPromotionListDtoOutputItemsInnerScopeEnum
  ];
  @override
  final String wireName = 'PublicPromotionListDtoOutputItemsInnerScopeEnum';

  @override
  Object serialize(Serializers serializers,
          PublicPromotionListDtoOutputItemsInnerScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicPromotionListDtoOutputItemsInnerScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicPromotionListDtoOutputItemsInnerScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicPromotionListDtoOutputItemsInnerDiscountTypeEnumSerializer
    implements
        PrimitiveSerializer<
            PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum
  ];
  @override
  final String wireName =
      'PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum';

  @override
  Object serialize(Serializers serializers,
          PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicPromotionListDtoOutputItemsInner
    extends PublicPromotionListDtoOutputItemsInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final PublicPromotionListDtoOutputItemsInnerScopeEnum scope;
  @override
  final String? operatorName;
  @override
  final PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum discountType;
  @override
  final int discountValue;
  @override
  final int? maxDiscount;
  @override
  final int minOrder;
  @override
  final DateTime endsAt;

  factory _$PublicPromotionListDtoOutputItemsInner(
          [void Function(PublicPromotionListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PublicPromotionListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PublicPromotionListDtoOutputItemsInner._(
      {required this.code,
      required this.name,
      required this.scope,
      this.operatorName,
      required this.discountType,
      required this.discountValue,
      this.maxDiscount,
      required this.minOrder,
      required this.endsAt})
      : super._();
  @override
  PublicPromotionListDtoOutputItemsInner rebuild(
          void Function(PublicPromotionListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicPromotionListDtoOutputItemsInnerBuilder toBuilder() =>
      PublicPromotionListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicPromotionListDtoOutputItemsInner &&
        code == other.code &&
        name == other.name &&
        scope == other.scope &&
        operatorName == other.operatorName &&
        discountType == other.discountType &&
        discountValue == other.discountValue &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        endsAt == other.endsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, discountType.hashCode);
    _$hash = $jc(_$hash, discountValue.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicPromotionListDtoOutputItemsInner')
          ..add('code', code)
          ..add('name', name)
          ..add('scope', scope)
          ..add('operatorName', operatorName)
          ..add('discountType', discountType)
          ..add('discountValue', discountValue)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class PublicPromotionListDtoOutputItemsInnerBuilder
    implements
        Builder<PublicPromotionListDtoOutputItemsInner,
            PublicPromotionListDtoOutputItemsInnerBuilder> {
  _$PublicPromotionListDtoOutputItemsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PublicPromotionListDtoOutputItemsInnerScopeEnum? _scope;
  PublicPromotionListDtoOutputItemsInnerScopeEnum? get scope => _$this._scope;
  set scope(PublicPromotionListDtoOutputItemsInnerScopeEnum? scope) =>
      _$this._scope = scope;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum? _discountType;
  PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum? get discountType =>
      _$this._discountType;
  set discountType(
          PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum?
              discountType) =>
      _$this._discountType = discountType;

  int? _discountValue;
  int? get discountValue => _$this._discountValue;
  set discountValue(int? discountValue) =>
      _$this._discountValue = discountValue;

  int? _maxDiscount;
  int? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(int? maxDiscount) => _$this._maxDiscount = maxDiscount;

  int? _minOrder;
  int? get minOrder => _$this._minOrder;
  set minOrder(int? minOrder) => _$this._minOrder = minOrder;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  PublicPromotionListDtoOutputItemsInnerBuilder() {
    PublicPromotionListDtoOutputItemsInner._defaults(this);
  }

  PublicPromotionListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _scope = $v.scope;
      _operatorName = $v.operatorName;
      _discountType = $v.discountType;
      _discountValue = $v.discountValue;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicPromotionListDtoOutputItemsInner other) {
    _$v = other as _$PublicPromotionListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PublicPromotionListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicPromotionListDtoOutputItemsInner build() => _build();

  _$PublicPromotionListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PublicPromotionListDtoOutputItemsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PublicPromotionListDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PublicPromotionListDtoOutputItemsInner', 'name'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'PublicPromotionListDtoOutputItemsInner', 'scope'),
          operatorName: operatorName,
          discountType: BuiltValueNullFieldError.checkNotNull(discountType,
              r'PublicPromotionListDtoOutputItemsInner', 'discountType'),
          discountValue: BuiltValueNullFieldError.checkNotNull(discountValue,
              r'PublicPromotionListDtoOutputItemsInner', 'discountValue'),
          maxDiscount: maxDiscount,
          minOrder: BuiltValueNullFieldError.checkNotNull(
              minOrder, r'PublicPromotionListDtoOutputItemsInner', 'minOrder'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'PublicPromotionListDtoOutputItemsInner', 'endsAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
