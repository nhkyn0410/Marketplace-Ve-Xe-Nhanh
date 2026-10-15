//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_access_link_input_dto.g.dart';

/// ApplicationAccessLinkInputDto
///
/// Properties:
/// * [contactEmail] 
/// * [applicationCode] 
@BuiltValue()
abstract class ApplicationAccessLinkInputDto implements Built<ApplicationAccessLinkInputDto, ApplicationAccessLinkInputDtoBuilder> {
  @BuiltValueField(wireName: r'contactEmail')
  String get contactEmail;

  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  ApplicationAccessLinkInputDto._();

  factory ApplicationAccessLinkInputDto([void updates(ApplicationAccessLinkInputDtoBuilder b)]) = _$ApplicationAccessLinkInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationAccessLinkInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationAccessLinkInputDto> get serializer => _$ApplicationAccessLinkInputDtoSerializer();
}

class _$ApplicationAccessLinkInputDtoSerializer implements PrimitiveSerializer<ApplicationAccessLinkInputDto> {
  @override
  final Iterable<Type> types = const [ApplicationAccessLinkInputDto, _$ApplicationAccessLinkInputDto];

  @override
  final String wireName = r'ApplicationAccessLinkInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationAccessLinkInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contactEmail';
    yield serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType(String),
    );
    yield r'applicationCode';
    yield serializers.serialize(
      object.applicationCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationAccessLinkInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationAccessLinkInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEmail = valueDes;
          break;
        case r'applicationCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.applicationCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationAccessLinkInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationAccessLinkInputDtoBuilder();
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


