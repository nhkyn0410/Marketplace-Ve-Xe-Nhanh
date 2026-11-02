//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_by_route_inner.g.dart';

/// AdminReportDtoOutputByRouteInner
///
/// Properties:
/// * [routeId] 
/// * [routeName] 
/// * [operatorId] 
/// * [operatorName] 
/// * [originName] 
/// * [destinationName] 
/// * [trips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [ticketRevenue] 
@BuiltValue()
abstract class AdminReportDtoOutputByRouteInner implements Built<AdminReportDtoOutputByRouteInner, AdminReportDtoOutputByRouteInnerBuilder> {
  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'originName')
  String? get originName;

  @BuiltValueField(wireName: r'destinationName')
  String? get destinationName;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'ticketRevenue')
  int get ticketRevenue;

  AdminReportDtoOutputByRouteInner._();

  factory AdminReportDtoOutputByRouteInner([void updates(AdminReportDtoOutputByRouteInnerBuilder b)]) = _$AdminReportDtoOutputByRouteInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputByRouteInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputByRouteInner> get serializer => _$AdminReportDtoOutputByRouteInnerSerializer();
}

class _$AdminReportDtoOutputByRouteInnerSerializer implements PrimitiveSerializer<AdminReportDtoOutputByRouteInner> {
  @override
  final Iterable<Type> types = const [AdminReportDtoOutputByRouteInner, _$AdminReportDtoOutputByRouteInner];

  @override
  final String wireName = r'AdminReportDtoOutputByRouteInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputByRouteInner object, {
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
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'originName';
    yield object.originName == null ? null : serializers.serialize(
      object.originName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'destinationName';
    yield object.destinationName == null ? null : serializers.serialize(
      object.destinationName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
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
    yield r'ticketRevenue';
    yield serializers.serialize(
      object.ticketRevenue,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputByRouteInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputByRouteInnerBuilder result,
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'originName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originName = valueDes;
          break;
        case r'destinationName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.destinationName = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
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
        case r'ticketRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketRevenue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputByRouteInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputByRouteInnerBuilder();
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


