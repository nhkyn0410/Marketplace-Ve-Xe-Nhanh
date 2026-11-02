//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_response_dto_output_documents_inner.g.dart';

/// ApplicationResponseDtoOutputDocumentsInner
///
/// Properties:
/// * [type] 
/// * [objectKey] 
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [uploadedAt] 
@BuiltValue()
abstract class ApplicationResponseDtoOutputDocumentsInner implements Built<ApplicationResponseDtoOutputDocumentsInner, ApplicationResponseDtoOutputDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'type')
  ApplicationResponseDtoOutputDocumentsInnerTypeEnum get type;
  // enum typeEnum {  BUSINESS_REGISTRATION,  TRANSPORT_LICENSE,  REPRESENTATIVE_AUTHORIZATION,  };

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  String get contentType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  ApplicationResponseDtoOutputDocumentsInner._();

  factory ApplicationResponseDtoOutputDocumentsInner([void updates(ApplicationResponseDtoOutputDocumentsInnerBuilder b)]) = _$ApplicationResponseDtoOutputDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationResponseDtoOutputDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationResponseDtoOutputDocumentsInner> get serializer => _$ApplicationResponseDtoOutputDocumentsInnerSerializer();
}

class _$ApplicationResponseDtoOutputDocumentsInnerSerializer implements PrimitiveSerializer<ApplicationResponseDtoOutputDocumentsInner> {
  @override
  final Iterable<Type> types = const [ApplicationResponseDtoOutputDocumentsInner, _$ApplicationResponseDtoOutputDocumentsInner];

  @override
  final String wireName = r'ApplicationResponseDtoOutputDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationResponseDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ApplicationResponseDtoOutputDocumentsInnerTypeEnum),
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
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'uploadedAt';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationResponseDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationResponseDtoOutputDocumentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApplicationResponseDtoOutputDocumentsInnerTypeEnum),
          ) as ApplicationResponseDtoOutputDocumentsInnerTypeEnum;
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
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'uploadedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.uploadedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationResponseDtoOutputDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationResponseDtoOutputDocumentsInnerBuilder();
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


class ApplicationResponseDtoOutputDocumentsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUSINESS_REGISTRATION')
  static const ApplicationResponseDtoOutputDocumentsInnerTypeEnum BUSINESS_REGISTRATION = _$applicationResponseDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
  @BuiltValueEnumConst(wireName: r'TRANSPORT_LICENSE')
  static const ApplicationResponseDtoOutputDocumentsInnerTypeEnum TRANSPORT_LICENSE = _$applicationResponseDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
  @BuiltValueEnumConst(wireName: r'REPRESENTATIVE_AUTHORIZATION')
  static const ApplicationResponseDtoOutputDocumentsInnerTypeEnum REPRESENTATIVE_AUTHORIZATION = _$applicationResponseDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;

  static Serializer<ApplicationResponseDtoOutputDocumentsInnerTypeEnum> get serializer => _$applicationResponseDtoOutputDocumentsInnerTypeEnumSerializer;

  const ApplicationResponseDtoOutputDocumentsInnerTypeEnum._(String name): super(name);

  static BuiltSet<ApplicationResponseDtoOutputDocumentsInnerTypeEnum> get values => _$applicationResponseDtoOutputDocumentsInnerTypeEnumValues;
  static ApplicationResponseDtoOutputDocumentsInnerTypeEnum valueOf(String name) => _$applicationResponseDtoOutputDocumentsInnerTypeEnumValueOf(name);
}

