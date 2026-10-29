//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_page_dto_output_items_inner.g.dart';

/// AdminTripPageDtoOutputItemsInner
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
@BuiltValue()
abstract class AdminTripPageDtoOutputItemsInner implements Built<AdminTripPageDtoOutputItemsInner, AdminTripPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  AdminTripPageDtoOutputItemsInnerStatusEnum get status;
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

  AdminTripPageDtoOutputItemsInner._();

  factory AdminTripPageDtoOutputItemsInner([void updates(AdminTripPageDtoOutputItemsInnerBuilder b)]) = _$AdminTripPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripPageDtoOutputItemsInner> get serializer => _$AdminTripPageDtoOutputItemsInnerSerializer();
}

class _$AdminTripPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminTripPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminTripPageDtoOutputItemsInner, _$AdminTripPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminTripPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminTripPageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminTripPageDtoOutputItemsInnerStatusEnum),
          ) as AdminTripPageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripPageDtoOutputItemsInnerBuilder();
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


class AdminTripPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum DRAFT = _$adminTripPageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum OPEN_FOR_SALE = _$adminTripPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum SOLD_OUT = _$adminTripPageDtoOutputItemsInnerStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum LOCKED = _$adminTripPageDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum BOARDING = _$adminTripPageDtoOutputItemsInnerStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum DEPARTED = _$adminTripPageDtoOutputItemsInnerStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum IN_PROGRESS = _$adminTripPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum COMPLETED = _$adminTripPageDtoOutputItemsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum CANCELLED = _$adminTripPageDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const AdminTripPageDtoOutputItemsInnerStatusEnum INCIDENT = _$adminTripPageDtoOutputItemsInnerStatusEnum_INCIDENT;

  static Serializer<AdminTripPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminTripPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminTripPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminTripPageDtoOutputItemsInnerStatusEnum> get values => _$adminTripPageDtoOutputItemsInnerStatusEnumValues;
  static AdminTripPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminTripPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

