//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_redemption_input_dto.g.dart';

/// LoyaltyRedemptionInputDto
///
/// Properties:
/// * [points]
@BuiltValue()
abstract class LoyaltyRedemptionInputDto
    implements
        Built<LoyaltyRedemptionInputDto, LoyaltyRedemptionInputDtoBuilder> {
  @BuiltValueField(wireName: r'points')
  int get points;

  LoyaltyRedemptionInputDto._();

  factory LoyaltyRedemptionInputDto(
          [void updates(LoyaltyRedemptionInputDtoBuilder b)]) =
      _$LoyaltyRedemptionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyRedemptionInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyRedemptionInputDto> get serializer =>
      _$LoyaltyRedemptionInputDtoSerializer();
}

class _$LoyaltyRedemptionInputDtoSerializer
    implements PrimitiveSerializer<LoyaltyRedemptionInputDto> {
  @override
  final Iterable<Type> types = const [
    LoyaltyRedemptionInputDto,
    _$LoyaltyRedemptionInputDto
  ];

  @override
  final String wireName = r'LoyaltyRedemptionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyRedemptionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoyaltyRedemptionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyRedemptionInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.points = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoyaltyRedemptionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyRedemptionInputDtoBuilder();
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
