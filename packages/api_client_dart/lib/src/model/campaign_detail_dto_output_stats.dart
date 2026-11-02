//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_detail_dto_output_stats.g.dart';

/// CampaignDetailDtoOutputStats
///
/// Properties:
/// * [read] 
/// * [pushSent] 
/// * [pushPending] 
/// * [pushFailed] 
/// * [pushSkipped] 
@BuiltValue()
abstract class CampaignDetailDtoOutputStats implements Built<CampaignDetailDtoOutputStats, CampaignDetailDtoOutputStatsBuilder> {
  @BuiltValueField(wireName: r'read')
  int get read;

  @BuiltValueField(wireName: r'pushSent')
  int get pushSent;

  @BuiltValueField(wireName: r'pushPending')
  int get pushPending;

  @BuiltValueField(wireName: r'pushFailed')
  int get pushFailed;

  @BuiltValueField(wireName: r'pushSkipped')
  int get pushSkipped;

  CampaignDetailDtoOutputStats._();

  factory CampaignDetailDtoOutputStats([void updates(CampaignDetailDtoOutputStatsBuilder b)]) = _$CampaignDetailDtoOutputStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignDetailDtoOutputStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignDetailDtoOutputStats> get serializer => _$CampaignDetailDtoOutputStatsSerializer();
}

class _$CampaignDetailDtoOutputStatsSerializer implements PrimitiveSerializer<CampaignDetailDtoOutputStats> {
  @override
  final Iterable<Type> types = const [CampaignDetailDtoOutputStats, _$CampaignDetailDtoOutputStats];

  @override
  final String wireName = r'CampaignDetailDtoOutputStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignDetailDtoOutputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'read';
    yield serializers.serialize(
      object.read,
      specifiedType: const FullType(int),
    );
    yield r'pushSent';
    yield serializers.serialize(
      object.pushSent,
      specifiedType: const FullType(int),
    );
    yield r'pushPending';
    yield serializers.serialize(
      object.pushPending,
      specifiedType: const FullType(int),
    );
    yield r'pushFailed';
    yield serializers.serialize(
      object.pushFailed,
      specifiedType: const FullType(int),
    );
    yield r'pushSkipped';
    yield serializers.serialize(
      object.pushSkipped,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignDetailDtoOutputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignDetailDtoOutputStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'read':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.read = valueDes;
          break;
        case r'pushSent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pushSent = valueDes;
          break;
        case r'pushPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pushPending = valueDes;
          break;
        case r'pushFailed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pushFailed = valueDes;
          break;
        case r'pushSkipped':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pushSkipped = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignDetailDtoOutputStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignDetailDtoOutputStatsBuilder();
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


