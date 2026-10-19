//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download_url_response_dto_output.g.dart';

/// DownloadUrlResponseDtoOutput
///
/// Properties:
/// * [url] 
/// * [expiresAt] 
@BuiltValue()
abstract class DownloadUrlResponseDtoOutput implements Built<DownloadUrlResponseDtoOutput, DownloadUrlResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  DownloadUrlResponseDtoOutput._();

  factory DownloadUrlResponseDtoOutput([void updates(DownloadUrlResponseDtoOutputBuilder b)]) = _$DownloadUrlResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadUrlResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadUrlResponseDtoOutput> get serializer => _$DownloadUrlResponseDtoOutputSerializer();
}

class _$DownloadUrlResponseDtoOutputSerializer implements PrimitiveSerializer<DownloadUrlResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [DownloadUrlResponseDtoOutput, _$DownloadUrlResponseDtoOutput];

  @override
  final String wireName = r'DownloadUrlResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadUrlResponseDtoOutput object, {
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
    DownloadUrlResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadUrlResponseDtoOutputBuilder result,
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
  DownloadUrlResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadUrlResponseDtoOutputBuilder();
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


