//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_vehicle_list_dto_output_items_inner.g.dart';

/// AdminOperatorVehicleListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [plateNumber] 
/// * [vehicleTypeName] 
/// * [seatCount] 
/// * [status] 
/// * [upcomingTripCount] 
@BuiltValue()
abstract class AdminOperatorVehicleListDtoOutputItemsInner implements Built<AdminOperatorVehicleListDtoOutputItemsInner, AdminOperatorVehicleListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'plateNumber')
  String get plateNumber;

  @BuiltValueField(wireName: r'vehicleTypeName')
  String get vehicleTypeName;

  @BuiltValueField(wireName: r'seatCount')
  int? get seatCount;

  @BuiltValueField(wireName: r'status')
  AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  MAINTENANCE,  INACTIVE,  };

  @BuiltValueField(wireName: r'upcomingTripCount')
  int get upcomingTripCount;

  AdminOperatorVehicleListDtoOutputItemsInner._();

  factory AdminOperatorVehicleListDtoOutputItemsInner([void updates(AdminOperatorVehicleListDtoOutputItemsInnerBuilder b)]) = _$AdminOperatorVehicleListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorVehicleListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorVehicleListDtoOutputItemsInner> get serializer => _$AdminOperatorVehicleListDtoOutputItemsInnerSerializer();
}

class _$AdminOperatorVehicleListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminOperatorVehicleListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminOperatorVehicleListDtoOutputItemsInner, _$AdminOperatorVehicleListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminOperatorVehicleListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorVehicleListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'plateNumber';
    yield serializers.serialize(
      object.plateNumber,
      specifiedType: const FullType(String),
    );
    yield r'vehicleTypeName';
    yield serializers.serialize(
      object.vehicleTypeName,
      specifiedType: const FullType(String),
    );
    yield r'seatCount';
    yield object.seatCount == null ? null : serializers.serialize(
      object.seatCount,
      specifiedType: const FullType.nullable(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum),
    );
    yield r'upcomingTripCount';
    yield serializers.serialize(
      object.upcomingTripCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorVehicleListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorVehicleListDtoOutputItemsInnerBuilder result,
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
        case r'plateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.plateNumber = valueDes;
          break;
        case r'vehicleTypeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleTypeName = valueDes;
          break;
        case r'seatCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.seatCount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum),
          ) as AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'upcomingTripCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.upcomingTripCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorVehicleListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorVehicleListDtoOutputItemsInnerBuilder();
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


class AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'MAINTENANCE')
  static const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum MAINTENANCE = _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_MAINTENANCE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum INACTIVE = _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnum_INACTIVE;

  static Serializer<AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum> get serializer => _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum> get values => _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumValues;
  static AdminOperatorVehicleListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminOperatorVehicleListDtoOutputItemsInnerStatusEnumValueOf(name);
}

