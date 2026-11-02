//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_dto_output_evidence_inner.g.dart';

/// IncidentDtoOutputEvidenceInner
///
/// Properties:
/// * [objectKey] 
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class IncidentDtoOutputEvidenceInner implements Built<IncidentDtoOutputEvidenceInner, IncidentDtoOutputEvidenceInnerBuilder> {
  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  String get contentType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  IncidentDtoOutputEvidenceInner._();

  factory IncidentDtoOutputEvidenceInner([void updates(IncidentDtoOutputEvidenceInnerBuilder b)]) = _$IncidentDtoOutputEvidenceInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentDtoOutputEvidenceInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentDtoOutputEvidenceInner> get serializer => _$IncidentDtoOutputEvidenceInnerSerializer();
}

class _$IncidentDtoOutputEvidenceInnerSerializer implements PrimitiveSerializer<IncidentDtoOutputEvidenceInner> {
  @override
  final Iterable<Type> types = const [IncidentDtoOutputEvidenceInner, _$IncidentDtoOutputEvidenceInner];

  @override
  final String wireName = r'IncidentDtoOutputEvidenceInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentDtoOutputEvidenceInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentDtoOutputEvidenceInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncidentDtoOutputEvidenceInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncidentDtoOutputEvidenceInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentDtoOutputEvidenceInnerBuilder();
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


