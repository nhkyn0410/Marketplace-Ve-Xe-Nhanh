//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_assignment_dto_output.g.dart';

/// EmployeeAssignmentDtoOutput
///
/// Properties:
/// * [tripId] 
/// * [role] 
/// * [routeName] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [status] 
/// * [vehiclePlateNumber] 
/// * [origin] 
/// * [destination] 
/// * [ticketCount] 
/// * [checkedInCount] 
@BuiltValue()
abstract class EmployeeAssignmentDtoOutput implements Built<EmployeeAssignmentDtoOutput, EmployeeAssignmentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'role')
  EmployeeAssignmentDtoOutputRoleEnum get role;
  // enum roleEnum {  DRIVER,  TICKET_STAFF,  SUPPORT_STAFF,  };

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  EmployeeAssignmentDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  OPEN_FOR_SALE,  SOLD_OUT,  LOCKED,  BOARDING,  DEPARTED,  IN_PROGRESS,  COMPLETED,  CANCELLED,  INCIDENT,  };

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'origin')
  String get origin;

  @BuiltValueField(wireName: r'destination')
  String get destination;

  @BuiltValueField(wireName: r'ticketCount')
  int get ticketCount;

  @BuiltValueField(wireName: r'checkedInCount')
  int get checkedInCount;

  EmployeeAssignmentDtoOutput._();

  factory EmployeeAssignmentDtoOutput([void updates(EmployeeAssignmentDtoOutputBuilder b)]) = _$EmployeeAssignmentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeAssignmentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeAssignmentDtoOutput> get serializer => _$EmployeeAssignmentDtoOutputSerializer();
}

class _$EmployeeAssignmentDtoOutputSerializer implements PrimitiveSerializer<EmployeeAssignmentDtoOutput> {
  @override
  final Iterable<Type> types = const [EmployeeAssignmentDtoOutput, _$EmployeeAssignmentDtoOutput];

  @override
  final String wireName = r'EmployeeAssignmentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeAssignmentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(EmployeeAssignmentDtoOutputRoleEnum),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
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
      specifiedType: const FullType(EmployeeAssignmentDtoOutputStatusEnum),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(String),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(String),
    );
    yield r'ticketCount';
    yield serializers.serialize(
      object.ticketCount,
      specifiedType: const FullType(int),
    );
    yield r'checkedInCount';
    yield serializers.serialize(
      object.checkedInCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeAssignmentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeAssignmentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeAssignmentDtoOutputRoleEnum),
          ) as EmployeeAssignmentDtoOutputRoleEnum;
          result.role = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
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
            specifiedType: const FullType(EmployeeAssignmentDtoOutputStatusEnum),
          ) as EmployeeAssignmentDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origin = valueDes;
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destination = valueDes;
          break;
        case r'ticketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketCount = valueDes;
          break;
        case r'checkedInCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checkedInCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeAssignmentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeAssignmentDtoOutputBuilder();
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


class EmployeeAssignmentDtoOutputRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRIVER')
  static const EmployeeAssignmentDtoOutputRoleEnum DRIVER = _$employeeAssignmentDtoOutputRoleEnum_DRIVER;
  @BuiltValueEnumConst(wireName: r'TICKET_STAFF')
  static const EmployeeAssignmentDtoOutputRoleEnum TICKET_STAFF = _$employeeAssignmentDtoOutputRoleEnum_TICKET_STAFF;
  @BuiltValueEnumConst(wireName: r'SUPPORT_STAFF')
  static const EmployeeAssignmentDtoOutputRoleEnum SUPPORT_STAFF = _$employeeAssignmentDtoOutputRoleEnum_SUPPORT_STAFF;

  static Serializer<EmployeeAssignmentDtoOutputRoleEnum> get serializer => _$employeeAssignmentDtoOutputRoleEnumSerializer;

  const EmployeeAssignmentDtoOutputRoleEnum._(String name): super(name);

  static BuiltSet<EmployeeAssignmentDtoOutputRoleEnum> get values => _$employeeAssignmentDtoOutputRoleEnumValues;
  static EmployeeAssignmentDtoOutputRoleEnum valueOf(String name) => _$employeeAssignmentDtoOutputRoleEnumValueOf(name);
}

class EmployeeAssignmentDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const EmployeeAssignmentDtoOutputStatusEnum DRAFT = _$employeeAssignmentDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const EmployeeAssignmentDtoOutputStatusEnum OPEN_FOR_SALE = _$employeeAssignmentDtoOutputStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const EmployeeAssignmentDtoOutputStatusEnum SOLD_OUT = _$employeeAssignmentDtoOutputStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const EmployeeAssignmentDtoOutputStatusEnum LOCKED = _$employeeAssignmentDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const EmployeeAssignmentDtoOutputStatusEnum BOARDING = _$employeeAssignmentDtoOutputStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const EmployeeAssignmentDtoOutputStatusEnum DEPARTED = _$employeeAssignmentDtoOutputStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const EmployeeAssignmentDtoOutputStatusEnum IN_PROGRESS = _$employeeAssignmentDtoOutputStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const EmployeeAssignmentDtoOutputStatusEnum COMPLETED = _$employeeAssignmentDtoOutputStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const EmployeeAssignmentDtoOutputStatusEnum CANCELLED = _$employeeAssignmentDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const EmployeeAssignmentDtoOutputStatusEnum INCIDENT = _$employeeAssignmentDtoOutputStatusEnum_INCIDENT;

  static Serializer<EmployeeAssignmentDtoOutputStatusEnum> get serializer => _$employeeAssignmentDtoOutputStatusEnumSerializer;

  const EmployeeAssignmentDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<EmployeeAssignmentDtoOutputStatusEnum> get values => _$employeeAssignmentDtoOutputStatusEnumValues;
  static EmployeeAssignmentDtoOutputStatusEnum valueOf(String name) => _$employeeAssignmentDtoOutputStatusEnumValueOf(name);
}

