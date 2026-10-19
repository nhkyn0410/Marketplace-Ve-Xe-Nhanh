//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_totals.g.dart';

/// AdminReportDtoOutputTotals
///
/// Properties:
/// * [gmv] 
/// * [bookings] 
/// * [tickets] 
/// * [netRevenue] 
/// * [reconcileOpen] 
/// * [trips] 
/// * [completedTrips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [operatorCancelledTrips] 
/// * [tripsWithSales] 
@BuiltValue()
abstract class AdminReportDtoOutputTotals implements Built<AdminReportDtoOutputTotals, AdminReportDtoOutputTotalsBuilder> {
  @BuiltValueField(wireName: r'gmv')
  int get gmv;

  @BuiltValueField(wireName: r'bookings')
  int get bookings;

  @BuiltValueField(wireName: r'tickets')
  int get tickets;

  @BuiltValueField(wireName: r'netRevenue')
  int get netRevenue;

  @BuiltValueField(wireName: r'reconcileOpen')
  int get reconcileOpen;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'operatorCancelledTrips')
  int get operatorCancelledTrips;

  @BuiltValueField(wireName: r'tripsWithSales')
  int get tripsWithSales;

  AdminReportDtoOutputTotals._();

  factory AdminReportDtoOutputTotals([void updates(AdminReportDtoOutputTotalsBuilder b)]) = _$AdminReportDtoOutputTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputTotals> get serializer => _$AdminReportDtoOutputTotalsSerializer();
}

class _$AdminReportDtoOutputTotalsSerializer implements PrimitiveSerializer<AdminReportDtoOutputTotals> {
  @override
  final Iterable<Type> types = const [AdminReportDtoOutputTotals, _$AdminReportDtoOutputTotals];

  @override
  final String wireName = r'AdminReportDtoOutputTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gmv';
    yield serializers.serialize(
      object.gmv,
      specifiedType: const FullType(int),
    );
    yield r'bookings';
    yield serializers.serialize(
      object.bookings,
      specifiedType: const FullType(int),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(int),
    );
    yield r'netRevenue';
    yield serializers.serialize(
      object.netRevenue,
      specifiedType: const FullType(int),
    );
    yield r'reconcileOpen';
    yield serializers.serialize(
      object.reconcileOpen,
      specifiedType: const FullType(int),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'completedTrips';
    yield serializers.serialize(
      object.completedTrips,
      specifiedType: const FullType(int),
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
    yield r'operatorCancelledTrips';
    yield serializers.serialize(
      object.operatorCancelledTrips,
      specifiedType: const FullType(int),
    );
    yield r'tripsWithSales';
    yield serializers.serialize(
      object.tripsWithSales,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmv = valueDes;
          break;
        case r'bookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookings = valueDes;
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tickets = valueDes;
          break;
        case r'netRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netRevenue = valueDes;
          break;
        case r'reconcileOpen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reconcileOpen = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
          break;
        case r'completedTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completedTrips = valueDes;
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
        case r'operatorCancelledTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.operatorCancelledTrips = valueDes;
          break;
        case r'tripsWithSales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripsWithSales = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputTotalsBuilder();
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


