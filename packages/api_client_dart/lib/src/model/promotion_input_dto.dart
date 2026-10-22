//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_input_dto.g.dart';

/// PromotionInputDto
///
/// Properties:
/// * [code] 
/// * [name] 
/// * [discountType] 
/// * [discountValue] 
/// * [maxDiscount] 
/// * [minOrder] 
/// * [routeId] 
/// * [routeIds] 
/// * [tripId] 
/// * [startsAt] 
/// * [endsAt] 
/// * [usageLimit] 
@BuiltValue()
abstract class PromotionInputDto implements Built<PromotionInputDto, PromotionInputDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discountType')
  PromotionInputDtoDiscountTypeEnum get discountType;
  // enum discountTypeEnum {  PERCENT,  AMOUNT,  };

  @BuiltValueField(wireName: r'discountValue')
  int get discountValue;

  @BuiltValueField(wireName: r'maxDiscount')
  int? get maxDiscount;

  @BuiltValueField(wireName: r'minOrder')
  int? get minOrder;

  @BuiltValueField(wireName: r'routeId')
  String? get routeId;

  @BuiltValueField(wireName: r'routeIds')
  BuiltList<String>? get routeIds;

  @BuiltValueField(wireName: r'tripId')
  String? get tripId;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'usageLimit')
  int get usageLimit;

  PromotionInputDto._();

  factory PromotionInputDto([void updates(PromotionInputDtoBuilder b)]) = _$PromotionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionInputDtoBuilder b) => b
      ..minOrder = 0
      ..routeIds = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionInputDto> get serializer => _$PromotionInputDtoSerializer();
}

class _$PromotionInputDtoSerializer implements PrimitiveSerializer<PromotionInputDto> {
  @override
  final Iterable<Type> types = const [PromotionInputDto, _$PromotionInputDto];

  @override
  final String wireName = r'PromotionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'discountType';
    yield serializers.serialize(
      object.discountType,
      specifiedType: const FullType(PromotionInputDtoDiscountTypeEnum),
    );
    yield r'discountValue';
    yield serializers.serialize(
      object.discountValue,
      specifiedType: const FullType(int),
    );
    if (object.maxDiscount != null) {
      yield r'maxDiscount';
      yield serializers.serialize(
        object.maxDiscount,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.minOrder != null) {
      yield r'minOrder';
      yield serializers.serialize(
        object.minOrder,
        specifiedType: const FullType(int),
      );
    }
    if (object.routeId != null) {
      yield r'routeId';
      yield serializers.serialize(
        object.routeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.routeIds != null) {
      yield r'routeIds';
      yield serializers.serialize(
        object.routeIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.tripId != null) {
      yield r'tripId';
      yield serializers.serialize(
        object.tripId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'usageLimit';
    yield serializers.serialize(
      object.usageLimit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'discountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionInputDtoDiscountTypeEnum),
          ) as PromotionInputDtoDiscountTypeEnum;
          result.discountType = valueDes;
          break;
        case r'discountValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discountValue = valueDes;
          break;
        case r'maxDiscount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minOrder = valueDes;
          break;
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeId = valueDes;
          break;
        case r'routeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.routeIds.replace(valueDes);
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tripId = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'usageLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usageLimit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionInputDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class PromotionInputDtoDiscountTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const PromotionInputDtoDiscountTypeEnum PERCENT = _$promotionInputDtoDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const PromotionInputDtoDiscountTypeEnum AMOUNT = _$promotionInputDtoDiscountTypeEnum_AMOUNT;

  static Serializer<PromotionInputDtoDiscountTypeEnum> get serializer => _$promotionInputDtoDiscountTypeEnumSerializer;

  const PromotionInputDtoDiscountTypeEnum._(String name): super(name);

  static BuiltSet<PromotionInputDtoDiscountTypeEnum> get values => _$promotionInputDtoDiscountTypeEnumValues;
  static PromotionInputDtoDiscountTypeEnum valueOf(String name) => _$promotionInputDtoDiscountTypeEnumValueOf(name);
}

