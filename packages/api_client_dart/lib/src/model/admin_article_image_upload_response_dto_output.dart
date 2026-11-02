//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_article_image_upload_response_dto_output.g.dart';

/// AdminArticleImageUploadResponseDtoOutput
///
/// Properties:
/// * [uploadUrl] 
/// * [objectKey] 
/// * [publicUrl] 
/// * [expiresAt] 
@BuiltValue()
abstract class AdminArticleImageUploadResponseDtoOutput implements Built<AdminArticleImageUploadResponseDtoOutput, AdminArticleImageUploadResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'publicUrl')
  String get publicUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  AdminArticleImageUploadResponseDtoOutput._();

  factory AdminArticleImageUploadResponseDtoOutput([void updates(AdminArticleImageUploadResponseDtoOutputBuilder b)]) = _$AdminArticleImageUploadResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminArticleImageUploadResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminArticleImageUploadResponseDtoOutput> get serializer => _$AdminArticleImageUploadResponseDtoOutputSerializer();
}

class _$AdminArticleImageUploadResponseDtoOutputSerializer implements PrimitiveSerializer<AdminArticleImageUploadResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminArticleImageUploadResponseDtoOutput, _$AdminArticleImageUploadResponseDtoOutput];

  @override
  final String wireName = r'AdminArticleImageUploadResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminArticleImageUploadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadUrl';
    yield serializers.serialize(
      object.uploadUrl,
      specifiedType: const FullType(String),
    );
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'publicUrl';
    yield serializers.serialize(
      object.publicUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminArticleImageUploadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminArticleImageUploadResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadUrl = valueDes;
          break;
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'publicUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminArticleImageUploadResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminArticleImageUploadResponseDtoOutputBuilder();
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


