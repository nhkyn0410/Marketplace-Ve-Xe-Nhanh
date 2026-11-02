//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/campaign_options_dto_output_promotions_inner.dart';
import 'package:api_client_dart/src/model/campaign_options_dto_output_articles_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_options_dto_output.g.dart';

/// CampaignOptionsDtoOutput
///
/// Properties:
/// * [promotions] 
/// * [articles] 
@BuiltValue()
abstract class CampaignOptionsDtoOutput implements Built<CampaignOptionsDtoOutput, CampaignOptionsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'promotions')
  BuiltList<CampaignOptionsDtoOutputPromotionsInner> get promotions;

  @BuiltValueField(wireName: r'articles')
  BuiltList<CampaignOptionsDtoOutputArticlesInner> get articles;

  CampaignOptionsDtoOutput._();

  factory CampaignOptionsDtoOutput([void updates(CampaignOptionsDtoOutputBuilder b)]) = _$CampaignOptionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignOptionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignOptionsDtoOutput> get serializer => _$CampaignOptionsDtoOutputSerializer();
}

class _$CampaignOptionsDtoOutputSerializer implements PrimitiveSerializer<CampaignOptionsDtoOutput> {
  @override
  final Iterable<Type> types = const [CampaignOptionsDtoOutput, _$CampaignOptionsDtoOutput];

  @override
  final String wireName = r'CampaignOptionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignOptionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'promotions';
    yield serializers.serialize(
      object.promotions,
      specifiedType: const FullType(BuiltList, [FullType(CampaignOptionsDtoOutputPromotionsInner)]),
    );
    yield r'articles';
    yield serializers.serialize(
      object.articles,
      specifiedType: const FullType(BuiltList, [FullType(CampaignOptionsDtoOutputArticlesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignOptionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignOptionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'promotions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignOptionsDtoOutputPromotionsInner)]),
          ) as BuiltList<CampaignOptionsDtoOutputPromotionsInner>;
          result.promotions.replace(valueDes);
          break;
        case r'articles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignOptionsDtoOutputArticlesInner)]),
          ) as BuiltList<CampaignOptionsDtoOutputArticlesInner>;
          result.articles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignOptionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignOptionsDtoOutputBuilder();
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


