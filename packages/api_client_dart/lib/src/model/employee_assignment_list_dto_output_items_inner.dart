//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_assignment_list_dto_output_items_inner.g.dart';

/// EmployeeAssignmentListDtoOutputItemsInner
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
abstract class EmployeeAssignmentListDtoOutputItemsInner implements Built<EmployeeAssignmentListDtoOutputItemsInner, EmployeeAssignmentListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'role')
  EmployeeAssignmentListDtoOutputItemsInnerRoleEnum get role;
  // enum roleEnum {  DRIVER,  TICKET_STAFF,  SUPPORT_STAFF,  SALES_STAFF,  };

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  EmployeeAssignmentListDtoOutputItemsInnerStatusEnum get status;
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

  EmployeeAssignmentListDtoOutputItemsInner._();

  factory EmployeeAssignmentListDtoOutputItemsInner([void updates(EmployeeAssignmentListDtoOutputItemsInnerBuilder b)]) = _$EmployeeAssignmentListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeAssignmentListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeAssignmentListDtoOutputItemsInner> get serializer => _$EmployeeAssignmentListDtoOutputItemsInnerSerializer();
}

class _$EmployeeAssignmentListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<EmployeeAssignmentListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [EmployeeAssignmentListDtoOutputItemsInner, _$EmployeeAssignmentListDtoOutputItemsInner];

  @override
  final String wireName = r'EmployeeAssignmentListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeAssignmentListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInnerRoleEnum),
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
      specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInnerStatusEnum),
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
    EmployeeAssignmentListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeAssignmentListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInnerRoleEnum),
          ) as EmployeeAssignmentListDtoOutputItemsInnerRoleEnum;
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
            specifiedType: const FullType(EmployeeAssignmentListDtoOutputItemsInnerStatusEnum),
          ) as EmployeeAssignmentListDtoOutputItemsInnerStatusEnum;
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
  EmployeeAssignmentListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeAssignmentListDtoOutputItemsInnerBuilder();
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


class EmployeeAssignmentListDtoOutputItemsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRIVER')
  static const EmployeeAssignmentListDtoOutputItemsInnerRoleEnum DRIVER = _$employeeAssignmentListDtoOutputItemsInnerRoleEnum_DRIVER;
  @BuiltValueEnumConst(wireName: r'TICKET_STAFF')
  static const EmployeeAssignmentListDtoOutputItemsInnerRoleEnum TICKET_STAFF = _$employeeAssignmentListDtoOutputItemsInnerRoleEnum_TICKET_STAFF;
  @BuiltValueEnumConst(wireName: r'SUPPORT_STAFF')
  static const EmployeeAssignmentListDtoOutputItemsInnerRoleEnum SUPPORT_STAFF = _$employeeAssignmentListDtoOutputItemsInnerRoleEnum_SUPPORT_STAFF;
  @BuiltValueEnumConst(wireName: r'SALES_STAFF')
  static const EmployeeAssignmentListDtoOutputItemsInnerRoleEnum SALES_STAFF = _$employeeAssignmentListDtoOutputItemsInnerRoleEnum_SALES_STAFF;

  static Serializer<EmployeeAssignmentListDtoOutputItemsInnerRoleEnum> get serializer => _$employeeAssignmentListDtoOutputItemsInnerRoleEnumSerializer;

  const EmployeeAssignmentListDtoOutputItemsInnerRoleEnum._(String name): super(name);

  static BuiltSet<EmployeeAssignmentListDtoOutputItemsInnerRoleEnum> get values => _$employeeAssignmentListDtoOutputItemsInnerRoleEnumValues;
  static EmployeeAssignmentListDtoOutputItemsInnerRoleEnum valueOf(String name) => _$employeeAssignmentListDtoOutputItemsInnerRoleEnumValueOf(name);
}

class EmployeeAssignmentListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum DRAFT = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum OPEN_FOR_SALE = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum SOLD_OUT = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum LOCKED = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum BOARDING = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum DEPARTED = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum IN_PROGRESS = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum COMPLETED = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum CANCELLED = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum INCIDENT = _$employeeAssignmentListDtoOutputItemsInnerStatusEnum_INCIDENT;

  static Serializer<EmployeeAssignmentListDtoOutputItemsInnerStatusEnum> get serializer => _$employeeAssignmentListDtoOutputItemsInnerStatusEnumSerializer;

  const EmployeeAssignmentListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<EmployeeAssignmentListDtoOutputItemsInnerStatusEnum> get values => _$employeeAssignmentListDtoOutputItemsInnerStatusEnumValues;
  static EmployeeAssignmentListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$employeeAssignmentListDtoOutputItemsInnerStatusEnumValueOf(name);
}

