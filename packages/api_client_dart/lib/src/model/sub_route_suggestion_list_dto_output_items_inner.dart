//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/sub_route_suggestion_list_dto_output_items_inner_suggested_rules_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/route_response_dto_output_sub_routes_inner_from.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_route_suggestion_list_dto_output_items_inner.g.dart';

/// SubRouteSuggestionListDtoOutputItemsInner
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [name] 
/// * [totalDistanceMeters] 
/// * [totalDurationSeconds] 
/// * [suggestedRules] 
@BuiltValue()
abstract class SubRouteSuggestionListDtoOutputItemsInner implements Built<SubRouteSuggestionListDtoOutputItemsInner, SubRouteSuggestionListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'from')
  RouteResponseDtoOutputSubRoutesInnerFrom get from;

  @BuiltValueField(wireName: r'to')
  RouteResponseDtoOutputSubRoutesInnerFrom get to;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'totalDistanceMeters')
  int get totalDistanceMeters;

  @BuiltValueField(wireName: r'totalDurationSeconds')
  int get totalDurationSeconds;

  @BuiltValueField(wireName: r'suggestedRules')
  BuiltList<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>? get suggestedRules;

  SubRouteSuggestionListDtoOutputItemsInner._();

  factory SubRouteSuggestionListDtoOutputItemsInner([void updates(SubRouteSuggestionListDtoOutputItemsInnerBuilder b)]) = _$SubRouteSuggestionListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubRouteSuggestionListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubRouteSuggestionListDtoOutputItemsInner> get serializer => _$SubRouteSuggestionListDtoOutputItemsInnerSerializer();
}

class _$SubRouteSuggestionListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<SubRouteSuggestionListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [SubRouteSuggestionListDtoOutputItemsInner, _$SubRouteSuggestionListDtoOutputItemsInner];

  @override
  final String wireName = r'SubRouteSuggestionListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubRouteSuggestionListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'totalDistanceMeters';
    yield serializers.serialize(
      object.totalDistanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'totalDurationSeconds';
    yield serializers.serialize(
      object.totalDurationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'suggestedRules';
    yield object.suggestedRules == null ? null : serializers.serialize(
      object.suggestedRules,
      specifiedType: const FullType.nullable(BuiltList, [FullType(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubRouteSuggestionListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubRouteSuggestionListDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
          ) as RouteResponseDtoOutputSubRoutesInnerFrom;
          result.from.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
          ) as RouteResponseDtoOutputSubRoutesInnerFrom;
          result.to.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'totalDistanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDistanceMeters = valueDes;
          break;
        case r'totalDurationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDurationSeconds = valueDes;
          break;
        case r'suggestedRules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner)]),
          ) as BuiltList<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>?;
          if (valueDes == null) continue;
          result.suggestedRules.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubRouteSuggestionListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubRouteSuggestionListDtoOutputItemsInnerBuilder();
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


