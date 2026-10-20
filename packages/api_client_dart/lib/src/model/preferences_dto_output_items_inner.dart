//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'preferences_dto_output_items_inner.g.dart';

/// PreferencesDtoOutputItemsInner
///
/// Properties:
/// * [kind]
/// * [email]
/// * [push]
/// * [mandatory]
@BuiltValue()
abstract class PreferencesDtoOutputItemsInner
    implements
        Built<PreferencesDtoOutputItemsInner,
            PreferencesDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'kind')
  PreferencesDtoOutputItemsInnerKindEnum get kind;
  // enum kindEnum {  BOOKING_CONFIRMED,  TICKETS_CANCELLED,  REFUND_SUCCEEDED,  TRIP_CHANGED,  TRIP_CANCELLED,  MANUAL_REFUND,  CASE_UPDATED,  OPERATIONS_ALERT,  LOYALTY_UPDATED,  PROMOTION,  };

  @BuiltValueField(wireName: r'email')
  bool get email;

  @BuiltValueField(wireName: r'push')
  bool get push;

  @BuiltValueField(wireName: r'mandatory')
  bool get mandatory;

  PreferencesDtoOutputItemsInner._();

  factory PreferencesDtoOutputItemsInner(
          [void updates(PreferencesDtoOutputItemsInnerBuilder b)]) =
      _$PreferencesDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PreferencesDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PreferencesDtoOutputItemsInner> get serializer =>
      _$PreferencesDtoOutputItemsInnerSerializer();
}

class _$PreferencesDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<PreferencesDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    PreferencesDtoOutputItemsInner,
    _$PreferencesDtoOutputItemsInner
  ];

  @override
  final String wireName = r'PreferencesDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PreferencesDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PreferencesDtoOutputItemsInnerKindEnum),
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
    yield r'mandatory';
    yield serializers.serialize(
      object.mandatory,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PreferencesDtoOutputItemsInner object, {
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
    required PreferencesDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(PreferencesDtoOutputItemsInnerKindEnum),
          ) as PreferencesDtoOutputItemsInnerKindEnum;
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
        case r'mandatory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mandatory = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PreferencesDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PreferencesDtoOutputItemsInnerBuilder();
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

class PreferencesDtoOutputItemsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'BOOKING_CONFIRMED')
  static const PreferencesDtoOutputItemsInnerKindEnum BOOKING_CONFIRMED =
      _$preferencesDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'TICKETS_CANCELLED')
  static const PreferencesDtoOutputItemsInnerKindEnum TICKETS_CANCELLED =
      _$preferencesDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED;
  @BuiltValueEnumConst(wireName: r'REFUND_SUCCEEDED')
  static const PreferencesDtoOutputItemsInnerKindEnum REFUND_SUCCEEDED =
      _$preferencesDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED;
  @BuiltValueEnumConst(wireName: r'TRIP_CHANGED')
  static const PreferencesDtoOutputItemsInnerKindEnum TRIP_CHANGED =
      _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CHANGED;
  @BuiltValueEnumConst(wireName: r'TRIP_CANCELLED')
  static const PreferencesDtoOutputItemsInnerKindEnum TRIP_CANCELLED =
      _$preferencesDtoOutputItemsInnerKindEnum_TRIP_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REFUND')
  static const PreferencesDtoOutputItemsInnerKindEnum MANUAL_REFUND =
      _$preferencesDtoOutputItemsInnerKindEnum_MANUAL_REFUND;
  @BuiltValueEnumConst(wireName: r'CASE_UPDATED')
  static const PreferencesDtoOutputItemsInnerKindEnum CASE_UPDATED =
      _$preferencesDtoOutputItemsInnerKindEnum_CASE_UPDATED;
  @BuiltValueEnumConst(wireName: r'OPERATIONS_ALERT')
  static const PreferencesDtoOutputItemsInnerKindEnum OPERATIONS_ALERT =
      _$preferencesDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT;
  @BuiltValueEnumConst(wireName: r'LOYALTY_UPDATED')
  static const PreferencesDtoOutputItemsInnerKindEnum LOYALTY_UPDATED =
      _$preferencesDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const PreferencesDtoOutputItemsInnerKindEnum PROMOTION =
      _$preferencesDtoOutputItemsInnerKindEnum_PROMOTION;

  static Serializer<PreferencesDtoOutputItemsInnerKindEnum> get serializer =>
      _$preferencesDtoOutputItemsInnerKindEnumSerializer;

  const PreferencesDtoOutputItemsInnerKindEnum._(String name) : super(name);

  static BuiltSet<PreferencesDtoOutputItemsInnerKindEnum> get values =>
      _$preferencesDtoOutputItemsInnerKindEnumValues;
  static PreferencesDtoOutputItemsInnerKindEnum valueOf(String name) =>
      _$preferencesDtoOutputItemsInnerKindEnumValueOf(name);
}
