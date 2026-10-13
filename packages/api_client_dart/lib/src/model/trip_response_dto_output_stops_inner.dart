//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_response_dto_output_stops_inner.g.dart';

/// TripResponseDtoOutputStopsInner
///
/// Properties:
/// * [sequence] 
/// * [role] 
/// * [catalogStopPointId] 
/// * [stopPointId] 
/// * [name] 
/// * [address] 
/// * [type] 
/// * [plannedAt] 
/// * [allowPickup] 
/// * [allowDropoff] 
/// * [note] 
@BuiltValue()
abstract class TripResponseDtoOutputStopsInner implements Built<TripResponseDtoOutputStopsInner, TripResponseDtoOutputStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'role')
  TripResponseDtoOutputStopsInnerRoleEnum get role;
  // enum roleEnum {  ORIGIN,  INTERMEDIATE,  DESTINATION,  };

  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'type')
  TripResponseDtoOutputStopsInnerTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  OFFICE,  REST_STOP,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  @BuiltValueField(wireName: r'note')
  String? get note;

  TripResponseDtoOutputStopsInner._();

  factory TripResponseDtoOutputStopsInner([void updates(TripResponseDtoOutputStopsInnerBuilder b)]) = _$TripResponseDtoOutputStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripResponseDtoOutputStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripResponseDtoOutputStopsInner> get serializer => _$TripResponseDtoOutputStopsInnerSerializer();
}

class _$TripResponseDtoOutputStopsInnerSerializer implements PrimitiveSerializer<TripResponseDtoOutputStopsInner> {
  @override
  final Iterable<Type> types = const [TripResponseDtoOutputStopsInner, _$TripResponseDtoOutputStopsInner];

  @override
  final String wireName = r'TripResponseDtoOutputStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripResponseDtoOutputStopsInner object, {
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
      specifiedType: const FullType(TripResponseDtoOutputStopsInnerRoleEnum),
    );
    yield r'catalogStopPointId';
    yield object.catalogStopPointId == null ? null : serializers.serialize(
      object.catalogStopPointId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stopPointId';
    yield object.stopPointId == null ? null : serializers.serialize(
      object.stopPointId,
      specifiedType: const FullType.nullable(String),
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
      specifiedType: const FullType(TripResponseDtoOutputStopsInnerTypeEnum),
    );
    yield r'plannedAt';
    yield serializers.serialize(
      object.plannedAt,
      specifiedType: const FullType(DateTime),
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
    TripResponseDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripResponseDtoOutputStopsInnerBuilder result,
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
            specifiedType: const FullType(TripResponseDtoOutputStopsInnerRoleEnum),
          ) as TripResponseDtoOutputStopsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'catalogStopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.catalogStopPointId = valueDes;
          break;
        case r'stopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stopPointId = valueDes;
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
            specifiedType: const FullType(TripResponseDtoOutputStopsInnerTypeEnum),
          ) as TripResponseDtoOutputStopsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'plannedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.plannedAt = valueDes;
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
  TripResponseDtoOutputStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripResponseDtoOutputStopsInnerBuilder();
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


class TripResponseDtoOutputStopsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORIGIN')
  static const TripResponseDtoOutputStopsInnerRoleEnum ORIGIN = _$tripResponseDtoOutputStopsInnerRoleEnum_ORIGIN;
  @BuiltValueEnumConst(wireName: r'INTERMEDIATE')
  static const TripResponseDtoOutputStopsInnerRoleEnum INTERMEDIATE = _$tripResponseDtoOutputStopsInnerRoleEnum_INTERMEDIATE;
  @BuiltValueEnumConst(wireName: r'DESTINATION')
  static const TripResponseDtoOutputStopsInnerRoleEnum DESTINATION = _$tripResponseDtoOutputStopsInnerRoleEnum_DESTINATION;

  static Serializer<TripResponseDtoOutputStopsInnerRoleEnum> get serializer => _$tripResponseDtoOutputStopsInnerRoleEnumSerializer;

  const TripResponseDtoOutputStopsInnerRoleEnum._(String name): super(name);

  static BuiltSet<TripResponseDtoOutputStopsInnerRoleEnum> get values => _$tripResponseDtoOutputStopsInnerRoleEnumValues;
  static TripResponseDtoOutputStopsInnerRoleEnum valueOf(String name) => _$tripResponseDtoOutputStopsInnerRoleEnumValueOf(name);
}

class TripResponseDtoOutputStopsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const TripResponseDtoOutputStopsInnerTypeEnum BUS_STATION = _$tripResponseDtoOutputStopsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const TripResponseDtoOutputStopsInnerTypeEnum OFFICE = _$tripResponseDtoOutputStopsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const TripResponseDtoOutputStopsInnerTypeEnum REST_STOP = _$tripResponseDtoOutputStopsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const TripResponseDtoOutputStopsInnerTypeEnum PICKUP_POINT = _$tripResponseDtoOutputStopsInnerTypeEnum_PICKUP_POINT;

  static Serializer<TripResponseDtoOutputStopsInnerTypeEnum> get serializer => _$tripResponseDtoOutputStopsInnerTypeEnumSerializer;

  const TripResponseDtoOutputStopsInnerTypeEnum._(String name): super(name);

  static BuiltSet<TripResponseDtoOutputStopsInnerTypeEnum> get values => _$tripResponseDtoOutputStopsInnerTypeEnumValues;
  static TripResponseDtoOutputStopsInnerTypeEnum valueOf(String name) => _$tripResponseDtoOutputStopsInnerTypeEnumValueOf(name);
}

