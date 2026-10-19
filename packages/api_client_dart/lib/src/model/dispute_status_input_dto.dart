//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_status_input_dto.g.dart';

/// DisputeStatusInputDto
///
/// Properties:
/// * [status] 
/// * [reason] 
@BuiltValue()
abstract class DisputeStatusInputDto implements Built<DisputeStatusInputDto, DisputeStatusInputDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  DisputeStatusInputDtoStatusEnum get status;
  // enum statusEnum {  UNDER_REVIEW,  ESCALATED,  CLOSED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  DisputeStatusInputDto._();

  factory DisputeStatusInputDto([void updates(DisputeStatusInputDtoBuilder b)]) = _$DisputeStatusInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeStatusInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeStatusInputDto> get serializer => _$DisputeStatusInputDtoSerializer();
}

class _$DisputeStatusInputDtoSerializer implements PrimitiveSerializer<DisputeStatusInputDto> {
  @override
  final Iterable<Type> types = const [DisputeStatusInputDto, _$DisputeStatusInputDto];

  @override
  final String wireName = r'DisputeStatusInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeStatusInputDtoStatusEnum),
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
    DisputeStatusInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeStatusInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeStatusInputDtoStatusEnum),
          ) as DisputeStatusInputDtoStatusEnum;
          result.status = valueDes;
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
  DisputeStatusInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeStatusInputDtoBuilder();
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


class DisputeStatusInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const DisputeStatusInputDtoStatusEnum UNDER_REVIEW = _$disputeStatusInputDtoStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputeStatusInputDtoStatusEnum ESCALATED = _$disputeStatusInputDtoStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const DisputeStatusInputDtoStatusEnum CLOSED = _$disputeStatusInputDtoStatusEnum_CLOSED;

  static Serializer<DisputeStatusInputDtoStatusEnum> get serializer => _$disputeStatusInputDtoStatusEnumSerializer;

  const DisputeStatusInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<DisputeStatusInputDtoStatusEnum> get values => _$disputeStatusInputDtoStatusEnumValues;
  static DisputeStatusInputDtoStatusEnum valueOf(String name) => _$disputeStatusInputDtoStatusEnumValueOf(name);
}

