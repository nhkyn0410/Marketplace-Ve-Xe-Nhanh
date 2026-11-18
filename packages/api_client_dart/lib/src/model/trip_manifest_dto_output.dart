//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_manifest_dto_output_passengers_inner.dart';
import 'package:api_client_dart/src/model/trip_manifest_dto_output_seats_inner.dart';
import 'package:api_client_dart/src/model/employee_assignment_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_manifest_dto_output.g.dart';

/// TripManifestDtoOutput
///
/// Properties:
/// * [trip] 
/// * [passengers] 
/// * [seats] 
@BuiltValue()
abstract class TripManifestDtoOutput implements Built<TripManifestDtoOutput, TripManifestDtoOutputBuilder> {
  @BuiltValueField(wireName: r'trip')
  EmployeeAssignmentListDtoOutputItemsInner get trip;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<TripManifestDtoOutputPassengersInner> get passengers;

  @BuiltValueField(wireName: r'seats')
  BuiltList<TripManifestDtoOutputSeatsInner>? get seats;

  TripManifestDtoOutput._();

  factory TripManifestDtoOutput([void updates(TripManifestDtoOutputBuilder b)]) = _$TripManifestDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripManifestDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripManifestDtoOutput> get serializer => _$TripManifestDtoOutputSerializer();
}

class _$TripManifestDtoOutputSerializer implements PrimitiveSerializer<TripManifestDtoOutput> {
  @override
  final Iterable<Type> types = const [TripManifestDtoOutput, _$TripManifestDtoOutput];

  @override
  final String wireName = r'TripManifestDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripManifestDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInner),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(TripManifestDtoOutputPassengersInner)]),
    );
    if (object.seats != null) {
      yield r'seats';
      yield serializers.serialize(
        object.seats,
        specifiedType: const FullType(BuiltList, [FullType(TripManifestDtoOutputSeatsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TripManifestDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripManifestDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInner),
          ) as EmployeeAssignmentListDtoOutputItemsInner;
          result.trip.replace(valueDes);
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripManifestDtoOutputPassengersInner)]),
          ) as BuiltList<TripManifestDtoOutputPassengersInner>;
          result.passengers.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(TripManifestDtoOutputSeatsInner)]),
          ) as BuiltList<TripManifestDtoOutputSeatsInner>?;
          if (valueDes == null) continue;
          result.seats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripManifestDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripManifestDtoOutputBuilder();
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


