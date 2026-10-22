//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incident_input_dto_evidence_inner.g.dart';

/// IncidentInputDtoEvidenceInner
///
/// Properties:
/// * [objectKey] 
/// * [fileName] 
@BuiltValue()
abstract class IncidentInputDtoEvidenceInner implements Built<IncidentInputDtoEvidenceInner, IncidentInputDtoEvidenceInnerBuilder> {
  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  IncidentInputDtoEvidenceInner._();

  factory IncidentInputDtoEvidenceInner([void updates(IncidentInputDtoEvidenceInnerBuilder b)]) = _$IncidentInputDtoEvidenceInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncidentInputDtoEvidenceInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncidentInputDtoEvidenceInner> get serializer => _$IncidentInputDtoEvidenceInnerSerializer();
}

class _$IncidentInputDtoEvidenceInnerSerializer implements PrimitiveSerializer<IncidentInputDtoEvidenceInner> {
  @override
  final Iterable<Type> types = const [IncidentInputDtoEvidenceInner, _$IncidentInputDtoEvidenceInner];

  @override
  final String wireName = r'IncidentInputDtoEvidenceInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncidentInputDtoEvidenceInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    IncidentInputDtoEvidenceInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncidentInputDtoEvidenceInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncidentInputDtoEvidenceInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncidentInputDtoEvidenceInnerBuilder();
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


