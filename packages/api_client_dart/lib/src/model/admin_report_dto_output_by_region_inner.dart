//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_by_region_inner.g.dart';

/// AdminReportDtoOutputByRegionInner
///
/// Properties:
/// * [originProvinceId] 
/// * [originName] 
/// * [destinationProvinceId] 
/// * [destinationName] 
/// * [routes] 
/// * [operators] 
/// * [trips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [ticketRevenue] 
@BuiltValue()
abstract class AdminReportDtoOutputByRegionInner implements Built<AdminReportDtoOutputByRegionInner, AdminReportDtoOutputByRegionInnerBuilder> {
  @BuiltValueField(wireName: r'originProvinceId')
  String get originProvinceId;

  @BuiltValueField(wireName: r'originName')
  String get originName;

  @BuiltValueField(wireName: r'destinationProvinceId')
  String get destinationProvinceId;

  @BuiltValueField(wireName: r'destinationName')
  String get destinationName;

  @BuiltValueField(wireName: r'routes')
  int get routes;

  @BuiltValueField(wireName: r'operators')
  int get operators;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'ticketRevenue')
  int get ticketRevenue;

  AdminReportDtoOutputByRegionInner._();

  factory AdminReportDtoOutputByRegionInner([void updates(AdminReportDtoOutputByRegionInnerBuilder b)]) = _$AdminReportDtoOutputByRegionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputByRegionInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputByRegionInner> get serializer => _$AdminReportDtoOutputByRegionInnerSerializer();
}

class _$AdminReportDtoOutputByRegionInnerSerializer implements PrimitiveSerializer<AdminReportDtoOutputByRegionInner> {
  @override
  final Iterable<Type> types = const [AdminReportDtoOutputByRegionInner, _$AdminReportDtoOutputByRegionInner];

  @override
  final String wireName = r'AdminReportDtoOutputByRegionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputByRegionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'originProvinceId';
    yield serializers.serialize(
      object.originProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'originName';
    yield serializers.serialize(
      object.originName,
      specifiedType: const FullType(String),
    );
    yield r'destinationProvinceId';
    yield serializers.serialize(
      object.destinationProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'destinationName';
    yield serializers.serialize(
      object.destinationName,
      specifiedType: const FullType(String),
    );
    yield r'routes';
    yield serializers.serialize(
      object.routes,
      specifiedType: const FullType(int),
    );
    yield r'operators';
    yield serializers.serialize(
      object.operators,
      specifiedType: const FullType(int),
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
    AdminReportDtoOutputByRegionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputByRegionInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'originProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originProvinceId = valueDes;
          break;
        case r'originName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originName = valueDes;
          break;
        case r'destinationProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationProvinceId = valueDes;
          break;
        case r'destinationName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationName = valueDes;
          break;
        case r'routes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.routes = valueDes;
          break;
        case r'operators':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.operators = valueDes;
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
  AdminReportDtoOutputByRegionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputByRegionInnerBuilder();
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


