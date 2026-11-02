//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_promotion_list_dto_output_items_inner.g.dart';

/// PublicPromotionListDtoOutputItemsInner
///
/// Properties:
/// * [code] 
/// * [name] 
/// * [scope] 
/// * [operatorName] 
/// * [discountType] 
/// * [discountValue] 
/// * [maxDiscount] 
/// * [minOrder] 
/// * [endsAt] 
@BuiltValue()
abstract class PublicPromotionListDtoOutputItemsInner implements Built<PublicPromotionListDtoOutputItemsInner, PublicPromotionListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'scope')
  PublicPromotionListDtoOutputItemsInnerScopeEnum get scope;
  // enum scopeEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'operatorName')
  String? get operatorName;

  @BuiltValueField(wireName: r'discountType')
  PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum get discountType;
  // enum discountTypeEnum {  PERCENT,  AMOUNT,  };

  @BuiltValueField(wireName: r'discountValue')
  int get discountValue;

  @BuiltValueField(wireName: r'maxDiscount')
  int? get maxDiscount;

  @BuiltValueField(wireName: r'minOrder')
  int get minOrder;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  PublicPromotionListDtoOutputItemsInner._();

  factory PublicPromotionListDtoOutputItemsInner([void updates(PublicPromotionListDtoOutputItemsInnerBuilder b)]) = _$PublicPromotionListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicPromotionListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicPromotionListDtoOutputItemsInner> get serializer => _$PublicPromotionListDtoOutputItemsInnerSerializer();
}

class _$PublicPromotionListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PublicPromotionListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PublicPromotionListDtoOutputItemsInner, _$PublicPromotionListDtoOutputItemsInner];

  @override
  final String wireName = r'PublicPromotionListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicPromotionListDtoOutputItemsInner object, {
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
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(PublicPromotionListDtoOutputItemsInnerScopeEnum),
    );
    yield r'operatorName';
    yield object.operatorName == null ? null : serializers.serialize(
      object.operatorName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'discountType';
    yield serializers.serialize(
      object.discountType,
      specifiedType: const FullType(PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum),
    );
    yield r'discountValue';
    yield serializers.serialize(
      object.discountValue,
      specifiedType: const FullType(int),
    );
    yield r'maxDiscount';
    yield object.maxDiscount == null ? null : serializers.serialize(
      object.maxDiscount,
      specifiedType: const FullType.nullable(int),
    );
    yield r'minOrder';
    yield serializers.serialize(
      object.minOrder,
      specifiedType: const FullType(int),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicPromotionListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicPromotionListDtoOutputItemsInnerBuilder result,
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
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicPromotionListDtoOutputItemsInnerScopeEnum),
          ) as PublicPromotionListDtoOutputItemsInnerScopeEnum;
          result.scope = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorName = valueDes;
          break;
        case r'discountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum),
          ) as PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum;
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
            specifiedType: const FullType(int),
          ) as int;
          result.minOrder = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicPromotionListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicPromotionListDtoOutputItemsInnerBuilder();
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


class PublicPromotionListDtoOutputItemsInnerScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const PublicPromotionListDtoOutputItemsInnerScopeEnum PLATFORM = _$publicPromotionListDtoOutputItemsInnerScopeEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const PublicPromotionListDtoOutputItemsInnerScopeEnum OPERATOR = _$publicPromotionListDtoOutputItemsInnerScopeEnum_OPERATOR;

  static Serializer<PublicPromotionListDtoOutputItemsInnerScopeEnum> get serializer => _$publicPromotionListDtoOutputItemsInnerScopeEnumSerializer;

  const PublicPromotionListDtoOutputItemsInnerScopeEnum._(String name): super(name);

  static BuiltSet<PublicPromotionListDtoOutputItemsInnerScopeEnum> get values => _$publicPromotionListDtoOutputItemsInnerScopeEnumValues;
  static PublicPromotionListDtoOutputItemsInnerScopeEnum valueOf(String name) => _$publicPromotionListDtoOutputItemsInnerScopeEnumValueOf(name);
}

class PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PERCENT')
  static const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum PERCENT = _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_PERCENT;
  @BuiltValueEnumConst(wireName: r'AMOUNT')
  static const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum AMOUNT = _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnum_AMOUNT;

  static Serializer<PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum> get serializer => _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumSerializer;

  const PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum._(String name): super(name);

  static BuiltSet<PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum> get values => _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumValues;
  static PublicPromotionListDtoOutputItemsInnerDiscountTypeEnum valueOf(String name) => _$publicPromotionListDtoOutputItemsInnerDiscountTypeEnumValueOf(name);
}

