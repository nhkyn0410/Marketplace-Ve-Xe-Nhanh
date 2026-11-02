//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_commission_overview_dto_output_items_inner.g.dart';

/// CounterCommissionOverviewDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [bookingId] 
/// * [receiptId] 
/// * [commissionRuleId] 
/// * [rateBps] 
/// * [basis] 
/// * [amount] 
/// * [createdAt] 
@BuiltValue()
abstract class CounterCommissionOverviewDtoOutputItemsInner implements Built<CounterCommissionOverviewDtoOutputItemsInner, CounterCommissionOverviewDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'receiptId')
  String get receiptId;

  @BuiltValueField(wireName: r'commissionRuleId')
  String? get commissionRuleId;

  @BuiltValueField(wireName: r'rateBps')
  int get rateBps;

  @BuiltValueField(wireName: r'basis')
  String get basis;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CounterCommissionOverviewDtoOutputItemsInner._();

  factory CounterCommissionOverviewDtoOutputItemsInner([void updates(CounterCommissionOverviewDtoOutputItemsInnerBuilder b)]) = _$CounterCommissionOverviewDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterCommissionOverviewDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterCommissionOverviewDtoOutputItemsInner> get serializer => _$CounterCommissionOverviewDtoOutputItemsInnerSerializer();
}

class _$CounterCommissionOverviewDtoOutputItemsInnerSerializer implements PrimitiveSerializer<CounterCommissionOverviewDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [CounterCommissionOverviewDtoOutputItemsInner, _$CounterCommissionOverviewDtoOutputItemsInner];

  @override
  final String wireName = r'CounterCommissionOverviewDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterCommissionOverviewDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'receiptId';
    yield serializers.serialize(
      object.receiptId,
      specifiedType: const FullType(String),
    );
    yield r'commissionRuleId';
    yield object.commissionRuleId == null ? null : serializers.serialize(
      object.commissionRuleId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'rateBps';
    yield serializers.serialize(
      object.rateBps,
      specifiedType: const FullType(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
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
    CounterCommissionOverviewDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterCommissionOverviewDtoOutputItemsInnerBuilder result,
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
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'receiptId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.receiptId = valueDes;
          break;
        case r'commissionRuleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.commissionRuleId = valueDes;
          break;
        case r'rateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBps = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.basis = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
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
  CounterCommissionOverviewDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterCommissionOverviewDtoOutputItemsInnerBuilder();
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


