//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_manifest_dto_output_passengers_inner_pickup.g.dart';

/// TripManifestDtoOutputPassengersInnerPickup
///
/// Properties:
/// * [sequence]
/// * [name]
/// * [pickupWindowStart]
/// * [pickupWindowEnd]
@BuiltValue()
abstract class TripManifestDtoOutputPassengersInnerPickup
    implements
        Built<TripManifestDtoOutputPassengersInnerPickup,
            TripManifestDtoOutputPassengersInnerPickupBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'pickupWindowStart')
  DateTime? get pickupWindowStart;

  @BuiltValueField(wireName: r'pickupWindowEnd')
  DateTime? get pickupWindowEnd;

  TripManifestDtoOutputPassengersInnerPickup._();

  factory TripManifestDtoOutputPassengersInnerPickup(
          [void updates(TripManifestDtoOutputPassengersInnerPickupBuilder b)]) =
      _$TripManifestDtoOutputPassengersInnerPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripManifestDtoOutputPassengersInnerPickupBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripManifestDtoOutputPassengersInnerPickup>
      get serializer =>
          _$TripManifestDtoOutputPassengersInnerPickupSerializer();
}

class _$TripManifestDtoOutputPassengersInnerPickupSerializer
    implements PrimitiveSerializer<TripManifestDtoOutputPassengersInnerPickup> {
  @override
  final Iterable<Type> types = const [
    TripManifestDtoOutputPassengersInnerPickup,
    _$TripManifestDtoOutputPassengersInnerPickup
  ];

  @override
  final String wireName = r'TripManifestDtoOutputPassengersInnerPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripManifestDtoOutputPassengersInnerPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'pickupWindowStart';
    yield object.pickupWindowStart == null
        ? null
        : serializers.serialize(
            object.pickupWindowStart,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'pickupWindowEnd';
    yield object.pickupWindowEnd == null
        ? null
        : serializers.serialize(
            object.pickupWindowEnd,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripManifestDtoOutputPassengersInnerPickup object, {
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
    required TripManifestDtoOutputPassengersInnerPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'pickupWindowStart':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickupWindowStart = valueDes;
          break;
        case r'pickupWindowEnd':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickupWindowEnd = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripManifestDtoOutputPassengersInnerPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripManifestDtoOutputPassengersInnerPickupBuilder();
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
