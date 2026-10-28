//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/counter_commission_overview_dto_output_settlements_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_commission_overview_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_commission_overview_dto_output.g.dart';

/// CounterCommissionOverviewDtoOutput
///
/// Properties:
/// * [operatorId] 
/// * [accrued] 
/// * [settled] 
/// * [outstanding] 
/// * [items] 
/// * [settlements] 
@BuiltValue()
abstract class CounterCommissionOverviewDtoOutput implements Built<CounterCommissionOverviewDtoOutput, CounterCommissionOverviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'accrued')
  String get accrued;

  @BuiltValueField(wireName: r'settled')
  String get settled;

  @BuiltValueField(wireName: r'outstanding')
  String get outstanding;

  @BuiltValueField(wireName: r'items')
  BuiltList<CounterCommissionOverviewDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'settlements')
  BuiltList<CounterCommissionOverviewDtoOutputSettlementsInner> get settlements;

  CounterCommissionOverviewDtoOutput._();

  factory CounterCommissionOverviewDtoOutput([void updates(CounterCommissionOverviewDtoOutputBuilder b)]) = _$CounterCommissionOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterCommissionOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterCommissionOverviewDtoOutput> get serializer => _$CounterCommissionOverviewDtoOutputSerializer();
}

class _$CounterCommissionOverviewDtoOutputSerializer implements PrimitiveSerializer<CounterCommissionOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterCommissionOverviewDtoOutput, _$CounterCommissionOverviewDtoOutput];

  @override
  final String wireName = r'CounterCommissionOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterCommissionOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'accrued';
    yield serializers.serialize(
      object.accrued,
      specifiedType: const FullType(String),
    );
    yield r'settled';
    yield serializers.serialize(
      object.settled,
      specifiedType: const FullType(String),
    );
    yield r'outstanding';
    yield serializers.serialize(
      object.outstanding,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CounterCommissionOverviewDtoOutputItemsInner)]),
    );
    yield r'settlements';
    yield serializers.serialize(
      object.settlements,
      specifiedType: const FullType(BuiltList, [FullType(CounterCommissionOverviewDtoOutputSettlementsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterCommissionOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterCommissionOverviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'accrued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accrued = valueDes;
          break;
        case r'settled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.settled = valueDes;
          break;
        case r'outstanding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.outstanding = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterCommissionOverviewDtoOutputItemsInner)]),
          ) as BuiltList<CounterCommissionOverviewDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'settlements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterCommissionOverviewDtoOutputSettlementsInner)]),
          ) as BuiltList<CounterCommissionOverviewDtoOutputSettlementsInner>;
          result.settlements.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterCommissionOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterCommissionOverviewDtoOutputBuilder();
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


