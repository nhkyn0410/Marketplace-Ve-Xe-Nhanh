//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'preference_input_dto.g.dart';

/// PreferenceInputDto
///
/// Properties:
/// * [kind] 
/// * [email] 
/// * [push] 
@BuiltValue()
abstract class PreferenceInputDto implements Built<PreferenceInputDto, PreferenceInputDtoBuilder> {
  @BuiltValueField(wireName: r'kind')
  PreferenceInputDtoKindEnum get kind;
  // enum kindEnum {  BOOKING_CONFIRMED,  TICKETS_CANCELLED,  REFUND_SUCCEEDED,  TRIP_CHANGED,  TRIP_CANCELLED,  MANUAL_REFUND,  CASE_UPDATED,  OPERATIONS_ALERT,  LOYALTY_UPDATED,  PROMOTION,  };

  @BuiltValueField(wireName: r'email')
  bool get email;

  @BuiltValueField(wireName: r'push')
  bool get push;

  PreferenceInputDto._();

  factory PreferenceInputDto([void updates(PreferenceInputDtoBuilder b)]) = _$PreferenceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PreferenceInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PreferenceInputDto> get serializer => _$PreferenceInputDtoSerializer();
}

class _$PreferenceInputDtoSerializer implements PrimitiveSerializer<PreferenceInputDto> {
  @override
  final Iterable<Type> types = const [PreferenceInputDto, _$PreferenceInputDto];

  @override
  final String wireName = r'PreferenceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PreferenceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PreferenceInputDtoKindEnum),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(bool),
    );
    yield r'push';
    yield serializers.serialize(
      object.push,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PreferenceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PreferenceInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PreferenceInputDtoKindEnum),
          ) as PreferenceInputDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.email = valueDes;
          break;
        case r'push':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.push = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PreferenceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PreferenceInputDtoBuilder();
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


class PreferenceInputDtoKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOOKING_CONFIRMED')
  static const PreferenceInputDtoKindEnum BOOKING_CONFIRMED = _$preferenceInputDtoKindEnum_BOOKING_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'TICKETS_CANCELLED')
  static const PreferenceInputDtoKindEnum TICKETS_CANCELLED = _$preferenceInputDtoKindEnum_TICKETS_CANCELLED;
  @BuiltValueEnumConst(wireName: r'REFUND_SUCCEEDED')
  static const PreferenceInputDtoKindEnum REFUND_SUCCEEDED = _$preferenceInputDtoKindEnum_REFUND_SUCCEEDED;
  @BuiltValueEnumConst(wireName: r'TRIP_CHANGED')
  static const PreferenceInputDtoKindEnum TRIP_CHANGED = _$preferenceInputDtoKindEnum_TRIP_CHANGED;
  @BuiltValueEnumConst(wireName: r'TRIP_CANCELLED')
  static const PreferenceInputDtoKindEnum TRIP_CANCELLED = _$preferenceInputDtoKindEnum_TRIP_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REFUND')
  static const PreferenceInputDtoKindEnum MANUAL_REFUND = _$preferenceInputDtoKindEnum_MANUAL_REFUND;
  @BuiltValueEnumConst(wireName: r'CASE_UPDATED')
  static const PreferenceInputDtoKindEnum CASE_UPDATED = _$preferenceInputDtoKindEnum_CASE_UPDATED;
  @BuiltValueEnumConst(wireName: r'OPERATIONS_ALERT')
  static const PreferenceInputDtoKindEnum OPERATIONS_ALERT = _$preferenceInputDtoKindEnum_OPERATIONS_ALERT;
  @BuiltValueEnumConst(wireName: r'LOYALTY_UPDATED')
  static const PreferenceInputDtoKindEnum LOYALTY_UPDATED = _$preferenceInputDtoKindEnum_LOYALTY_UPDATED;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const PreferenceInputDtoKindEnum PROMOTION = _$preferenceInputDtoKindEnum_PROMOTION;

  static Serializer<PreferenceInputDtoKindEnum> get serializer => _$preferenceInputDtoKindEnumSerializer;

  const PreferenceInputDtoKindEnum._(String name): super(name);

  static BuiltSet<PreferenceInputDtoKindEnum> get values => _$preferenceInputDtoKindEnumValues;
  static PreferenceInputDtoKindEnum valueOf(String name) => _$preferenceInputDtoKindEnumValueOf(name);
}

