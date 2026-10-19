//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output_trip.g.dart';

/// DisputeDetailDtoOutputTrip
///
/// Properties:
/// * [tripId] 
/// * [routeName] 
/// * [departureAt] 
/// * [departedAt] 
/// * [vehiclePlateNumber] 
@BuiltValue()
abstract class DisputeDetailDtoOutputTrip implements Built<DisputeDetailDtoOutputTrip, DisputeDetailDtoOutputTripBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'departedAt')
  DateTime? get departedAt;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  DisputeDetailDtoOutputTrip._();

  factory DisputeDetailDtoOutputTrip([void updates(DisputeDetailDtoOutputTripBuilder b)]) = _$DisputeDetailDtoOutputTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutputTrip> get serializer => _$DisputeDetailDtoOutputTripSerializer();
}

class _$DisputeDetailDtoOutputTripSerializer implements PrimitiveSerializer<DisputeDetailDtoOutputTrip> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutputTrip, _$DisputeDetailDtoOutputTrip];

  @override
  final String wireName = r'DisputeDetailDtoOutputTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'departedAt';
    yield object.departedAt == null ? null : serializers.serialize(
      object.departedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutputTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputTripBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'departedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.departedAt = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutputTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputTripBuilder();
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


