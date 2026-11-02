//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_route_page_dto_output_items_inner_origin.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_page_dto_output_items_inner.g.dart';

/// AdminRoutePageDtoOutputItemsInner
///
/// Properties:
/// * [trips] 
/// * [completedTrips] 
/// * [cancelledTrips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [ticketRevenue] 
/// * [id] 
/// * [name] 
/// * [status] 
/// * [operatorId] 
/// * [operatorName] 
/// * [origin] 
/// * [destination] 
/// * [stopCount] 
/// * [distanceMeters] 
/// * [durationSeconds] 
/// * [upcomingTrips] 
/// * [averageRating] 
/// * [reviewCount] 
@BuiltValue()
abstract class AdminRoutePageDtoOutputItemsInner implements Built<AdminRoutePageDtoOutputItemsInner, AdminRoutePageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'cancelledTrips')
  int get cancelledTrips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'ticketRevenue')
  int? get ticketRevenue;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminRoutePageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  DRAFT,  };

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'origin')
  AdminRoutePageDtoOutputItemsInnerOrigin? get origin;

  @BuiltValueField(wireName: r'destination')
  AdminRoutePageDtoOutputItemsInnerOrigin? get destination;

  @BuiltValueField(wireName: r'stopCount')
  int get stopCount;

  @BuiltValueField(wireName: r'distanceMeters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'durationSeconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'upcomingTrips')
  int get upcomingTrips;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  AdminRoutePageDtoOutputItemsInner._();

  factory AdminRoutePageDtoOutputItemsInner([void updates(AdminRoutePageDtoOutputItemsInnerBuilder b)]) = _$AdminRoutePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRoutePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRoutePageDtoOutputItemsInner> get serializer => _$AdminRoutePageDtoOutputItemsInnerSerializer();
}

class _$AdminRoutePageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminRoutePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminRoutePageDtoOutputItemsInner, _$AdminRoutePageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminRoutePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRoutePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'cancelledTrips';
    yield serializers.serialize(
      object.cancelledTrips,
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
    yield object.ticketRevenue == null ? null : serializers.serialize(
      object.ticketRevenue,
      specifiedType: const FullType.nullable(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminRoutePageDtoOutputItemsInnerStatusEnum),
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
    yield r'origin';
    yield object.origin == null ? null : serializers.serialize(
      object.origin,
      specifiedType: const FullType.nullable(AdminRoutePageDtoOutputItemsInnerOrigin),
    );
    yield r'destination';
    yield object.destination == null ? null : serializers.serialize(
      object.destination,
      specifiedType: const FullType.nullable(AdminRoutePageDtoOutputItemsInnerOrigin),
    );
    yield r'stopCount';
    yield serializers.serialize(
      object.stopCount,
      specifiedType: const FullType(int),
    );
    yield r'distanceMeters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'durationSeconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'upcomingTrips';
    yield serializers.serialize(
      object.upcomingTrips,
      specifiedType: const FullType(int),
    );
    yield r'averageRating';
    yield object.averageRating == null ? null : serializers.serialize(
      object.averageRating,
      specifiedType: const FullType.nullable(num),
    );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRoutePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRoutePageDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'cancelledTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelledTrips = valueDes;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ticketRevenue = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRoutePageDtoOutputItemsInnerStatusEnum),
          ) as AdminRoutePageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
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
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminRoutePageDtoOutputItemsInnerOrigin),
          ) as AdminRoutePageDtoOutputItemsInnerOrigin?;
          if (valueDes == null) continue;
          result.origin.replace(valueDes);
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminRoutePageDtoOutputItemsInnerOrigin),
          ) as AdminRoutePageDtoOutputItemsInnerOrigin?;
          if (valueDes == null) continue;
          result.destination.replace(valueDes);
          break;
        case r'stopCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stopCount = valueDes;
          break;
        case r'distanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'durationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'upcomingTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.upcomingTrips = valueDes;
          break;
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRoutePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRoutePageDtoOutputItemsInnerBuilder();
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


class AdminRoutePageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminRoutePageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminRoutePageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminRoutePageDtoOutputItemsInnerStatusEnum INACTIVE = _$adminRoutePageDtoOutputItemsInnerStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminRoutePageDtoOutputItemsInnerStatusEnum DRAFT = _$adminRoutePageDtoOutputItemsInnerStatusEnum_DRAFT;

  static Serializer<AdminRoutePageDtoOutputItemsInnerStatusEnum> get serializer => _$adminRoutePageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminRoutePageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminRoutePageDtoOutputItemsInnerStatusEnum> get values => _$adminRoutePageDtoOutputItemsInnerStatusEnumValues;
  static AdminRoutePageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminRoutePageDtoOutputItemsInnerStatusEnumValueOf(name);
}

