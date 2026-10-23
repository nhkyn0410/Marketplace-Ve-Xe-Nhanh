//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_suspend_dto.g.dart';

/// AdminOperatorSuspendDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class AdminOperatorSuspendDto implements Built<AdminOperatorSuspendDto, AdminOperatorSuspendDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminOperatorSuspendDto._();

  factory AdminOperatorSuspendDto([void updates(AdminOperatorSuspendDtoBuilder b)]) = _$AdminOperatorSuspendDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorSuspendDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorSuspendDto> get serializer => _$AdminOperatorSuspendDtoSerializer();
}

class _$AdminOperatorSuspendDtoSerializer implements PrimitiveSerializer<AdminOperatorSuspendDto> {
  @override
  final Iterable<Type> types = const [AdminOperatorSuspendDto, _$AdminOperatorSuspendDto];

  @override
  final String wireName = r'AdminOperatorSuspendDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorSuspendDto object, {
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
    AdminOperatorSuspendDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorSuspendDtoBuilder result,
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
  AdminOperatorSuspendDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorSuspendDtoBuilder();
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


