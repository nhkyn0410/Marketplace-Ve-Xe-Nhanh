//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_trip_changes_inner.g.dart';

/// CreatedBookingDtoOutputTripChangesInner
///
/// Properties:
/// * [kinds] 
/// * [before] 
/// * [after] 
/// * [reason] 
/// * [createdAt] 
@BuiltValue()
abstract class CreatedBookingDtoOutputTripChangesInner implements Built<CreatedBookingDtoOutputTripChangesInner, CreatedBookingDtoOutputTripChangesInnerBuilder> {
  @BuiltValueField(wireName: r'kinds')
  BuiltList<CreatedBookingDtoOutputTripChangesInnerKindsEnum> get kinds;
  // enum kindsEnum {  SCHEDULE,  VEHICLE,  STOP,  CANCEL,  };

  @BuiltValueField(wireName: r'before')
  TripSalesDtoOutputChangesInnerBefore get before;

  @BuiltValueField(wireName: r'after')
  TripSalesDtoOutputChangesInnerBefore get after;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CreatedBookingDtoOutputTripChangesInner._();

  factory CreatedBookingDtoOutputTripChangesInner([void updates(CreatedBookingDtoOutputTripChangesInnerBuilder b)]) = _$CreatedBookingDtoOutputTripChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputTripChangesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputTripChangesInner> get serializer => _$CreatedBookingDtoOutputTripChangesInnerSerializer();
}

class _$CreatedBookingDtoOutputTripChangesInnerSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputTripChangesInner> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputTripChangesInner, _$CreatedBookingDtoOutputTripChangesInner];

  @override
  final String wireName = r'CreatedBookingDtoOutputTripChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputTripChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kinds';
    yield serializers.serialize(
      object.kinds,
      specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInnerKindsEnum)]),
    );
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
    );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatedBookingDtoOutputTripChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputTripChangesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kinds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInnerKindsEnum)]),
          ) as BuiltList<CreatedBookingDtoOutputTripChangesInnerKindsEnum>;
          result.kinds.replace(valueDes);
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
          ) as TripSalesDtoOutputChangesInnerBefore;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
          ) as TripSalesDtoOutputChangesInnerBefore;
          result.after.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatedBookingDtoOutputTripChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputTripChangesInnerBuilder();
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


class CreatedBookingDtoOutputTripChangesInnerKindsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const CreatedBookingDtoOutputTripChangesInnerKindsEnum SCHEDULE = _$createdBookingDtoOutputTripChangesInnerKindsEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const CreatedBookingDtoOutputTripChangesInnerKindsEnum VEHICLE = _$createdBookingDtoOutputTripChangesInnerKindsEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'STOP')
  static const CreatedBookingDtoOutputTripChangesInnerKindsEnum STOP = _$createdBookingDtoOutputTripChangesInnerKindsEnum_STOP;
  @BuiltValueEnumConst(wireName: r'CANCEL')
  static const CreatedBookingDtoOutputTripChangesInnerKindsEnum CANCEL = _$createdBookingDtoOutputTripChangesInnerKindsEnum_CANCEL;

  static Serializer<CreatedBookingDtoOutputTripChangesInnerKindsEnum> get serializer => _$createdBookingDtoOutputTripChangesInnerKindsEnumSerializer;

  const CreatedBookingDtoOutputTripChangesInnerKindsEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputTripChangesInnerKindsEnum> get values => _$createdBookingDtoOutputTripChangesInnerKindsEnumValues;
  static CreatedBookingDtoOutputTripChangesInnerKindsEnum valueOf(String name) => _$createdBookingDtoOutputTripChangesInnerKindsEnumValueOf(name);
}

