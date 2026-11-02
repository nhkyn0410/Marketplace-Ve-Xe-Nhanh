//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_options_dto_output_promotions_inner.g.dart';

/// CampaignOptionsDtoOutputPromotionsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [endsAt] 
@BuiltValue()
abstract class CampaignOptionsDtoOutputPromotionsInner implements Built<CampaignOptionsDtoOutputPromotionsInner, CampaignOptionsDtoOutputPromotionsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  CampaignOptionsDtoOutputPromotionsInner._();

  factory CampaignOptionsDtoOutputPromotionsInner([void updates(CampaignOptionsDtoOutputPromotionsInnerBuilder b)]) = _$CampaignOptionsDtoOutputPromotionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignOptionsDtoOutputPromotionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignOptionsDtoOutputPromotionsInner> get serializer => _$CampaignOptionsDtoOutputPromotionsInnerSerializer();
}

class _$CampaignOptionsDtoOutputPromotionsInnerSerializer implements PrimitiveSerializer<CampaignOptionsDtoOutputPromotionsInner> {
  @override
  final Iterable<Type> types = const [CampaignOptionsDtoOutputPromotionsInner, _$CampaignOptionsDtoOutputPromotionsInner];

  @override
  final String wireName = r'CampaignOptionsDtoOutputPromotionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignOptionsDtoOutputPromotionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignOptionsDtoOutputPromotionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignOptionsDtoOutputPromotionsInnerBuilder result,
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
  CampaignOptionsDtoOutputPromotionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignOptionsDtoOutputPromotionsInnerBuilder();
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


