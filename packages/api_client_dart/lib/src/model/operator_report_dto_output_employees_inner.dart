//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_report_dto_output_employees_inner.g.dart';

/// OperatorReportDtoOutputEmployeesInner
///
/// Properties:
/// * [employeeId]
/// * [loginName]
/// * [role]
/// * [assignedTrips]
/// * [completedTrips]
/// * [ticketsChecked]
/// * [incidentsReported]
@BuiltValue()
abstract class OperatorReportDtoOutputEmployeesInner
    implements
        Built<OperatorReportDtoOutputEmployeesInner,
            OperatorReportDtoOutputEmployeesInnerBuilder> {
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'loginName')
  String get loginName;

  @BuiltValueField(wireName: r'role')
  OperatorReportDtoOutputEmployeesInnerRoleEnum get role;
  // enum roleEnum {  DRIVER,  TICKET_STAFF,  SUPPORT_STAFF,  };

  @BuiltValueField(wireName: r'assignedTrips')
  int get assignedTrips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'ticketsChecked')
  int get ticketsChecked;

  @BuiltValueField(wireName: r'incidentsReported')
  int get incidentsReported;

  OperatorReportDtoOutputEmployeesInner._();

  factory OperatorReportDtoOutputEmployeesInner(
          [void updates(OperatorReportDtoOutputEmployeesInnerBuilder b)]) =
      _$OperatorReportDtoOutputEmployeesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorReportDtoOutputEmployeesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorReportDtoOutputEmployeesInner> get serializer =>
      _$OperatorReportDtoOutputEmployeesInnerSerializer();
}

class _$OperatorReportDtoOutputEmployeesInnerSerializer
    implements PrimitiveSerializer<OperatorReportDtoOutputEmployeesInner> {
  @override
  final Iterable<Type> types = const [
    OperatorReportDtoOutputEmployeesInner,
    _$OperatorReportDtoOutputEmployeesInner
  ];

  @override
  final String wireName = r'OperatorReportDtoOutputEmployeesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorReportDtoOutputEmployeesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'loginName';
    yield serializers.serialize(
      object.loginName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType:
          const FullType(OperatorReportDtoOutputEmployeesInnerRoleEnum),
    );
    yield r'assignedTrips';
    yield serializers.serialize(
      object.assignedTrips,
      specifiedType: const FullType(int),
    );
    yield r'completedTrips';
    yield serializers.serialize(
      object.completedTrips,
      specifiedType: const FullType(int),
    );
    yield r'ticketsChecked';
    yield serializers.serialize(
      object.ticketsChecked,
      specifiedType: const FullType(int),
    );
    yield r'incidentsReported';
    yield serializers.serialize(
      object.incidentsReported,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorReportDtoOutputEmployeesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorReportDtoOutputEmployeesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'loginName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loginName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(OperatorReportDtoOutputEmployeesInnerRoleEnum),
          ) as OperatorReportDtoOutputEmployeesInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'assignedTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assignedTrips = valueDes;
          break;
        case r'completedTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completedTrips = valueDes;
          break;
        case r'ticketsChecked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsChecked = valueDes;
          break;
        case r'incidentsReported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.incidentsReported = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorReportDtoOutputEmployeesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorReportDtoOutputEmployeesInnerBuilder();
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

class OperatorReportDtoOutputEmployeesInnerRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DRIVER')
  static const OperatorReportDtoOutputEmployeesInnerRoleEnum DRIVER =
      _$operatorReportDtoOutputEmployeesInnerRoleEnum_DRIVER;
  @BuiltValueEnumConst(wireName: r'TICKET_STAFF')
  static const OperatorReportDtoOutputEmployeesInnerRoleEnum TICKET_STAFF =
      _$operatorReportDtoOutputEmployeesInnerRoleEnum_TICKET_STAFF;
  @BuiltValueEnumConst(wireName: r'SUPPORT_STAFF')
  static const OperatorReportDtoOutputEmployeesInnerRoleEnum SUPPORT_STAFF =
      _$operatorReportDtoOutputEmployeesInnerRoleEnum_SUPPORT_STAFF;

  static Serializer<OperatorReportDtoOutputEmployeesInnerRoleEnum>
      get serializer =>
          _$operatorReportDtoOutputEmployeesInnerRoleEnumSerializer;

  const OperatorReportDtoOutputEmployeesInnerRoleEnum._(String name)
      : super(name);

  static BuiltSet<OperatorReportDtoOutputEmployeesInnerRoleEnum> get values =>
      _$operatorReportDtoOutputEmployeesInnerRoleEnumValues;
  static OperatorReportDtoOutputEmployeesInnerRoleEnum valueOf(String name) =>
      _$operatorReportDtoOutputEmployeesInnerRoleEnumValueOf(name);
}
