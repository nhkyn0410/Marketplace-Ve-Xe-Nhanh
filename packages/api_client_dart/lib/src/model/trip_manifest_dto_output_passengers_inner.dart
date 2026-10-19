//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before_stops_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_manifest_dto_output_passengers_inner.g.dart';

/// TripManifestDtoOutputPassengersInner
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [seatCode] 
/// * [passengerName] 
/// * [phoneMasked] 
/// * [pickup] 
/// * [dropoff] 
/// * [status] 
/// * [checkedInAt] 
@BuiltValue()
abstract class TripManifestDtoOutputPassengersInner implements Built<TripManifestDtoOutputPassengersInner, TripManifestDtoOutputPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'phoneMasked')
  String get phoneMasked;

  @BuiltValueField(wireName: r'pickup')
  TripSalesDtoOutputChangesInnerBeforeStopsInner get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSalesDtoOutputChangesInnerBeforeStopsInner get dropoff;

  @BuiltValueField(wireName: r'status')
  TripManifestDtoOutputPassengersInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'checkedInAt')
  DateTime? get checkedInAt;

  TripManifestDtoOutputPassengersInner._();

  factory TripManifestDtoOutputPassengersInner([void updates(TripManifestDtoOutputPassengersInnerBuilder b)]) = _$TripManifestDtoOutputPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripManifestDtoOutputPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripManifestDtoOutputPassengersInner> get serializer => _$TripManifestDtoOutputPassengersInnerSerializer();
}

class _$TripManifestDtoOutputPassengersInnerSerializer implements PrimitiveSerializer<TripManifestDtoOutputPassengersInner> {
  @override
  final Iterable<Type> types = const [TripManifestDtoOutputPassengersInner, _$TripManifestDtoOutputPassengersInner];

  @override
  final String wireName = r'TripManifestDtoOutputPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripManifestDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'passengerName';
    yield serializers.serialize(
      object.passengerName,
      specifiedType: const FullType(String),
    );
    yield r'phoneMasked';
    yield serializers.serialize(
      object.phoneMasked,
      specifiedType: const FullType(String),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TripManifestDtoOutputPassengersInnerStatusEnum),
    );
    yield r'checkedInAt';
    yield object.checkedInAt == null ? null : serializers.serialize(
      object.checkedInAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripManifestDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripManifestDtoOutputPassengersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketId = valueDes;
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'passengerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passengerName = valueDes;
          break;
        case r'phoneMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneMasked = valueDes;
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
          ) as TripSalesDtoOutputChangesInnerBeforeStopsInner;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
          ) as TripSalesDtoOutputChangesInnerBeforeStopsInner;
          result.dropoff.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripManifestDtoOutputPassengersInnerStatusEnum),
          ) as TripManifestDtoOutputPassengersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'checkedInAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkedInAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripManifestDtoOutputPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripManifestDtoOutputPassengersInnerBuilder();
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


class TripManifestDtoOutputPassengersInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const TripManifestDtoOutputPassengersInnerStatusEnum VALID = _$tripManifestDtoOutputPassengersInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TripManifestDtoOutputPassengersInnerStatusEnum CANCELLED = _$tripManifestDtoOutputPassengersInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const TripManifestDtoOutputPassengersInnerStatusEnum CHECKED_IN = _$tripManifestDtoOutputPassengersInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const TripManifestDtoOutputPassengersInnerStatusEnum NO_SHOW = _$tripManifestDtoOutputPassengersInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const TripManifestDtoOutputPassengersInnerStatusEnum USED = _$tripManifestDtoOutputPassengersInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TripManifestDtoOutputPassengersInnerStatusEnum REFUNDED = _$tripManifestDtoOutputPassengersInnerStatusEnum_REFUNDED;

  static Serializer<TripManifestDtoOutputPassengersInnerStatusEnum> get serializer => _$tripManifestDtoOutputPassengersInnerStatusEnumSerializer;

  const TripManifestDtoOutputPassengersInnerStatusEnum._(String name): super(name);

  static BuiltSet<TripManifestDtoOutputPassengersInnerStatusEnum> get values => _$tripManifestDtoOutputPassengersInnerStatusEnumValues;
  static TripManifestDtoOutputPassengersInnerStatusEnum valueOf(String name) => _$tripManifestDtoOutputPassengersInnerStatusEnumValueOf(name);
}

