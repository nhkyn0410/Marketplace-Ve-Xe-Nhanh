//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audience_input_dto.g.dart';

/// AudienceInputDto
///
/// Properties:
/// * [type] 
/// * [audience] 
/// * [tiers] 
@BuiltValue()
abstract class AudienceInputDto implements Built<AudienceInputDto, AudienceInputDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  AudienceInputDtoTypeEnum get type;
  // enum typeEnum {  SERVICE,  PROMOTION,  NEWS,  };

  @BuiltValueField(wireName: r'audience')
  AudienceInputDtoAudienceEnum? get audience;
  // enum audienceEnum {  ALL,  LOYALTY_TIER,  };

  @BuiltValueField(wireName: r'tiers')
  BuiltList<AudienceInputDtoTiersEnum> get tiers;
  // enum tiersEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  AudienceInputDto._();

  factory AudienceInputDto([void updates(AudienceInputDtoBuilder b)]) = _$AudienceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AudienceInputDtoBuilder b) => b
      ..audience = AudienceInputDtoAudienceEnum.valueOf('ALL');

  @BuiltValueSerializer(custom: true)
  static Serializer<AudienceInputDto> get serializer => _$AudienceInputDtoSerializer();
}

class _$AudienceInputDtoSerializer implements PrimitiveSerializer<AudienceInputDto> {
  @override
  final Iterable<Type> types = const [AudienceInputDto, _$AudienceInputDto];

  @override
  final String wireName = r'AudienceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AudienceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AudienceInputDtoTypeEnum),
    );
    if (object.audience != null) {
      yield r'audience';
      yield serializers.serialize(
        object.audience,
        specifiedType: const FullType(AudienceInputDtoAudienceEnum),
      );
    }
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(AudienceInputDtoTiersEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AudienceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AudienceInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AudienceInputDtoTypeEnum),
          ) as AudienceInputDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AudienceInputDtoAudienceEnum),
          ) as AudienceInputDtoAudienceEnum?;
          if (valueDes == null) continue;
          result.audience = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AudienceInputDtoTiersEnum)]),
          ) as BuiltList<AudienceInputDtoTiersEnum>;
          result.tiers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AudienceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AudienceInputDtoBuilder();
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


class AudienceInputDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SERVICE')
  static const AudienceInputDtoTypeEnum SERVICE = _$audienceInputDtoTypeEnum_SERVICE;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const AudienceInputDtoTypeEnum PROMOTION = _$audienceInputDtoTypeEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'NEWS')
  static const AudienceInputDtoTypeEnum NEWS = _$audienceInputDtoTypeEnum_NEWS;

  static Serializer<AudienceInputDtoTypeEnum> get serializer => _$audienceInputDtoTypeEnumSerializer;

  const AudienceInputDtoTypeEnum._(String name): super(name);

  static BuiltSet<AudienceInputDtoTypeEnum> get values => _$audienceInputDtoTypeEnumValues;
  static AudienceInputDtoTypeEnum valueOf(String name) => _$audienceInputDtoTypeEnumValueOf(name);
}

class AudienceInputDtoAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL')
  static const AudienceInputDtoAudienceEnum ALL = _$audienceInputDtoAudienceEnum_ALL;
  @BuiltValueEnumConst(wireName: r'LOYALTY_TIER')
  static const AudienceInputDtoAudienceEnum LOYALTY_TIER = _$audienceInputDtoAudienceEnum_LOYALTY_TIER;

  static Serializer<AudienceInputDtoAudienceEnum> get serializer => _$audienceInputDtoAudienceEnumSerializer;

  const AudienceInputDtoAudienceEnum._(String name): super(name);

  static BuiltSet<AudienceInputDtoAudienceEnum> get values => _$audienceInputDtoAudienceEnumValues;
  static AudienceInputDtoAudienceEnum valueOf(String name) => _$audienceInputDtoAudienceEnumValueOf(name);
}

class AudienceInputDtoTiersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const AudienceInputDtoTiersEnum BRONZE = _$audienceInputDtoTiersEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const AudienceInputDtoTiersEnum SILVER = _$audienceInputDtoTiersEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const AudienceInputDtoTiersEnum GOLD = _$audienceInputDtoTiersEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const AudienceInputDtoTiersEnum PLATINUM = _$audienceInputDtoTiersEnum_PLATINUM;

  static Serializer<AudienceInputDtoTiersEnum> get serializer => _$audienceInputDtoTiersEnumSerializer;

  const AudienceInputDtoTiersEnum._(String name): super(name);

  static BuiltSet<AudienceInputDtoTiersEnum> get values => _$audienceInputDtoTiersEnumValues;
  static AudienceInputDtoTiersEnum valueOf(String name) => _$audienceInputDtoTiersEnumValueOf(name);
}

