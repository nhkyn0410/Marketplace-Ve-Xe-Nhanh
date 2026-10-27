//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'logo_upload_response_dto_output.g.dart';

/// LogoUploadResponseDtoOutput
///
/// Properties:
/// * [uploadUrl] 
/// * [objectKey] 
/// * [expiresAt] 
@BuiltValue()
abstract class LogoUploadResponseDtoOutput implements Built<LogoUploadResponseDtoOutput, LogoUploadResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  LogoUploadResponseDtoOutput._();

  factory LogoUploadResponseDtoOutput([void updates(LogoUploadResponseDtoOutputBuilder b)]) = _$LogoUploadResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LogoUploadResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LogoUploadResponseDtoOutput> get serializer => _$LogoUploadResponseDtoOutputSerializer();
}

class _$LogoUploadResponseDtoOutputSerializer implements PrimitiveSerializer<LogoUploadResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [LogoUploadResponseDtoOutput, _$LogoUploadResponseDtoOutput];

  @override
  final String wireName = r'LogoUploadResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LogoUploadResponseDtoOutput object, {
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
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LogoUploadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LogoUploadResponseDtoOutputBuilder result,
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
  LogoUploadResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LogoUploadResponseDtoOutputBuilder();
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


