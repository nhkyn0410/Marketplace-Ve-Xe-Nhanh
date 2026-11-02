//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/campaign_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_page_dto_output.g.dart';

/// CampaignPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [total] 
/// * [offset] 
/// * [limit] 
@BuiltValue()
abstract class CampaignPageDtoOutput implements Built<CampaignPageDtoOutput, CampaignPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CampaignPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'offset')
  int get offset;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  CampaignPageDtoOutput._();

  factory CampaignPageDtoOutput([void updates(CampaignPageDtoOutputBuilder b)]) = _$CampaignPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignPageDtoOutput> get serializer => _$CampaignPageDtoOutputSerializer();
}

class _$CampaignPageDtoOutputSerializer implements PrimitiveSerializer<CampaignPageDtoOutput> {
  @override
  final Iterable<Type> types = const [CampaignPageDtoOutput, _$CampaignPageDtoOutput];

  @override
  final String wireName = r'CampaignPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CampaignPageDtoOutputItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'offset';
    yield serializers.serialize(
      object.offset,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignPageDtoOutputItemsInner)]),
          ) as BuiltList<CampaignPageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'offset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.offset = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignPageDtoOutputBuilder();
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


