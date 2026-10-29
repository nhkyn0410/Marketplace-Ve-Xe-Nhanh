//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_detail_dto_output_next_trips_inner.g.dart';

/// AdminRouteDetailDtoOutputNextTripsInner
///
/// Properties:
/// * [id] 
/// * [departureAt] 
/// * [status] 
/// * [vehiclePlate] 
/// * [seats] 
/// * [ticketsSold] 
@BuiltValue()
abstract class AdminRouteDetailDtoOutputNextTripsInner implements Built<AdminRouteDetailDtoOutputNextTripsInner, AdminRouteDetailDtoOutputNextTripsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'vehiclePlate')
  String? get vehiclePlate;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  AdminRouteDetailDtoOutputNextTripsInner._();

  factory AdminRouteDetailDtoOutputNextTripsInner([void updates(AdminRouteDetailDtoOutputNextTripsInnerBuilder b)]) = _$AdminRouteDetailDtoOutputNextTripsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRouteDetailDtoOutputNextTripsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRouteDetailDtoOutputNextTripsInner> get serializer => _$AdminRouteDetailDtoOutputNextTripsInnerSerializer();
}

class _$AdminRouteDetailDtoOutputNextTripsInnerSerializer implements PrimitiveSerializer<AdminRouteDetailDtoOutputNextTripsInner> {
  @override
  final Iterable<Type> types = const [AdminRouteDetailDtoOutputNextTripsInner, _$AdminRouteDetailDtoOutputNextTripsInner];

  @override
  final String wireName = r'AdminRouteDetailDtoOutputNextTripsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRouteDetailDtoOutputNextTripsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'vehiclePlate';
    yield object.vehiclePlate == null ? null : serializers.serialize(
      object.vehiclePlate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRouteDetailDtoOutputNextTripsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRouteDetailDtoOutputNextTripsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'vehiclePlate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlate = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRouteDetailDtoOutputNextTripsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRouteDetailDtoOutputNextTripsInnerBuilder();
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


