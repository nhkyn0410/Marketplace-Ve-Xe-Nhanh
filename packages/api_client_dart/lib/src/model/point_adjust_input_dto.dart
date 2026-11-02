//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'point_adjust_input_dto.g.dart';

/// PointAdjustInputDto
///
/// Properties:
/// * [direction] 
/// * [points] 
/// * [reason] 
@BuiltValue()
abstract class PointAdjustInputDto implements Built<PointAdjustInputDto, PointAdjustInputDtoBuilder> {
  @BuiltValueField(wireName: r'direction')
  PointAdjustInputDtoDirectionEnum get direction;
  // enum directionEnum {  CREDIT,  DEBIT,  };

  @BuiltValueField(wireName: r'points')
  int get points;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  PointAdjustInputDto._();

  factory PointAdjustInputDto([void updates(PointAdjustInputDtoBuilder b)]) = _$PointAdjustInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PointAdjustInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PointAdjustInputDto> get serializer => _$PointAdjustInputDtoSerializer();
}

class _$PointAdjustInputDtoSerializer implements PrimitiveSerializer<PointAdjustInputDto> {
  @override
  final Iterable<Type> types = const [PointAdjustInputDto, _$PointAdjustInputDto];

  @override
  final String wireName = r'PointAdjustInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PointAdjustInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(PointAdjustInputDtoDirectionEnum),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PointAdjustInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PointAdjustInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PointAdjustInputDtoDirectionEnum),
          ) as PointAdjustInputDtoDirectionEnum;
          result.direction = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.points = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PointAdjustInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PointAdjustInputDtoBuilder();
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


class PointAdjustInputDtoDirectionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CREDIT')
  static const PointAdjustInputDtoDirectionEnum CREDIT = _$pointAdjustInputDtoDirectionEnum_CREDIT;
  @BuiltValueEnumConst(wireName: r'DEBIT')
  static const PointAdjustInputDtoDirectionEnum DEBIT = _$pointAdjustInputDtoDirectionEnum_DEBIT;

  static Serializer<PointAdjustInputDtoDirectionEnum> get serializer => _$pointAdjustInputDtoDirectionEnumSerializer;

  const PointAdjustInputDtoDirectionEnum._(String name): super(name);

  static BuiltSet<PointAdjustInputDtoDirectionEnum> get values => _$pointAdjustInputDtoDirectionEnumValues;
  static PointAdjustInputDtoDirectionEnum valueOf(String name) => _$pointAdjustInputDtoDirectionEnumValueOf(name);
}

