//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_report_dto_output_by_route_inner.g.dart';

/// OperatorReportDtoOutputByRouteInner
///
/// Properties:
/// * [routeId] 
/// * [routeName] 
/// * [trips] 
/// * [completedTrips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [grossRevenue] 
@BuiltValue()
abstract class OperatorReportDtoOutputByRouteInner implements Built<OperatorReportDtoOutputByRouteInner, OperatorReportDtoOutputByRouteInnerBuilder> {
  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'grossRevenue')
  int get grossRevenue;

  OperatorReportDtoOutputByRouteInner._();

  factory OperatorReportDtoOutputByRouteInner([void updates(OperatorReportDtoOutputByRouteInnerBuilder b)]) = _$OperatorReportDtoOutputByRouteInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorReportDtoOutputByRouteInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorReportDtoOutputByRouteInner> get serializer => _$OperatorReportDtoOutputByRouteInnerSerializer();
}

class _$OperatorReportDtoOutputByRouteInnerSerializer implements PrimitiveSerializer<OperatorReportDtoOutputByRouteInner> {
  @override
  final Iterable<Type> types = const [OperatorReportDtoOutputByRouteInner, _$OperatorReportDtoOutputByRouteInner];

  @override
  final String wireName = r'OperatorReportDtoOutputByRouteInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorReportDtoOutputByRouteInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeId';
    yield serializers.serialize(
      object.routeId,
      specifiedType: const FullType(String),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
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
    yield r'grossRevenue';
    yield serializers.serialize(
      object.grossRevenue,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorReportDtoOutputByRouteInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorReportDtoOutputByRouteInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeId = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
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
        case r'grossRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossRevenue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorReportDtoOutputByRouteInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorReportDtoOutputByRouteInnerBuilder();
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


