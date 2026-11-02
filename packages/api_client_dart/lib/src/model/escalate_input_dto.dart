//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'escalate_input_dto.g.dart';

/// EscalateInputDto
///
/// Properties:
/// * [title] 
/// * [customerRequest] 
/// * [reason] 
@BuiltValue()
abstract class EscalateInputDto implements Built<EscalateInputDto, EscalateInputDtoBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'customerRequest')
  String? get customerRequest;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  EscalateInputDto._();

  factory EscalateInputDto([void updates(EscalateInputDtoBuilder b)]) = _$EscalateInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EscalateInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EscalateInputDto> get serializer => _$EscalateInputDtoSerializer();
}

class _$EscalateInputDtoSerializer implements PrimitiveSerializer<EscalateInputDto> {
  @override
  final Iterable<Type> types = const [EscalateInputDto, _$EscalateInputDto];

  @override
  final String wireName = r'EscalateInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EscalateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.customerRequest != null) {
      yield r'customerRequest';
      yield serializers.serialize(
        object.customerRequest,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EscalateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EscalateInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'customerRequest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customerRequest = valueDes;
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
  EscalateInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EscalateInputDtoBuilder();
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


