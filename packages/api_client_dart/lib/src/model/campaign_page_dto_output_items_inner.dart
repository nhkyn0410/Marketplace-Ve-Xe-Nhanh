//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_page_dto_output_items_inner.g.dart';

/// CampaignPageDtoOutputItemsInner
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
@BuiltValue()
abstract class CampaignPageDtoOutputItemsInner implements Built<CampaignPageDtoOutputItemsInner, CampaignPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  CampaignPageDtoOutputItemsInnerTypeEnum get type;
  // enum typeEnum {  SERVICE,  PROMOTION,  NEWS,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'audience')
  CampaignPageDtoOutputItemsInnerAudienceEnum get audience;
  // enum audienceEnum {  ALL,  LOYALTY_TIER,  };

  @BuiltValueField(wireName: r'tiers')
  BuiltList<CampaignPageDtoOutputItemsInnerTiersEnum> get tiers;
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
  CampaignPageDtoOutputItemsInnerStatusEnum get status;
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

  CampaignPageDtoOutputItemsInner._();

  factory CampaignPageDtoOutputItemsInner([void updates(CampaignPageDtoOutputItemsInnerBuilder b)]) = _$CampaignPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignPageDtoOutputItemsInner> get serializer => _$CampaignPageDtoOutputItemsInnerSerializer();
}

class _$CampaignPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<CampaignPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [CampaignPageDtoOutputItemsInner, _$CampaignPageDtoOutputItemsInner];

  @override
  final String wireName = r'CampaignPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(CampaignPageDtoOutputItemsInnerTypeEnum),
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
      specifiedType: const FullType(CampaignPageDtoOutputItemsInnerAudienceEnum),
    );
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(CampaignPageDtoOutputItemsInnerTiersEnum)]),
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
      specifiedType: const FullType(CampaignPageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(CampaignPageDtoOutputItemsInnerTypeEnum),
          ) as CampaignPageDtoOutputItemsInnerTypeEnum;
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
            specifiedType: const FullType(CampaignPageDtoOutputItemsInnerAudienceEnum),
          ) as CampaignPageDtoOutputItemsInnerAudienceEnum;
          result.audience = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignPageDtoOutputItemsInnerTiersEnum)]),
          ) as BuiltList<CampaignPageDtoOutputItemsInnerTiersEnum>;
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
            specifiedType: const FullType(CampaignPageDtoOutputItemsInnerStatusEnum),
          ) as CampaignPageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignPageDtoOutputItemsInnerBuilder();
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


class CampaignPageDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SERVICE')
  static const CampaignPageDtoOutputItemsInnerTypeEnum SERVICE = _$campaignPageDtoOutputItemsInnerTypeEnum_SERVICE;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const CampaignPageDtoOutputItemsInnerTypeEnum PROMOTION = _$campaignPageDtoOutputItemsInnerTypeEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'NEWS')
  static const CampaignPageDtoOutputItemsInnerTypeEnum NEWS = _$campaignPageDtoOutputItemsInnerTypeEnum_NEWS;

  static Serializer<CampaignPageDtoOutputItemsInnerTypeEnum> get serializer => _$campaignPageDtoOutputItemsInnerTypeEnumSerializer;

  const CampaignPageDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<CampaignPageDtoOutputItemsInnerTypeEnum> get values => _$campaignPageDtoOutputItemsInnerTypeEnumValues;
  static CampaignPageDtoOutputItemsInnerTypeEnum valueOf(String name) => _$campaignPageDtoOutputItemsInnerTypeEnumValueOf(name);
}

class CampaignPageDtoOutputItemsInnerAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL')
  static const CampaignPageDtoOutputItemsInnerAudienceEnum ALL = _$campaignPageDtoOutputItemsInnerAudienceEnum_ALL;
  @BuiltValueEnumConst(wireName: r'LOYALTY_TIER')
  static const CampaignPageDtoOutputItemsInnerAudienceEnum LOYALTY_TIER = _$campaignPageDtoOutputItemsInnerAudienceEnum_LOYALTY_TIER;

  static Serializer<CampaignPageDtoOutputItemsInnerAudienceEnum> get serializer => _$campaignPageDtoOutputItemsInnerAudienceEnumSerializer;

  const CampaignPageDtoOutputItemsInnerAudienceEnum._(String name): super(name);

  static BuiltSet<CampaignPageDtoOutputItemsInnerAudienceEnum> get values => _$campaignPageDtoOutputItemsInnerAudienceEnumValues;
  static CampaignPageDtoOutputItemsInnerAudienceEnum valueOf(String name) => _$campaignPageDtoOutputItemsInnerAudienceEnumValueOf(name);
}

class CampaignPageDtoOutputItemsInnerTiersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const CampaignPageDtoOutputItemsInnerTiersEnum BRONZE = _$campaignPageDtoOutputItemsInnerTiersEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const CampaignPageDtoOutputItemsInnerTiersEnum SILVER = _$campaignPageDtoOutputItemsInnerTiersEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const CampaignPageDtoOutputItemsInnerTiersEnum GOLD = _$campaignPageDtoOutputItemsInnerTiersEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const CampaignPageDtoOutputItemsInnerTiersEnum PLATINUM = _$campaignPageDtoOutputItemsInnerTiersEnum_PLATINUM;

  static Serializer<CampaignPageDtoOutputItemsInnerTiersEnum> get serializer => _$campaignPageDtoOutputItemsInnerTiersEnumSerializer;

  const CampaignPageDtoOutputItemsInnerTiersEnum._(String name): super(name);

  static BuiltSet<CampaignPageDtoOutputItemsInnerTiersEnum> get values => _$campaignPageDtoOutputItemsInnerTiersEnumValues;
  static CampaignPageDtoOutputItemsInnerTiersEnum valueOf(String name) => _$campaignPageDtoOutputItemsInnerTiersEnumValueOf(name);
}

class CampaignPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const CampaignPageDtoOutputItemsInnerStatusEnum DRAFT = _$campaignPageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const CampaignPageDtoOutputItemsInnerStatusEnum SCHEDULED = _$campaignPageDtoOutputItemsInnerStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'SENDING')
  static const CampaignPageDtoOutputItemsInnerStatusEnum SENDING = _$campaignPageDtoOutputItemsInnerStatusEnum_SENDING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const CampaignPageDtoOutputItemsInnerStatusEnum COMPLETED = _$campaignPageDtoOutputItemsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CampaignPageDtoOutputItemsInnerStatusEnum CANCELLED = _$campaignPageDtoOutputItemsInnerStatusEnum_CANCELLED;

  static Serializer<CampaignPageDtoOutputItemsInnerStatusEnum> get serializer => _$campaignPageDtoOutputItemsInnerStatusEnumSerializer;

  const CampaignPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CampaignPageDtoOutputItemsInnerStatusEnum> get values => _$campaignPageDtoOutputItemsInnerStatusEnumValues;
  static CampaignPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$campaignPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

