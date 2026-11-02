//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_operator.g.dart';

/// PublicTripDtoOutputOperator
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [slug] 
/// * [logoUrl] 
/// * [hotline] 
/// * [averageRating] 
/// * [reviewCount] 
@BuiltValue()
abstract class PublicTripDtoOutputOperator implements Built<PublicTripDtoOutputOperator, PublicTripDtoOutputOperatorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'hotline')
  String? get hotline;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  PublicTripDtoOutputOperator._();

  factory PublicTripDtoOutputOperator([void updates(PublicTripDtoOutputOperatorBuilder b)]) = _$PublicTripDtoOutputOperator;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputOperatorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputOperator> get serializer => _$PublicTripDtoOutputOperatorSerializer();
}

class _$PublicTripDtoOutputOperatorSerializer implements PrimitiveSerializer<PublicTripDtoOutputOperator> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputOperator, _$PublicTripDtoOutputOperator];

  @override
  final String wireName = r'PublicTripDtoOutputOperator';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputOperator object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    if (object.logoUrl != null) {
      yield r'logoUrl';
      yield serializers.serialize(
        object.logoUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'hotline';
    yield object.hotline == null ? null : serializers.serialize(
      object.hotline,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputOperator object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputOperatorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'logoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'hotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hotline = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutputOperator deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputOperatorBuilder();
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


