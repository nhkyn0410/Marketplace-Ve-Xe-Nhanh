//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_report_dto_output_sellers_inner.g.dart';

/// CounterReportDtoOutputSellersInner
///
/// Properties:
/// * [seller] 
/// * [cash] 
/// * [bankTransfer] 
/// * [exceptions] 
/// * [commission] 
@BuiltValue()
abstract class CounterReportDtoOutputSellersInner implements Built<CounterReportDtoOutputSellersInner, CounterReportDtoOutputSellersInnerBuilder> {
  @BuiltValueField(wireName: r'seller')
  String get seller;

  @BuiltValueField(wireName: r'cash')
  String get cash;

  @BuiltValueField(wireName: r'bankTransfer')
  String get bankTransfer;

  @BuiltValueField(wireName: r'exceptions')
  String get exceptions;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  CounterReportDtoOutputSellersInner._();

  factory CounterReportDtoOutputSellersInner([void updates(CounterReportDtoOutputSellersInnerBuilder b)]) = _$CounterReportDtoOutputSellersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterReportDtoOutputSellersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterReportDtoOutputSellersInner> get serializer => _$CounterReportDtoOutputSellersInnerSerializer();
}

class _$CounterReportDtoOutputSellersInnerSerializer implements PrimitiveSerializer<CounterReportDtoOutputSellersInner> {
  @override
  final Iterable<Type> types = const [CounterReportDtoOutputSellersInner, _$CounterReportDtoOutputSellersInner];

  @override
  final String wireName = r'CounterReportDtoOutputSellersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterReportDtoOutputSellersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seller';
    yield serializers.serialize(
      object.seller,
      specifiedType: const FullType(String),
    );
    yield r'cash';
    yield serializers.serialize(
      object.cash,
      specifiedType: const FullType(String),
    );
    yield r'bankTransfer';
    yield serializers.serialize(
      object.bankTransfer,
      specifiedType: const FullType(String),
    );
    yield r'exceptions';
    yield serializers.serialize(
      object.exceptions,
      specifiedType: const FullType(String),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterReportDtoOutputSellersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterReportDtoOutputSellersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seller':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seller = valueDes;
          break;
        case r'cash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cash = valueDes;
          break;
        case r'bankTransfer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bankTransfer = valueDes;
          break;
        case r'exceptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.exceptions = valueDes;
          break;
        case r'commission':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commission = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterReportDtoOutputSellersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterReportDtoOutputSellersInnerBuilder();
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


