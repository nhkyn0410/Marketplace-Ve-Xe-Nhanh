//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_test_input_dto.g.dart';

/// CampaignTestInputDto
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class CampaignTestInputDto implements Built<CampaignTestInputDto, CampaignTestInputDtoBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  CampaignTestInputDto._();

  factory CampaignTestInputDto([void updates(CampaignTestInputDtoBuilder b)]) = _$CampaignTestInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignTestInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignTestInputDto> get serializer => _$CampaignTestInputDtoSerializer();
}

class _$CampaignTestInputDtoSerializer implements PrimitiveSerializer<CampaignTestInputDto> {
  @override
  final Iterable<Type> types = const [CampaignTestInputDto, _$CampaignTestInputDto];

  @override
  final String wireName = r'CampaignTestInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignTestInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignTestInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignTestInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignTestInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignTestInputDtoBuilder();
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


