//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reconciliation_request_dto.g.dart';

/// ReconciliationRequestDto
///
/// Properties:
/// * [requestId]
/// * [reason]
@BuiltValue()
abstract class ReconciliationRequestDto
    implements
        Built<ReconciliationRequestDto, ReconciliationRequestDtoBuilder> {
  @BuiltValueField(wireName: r'requestId')
  String get requestId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ReconciliationRequestDto._();

  factory ReconciliationRequestDto(
          [void updates(ReconciliationRequestDtoBuilder b)]) =
      _$ReconciliationRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReconciliationRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReconciliationRequestDto> get serializer =>
      _$ReconciliationRequestDtoSerializer();
}

class _$ReconciliationRequestDtoSerializer
    implements PrimitiveSerializer<ReconciliationRequestDto> {
  @override
  final Iterable<Type> types = const [
    ReconciliationRequestDto,
    _$ReconciliationRequestDto
  ];

  @override
  final String wireName = r'ReconciliationRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReconciliationRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReconciliationRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReconciliationRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReconciliationRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReconciliationRequestDtoBuilder();
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
