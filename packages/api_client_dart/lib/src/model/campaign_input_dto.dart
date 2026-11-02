//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_input_dto.g.dart';

/// CampaignInputDto
///
/// Properties:
/// * [type] 
/// * [title] 
/// * [body] 
/// * [audience] 
/// * [tiers] 
/// * [promotionId] 
/// * [articleId] 
@BuiltValue()
abstract class CampaignInputDto implements Built<CampaignInputDto, CampaignInputDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  CampaignInputDtoTypeEnum get type;
  // enum typeEnum {  SERVICE,  PROMOTION,  NEWS,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'audience')
  CampaignInputDtoAudienceEnum? get audience;
  // enum audienceEnum {  ALL,  LOYALTY_TIER,  };

  @BuiltValueField(wireName: r'tiers')
  BuiltList<CampaignInputDtoTiersEnum> get tiers;
  // enum tiersEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'promotionId')
  String? get promotionId;

  @BuiltValueField(wireName: r'articleId')
  String? get articleId;

  CampaignInputDto._();

  factory CampaignInputDto([void updates(CampaignInputDtoBuilder b)]) = _$CampaignInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignInputDtoBuilder b) => b
      ..audience = CampaignInputDtoAudienceEnum.valueOf('ALL');

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignInputDto> get serializer => _$CampaignInputDtoSerializer();
}

class _$CampaignInputDtoSerializer implements PrimitiveSerializer<CampaignInputDto> {
  @override
  final Iterable<Type> types = const [CampaignInputDto, _$CampaignInputDto];

  @override
  final String wireName = r'CampaignInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CampaignInputDtoTypeEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    if (object.audience != null) {
      yield r'audience';
      yield serializers.serialize(
        object.audience,
        specifiedType: const FullType(CampaignInputDtoAudienceEnum),
      );
    }
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(CampaignInputDtoTiersEnum)]),
    );
    if (object.promotionId != null) {
      yield r'promotionId';
      yield serializers.serialize(
        object.promotionId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.articleId != null) {
      yield r'articleId';
      yield serializers.serialize(
        object.articleId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignInputDtoTypeEnum),
          ) as CampaignInputDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CampaignInputDtoAudienceEnum),
          ) as CampaignInputDtoAudienceEnum?;
          if (valueDes == null) continue;
          result.audience = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignInputDtoTiersEnum)]),
          ) as BuiltList<CampaignInputDtoTiersEnum>;
          result.tiers.replace(valueDes);
          break;
        case r'promotionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.promotionId = valueDes;
          break;
        case r'articleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.articleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignInputDtoBuilder();
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


class CampaignInputDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SERVICE')
  static const CampaignInputDtoTypeEnum SERVICE = _$campaignInputDtoTypeEnum_SERVICE;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const CampaignInputDtoTypeEnum PROMOTION = _$campaignInputDtoTypeEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'NEWS')
  static const CampaignInputDtoTypeEnum NEWS = _$campaignInputDtoTypeEnum_NEWS;

  static Serializer<CampaignInputDtoTypeEnum> get serializer => _$campaignInputDtoTypeEnumSerializer;

  const CampaignInputDtoTypeEnum._(String name): super(name);

  static BuiltSet<CampaignInputDtoTypeEnum> get values => _$campaignInputDtoTypeEnumValues;
  static CampaignInputDtoTypeEnum valueOf(String name) => _$campaignInputDtoTypeEnumValueOf(name);
}

class CampaignInputDtoAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL')
  static const CampaignInputDtoAudienceEnum ALL = _$campaignInputDtoAudienceEnum_ALL;
  @BuiltValueEnumConst(wireName: r'LOYALTY_TIER')
  static const CampaignInputDtoAudienceEnum LOYALTY_TIER = _$campaignInputDtoAudienceEnum_LOYALTY_TIER;

  static Serializer<CampaignInputDtoAudienceEnum> get serializer => _$campaignInputDtoAudienceEnumSerializer;

  const CampaignInputDtoAudienceEnum._(String name): super(name);

  static BuiltSet<CampaignInputDtoAudienceEnum> get values => _$campaignInputDtoAudienceEnumValues;
  static CampaignInputDtoAudienceEnum valueOf(String name) => _$campaignInputDtoAudienceEnumValueOf(name);
}

class CampaignInputDtoTiersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const CampaignInputDtoTiersEnum BRONZE = _$campaignInputDtoTiersEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const CampaignInputDtoTiersEnum SILVER = _$campaignInputDtoTiersEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const CampaignInputDtoTiersEnum GOLD = _$campaignInputDtoTiersEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const CampaignInputDtoTiersEnum PLATINUM = _$campaignInputDtoTiersEnum_PLATINUM;

  static Serializer<CampaignInputDtoTiersEnum> get serializer => _$campaignInputDtoTiersEnumSerializer;

  const CampaignInputDtoTiersEnum._(String name): super(name);

  static BuiltSet<CampaignInputDtoTiersEnum> get values => _$campaignInputDtoTiersEnumValues;
  static CampaignInputDtoTiersEnum valueOf(String name) => _$campaignInputDtoTiersEnumValueOf(name);
}

