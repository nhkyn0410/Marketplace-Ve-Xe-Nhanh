//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_report_dto_output_totals.g.dart';

/// OperatorReportDtoOutputTotals
///
/// Properties:
/// * [grossRevenue] 
/// * [trips] 
/// * [completedTrips] 
/// * [ticketsSold] 
/// * [bookings] 
/// * [seats] 
/// * [cancelledTickets] 
/// * [refundedTickets] 
@BuiltValue()
abstract class OperatorReportDtoOutputTotals implements Built<OperatorReportDtoOutputTotals, OperatorReportDtoOutputTotalsBuilder> {
  @BuiltValueField(wireName: r'grossRevenue')
  int get grossRevenue;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'bookings')
  int get bookings;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'cancelledTickets')
  int get cancelledTickets;

  @BuiltValueField(wireName: r'refundedTickets')
  int get refundedTickets;

  OperatorReportDtoOutputTotals._();

  factory OperatorReportDtoOutputTotals([void updates(OperatorReportDtoOutputTotalsBuilder b)]) = _$OperatorReportDtoOutputTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorReportDtoOutputTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorReportDtoOutputTotals> get serializer => _$OperatorReportDtoOutputTotalsSerializer();
}

class _$OperatorReportDtoOutputTotalsSerializer implements PrimitiveSerializer<OperatorReportDtoOutputTotals> {
  @override
  final Iterable<Type> types = const [OperatorReportDtoOutputTotals, _$OperatorReportDtoOutputTotals];

  @override
  final String wireName = r'OperatorReportDtoOutputTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorReportDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'grossRevenue';
    yield serializers.serialize(
      object.grossRevenue,
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
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'bookings';
    yield serializers.serialize(
      object.bookings,
      specifiedType: const FullType(int),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
    yield r'cancelledTickets';
    yield serializers.serialize(
      object.cancelledTickets,
      specifiedType: const FullType(int),
    );
    yield r'refundedTickets';
    yield serializers.serialize(
      object.refundedTickets,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorReportDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorReportDtoOutputTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'grossRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossRevenue = valueDes;
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
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'bookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookings = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        case r'cancelledTickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelledTickets = valueDes;
          break;
        case r'refundedTickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundedTickets = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorReportDtoOutputTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorReportDtoOutputTotalsBuilder();
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


