//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_commission_overview_dto_output_settlements_inner.g.dart';

/// CounterCommissionOverviewDtoOutputSettlementsInner
///
/// Properties:
/// * [id] 
/// * [operatorId] 
/// * [amount] 
/// * [reference] 
/// * [reason] 
/// * [createdBy] 
/// * [createdAt] 
@BuiltValue()
abstract class CounterCommissionOverviewDtoOutputSettlementsInner implements Built<CounterCommissionOverviewDtoOutputSettlementsInner, CounterCommissionOverviewDtoOutputSettlementsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'createdBy')
  String get createdBy;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CounterCommissionOverviewDtoOutputSettlementsInner._();

  factory CounterCommissionOverviewDtoOutputSettlementsInner([void updates(CounterCommissionOverviewDtoOutputSettlementsInnerBuilder b)]) = _$CounterCommissionOverviewDtoOutputSettlementsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterCommissionOverviewDtoOutputSettlementsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterCommissionOverviewDtoOutputSettlementsInner> get serializer => _$CounterCommissionOverviewDtoOutputSettlementsInnerSerializer();
}

class _$CounterCommissionOverviewDtoOutputSettlementsInnerSerializer implements PrimitiveSerializer<CounterCommissionOverviewDtoOutputSettlementsInner> {
  @override
  final Iterable<Type> types = const [CounterCommissionOverviewDtoOutputSettlementsInner, _$CounterCommissionOverviewDtoOutputSettlementsInner];

  @override
  final String wireName = r'CounterCommissionOverviewDtoOutputSettlementsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterCommissionOverviewDtoOutputSettlementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'createdBy';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(String),
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
    CounterCommissionOverviewDtoOutputSettlementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterCommissionOverviewDtoOutputSettlementsInnerBuilder result,
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'createdBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdBy = valueDes;
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
  CounterCommissionOverviewDtoOutputSettlementsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterCommissionOverviewDtoOutputSettlementsInnerBuilder();
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


