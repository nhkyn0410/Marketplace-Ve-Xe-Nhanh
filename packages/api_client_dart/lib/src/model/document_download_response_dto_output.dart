//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document_download_response_dto_output.g.dart';

/// DocumentDownloadResponseDtoOutput
///
/// Properties:
/// * [url] 
/// * [expiresAt] 
@BuiltValue()
abstract class DocumentDownloadResponseDtoOutput implements Built<DocumentDownloadResponseDtoOutput, DocumentDownloadResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  DocumentDownloadResponseDtoOutput._();

  factory DocumentDownloadResponseDtoOutput([void updates(DocumentDownloadResponseDtoOutputBuilder b)]) = _$DocumentDownloadResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentDownloadResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentDownloadResponseDtoOutput> get serializer => _$DocumentDownloadResponseDtoOutputSerializer();
}

class _$DocumentDownloadResponseDtoOutputSerializer implements PrimitiveSerializer<DocumentDownloadResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [DocumentDownloadResponseDtoOutput, _$DocumentDownloadResponseDtoOutput];

  @override
  final String wireName = r'DocumentDownloadResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentDownloadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
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
    DocumentDownloadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DocumentDownloadResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
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
  DocumentDownloadResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentDownloadResponseDtoOutputBuilder();
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


