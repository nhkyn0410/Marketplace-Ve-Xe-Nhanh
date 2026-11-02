//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_quote_dto_output_tier.g.dart';

/// CancellationQuoteDtoOutputTier
///
/// Properties:
/// * [minHoursBefore] 
/// * [refundPercent] 
@BuiltValue()
abstract class CancellationQuoteDtoOutputTier implements Built<CancellationQuoteDtoOutputTier, CancellationQuoteDtoOutputTierBuilder> {
  @BuiltValueField(wireName: r'minHoursBefore')
  int get minHoursBefore;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  CancellationQuoteDtoOutputTier._();

  factory CancellationQuoteDtoOutputTier([void updates(CancellationQuoteDtoOutputTierBuilder b)]) = _$CancellationQuoteDtoOutputTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationQuoteDtoOutputTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationQuoteDtoOutputTier> get serializer => _$CancellationQuoteDtoOutputTierSerializer();
}

class _$CancellationQuoteDtoOutputTierSerializer implements PrimitiveSerializer<CancellationQuoteDtoOutputTier> {
  @override
  final Iterable<Type> types = const [CancellationQuoteDtoOutputTier, _$CancellationQuoteDtoOutputTier];

  @override
  final String wireName = r'CancellationQuoteDtoOutputTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationQuoteDtoOutputTier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minHoursBefore';
    yield serializers.serialize(
      object.minHoursBefore,
      specifiedType: const FullType(int),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationQuoteDtoOutputTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationQuoteDtoOutputTierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minHoursBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minHoursBefore = valueDes;
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationQuoteDtoOutputTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationQuoteDtoOutputTierBuilder();
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


