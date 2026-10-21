//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_download_response_dto_output.g.dart';

/// KycDownloadResponseDtoOutput
///
/// Properties:
/// * [url] 
/// * [expiresAt] 
@BuiltValue()
abstract class KycDownloadResponseDtoOutput implements Built<KycDownloadResponseDtoOutput, KycDownloadResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  KycDownloadResponseDtoOutput._();

  factory KycDownloadResponseDtoOutput([void updates(KycDownloadResponseDtoOutputBuilder b)]) = _$KycDownloadResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycDownloadResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycDownloadResponseDtoOutput> get serializer => _$KycDownloadResponseDtoOutputSerializer();
}

class _$KycDownloadResponseDtoOutputSerializer implements PrimitiveSerializer<KycDownloadResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [KycDownloadResponseDtoOutput, _$KycDownloadResponseDtoOutput];

  @override
  final String wireName = r'KycDownloadResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycDownloadResponseDtoOutput object, {
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
    KycDownloadResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycDownloadResponseDtoOutputBuilder result,
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
  KycDownloadResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycDownloadResponseDtoOutputBuilder();
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


