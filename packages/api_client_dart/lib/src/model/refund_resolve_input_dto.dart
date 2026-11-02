//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'refund_resolve_input_dto.g.dart';

/// RefundResolveInputDto
///
/// Properties:
/// * [reference] 
/// * [reason] 
@BuiltValue()
abstract class RefundResolveInputDto implements Built<RefundResolveInputDto, RefundResolveInputDtoBuilder> {
  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  RefundResolveInputDto._();

  factory RefundResolveInputDto([void updates(RefundResolveInputDtoBuilder b)]) = _$RefundResolveInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RefundResolveInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RefundResolveInputDto> get serializer => _$RefundResolveInputDtoSerializer();
}

class _$RefundResolveInputDtoSerializer implements PrimitiveSerializer<RefundResolveInputDto> {
  @override
  final Iterable<Type> types = const [RefundResolveInputDto, _$RefundResolveInputDto];

  @override
  final String wireName = r'RefundResolveInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RefundResolveInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
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
    RefundResolveInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RefundResolveInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
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
  RefundResolveInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RefundResolveInputDtoBuilder();
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


