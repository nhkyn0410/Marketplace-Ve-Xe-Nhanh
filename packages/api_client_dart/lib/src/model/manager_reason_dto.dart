//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_reason_dto.g.dart';

/// ManagerReasonDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class ManagerReasonDto implements Built<ManagerReasonDto, ManagerReasonDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  ManagerReasonDto._();

  factory ManagerReasonDto([void updates(ManagerReasonDtoBuilder b)]) = _$ManagerReasonDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerReasonDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerReasonDto> get serializer => _$ManagerReasonDtoSerializer();
}

class _$ManagerReasonDtoSerializer implements PrimitiveSerializer<ManagerReasonDto> {
  @override
  final Iterable<Type> types = const [ManagerReasonDto, _$ManagerReasonDto];

  @override
  final String wireName = r'ManagerReasonDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerReasonDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ManagerReasonDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerReasonDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  ManagerReasonDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerReasonDtoBuilder();
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


