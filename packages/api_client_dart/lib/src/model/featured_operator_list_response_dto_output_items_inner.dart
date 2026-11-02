//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/featured_operator_list_response_dto_output_items_inner_routes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'featured_operator_list_response_dto_output_items_inner.g.dart';

/// FeaturedOperatorListResponseDtoOutputItemsInner
///
/// Properties:
/// * [operatorId] 
/// * [displayName] 
/// * [logoUrl] 
/// * [averageRating] 
/// * [reviewCount] 
/// * [routes] 
@BuiltValue()
abstract class FeaturedOperatorListResponseDtoOutputItemsInner implements Built<FeaturedOperatorListResponseDtoOutputItemsInner, FeaturedOperatorListResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  @BuiltValueField(wireName: r'routes')
  BuiltList<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner> get routes;

  FeaturedOperatorListResponseDtoOutputItemsInner._();

  factory FeaturedOperatorListResponseDtoOutputItemsInner([void updates(FeaturedOperatorListResponseDtoOutputItemsInnerBuilder b)]) = _$FeaturedOperatorListResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeaturedOperatorListResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeaturedOperatorListResponseDtoOutputItemsInner> get serializer => _$FeaturedOperatorListResponseDtoOutputItemsInnerSerializer();
}

class _$FeaturedOperatorListResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<FeaturedOperatorListResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [FeaturedOperatorListResponseDtoOutputItemsInner, _$FeaturedOperatorListResponseDtoOutputItemsInner];

  @override
  final String wireName = r'FeaturedOperatorListResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'logoUrl';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'averageRating';
    yield object.averageRating == null ? null : serializers.serialize(
      object.averageRating,
      specifiedType: const FullType.nullable(num),
    );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
    yield r'routes';
    yield serializers.serialize(
      object.routes,
      specifiedType: const FullType(BuiltList, [FullType(FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeaturedOperatorListResponseDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'logoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        case r'routes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner)]),
          ) as BuiltList<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>;
          result.routes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeaturedOperatorListResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeaturedOperatorListResponseDtoOutputItemsInnerBuilder();
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


