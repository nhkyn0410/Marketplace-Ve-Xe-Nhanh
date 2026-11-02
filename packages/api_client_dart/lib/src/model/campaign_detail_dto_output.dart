//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/campaign_detail_dto_output_stats.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_detail_dto_output.g.dart';

/// CampaignDetailDtoOutput
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [title] 
/// * [body] 
/// * [audience] 
/// * [tiers] 
/// * [promotionId] 
/// * [promotionLabel] 
/// * [articleId] 
/// * [articleLabel] 
/// * [status] 
/// * [scheduledAt] 
/// * [startedAt] 
/// * [completedAt] 
/// * [cancelledAt] 
/// * [note] 
/// * [recipientCount] 
/// * [cappedCount] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [stats] 
@BuiltValue()
abstract class CampaignDetailDtoOutput implements Built<CampaignDetailDtoOutput, CampaignDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  CampaignDetailDtoOutputTypeEnum get type;
  // enum typeEnum {  SERVICE,  PROMOTION,  NEWS,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'audience')
  CampaignDetailDtoOutputAudienceEnum get audience;
  // enum audienceEnum {  ALL,  LOYALTY_TIER,  };

  @BuiltValueField(wireName: r'tiers')
  BuiltList<CampaignDetailDtoOutputTiersEnum> get tiers;
  // enum tiersEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'promotionId')
  String? get promotionId;

  @BuiltValueField(wireName: r'promotionLabel')
  String? get promotionLabel;

  @BuiltValueField(wireName: r'articleId')
  String? get articleId;

  @BuiltValueField(wireName: r'articleLabel')
  String? get articleLabel;

  @BuiltValueField(wireName: r'status')
  CampaignDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  SCHEDULED,  SENDING,  COMPLETED,  CANCELLED,  };

  @BuiltValueField(wireName: r'scheduledAt')
  DateTime? get scheduledAt;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'completedAt')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'cancelledAt')
  DateTime? get cancelledAt;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'recipientCount')
  int get recipientCount;

  @BuiltValueField(wireName: r'cappedCount')
  int get cappedCount;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'stats')
  CampaignDetailDtoOutputStats get stats;

  CampaignDetailDtoOutput._();

  factory CampaignDetailDtoOutput([void updates(CampaignDetailDtoOutputBuilder b)]) = _$CampaignDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignDetailDtoOutput> get serializer => _$CampaignDetailDtoOutputSerializer();
}

class _$CampaignDetailDtoOutputSerializer implements PrimitiveSerializer<CampaignDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [CampaignDetailDtoOutput, _$CampaignDetailDtoOutput];

  @override
  final String wireName = r'CampaignDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CampaignDetailDtoOutputTypeEnum),
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
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(CampaignDetailDtoOutputAudienceEnum),
    );
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(CampaignDetailDtoOutputTiersEnum)]),
    );
    yield r'promotionId';
    yield object.promotionId == null ? null : serializers.serialize(
      object.promotionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'promotionLabel';
    yield object.promotionLabel == null ? null : serializers.serialize(
      object.promotionLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'articleId';
    yield object.articleId == null ? null : serializers.serialize(
      object.articleId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'articleLabel';
    yield object.articleLabel == null ? null : serializers.serialize(
      object.articleLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CampaignDetailDtoOutputStatusEnum),
    );
    yield r'scheduledAt';
    yield object.scheduledAt == null ? null : serializers.serialize(
      object.scheduledAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'startedAt';
    yield object.startedAt == null ? null : serializers.serialize(
      object.startedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'completedAt';
    yield object.completedAt == null ? null : serializers.serialize(
      object.completedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'cancelledAt';
    yield object.cancelledAt == null ? null : serializers.serialize(
      object.cancelledAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'recipientCount';
    yield serializers.serialize(
      object.recipientCount,
      specifiedType: const FullType(int),
    );
    yield r'cappedCount';
    yield serializers.serialize(
      object.cappedCount,
      specifiedType: const FullType(int),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(CampaignDetailDtoOutputStats),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignDetailDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignDetailDtoOutputTypeEnum),
          ) as CampaignDetailDtoOutputTypeEnum;
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
            specifiedType: const FullType(CampaignDetailDtoOutputAudienceEnum),
          ) as CampaignDetailDtoOutputAudienceEnum;
          result.audience = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignDetailDtoOutputTiersEnum)]),
          ) as BuiltList<CampaignDetailDtoOutputTiersEnum>;
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
        case r'promotionLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.promotionLabel = valueDes;
          break;
        case r'articleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.articleId = valueDes;
          break;
        case r'articleLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.articleLabel = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignDetailDtoOutputStatusEnum),
          ) as CampaignDetailDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'scheduledAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.scheduledAt = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'completedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'cancelledAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.cancelledAt = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'recipientCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recipientCount = valueDes;
          break;
        case r'cappedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cappedCount = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignDetailDtoOutputStats),
          ) as CampaignDetailDtoOutputStats;
          result.stats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignDetailDtoOutputBuilder();
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


class CampaignDetailDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SERVICE')
  static const CampaignDetailDtoOutputTypeEnum SERVICE = _$campaignDetailDtoOutputTypeEnum_SERVICE;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const CampaignDetailDtoOutputTypeEnum PROMOTION = _$campaignDetailDtoOutputTypeEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'NEWS')
  static const CampaignDetailDtoOutputTypeEnum NEWS = _$campaignDetailDtoOutputTypeEnum_NEWS;

  static Serializer<CampaignDetailDtoOutputTypeEnum> get serializer => _$campaignDetailDtoOutputTypeEnumSerializer;

  const CampaignDetailDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<CampaignDetailDtoOutputTypeEnum> get values => _$campaignDetailDtoOutputTypeEnumValues;
  static CampaignDetailDtoOutputTypeEnum valueOf(String name) => _$campaignDetailDtoOutputTypeEnumValueOf(name);
}

class CampaignDetailDtoOutputAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL')
  static const CampaignDetailDtoOutputAudienceEnum ALL = _$campaignDetailDtoOutputAudienceEnum_ALL;
  @BuiltValueEnumConst(wireName: r'LOYALTY_TIER')
  static const CampaignDetailDtoOutputAudienceEnum LOYALTY_TIER = _$campaignDetailDtoOutputAudienceEnum_LOYALTY_TIER;

  static Serializer<CampaignDetailDtoOutputAudienceEnum> get serializer => _$campaignDetailDtoOutputAudienceEnumSerializer;

  const CampaignDetailDtoOutputAudienceEnum._(String name): super(name);

  static BuiltSet<CampaignDetailDtoOutputAudienceEnum> get values => _$campaignDetailDtoOutputAudienceEnumValues;
  static CampaignDetailDtoOutputAudienceEnum valueOf(String name) => _$campaignDetailDtoOutputAudienceEnumValueOf(name);
}

class CampaignDetailDtoOutputTiersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const CampaignDetailDtoOutputTiersEnum BRONZE = _$campaignDetailDtoOutputTiersEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const CampaignDetailDtoOutputTiersEnum SILVER = _$campaignDetailDtoOutputTiersEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const CampaignDetailDtoOutputTiersEnum GOLD = _$campaignDetailDtoOutputTiersEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const CampaignDetailDtoOutputTiersEnum PLATINUM = _$campaignDetailDtoOutputTiersEnum_PLATINUM;

  static Serializer<CampaignDetailDtoOutputTiersEnum> get serializer => _$campaignDetailDtoOutputTiersEnumSerializer;

  const CampaignDetailDtoOutputTiersEnum._(String name): super(name);

  static BuiltSet<CampaignDetailDtoOutputTiersEnum> get values => _$campaignDetailDtoOutputTiersEnumValues;
  static CampaignDetailDtoOutputTiersEnum valueOf(String name) => _$campaignDetailDtoOutputTiersEnumValueOf(name);
}

class CampaignDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const CampaignDetailDtoOutputStatusEnum DRAFT = _$campaignDetailDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const CampaignDetailDtoOutputStatusEnum SCHEDULED = _$campaignDetailDtoOutputStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'SENDING')
  static const CampaignDetailDtoOutputStatusEnum SENDING = _$campaignDetailDtoOutputStatusEnum_SENDING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const CampaignDetailDtoOutputStatusEnum COMPLETED = _$campaignDetailDtoOutputStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CampaignDetailDtoOutputStatusEnum CANCELLED = _$campaignDetailDtoOutputStatusEnum_CANCELLED;

  static Serializer<CampaignDetailDtoOutputStatusEnum> get serializer => _$campaignDetailDtoOutputStatusEnumSerializer;

  const CampaignDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CampaignDetailDtoOutputStatusEnum> get values => _$campaignDetailDtoOutputStatusEnumValues;
  static CampaignDetailDtoOutputStatusEnum valueOf(String name) => _$campaignDetailDtoOutputStatusEnumValueOf(name);
}

