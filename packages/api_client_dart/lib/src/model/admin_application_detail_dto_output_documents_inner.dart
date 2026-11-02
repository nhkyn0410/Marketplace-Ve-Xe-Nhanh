//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_application_detail_dto_output_documents_inner.g.dart';

/// AdminApplicationDetailDtoOutputDocumentsInner
///
/// Properties:
/// * [type] 
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [uploadedAt] 
@BuiltValue()
abstract class AdminApplicationDetailDtoOutputDocumentsInner implements Built<AdminApplicationDetailDtoOutputDocumentsInner, AdminApplicationDetailDtoOutputDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'type')
  AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum get type;
  // enum typeEnum {  BUSINESS_REGISTRATION,  TRANSPORT_LICENSE,  REPRESENTATIVE_AUTHORIZATION,  };

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  String get contentType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  AdminApplicationDetailDtoOutputDocumentsInner._();

  factory AdminApplicationDetailDtoOutputDocumentsInner([void updates(AdminApplicationDetailDtoOutputDocumentsInnerBuilder b)]) = _$AdminApplicationDetailDtoOutputDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApplicationDetailDtoOutputDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApplicationDetailDtoOutputDocumentsInner> get serializer => _$AdminApplicationDetailDtoOutputDocumentsInnerSerializer();
}

class _$AdminApplicationDetailDtoOutputDocumentsInnerSerializer implements PrimitiveSerializer<AdminApplicationDetailDtoOutputDocumentsInner> {
  @override
  final Iterable<Type> types = const [AdminApplicationDetailDtoOutputDocumentsInner, _$AdminApplicationDetailDtoOutputDocumentsInner];

  @override
  final String wireName = r'AdminApplicationDetailDtoOutputDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApplicationDetailDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum),
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
    AdminApplicationDetailDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminApplicationDetailDtoOutputDocumentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum),
          ) as AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum;
          result.type = valueDes;
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
  AdminApplicationDetailDtoOutputDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApplicationDetailDtoOutputDocumentsInnerBuilder();
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


class AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUSINESS_REGISTRATION')
  static const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum BUSINESS_REGISTRATION = _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
  @BuiltValueEnumConst(wireName: r'TRANSPORT_LICENSE')
  static const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum TRANSPORT_LICENSE = _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
  @BuiltValueEnumConst(wireName: r'REPRESENTATIVE_AUTHORIZATION')
  static const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum REPRESENTATIVE_AUTHORIZATION = _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;

  static Serializer<AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum> get serializer => _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumSerializer;

  const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum._(String name): super(name);

  static BuiltSet<AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum> get values => _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumValues;
  static AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum valueOf(String name) => _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumValueOf(name);
}

