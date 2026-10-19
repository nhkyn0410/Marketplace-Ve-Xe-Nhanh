//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_evidence_input_dto.g.dart';

/// RequestEvidenceInputDto
///
/// Properties:
/// * [party] 
/// * [message] 
/// * [dueAt] 
@BuiltValue()
abstract class RequestEvidenceInputDto implements Built<RequestEvidenceInputDto, RequestEvidenceInputDtoBuilder> {
  @BuiltValueField(wireName: r'party')
  RequestEvidenceInputDtoPartyEnum get party;
  // enum partyEnum {  PASSENGER,  OPERATOR,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'dueAt')
  DateTime get dueAt;

  RequestEvidenceInputDto._();

  factory RequestEvidenceInputDto([void updates(RequestEvidenceInputDtoBuilder b)]) = _$RequestEvidenceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestEvidenceInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestEvidenceInputDto> get serializer => _$RequestEvidenceInputDtoSerializer();
}

class _$RequestEvidenceInputDtoSerializer implements PrimitiveSerializer<RequestEvidenceInputDto> {
  @override
  final Iterable<Type> types = const [RequestEvidenceInputDto, _$RequestEvidenceInputDto];

  @override
  final String wireName = r'RequestEvidenceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestEvidenceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(RequestEvidenceInputDtoPartyEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'dueAt';
    yield serializers.serialize(
      object.dueAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RequestEvidenceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RequestEvidenceInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RequestEvidenceInputDtoPartyEnum),
          ) as RequestEvidenceInputDtoPartyEnum;
          result.party = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RequestEvidenceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestEvidenceInputDtoBuilder();
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


class RequestEvidenceInputDtoPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const RequestEvidenceInputDtoPartyEnum PASSENGER = _$requestEvidenceInputDtoPartyEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const RequestEvidenceInputDtoPartyEnum OPERATOR = _$requestEvidenceInputDtoPartyEnum_OPERATOR;

  static Serializer<RequestEvidenceInputDtoPartyEnum> get serializer => _$requestEvidenceInputDtoPartyEnumSerializer;

  const RequestEvidenceInputDtoPartyEnum._(String name): super(name);

  static BuiltSet<RequestEvidenceInputDtoPartyEnum> get values => _$requestEvidenceInputDtoPartyEnumValues;
  static RequestEvidenceInputDtoPartyEnum valueOf(String name) => _$requestEvidenceInputDtoPartyEnumValueOf(name);
}

