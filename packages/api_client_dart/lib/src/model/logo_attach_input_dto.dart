//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'logo_attach_input_dto.g.dart';

/// LogoAttachInputDto
///
/// Properties:
/// * [objectKey] 
@BuiltValue()
abstract class LogoAttachInputDto implements Built<LogoAttachInputDto, LogoAttachInputDtoBuilder> {
  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  LogoAttachInputDto._();

  factory LogoAttachInputDto([void updates(LogoAttachInputDtoBuilder b)]) = _$LogoAttachInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LogoAttachInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LogoAttachInputDto> get serializer => _$LogoAttachInputDtoSerializer();
}

class _$LogoAttachInputDtoSerializer implements PrimitiveSerializer<LogoAttachInputDto> {
  @override
  final Iterable<Type> types = const [LogoAttachInputDto, _$LogoAttachInputDto];

  @override
  final String wireName = r'LogoAttachInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LogoAttachInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LogoAttachInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LogoAttachInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LogoAttachInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogoAttachInputDtoBuilder();
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


