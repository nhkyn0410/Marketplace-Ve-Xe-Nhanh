//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'featured_operator_list_response_dto_output_items_inner_routes_inner.g.dart';

/// FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner
///
/// Properties:
/// * [originProvinceId] 
/// * [originName] 
/// * [destinationProvinceId] 
/// * [destinationName] 
@BuiltValue()
abstract class FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner implements Built<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner, FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder> {
  @BuiltValueField(wireName: r'originProvinceId')
  String get originProvinceId;

  @BuiltValueField(wireName: r'originName')
  String get originName;

  @BuiltValueField(wireName: r'destinationProvinceId')
  String get destinationProvinceId;

  @BuiltValueField(wireName: r'destinationName')
  String get destinationName;

  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner._();

  factory FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner([void updates(FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder b)]) = _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner> get serializer => _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerSerializer();
}

class _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerSerializer implements PrimitiveSerializer<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner> {
  @override
  final Iterable<Type> types = const [FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner, _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner];

  @override
  final String wireName = r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'originProvinceId';
    yield serializers.serialize(
      object.originProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'originName';
    yield serializers.serialize(
      object.originName,
      specifiedType: const FullType(String),
    );
    yield r'destinationProvinceId';
    yield serializers.serialize(
      object.destinationProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'destinationName';
    yield serializers.serialize(
      object.destinationName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'originProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originProvinceId = valueDes;
          break;
        case r'originName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originName = valueDes;
          break;
        case r'destinationProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationProvinceId = valueDes;
          break;
        case r'destinationName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder();
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


