//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output_upcoming_inner.g.dart';

/// OperatorOverviewDtoOutputUpcomingInner
///
/// Properties:
/// * [tripId] 
/// * [routeName] 
/// * [departureAt] 
/// * [status] 
/// * [vehiclePlateNumber] 
/// * [ticketsSold] 
/// * [seats] 
/// * [driverName] 
@BuiltValue()
abstract class OperatorOverviewDtoOutputUpcomingInner implements Built<OperatorOverviewDtoOutputUpcomingInner, OperatorOverviewDtoOutputUpcomingInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'status')
  OperatorOverviewDtoOutputUpcomingInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  OPEN_FOR_SALE,  SOLD_OUT,  LOCKED,  BOARDING,  DEPARTED,  IN_PROGRESS,  COMPLETED,  CANCELLED,  INCIDENT,  };

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'driverName')
  String? get driverName;

  OperatorOverviewDtoOutputUpcomingInner._();

  factory OperatorOverviewDtoOutputUpcomingInner([void updates(OperatorOverviewDtoOutputUpcomingInnerBuilder b)]) = _$OperatorOverviewDtoOutputUpcomingInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputUpcomingInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutputUpcomingInner> get serializer => _$OperatorOverviewDtoOutputUpcomingInnerSerializer();
}

class _$OperatorOverviewDtoOutputUpcomingInnerSerializer implements PrimitiveSerializer<OperatorOverviewDtoOutputUpcomingInner> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutputUpcomingInner, _$OperatorOverviewDtoOutputUpcomingInner];

  @override
  final String wireName = r'OperatorOverviewDtoOutputUpcomingInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutputUpcomingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OperatorOverviewDtoOutputUpcomingInnerStatusEnum),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
    yield r'driverName';
    yield object.driverName == null ? null : serializers.serialize(
      object.driverName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorOverviewDtoOutputUpcomingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputUpcomingInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorOverviewDtoOutputUpcomingInnerStatusEnum),
          ) as OperatorOverviewDtoOutputUpcomingInnerStatusEnum;
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
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        case r'driverName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.driverName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorOverviewDtoOutputUpcomingInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputUpcomingInnerBuilder();
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


class OperatorOverviewDtoOutputUpcomingInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum DRAFT = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum OPEN_FOR_SALE = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_OPEN_FOR_SALE;
  @BuiltValueEnumConst(wireName: r'SOLD_OUT')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum SOLD_OUT = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_SOLD_OUT;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum LOCKED = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum BOARDING = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum DEPARTED = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum IN_PROGRESS = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum COMPLETED = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum CANCELLED = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'INCIDENT')
  static const OperatorOverviewDtoOutputUpcomingInnerStatusEnum INCIDENT = _$operatorOverviewDtoOutputUpcomingInnerStatusEnum_INCIDENT;

  static Serializer<OperatorOverviewDtoOutputUpcomingInnerStatusEnum> get serializer => _$operatorOverviewDtoOutputUpcomingInnerStatusEnumSerializer;

  const OperatorOverviewDtoOutputUpcomingInnerStatusEnum._(String name): super(name);

  static BuiltSet<OperatorOverviewDtoOutputUpcomingInnerStatusEnum> get values => _$operatorOverviewDtoOutputUpcomingInnerStatusEnumValues;
  static OperatorOverviewDtoOutputUpcomingInnerStatusEnum valueOf(String name) => _$operatorOverviewDtoOutputUpcomingInnerStatusEnumValueOf(name);
}

