//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_create_input_dto.g.dart';

/// ApplicationCreateInputDto
///
/// Properties:
/// * [operatorName] 
/// * [contactName] 
/// * [contactEmail] 
/// * [acceptTerms] 
@BuiltValue()
abstract class ApplicationCreateInputDto implements Built<ApplicationCreateInputDto, ApplicationCreateInputDtoBuilder> {
  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'contactName')
  String get contactName;

  @BuiltValueField(wireName: r'contactEmail')
  String get contactEmail;

  @BuiltValueField(wireName: r'acceptTerms')
  ApplicationCreateInputDtoAcceptTermsEnum get acceptTerms;
  // enum acceptTermsEnum {  true,  };

  ApplicationCreateInputDto._();

  factory ApplicationCreateInputDto([void updates(ApplicationCreateInputDtoBuilder b)]) = _$ApplicationCreateInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationCreateInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationCreateInputDto> get serializer => _$ApplicationCreateInputDtoSerializer();
}

class _$ApplicationCreateInputDtoSerializer implements PrimitiveSerializer<ApplicationCreateInputDto> {
  @override
  final Iterable<Type> types = const [ApplicationCreateInputDto, _$ApplicationCreateInputDto];

  @override
  final String wireName = r'ApplicationCreateInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationCreateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'contactName';
    yield serializers.serialize(
      object.contactName,
      specifiedType: const FullType(String),
    );
    yield r'contactEmail';
    yield serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType(String),
    );
    yield r'acceptTerms';
    yield serializers.serialize(
      object.acceptTerms,
      specifiedType: const FullType(ApplicationCreateInputDtoAcceptTermsEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationCreateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationCreateInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'contactName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactName = valueDes;
          break;
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEmail = valueDes;
          break;
        case r'acceptTerms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApplicationCreateInputDtoAcceptTermsEnum),
          ) as ApplicationCreateInputDtoAcceptTermsEnum;
          result.acceptTerms = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationCreateInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationCreateInputDtoBuilder();
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


class ApplicationCreateInputDtoAcceptTermsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const ApplicationCreateInputDtoAcceptTermsEnum true_ = _$applicationCreateInputDtoAcceptTermsEnum_true_;

  static Serializer<ApplicationCreateInputDtoAcceptTermsEnum> get serializer => _$applicationCreateInputDtoAcceptTermsEnumSerializer;

  const ApplicationCreateInputDtoAcceptTermsEnum._(String name): super(name);

  static BuiltSet<ApplicationCreateInputDtoAcceptTermsEnum> get values => _$applicationCreateInputDtoAcceptTermsEnumValues;
  static ApplicationCreateInputDtoAcceptTermsEnum valueOf(String name) => _$applicationCreateInputDtoAcceptTermsEnumValueOf(name);
}

