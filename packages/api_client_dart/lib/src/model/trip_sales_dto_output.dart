//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_sales_dto_output.g.dart';

/// TripSalesDtoOutput
///
/// Properties:
/// * [soldSeats] 
/// * [holdingSeats] 
/// * [activeBookings] 
/// * [pendingBookings] 
/// * [refundOnCancel] 
/// * [changes] 
@BuiltValue()
abstract class TripSalesDtoOutput implements Built<TripSalesDtoOutput, TripSalesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'soldSeats')
  int get soldSeats;

  @BuiltValueField(wireName: r'holdingSeats')
  int get holdingSeats;

  @BuiltValueField(wireName: r'activeBookings')
  int get activeBookings;

  @BuiltValueField(wireName: r'pendingBookings')
  int get pendingBookings;

  @BuiltValueField(wireName: r'refundOnCancel')
  int get refundOnCancel;

  @BuiltValueField(wireName: r'changes')
  BuiltList<TripSalesDtoOutputChangesInner> get changes;

  TripSalesDtoOutput._();

  factory TripSalesDtoOutput([void updates(TripSalesDtoOutputBuilder b)]) = _$TripSalesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSalesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSalesDtoOutput> get serializer => _$TripSalesDtoOutputSerializer();
}

class _$TripSalesDtoOutputSerializer implements PrimitiveSerializer<TripSalesDtoOutput> {
  @override
  final Iterable<Type> types = const [TripSalesDtoOutput, _$TripSalesDtoOutput];

  @override
  final String wireName = r'TripSalesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSalesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'soldSeats';
    yield serializers.serialize(
      object.soldSeats,
      specifiedType: const FullType(int),
    );
    yield r'holdingSeats';
    yield serializers.serialize(
      object.holdingSeats,
      specifiedType: const FullType(int),
    );
    yield r'activeBookings';
    yield serializers.serialize(
      object.activeBookings,
      specifiedType: const FullType(int),
    );
    yield r'pendingBookings';
    yield serializers.serialize(
      object.pendingBookings,
      specifiedType: const FullType(int),
    );
    yield r'refundOnCancel';
    yield serializers.serialize(
      object.refundOnCancel,
      specifiedType: const FullType(int),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSalesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSalesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'soldSeats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.soldSeats = valueDes;
          break;
        case r'holdingSeats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.holdingSeats = valueDes;
          break;
        case r'activeBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeBookings = valueDes;
          break;
        case r'pendingBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingBookings = valueDes;
          break;
        case r'refundOnCancel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundOnCancel = valueDes;
          break;
        case r'changes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSalesDtoOutputChangesInner)]),
          ) as BuiltList<TripSalesDtoOutputChangesInner>;
          result.changes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSalesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSalesDtoOutputBuilder();
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


