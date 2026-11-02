//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_send_input_dto.g.dart';

/// CampaignSendInputDto
///
/// Properties:
/// * [scheduledAt] 
@BuiltValue()
abstract class CampaignSendInputDto implements Built<CampaignSendInputDto, CampaignSendInputDtoBuilder> {
  @BuiltValueField(wireName: r'scheduledAt')
  DateTime? get scheduledAt;

  CampaignSendInputDto._();

  factory CampaignSendInputDto([void updates(CampaignSendInputDtoBuilder b)]) = _$CampaignSendInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignSendInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignSendInputDto> get serializer => _$CampaignSendInputDtoSerializer();
}

class _$CampaignSendInputDtoSerializer implements PrimitiveSerializer<CampaignSendInputDto> {
  @override
  final Iterable<Type> types = const [CampaignSendInputDto, _$CampaignSendInputDto];

  @override
  final String wireName = r'CampaignSendInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignSendInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.scheduledAt != null) {
      yield r'scheduledAt';
      yield serializers.serialize(
        object.scheduledAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignSendInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignSendInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scheduledAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.scheduledAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignSendInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignSendInputDtoBuilder();
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


