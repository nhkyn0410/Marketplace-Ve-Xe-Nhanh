//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decision_response_dto_output.g.dart';

/// DecisionResponseDtoOutput
///
/// Properties:
/// * [applicationCode] 
/// * [status] 
/// * [emailDelivered] 
@BuiltValue()
abstract class DecisionResponseDtoOutput implements Built<DecisionResponseDtoOutput, DecisionResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  @BuiltValueField(wireName: r'status')
  DecisionResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  NEEDS_INFO,  REJECTED,  };

  @BuiltValueField(wireName: r'emailDelivered')
  bool get emailDelivered;

  DecisionResponseDtoOutput._();

  factory DecisionResponseDtoOutput([void updates(DecisionResponseDtoOutputBuilder b)]) = _$DecisionResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecisionResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecisionResponseDtoOutput> get serializer => _$DecisionResponseDtoOutputSerializer();
}

class _$DecisionResponseDtoOutputSerializer implements PrimitiveSerializer<DecisionResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [DecisionResponseDtoOutput, _$DecisionResponseDtoOutput];

  @override
  final String wireName = r'DecisionResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecisionResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicationCode';
    yield serializers.serialize(
      object.applicationCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DecisionResponseDtoOutputStatusEnum),
    );
    yield r'emailDelivered';
    yield serializers.serialize(
      object.emailDelivered,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DecisionResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DecisionResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applicationCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.applicationCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DecisionResponseDtoOutputStatusEnum),
          ) as DecisionResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'emailDelivered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailDelivered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DecisionResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecisionResponseDtoOutputBuilder();
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


class DecisionResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NEEDS_INFO')
  static const DecisionResponseDtoOutputStatusEnum NEEDS_INFO = _$decisionResponseDtoOutputStatusEnum_NEEDS_INFO;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const DecisionResponseDtoOutputStatusEnum REJECTED = _$decisionResponseDtoOutputStatusEnum_REJECTED;

  static Serializer<DecisionResponseDtoOutputStatusEnum> get serializer => _$decisionResponseDtoOutputStatusEnumSerializer;

  const DecisionResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<DecisionResponseDtoOutputStatusEnum> get values => _$decisionResponseDtoOutputStatusEnumValues;
  static DecisionResponseDtoOutputStatusEnum valueOf(String name) => _$decisionResponseDtoOutputStatusEnumValueOf(name);
}

