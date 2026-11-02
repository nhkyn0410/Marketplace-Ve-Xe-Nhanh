//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_sales_dto_output_changes_inner.g.dart';

/// TripSalesDtoOutputChangesInner
///
/// Properties:
/// * [id] 
/// * [kinds] 
/// * [before] 
/// * [after] 
/// * [reason] 
/// * [affectedBookings] 
/// * [actor] 
/// * [createdAt] 
@BuiltValue()
abstract class TripSalesDtoOutputChangesInner implements Built<TripSalesDtoOutputChangesInner, TripSalesDtoOutputChangesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kinds')
  BuiltList<TripSalesDtoOutputChangesInnerKindsEnum> get kinds;
  // enum kindsEnum {  SCHEDULE,  VEHICLE,  STOP,  CANCEL,  };

  @BuiltValueField(wireName: r'before')
  TripSalesDtoOutputChangesInnerBefore get before;

  @BuiltValueField(wireName: r'after')
  TripSalesDtoOutputChangesInnerBefore get after;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'affectedBookings')
  int get affectedBookings;

  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  TripSalesDtoOutputChangesInner._();

  factory TripSalesDtoOutputChangesInner([void updates(TripSalesDtoOutputChangesInnerBuilder b)]) = _$TripSalesDtoOutputChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSalesDtoOutputChangesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSalesDtoOutputChangesInner> get serializer => _$TripSalesDtoOutputChangesInnerSerializer();
}

class _$TripSalesDtoOutputChangesInnerSerializer implements PrimitiveSerializer<TripSalesDtoOutputChangesInner> {
  @override
  final Iterable<Type> types = const [TripSalesDtoOutputChangesInner, _$TripSalesDtoOutputChangesInner];

  @override
  final String wireName = r'TripSalesDtoOutputChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSalesDtoOutputChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kinds';
    yield serializers.serialize(
      object.kinds,
      specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerKindsEnum)]),
    );
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
    );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'affectedBookings';
    yield serializers.serialize(
      object.affectedBookings,
      specifiedType: const FullType(int),
    );
    yield r'actor';
    yield object.actor == null ? null : serializers.serialize(
      object.actor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSalesDtoOutputChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSalesDtoOutputChangesInnerBuilder result,
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
        case r'kinds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInnerKindsEnum)]),
          ) as BuiltList<TripSalesDtoOutputChangesInnerKindsEnum>;
          result.kinds.replace(valueDes);
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
          ) as TripSalesDtoOutputChangesInnerBefore;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBefore),
          ) as TripSalesDtoOutputChangesInnerBefore;
          result.after.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'affectedBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.affectedBookings = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actor = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSalesDtoOutputChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSalesDtoOutputChangesInnerBuilder();
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


class TripSalesDtoOutputChangesInnerKindsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const TripSalesDtoOutputChangesInnerKindsEnum SCHEDULE = _$tripSalesDtoOutputChangesInnerKindsEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const TripSalesDtoOutputChangesInnerKindsEnum VEHICLE = _$tripSalesDtoOutputChangesInnerKindsEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'STOP')
  static const TripSalesDtoOutputChangesInnerKindsEnum STOP = _$tripSalesDtoOutputChangesInnerKindsEnum_STOP;
  @BuiltValueEnumConst(wireName: r'CANCEL')
  static const TripSalesDtoOutputChangesInnerKindsEnum CANCEL = _$tripSalesDtoOutputChangesInnerKindsEnum_CANCEL;

  static Serializer<TripSalesDtoOutputChangesInnerKindsEnum> get serializer => _$tripSalesDtoOutputChangesInnerKindsEnumSerializer;

  const TripSalesDtoOutputChangesInnerKindsEnum._(String name): super(name);

  static BuiltSet<TripSalesDtoOutputChangesInnerKindsEnum> get values => _$tripSalesDtoOutputChangesInnerKindsEnumValues;
  static TripSalesDtoOutputChangesInnerKindsEnum valueOf(String name) => _$tripSalesDtoOutputChangesInnerKindsEnumValueOf(name);
}

