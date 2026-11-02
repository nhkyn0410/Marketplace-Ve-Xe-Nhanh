//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_assignment_page_dto_output_items_inner_driver.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_assignment_page_dto_output_items_inner_conflict.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_assignment_page_dto_output_items_inner.g.dart';

/// TripAssignmentPageDtoOutputItemsInner
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [arrivalAt] 
/// * [status] 
/// * [routeName] 
/// * [vehiclePlateNumber] 
/// * [driver] 
/// * [conflict] 
/// * [reasonRequired] 
/// * [editable] 
@BuiltValue()
abstract class TripAssignmentPageDtoOutputItemsInner implements Built<TripAssignmentPageDtoOutputItemsInner, TripAssignmentPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  @BuiltValueField(wireName: r'status')
  TripAssignmentPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  OPEN_FOR_SALE,  SOLD_OUT,  LOCKED,  BOARDING,  DEPARTED,  IN_PROGRESS,  COMPLETED,  CANCELLED,  INCIDENT,  };

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'driver')
  TripAssignmentPageDtoOutputItemsInnerDriver? get driver;

  @BuiltValueField(wireName: r'conflict')
  TripAssignmentPageDtoOutputItemsInnerConflict? get conflict;

  @BuiltValueField(wireName: r'reasonRequired')
  bool get reasonRequired;

  @BuiltValueField(wireName: r'editable')
  bool get editable;

  TripAssignmentPageDtoOutputItemsInner._();

  factory TripAssignmentPageDtoOutputItemsInner([void updates(TripAssignmentPageDtoOutputItemsInnerBuilder b)]) = _$TripAssignmentPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripAssignmentPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripAssignmentPageDtoOutputItemsInner> get serializer => _$TripAssignmentPageDtoOutputItemsInnerSerializer();
}

class _$TripAssignmentPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<TripAssignmentPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [TripAssignmentPageDtoOutputItemsInner, _$TripAssignmentPageDtoOutputItemsInner];

  @override
  final String wireName = r'TripAssignmentPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
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
      specifiedType: const FullType(TripAssignmentPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'driver';
    yield object.driver == null ? null : serializers.serialize(
      object.driver,
      specifiedType: const FullType.nullable(TripAssignmentPageDtoOutputItemsInnerDriver),
    );
    yield r'conflict';
    yield object.conflict == null ? null : serializers.serialize(
      object.conflict,
      specifiedType: const FullType.nullable(TripAssignmentPageDtoOutputItemsInnerConflict),
    );
    yield r'reasonRequired';
    yield serializers.serialize(
      object.reasonRequired,
      specifiedType: const FullType(bool),
    );
    yield r'editable';
    yield serializers.serialize(
      object.editable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripAssignmentPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(TripAssignmentPageDtoOutputItemsInnerStatusEnum),
          ) as TripAssignmentPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        case r'driver':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TripAssignmentPageDtoOutputItemsInnerDriver),
          ) as TripAssignmentPageDtoOutputItemsInnerDriver?;
          if (valueDes == null) continue;
          result.driver.replace(valueDes);
          break;
        case r'conflict':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TripAssignmentPageDtoOutputItemsInnerConflict),
          ) as TripAssignmentPageDtoOutputItemsInnerConflict?;
          if (valueDes == null) continue;
          result.conflict.replace(valueDes);
          break;
        case r'reasonRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reasonRequired = valueDes;
          break;
        case r'editable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.editable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripAssignmentPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripAssignmentPageDtoOutputItemsInnerBuilder();
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


class TripAssignmentPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum DRAFT = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum OPEN_FOR_SALE = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum SOLD_OUT = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum LOCKED = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum BOARDING = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum DEPARTED = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum IN_PROGRESS = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum COMPLETED = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum CANCELLED = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const TripAssignmentPageDtoOutputItemsInnerStatusEnum INCIDENT = _$tripAssignmentPageDtoOutputItemsInnerStatusEnum_INCIDENT;

  static Serializer<TripAssignmentPageDtoOutputItemsInnerStatusEnum> get serializer => _$tripAssignmentPageDtoOutputItemsInnerStatusEnumSerializer;

  const TripAssignmentPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<TripAssignmentPageDtoOutputItemsInnerStatusEnum> get values => _$tripAssignmentPageDtoOutputItemsInnerStatusEnumValues;
  static TripAssignmentPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$tripAssignmentPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

