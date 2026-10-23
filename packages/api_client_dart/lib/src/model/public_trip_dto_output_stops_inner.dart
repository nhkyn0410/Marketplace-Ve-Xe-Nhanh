//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_stops_inner.g.dart';

/// PublicTripDtoOutputStopsInner
///
/// Properties:
/// * [sequence] 
/// * [role] 
/// * [name] 
/// * [address] 
/// * [type] 
/// * [latitude] 
/// * [longitude] 
/// * [plannedAt] 
/// * [pickupWindowStart] 
/// * [pickupWindowEnd] 
/// * [allowPickup] 
/// * [allowDropoff] 
/// * [note] 
@BuiltValue()
abstract class PublicTripDtoOutputStopsInner implements Built<PublicTripDtoOutputStopsInner, PublicTripDtoOutputStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'role')
  PublicTripDtoOutputStopsInnerRoleEnum get role;
  // enum roleEnum {  ORIGIN,  INTERMEDIATE,  DESTINATION,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'type')
  PublicTripDtoOutputStopsInnerTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  OFFICE,  REST_STOP,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  @BuiltValueField(wireName: r'pickupWindowStart')
  DateTime? get pickupWindowStart;

  @BuiltValueField(wireName: r'pickupWindowEnd')
  DateTime? get pickupWindowEnd;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  @BuiltValueField(wireName: r'note')
  String? get note;

  PublicTripDtoOutputStopsInner._();

  factory PublicTripDtoOutputStopsInner([void updates(PublicTripDtoOutputStopsInnerBuilder b)]) = _$PublicTripDtoOutputStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputStopsInner> get serializer => _$PublicTripDtoOutputStopsInnerSerializer();
}

class _$PublicTripDtoOutputStopsInnerSerializer implements PrimitiveSerializer<PublicTripDtoOutputStopsInner> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputStopsInner, _$PublicTripDtoOutputStopsInner];

  @override
  final String wireName = r'PublicTripDtoOutputStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(PublicTripDtoOutputStopsInnerRoleEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PublicTripDtoOutputStopsInnerTypeEnum),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'plannedAt';
    yield serializers.serialize(
      object.plannedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'pickupWindowStart';
    yield object.pickupWindowStart == null ? null : serializers.serialize(
      object.pickupWindowStart,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'pickupWindowEnd';
    yield object.pickupWindowEnd == null ? null : serializers.serialize(
      object.pickupWindowEnd,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'allowPickup';
    yield serializers.serialize(
      object.allowPickup,
      specifiedType: const FullType(bool),
    );
    yield r'allowDropoff';
    yield serializers.serialize(
      object.allowDropoff,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputStopsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputStopsInnerRoleEnum),
          ) as PublicTripDtoOutputStopsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputStopsInnerTypeEnum),
          ) as PublicTripDtoOutputStopsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'plannedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.plannedAt = valueDes;
          break;
        case r'pickupWindowStart':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickupWindowStart = valueDes;
          break;
        case r'pickupWindowEnd':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickupWindowEnd = valueDes;
          break;
        case r'allowPickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowPickup = valueDes;
          break;
        case r'allowDropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowDropoff = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutputStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputStopsInnerBuilder();
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


class PublicTripDtoOutputStopsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORIGIN')
  static const PublicTripDtoOutputStopsInnerRoleEnum ORIGIN = _$publicTripDtoOutputStopsInnerRoleEnum_ORIGIN;
  @BuiltValueEnumConst(wireName: r'INTERMEDIATE')
  static const PublicTripDtoOutputStopsInnerRoleEnum INTERMEDIATE = _$publicTripDtoOutputStopsInnerRoleEnum_INTERMEDIATE;
  @BuiltValueEnumConst(wireName: r'DESTINATION')
  static const PublicTripDtoOutputStopsInnerRoleEnum DESTINATION = _$publicTripDtoOutputStopsInnerRoleEnum_DESTINATION;

  static Serializer<PublicTripDtoOutputStopsInnerRoleEnum> get serializer => _$publicTripDtoOutputStopsInnerRoleEnumSerializer;

  const PublicTripDtoOutputStopsInnerRoleEnum._(String name): super(name);

  static BuiltSet<PublicTripDtoOutputStopsInnerRoleEnum> get values => _$publicTripDtoOutputStopsInnerRoleEnumValues;
  static PublicTripDtoOutputStopsInnerRoleEnum valueOf(String name) => _$publicTripDtoOutputStopsInnerRoleEnumValueOf(name);
}

class PublicTripDtoOutputStopsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const PublicTripDtoOutputStopsInnerTypeEnum BUS_STATION = _$publicTripDtoOutputStopsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const PublicTripDtoOutputStopsInnerTypeEnum OFFICE = _$publicTripDtoOutputStopsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const PublicTripDtoOutputStopsInnerTypeEnum REST_STOP = _$publicTripDtoOutputStopsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const PublicTripDtoOutputStopsInnerTypeEnum PICKUP_POINT = _$publicTripDtoOutputStopsInnerTypeEnum_PICKUP_POINT;

  static Serializer<PublicTripDtoOutputStopsInnerTypeEnum> get serializer => _$publicTripDtoOutputStopsInnerTypeEnumSerializer;

  const PublicTripDtoOutputStopsInnerTypeEnum._(String name): super(name);

  static BuiltSet<PublicTripDtoOutputStopsInnerTypeEnum> get values => _$publicTripDtoOutputStopsInnerTypeEnumValues;
  static PublicTripDtoOutputStopsInnerTypeEnum valueOf(String name) => _$publicTripDtoOutputStopsInnerTypeEnumValueOf(name);
}

