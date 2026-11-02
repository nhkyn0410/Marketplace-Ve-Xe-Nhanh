// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PromotionInputDtoDiscountTypeEnum
    _$promotionInputDtoDiscountTypeEnum_PERCENT =
    const PromotionInputDtoDiscountTypeEnum._('PERCENT');
const PromotionInputDtoDiscountTypeEnum
    _$promotionInputDtoDiscountTypeEnum_AMOUNT =
    const PromotionInputDtoDiscountTypeEnum._('AMOUNT');

PromotionInputDtoDiscountTypeEnum _$promotionInputDtoDiscountTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'PERCENT':
      return _$promotionInputDtoDiscountTypeEnum_PERCENT;
    case 'AMOUNT':
      return _$promotionInputDtoDiscountTypeEnum_AMOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionInputDtoDiscountTypeEnum>
    _$promotionInputDtoDiscountTypeEnumValues = BuiltSet<
        PromotionInputDtoDiscountTypeEnum>(const <PromotionInputDtoDiscountTypeEnum>[
  _$promotionInputDtoDiscountTypeEnum_PERCENT,
  _$promotionInputDtoDiscountTypeEnum_AMOUNT,
]);

Serializer<PromotionInputDtoDiscountTypeEnum>
    _$promotionInputDtoDiscountTypeEnumSerializer =
    _$PromotionInputDtoDiscountTypeEnumSerializer();

class _$PromotionInputDtoDiscountTypeEnumSerializer
    implements PrimitiveSerializer<PromotionInputDtoDiscountTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionInputDtoDiscountTypeEnum];
  @override
  final String wireName = 'PromotionInputDtoDiscountTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PromotionInputDtoDiscountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionInputDtoDiscountTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionInputDtoDiscountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionInputDto extends PromotionInputDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final PromotionInputDtoDiscountTypeEnum discountType;
  @override
  final int discountValue;
  @override
  final int? maxDiscount;
  @override
  final int? minOrder;
  @override
  final String? routeId;
  @override
  final BuiltList<String>? routeIds;
  @override
  final String? tripId;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final int usageLimit;

  factory _$PromotionInputDto(
          [void Function(PromotionInputDtoBuilder)? updates]) =>
      (PromotionInputDtoBuilder()..update(updates))._build();

  _$PromotionInputDto._(
      {required this.code,
      required this.name,
      required this.discountType,
      required this.discountValue,
      this.maxDiscount,
      this.minOrder,
      this.routeId,
      this.routeIds,
      this.tripId,
      required this.startsAt,
      required this.endsAt,
      required this.usageLimit})
      : super._();
  @override
  PromotionInputDto rebuild(void Function(PromotionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionInputDtoBuilder toBuilder() =>
      PromotionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionInputDto &&
        code == other.code &&
        name == other.name &&
        discountType == other.discountType &&
        discountValue == other.discountValue &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        routeId == other.routeId &&
        routeIds == other.routeIds &&
        tripId == other.tripId &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        usageLimit == other.usageLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discountType.hashCode);
    _$hash = $jc(_$hash, discountValue.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeIds.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, usageLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionInputDto')
          ..add('code', code)
          ..add('name', name)
          ..add('discountType', discountType)
          ..add('discountValue', discountValue)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('routeId', routeId)
          ..add('routeIds', routeIds)
          ..add('tripId', tripId)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('usageLimit', usageLimit))
        .toString();
  }
}

class PromotionInputDtoBuilder
    implements Builder<PromotionInputDto, PromotionInputDtoBuilder> {
  _$PromotionInputDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PromotionInputDtoDiscountTypeEnum? _discountType;
  PromotionInputDtoDiscountTypeEnum? get discountType => _$this._discountType;
  set discountType(PromotionInputDtoDiscountTypeEnum? discountType) =>
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

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  ListBuilder<String>? _routeIds;
  ListBuilder<String> get routeIds =>
      _$this._routeIds ??= ListBuilder<String>();
  set routeIds(ListBuilder<String>? routeIds) => _$this._routeIds = routeIds;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  int? _usageLimit;
  int? get usageLimit => _$this._usageLimit;
  set usageLimit(int? usageLimit) => _$this._usageLimit = usageLimit;

  PromotionInputDtoBuilder() {
    PromotionInputDto._defaults(this);
  }

  PromotionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _discountType = $v.discountType;
      _discountValue = $v.discountValue;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _routeId = $v.routeId;
      _routeIds = $v.routeIds?.toBuilder();
      _tripId = $v.tripId;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _usageLimit = $v.usageLimit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionInputDto other) {
    _$v = other as _$PromotionInputDto;
  }

  @override
  void update(void Function(PromotionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionInputDto build() => _build();

  _$PromotionInputDto _build() {
    _$PromotionInputDto _$result;
    try {
      _$result = _$v ??
          _$PromotionInputDto._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'PromotionInputDto', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PromotionInputDto', 'name'),
            discountType: BuiltValueNullFieldError.checkNotNull(
                discountType, r'PromotionInputDto', 'discountType'),
            discountValue: BuiltValueNullFieldError.checkNotNull(
                discountValue, r'PromotionInputDto', 'discountValue'),
            maxDiscount: maxDiscount,
            minOrder: minOrder,
            routeId: routeId,
            routeIds: _routeIds?.build(),
            tripId: tripId,
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'PromotionInputDto', 'startsAt'),
            endsAt: BuiltValueNullFieldError.checkNotNull(
                endsAt, r'PromotionInputDto', 'endsAt'),
            usageLimit: BuiltValueNullFieldError.checkNotNull(
                usageLimit, r'PromotionInputDto', 'usageLimit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routeIds';
        _routeIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PromotionInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
