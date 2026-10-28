//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_report_dto_output_sellers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_report_dto_output.g.dart';

/// CounterReportDtoOutput
///
/// Properties:
/// * [cash] 
/// * [bankTransfer] 
/// * [exceptions] 
/// * [commission] 
/// * [receipts] 
/// * [sellers] 
@BuiltValue()
abstract class CounterReportDtoOutput implements Built<CounterReportDtoOutput, CounterReportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'cash')
  String get cash;

  @BuiltValueField(wireName: r'bankTransfer')
  String get bankTransfer;

  @BuiltValueField(wireName: r'exceptions')
  String get exceptions;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'receipts')
  int get receipts;

  @BuiltValueField(wireName: r'sellers')
  BuiltList<CounterReportDtoOutputSellersInner> get sellers;

  CounterReportDtoOutput._();

  factory CounterReportDtoOutput([void updates(CounterReportDtoOutputBuilder b)]) = _$CounterReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterReportDtoOutput> get serializer => _$CounterReportDtoOutputSerializer();
}

class _$CounterReportDtoOutputSerializer implements PrimitiveSerializer<CounterReportDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterReportDtoOutput, _$CounterReportDtoOutput];

  @override
  final String wireName = r'CounterReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(int),
    );
    yield r'sellers';
    yield serializers.serialize(
      object.sellers,
      specifiedType: const FullType(BuiltList, [FullType(CounterReportDtoOutputSellersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'receipts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.receipts = valueDes;
          break;
        case r'sellers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterReportDtoOutputSellersInner)]),
          ) as BuiltList<CounterReportDtoOutputSellersInner>;
          result.sellers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterReportDtoOutputBuilder();
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


