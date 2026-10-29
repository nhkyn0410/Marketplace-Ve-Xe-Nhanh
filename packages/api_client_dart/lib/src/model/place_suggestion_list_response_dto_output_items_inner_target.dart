//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'place_suggestion_list_response_dto_output_items_inner_target.g.dart';

/// PlaceSuggestionListResponseDtoOutputItemsInnerTarget
///
/// Properties:
/// * [type] 
/// * [id] 
@BuiltValue()
abstract class PlaceSuggestionListResponseDtoOutputItemsInnerTarget implements Built<PlaceSuggestionListResponseDtoOutputItemsInnerTarget, PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder> {
  @BuiltValueField(wireName: r'type')
  PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum get type;
  // enum typeEnum {  province,  ward,  area,  stopPoint,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  PlaceSuggestionListResponseDtoOutputItemsInnerTarget._();

  factory PlaceSuggestionListResponseDtoOutputItemsInnerTarget([void updates(PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder b)]) = _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlaceSuggestionListResponseDtoOutputItemsInnerTarget> get serializer => _$PlaceSuggestionListResponseDtoOutputItemsInnerTargetSerializer();
}

class _$PlaceSuggestionListResponseDtoOutputItemsInnerTargetSerializer implements PrimitiveSerializer<PlaceSuggestionListResponseDtoOutputItemsInnerTarget> {
  @override
  final Iterable<Type> types = const [PlaceSuggestionListResponseDtoOutputItemsInnerTarget, _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget];

  @override
  final String wireName = r'PlaceSuggestionListResponseDtoOutputItemsInnerTarget';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutputItemsInnerTarget object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutputItemsInnerTarget object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum),
          ) as PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerTarget deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder();
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


class PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'province')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum province = _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_province;
  @BuiltValueEnumConst(wireName: r'ward')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum ward = _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_ward;
  @BuiltValueEnumConst(wireName: r'area')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum area = _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_area;
  @BuiltValueEnumConst(wireName: r'stopPoint')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum stopPoint = _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_stopPoint;

  static Serializer<PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum> get serializer => _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumSerializer;

  const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum._(String name): super(name);

  static BuiltSet<PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum> get values => _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumValues;
  static PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum valueOf(String name) => _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumValueOf(name);
}

