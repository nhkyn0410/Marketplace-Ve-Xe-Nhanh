//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_update_input_dto_documents_inner.g.dart';

/// ApplicationUpdateInputDtoDocumentsInner
///
/// Properties:
/// * [type] 
/// * [objectKey] 
/// * [fileName] 
@BuiltValue()
abstract class ApplicationUpdateInputDtoDocumentsInner implements Built<ApplicationUpdateInputDtoDocumentsInner, ApplicationUpdateInputDtoDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'type')
  ApplicationUpdateInputDtoDocumentsInnerTypeEnum get type;
  // enum typeEnum {  BUSINESS_REGISTRATION,  TRANSPORT_LICENSE,  REPRESENTATIVE_AUTHORIZATION,  };

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  ApplicationUpdateInputDtoDocumentsInner._();

  factory ApplicationUpdateInputDtoDocumentsInner([void updates(ApplicationUpdateInputDtoDocumentsInnerBuilder b)]) = _$ApplicationUpdateInputDtoDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationUpdateInputDtoDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationUpdateInputDtoDocumentsInner> get serializer => _$ApplicationUpdateInputDtoDocumentsInnerSerializer();
}

class _$ApplicationUpdateInputDtoDocumentsInnerSerializer implements PrimitiveSerializer<ApplicationUpdateInputDtoDocumentsInner> {
  @override
  final Iterable<Type> types = const [ApplicationUpdateInputDtoDocumentsInner, _$ApplicationUpdateInputDtoDocumentsInner];

  @override
  final String wireName = r'ApplicationUpdateInputDtoDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationUpdateInputDtoDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ApplicationUpdateInputDtoDocumentsInnerTypeEnum),
    );
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationUpdateInputDtoDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationUpdateInputDtoDocumentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApplicationUpdateInputDtoDocumentsInnerTypeEnum),
          ) as ApplicationUpdateInputDtoDocumentsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationUpdateInputDtoDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationUpdateInputDtoDocumentsInnerBuilder();
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


class ApplicationUpdateInputDtoDocumentsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUSINESS_REGISTRATION')
  static const ApplicationUpdateInputDtoDocumentsInnerTypeEnum BUSINESS_REGISTRATION = _$applicationUpdateInputDtoDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
  @BuiltValueEnumConst(wireName: r'TRANSPORT_LICENSE')
  static const ApplicationUpdateInputDtoDocumentsInnerTypeEnum TRANSPORT_LICENSE = _$applicationUpdateInputDtoDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
  @BuiltValueEnumConst(wireName: r'REPRESENTATIVE_AUTHORIZATION')
  static const ApplicationUpdateInputDtoDocumentsInnerTypeEnum REPRESENTATIVE_AUTHORIZATION = _$applicationUpdateInputDtoDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;

  static Serializer<ApplicationUpdateInputDtoDocumentsInnerTypeEnum> get serializer => _$applicationUpdateInputDtoDocumentsInnerTypeEnumSerializer;

  const ApplicationUpdateInputDtoDocumentsInnerTypeEnum._(String name): super(name);

  static BuiltSet<ApplicationUpdateInputDtoDocumentsInnerTypeEnum> get values => _$applicationUpdateInputDtoDocumentsInnerTypeEnumValues;
  static ApplicationUpdateInputDtoDocumentsInnerTypeEnum valueOf(String name) => _$applicationUpdateInputDtoDocumentsInnerTypeEnumValueOf(name);
}

