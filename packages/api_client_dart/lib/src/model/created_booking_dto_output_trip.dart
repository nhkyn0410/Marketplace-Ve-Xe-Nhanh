//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_trip.g.dart';

/// CreatedBookingDtoOutputTrip
///
/// Properties:
/// * [routeName] 
/// * [operatorName] 
/// * [operatorHotline] 
/// * [vehicleTypeName] 
/// * [departureAt] 
/// * [arrivalAt] 
@BuiltValue()
abstract class CreatedBookingDtoOutputTrip implements Built<CreatedBookingDtoOutputTrip, CreatedBookingDtoOutputTripBuilder> {
  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'operatorHotline')
  String? get operatorHotline;

  @BuiltValueField(wireName: r'vehicleTypeName')
  String get vehicleTypeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  CreatedBookingDtoOutputTrip._();

  factory CreatedBookingDtoOutputTrip([void updates(CreatedBookingDtoOutputTripBuilder b)]) = _$CreatedBookingDtoOutputTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputTrip> get serializer => _$CreatedBookingDtoOutputTripSerializer();
}

class _$CreatedBookingDtoOutputTripSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputTrip> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputTrip, _$CreatedBookingDtoOutputTrip];

  @override
  final String wireName = r'CreatedBookingDtoOutputTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'operatorHotline';
    yield object.operatorHotline == null ? null : serializers.serialize(
      object.operatorHotline,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehicleTypeName';
    yield serializers.serialize(
      object.vehicleTypeName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatedBookingDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputTripBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'operatorHotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorHotline = valueDes;
          break;
        case r'vehicleTypeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleTypeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatedBookingDtoOutputTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputTripBuilder();
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


