//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_trip_detail_dto_output_staff_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_trip_detail_dto_output_manifest_inner.dart';
import 'package:api_client_dart/src/model/admin_trip_detail_dto_output_stops_inner.dart';
import 'package:api_client_dart/src/model/admin_trip_detail_dto_output_seat_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_detail_dto_output.g.dart';

/// AdminTripDetailDtoOutput
///
/// Properties:
/// * [id] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [status] 
/// * [operatorId] 
/// * [operatorName] 
/// * [routeId] 
/// * [routeName] 
/// * [vehiclePlate] 
/// * [seats] 
/// * [ticketsSold] 
/// * [statusReason] 
/// * [departedAt] 
/// * [completedAt] 
/// * [onlineSaleCutoffMinutes] 
/// * [vehicleTypeName] 
/// * [stops] 
/// * [seatSummary] 
/// * [staff] 
/// * [bookingCount] 
/// * [ticketRevenue] 
/// * [manifest] 
@BuiltValue()
abstract class AdminTripDetailDtoOutput implements Built<AdminTripDetailDtoOutput, AdminTripDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  AdminTripDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  OPEN_FOR_SALE,  SOLD_OUT,  LOCKED,  BOARDING,  DEPARTED,  IN_PROGRESS,  COMPLETED,  CANCELLED,  INCIDENT,  };

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehiclePlate')
  String? get vehiclePlate;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'statusReason')
  String? get statusReason;

  @BuiltValueField(wireName: r'departedAt')
  DateTime? get departedAt;

  @BuiltValueField(wireName: r'completedAt')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'onlineSaleCutoffMinutes')
  int get onlineSaleCutoffMinutes;

  @BuiltValueField(wireName: r'vehicleTypeName')
  String? get vehicleTypeName;

  @BuiltValueField(wireName: r'stops')
  BuiltList<AdminTripDetailDtoOutputStopsInner> get stops;

  @BuiltValueField(wireName: r'seatSummary')
  AdminTripDetailDtoOutputSeatSummary get seatSummary;

  @BuiltValueField(wireName: r'staff')
  BuiltList<AdminTripDetailDtoOutputStaffInner> get staff;

  @BuiltValueField(wireName: r'bookingCount')
  int get bookingCount;

  @BuiltValueField(wireName: r'ticketRevenue')
  int? get ticketRevenue;

  @BuiltValueField(wireName: r'manifest')
  BuiltList<AdminTripDetailDtoOutputManifestInner> get manifest;

  AdminTripDetailDtoOutput._();

  factory AdminTripDetailDtoOutput([void updates(AdminTripDetailDtoOutputBuilder b)]) = _$AdminTripDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripDetailDtoOutput> get serializer => _$AdminTripDetailDtoOutputSerializer();
}

class _$AdminTripDetailDtoOutputSerializer implements PrimitiveSerializer<AdminTripDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminTripDetailDtoOutput, _$AdminTripDetailDtoOutput];

  @override
  final String wireName = r'AdminTripDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripDetailDtoOutput object, {
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
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminTripDetailDtoOutputStatusEnum),
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
    yield r'statusReason';
    yield object.statusReason == null ? null : serializers.serialize(
      object.statusReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'departedAt';
    yield object.departedAt == null ? null : serializers.serialize(
      object.departedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'completedAt';
    yield object.completedAt == null ? null : serializers.serialize(
      object.completedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'onlineSaleCutoffMinutes';
    yield serializers.serialize(
      object.onlineSaleCutoffMinutes,
      specifiedType: const FullType(int),
    );
    yield r'vehicleTypeName';
    yield object.vehicleTypeName == null ? null : serializers.serialize(
      object.vehicleTypeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stops';
    yield serializers.serialize(
      object.stops,
      specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputStopsInner)]),
    );
    yield r'seatSummary';
    yield serializers.serialize(
      object.seatSummary,
      specifiedType: const FullType(AdminTripDetailDtoOutputSeatSummary),
    );
    yield r'staff';
    yield serializers.serialize(
      object.staff,
      specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputStaffInner)]),
    );
    yield r'bookingCount';
    yield serializers.serialize(
      object.bookingCount,
      specifiedType: const FullType(int),
    );
    yield r'ticketRevenue';
    yield object.ticketRevenue == null ? null : serializers.serialize(
      object.ticketRevenue,
      specifiedType: const FullType.nullable(int),
    );
    yield r'manifest';
    yield serializers.serialize(
      object.manifest,
      specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputManifestInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripDetailDtoOutputBuilder result,
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
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTripDetailDtoOutputStatusEnum),
          ) as AdminTripDetailDtoOutputStatusEnum;
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
        case r'statusReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.statusReason = valueDes;
          break;
        case r'departedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.departedAt = valueDes;
          break;
        case r'completedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'onlineSaleCutoffMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineSaleCutoffMinutes = valueDes;
          break;
        case r'vehicleTypeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleTypeName = valueDes;
          break;
        case r'stops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputStopsInner)]),
          ) as BuiltList<AdminTripDetailDtoOutputStopsInner>;
          result.stops.replace(valueDes);
          break;
        case r'seatSummary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTripDetailDtoOutputSeatSummary),
          ) as AdminTripDetailDtoOutputSeatSummary;
          result.seatSummary.replace(valueDes);
          break;
        case r'staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputStaffInner)]),
          ) as BuiltList<AdminTripDetailDtoOutputStaffInner>;
          result.staff.replace(valueDes);
          break;
        case r'bookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingCount = valueDes;
          break;
        case r'ticketRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ticketRevenue = valueDes;
          break;
        case r'manifest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminTripDetailDtoOutputManifestInner)]),
          ) as BuiltList<AdminTripDetailDtoOutputManifestInner>;
          result.manifest.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripDetailDtoOutputBuilder();
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


class AdminTripDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminTripDetailDtoOutputStatusEnum DRAFT = _$adminTripDetailDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const AdminTripDetailDtoOutputStatusEnum OPEN_FOR_SALE = _$adminTripDetailDtoOutputStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const AdminTripDetailDtoOutputStatusEnum SOLD_OUT = _$adminTripDetailDtoOutputStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminTripDetailDtoOutputStatusEnum LOCKED = _$adminTripDetailDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const AdminTripDetailDtoOutputStatusEnum BOARDING = _$adminTripDetailDtoOutputStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const AdminTripDetailDtoOutputStatusEnum DEPARTED = _$adminTripDetailDtoOutputStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const AdminTripDetailDtoOutputStatusEnum IN_PROGRESS = _$adminTripDetailDtoOutputStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const AdminTripDetailDtoOutputStatusEnum COMPLETED = _$adminTripDetailDtoOutputStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminTripDetailDtoOutputStatusEnum CANCELLED = _$adminTripDetailDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const AdminTripDetailDtoOutputStatusEnum INCIDENT = _$adminTripDetailDtoOutputStatusEnum_INCIDENT;

  static Serializer<AdminTripDetailDtoOutputStatusEnum> get serializer => _$adminTripDetailDtoOutputStatusEnumSerializer;

  const AdminTripDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminTripDetailDtoOutputStatusEnum> get values => _$adminTripDetailDtoOutputStatusEnumValues;
  static AdminTripDetailDtoOutputStatusEnum valueOf(String name) => _$adminTripDetailDtoOutputStatusEnumValueOf(name);
}

