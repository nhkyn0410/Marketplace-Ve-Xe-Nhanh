//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_page_dto_output_stats.g.dart';

/// PromotionPageDtoOutputStats
///
/// Properties:
/// * [running] 
/// * [scheduled] 
/// * [drafts] 
/// * [paused] 
/// * [redemptions] 
/// * [discount] 
/// * [revenue] 
@BuiltValue()
abstract class PromotionPageDtoOutputStats implements Built<PromotionPageDtoOutputStats, PromotionPageDtoOutputStatsBuilder> {
  @BuiltValueField(wireName: r'running')
  int get running;

  @BuiltValueField(wireName: r'scheduled')
  int get scheduled;

  @BuiltValueField(wireName: r'drafts')
  int get drafts;

  @BuiltValueField(wireName: r'paused')
  int get paused;

  @BuiltValueField(wireName: r'redemptions')
  int get redemptions;

  @BuiltValueField(wireName: r'discount')
  int get discount;

  @BuiltValueField(wireName: r'revenue')
  int get revenue;

  PromotionPageDtoOutputStats._();

  factory PromotionPageDtoOutputStats([void updates(PromotionPageDtoOutputStatsBuilder b)]) = _$PromotionPageDtoOutputStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionPageDtoOutputStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionPageDtoOutputStats> get serializer => _$PromotionPageDtoOutputStatsSerializer();
}

class _$PromotionPageDtoOutputStatsSerializer implements PrimitiveSerializer<PromotionPageDtoOutputStats> {
  @override
  final Iterable<Type> types = const [PromotionPageDtoOutputStats, _$PromotionPageDtoOutputStats];

  @override
  final String wireName = r'PromotionPageDtoOutputStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionPageDtoOutputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'running';
    yield serializers.serialize(
      object.running,
      specifiedType: const FullType(int),
    );
    yield r'scheduled';
    yield serializers.serialize(
      object.scheduled,
      specifiedType: const FullType(int),
    );
    yield r'drafts';
    yield serializers.serialize(
      object.drafts,
      specifiedType: const FullType(int),
    );
    yield r'paused';
    yield serializers.serialize(
      object.paused,
      specifiedType: const FullType(int),
    );
    yield r'redemptions';
    yield serializers.serialize(
      object.redemptions,
      specifiedType: const FullType(int),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(int),
    );
    yield r'revenue';
    yield serializers.serialize(
      object.revenue,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionPageDtoOutputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionPageDtoOutputStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'running':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.running = valueDes;
          break;
        case r'scheduled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.scheduled = valueDes;
          break;
        case r'drafts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.drafts = valueDes;
          break;
        case r'paused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paused = valueDes;
          break;
        case r'redemptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.redemptions = valueDes;
          break;
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discount = valueDes;
          break;
        case r'revenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revenue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionPageDtoOutputStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionPageDtoOutputStatsBuilder();
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


