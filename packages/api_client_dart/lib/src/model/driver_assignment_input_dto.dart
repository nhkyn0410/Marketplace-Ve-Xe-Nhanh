//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'driver_assignment_input_dto.g.dart';

/// DriverAssignmentInputDto
///
/// Properties:
/// * [employeeId] 
/// * [reason] 
@BuiltValue()
abstract class DriverAssignmentInputDto implements Built<DriverAssignmentInputDto, DriverAssignmentInputDtoBuilder> {
  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  DriverAssignmentInputDto._();

  factory DriverAssignmentInputDto([void updates(DriverAssignmentInputDtoBuilder b)]) = _$DriverAssignmentInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DriverAssignmentInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DriverAssignmentInputDto> get serializer => _$DriverAssignmentInputDtoSerializer();
}

class _$DriverAssignmentInputDtoSerializer implements PrimitiveSerializer<DriverAssignmentInputDto> {
  @override
  final Iterable<Type> types = const [DriverAssignmentInputDto, _$DriverAssignmentInputDto];

  @override
  final String wireName = r'DriverAssignmentInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DriverAssignmentInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield object.employeeId == null ? null : serializers.serialize(
      object.employeeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DriverAssignmentInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DriverAssignmentInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.employeeId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  DriverAssignmentInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DriverAssignmentInputDtoBuilder();
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


