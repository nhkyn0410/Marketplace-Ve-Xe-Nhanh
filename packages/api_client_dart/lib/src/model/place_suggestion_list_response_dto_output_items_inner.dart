//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/place_suggestion_list_response_dto_output_items_inner_target.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'place_suggestion_list_response_dto_output_items_inner.g.dart';

/// PlaceSuggestionListResponseDtoOutputItemsInner
///
/// Properties:
/// * [kind] 
/// * [label] 
/// * [detail] 
/// * [target] 
@BuiltValue()
abstract class PlaceSuggestionListResponseDtoOutputItemsInner implements Built<PlaceSuggestionListResponseDtoOutputItemsInner, PlaceSuggestionListResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'kind')
  PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum get kind;
  // enum kindEnum {  PROVINCE,  WARD,  STOP_POINT,  LEGACY,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'detail')
  String? get detail;

  @BuiltValueField(wireName: r'target')
  PlaceSuggestionListResponseDtoOutputItemsInnerTarget get target;

  PlaceSuggestionListResponseDtoOutputItemsInner._();

  factory PlaceSuggestionListResponseDtoOutputItemsInner([void updates(PlaceSuggestionListResponseDtoOutputItemsInnerBuilder b)]) = _$PlaceSuggestionListResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlaceSuggestionListResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlaceSuggestionListResponseDtoOutputItemsInner> get serializer => _$PlaceSuggestionListResponseDtoOutputItemsInnerSerializer();
}

class _$PlaceSuggestionListResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PlaceSuggestionListResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PlaceSuggestionListResponseDtoOutputItemsInner, _$PlaceSuggestionListResponseDtoOutputItemsInner];

  @override
  final String wireName = r'PlaceSuggestionListResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'detail';
    yield object.detail == null ? null : serializers.serialize(
      object.detail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerTarget),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlaceSuggestionListResponseDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum),
          ) as PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.detail = valueDes;
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlaceSuggestionListResponseDtoOutputItemsInnerTarget),
          ) as PlaceSuggestionListResponseDtoOutputItemsInnerTarget;
          result.target.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlaceSuggestionListResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlaceSuggestionListResponseDtoOutputItemsInnerBuilder();
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


class PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROVINCE')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum PROVINCE = _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_PROVINCE;
  @BuiltValueEnumConst(wireName: r'WARD')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum WARD = _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_WARD;
  @BuiltValueEnumConst(wireName: r'STOP_POINT')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum STOP_POINT = _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_STOP_POINT;
  @BuiltValueEnumConst(wireName: r'LEGACY')
  static const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum LEGACY = _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_LEGACY;

  static Serializer<PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum> get serializer => _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumSerializer;

  const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum._(String name): super(name);

  static BuiltSet<PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum> get values => _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumValues;
  static PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum valueOf(String name) => _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumValueOf(name);
}

