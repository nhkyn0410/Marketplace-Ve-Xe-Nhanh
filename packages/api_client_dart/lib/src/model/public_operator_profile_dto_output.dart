//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/public_operator_profile_dto_output_reviews_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/public_operator_profile_dto_output_routes_inner.dart';
import 'package:api_client_dart/src/model/public_operator_profile_dto_output_service_terms.dart';
import 'package:api_client_dart/src/model/public_operator_profile_dto_output_scorecard.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_operator_profile_dto_output.g.dart';

/// PublicOperatorProfileDtoOutput
///
/// Properties:
/// * [operatorId] 
/// * [operatorSlug] 
/// * [displayName] 
/// * [logoUrl] 
/// * [description] 
/// * [hotline] 
/// * [publicEmail] 
/// * [address] 
/// * [scorecard] 
/// * [routes] 
/// * [serviceTerms] 
/// * [reviews] 
/// * [nextReviewCursor] 
@BuiltValue()
abstract class PublicOperatorProfileDtoOutput implements Built<PublicOperatorProfileDtoOutput, PublicOperatorProfileDtoOutputBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'hotline')
  String? get hotline;

  @BuiltValueField(wireName: r'publicEmail')
  String? get publicEmail;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'scorecard')
  PublicOperatorProfileDtoOutputScorecard get scorecard;

  @BuiltValueField(wireName: r'routes')
  BuiltList<PublicOperatorProfileDtoOutputRoutesInner> get routes;

  @BuiltValueField(wireName: r'serviceTerms')
  PublicOperatorProfileDtoOutputServiceTerms? get serviceTerms;

  @BuiltValueField(wireName: r'reviews')
  BuiltList<PublicOperatorProfileDtoOutputReviewsInner> get reviews;

  @BuiltValueField(wireName: r'nextReviewCursor')
  String? get nextReviewCursor;

  PublicOperatorProfileDtoOutput._();

  factory PublicOperatorProfileDtoOutput([void updates(PublicOperatorProfileDtoOutputBuilder b)]) = _$PublicOperatorProfileDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicOperatorProfileDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicOperatorProfileDtoOutput> get serializer => _$PublicOperatorProfileDtoOutputSerializer();
}

class _$PublicOperatorProfileDtoOutputSerializer implements PrimitiveSerializer<PublicOperatorProfileDtoOutput> {
  @override
  final Iterable<Type> types = const [PublicOperatorProfileDtoOutput, _$PublicOperatorProfileDtoOutput];

  @override
  final String wireName = r'PublicOperatorProfileDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicOperatorProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
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
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'hotline';
    yield object.hotline == null ? null : serializers.serialize(
      object.hotline,
      specifiedType: const FullType.nullable(String),
    );
    yield r'publicEmail';
    yield object.publicEmail == null ? null : serializers.serialize(
      object.publicEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(String),
    );
    yield r'scorecard';
    yield serializers.serialize(
      object.scorecard,
      specifiedType: const FullType(PublicOperatorProfileDtoOutputScorecard),
    );
    yield r'routes';
    yield serializers.serialize(
      object.routes,
      specifiedType: const FullType(BuiltList, [FullType(PublicOperatorProfileDtoOutputRoutesInner)]),
    );
    yield r'serviceTerms';
    yield object.serviceTerms == null ? null : serializers.serialize(
      object.serviceTerms,
      specifiedType: const FullType.nullable(PublicOperatorProfileDtoOutputServiceTerms),
    );
    yield r'reviews';
    yield serializers.serialize(
      object.reviews,
      specifiedType: const FullType(BuiltList, [FullType(PublicOperatorProfileDtoOutputReviewsInner)]),
    );
    yield r'nextReviewCursor';
    yield object.nextReviewCursor == null ? null : serializers.serialize(
      object.nextReviewCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicOperatorProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicOperatorProfileDtoOutputBuilder result,
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
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'hotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hotline = valueDes;
          break;
        case r'publicEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicEmail = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'scorecard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicOperatorProfileDtoOutputScorecard),
          ) as PublicOperatorProfileDtoOutputScorecard;
          result.scorecard.replace(valueDes);
          break;
        case r'routes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicOperatorProfileDtoOutputRoutesInner)]),
          ) as BuiltList<PublicOperatorProfileDtoOutputRoutesInner>;
          result.routes.replace(valueDes);
          break;
        case r'serviceTerms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PublicOperatorProfileDtoOutputServiceTerms),
          ) as PublicOperatorProfileDtoOutputServiceTerms?;
          if (valueDes == null) continue;
          result.serviceTerms.replace(valueDes);
          break;
        case r'reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicOperatorProfileDtoOutputReviewsInner)]),
          ) as BuiltList<PublicOperatorProfileDtoOutputReviewsInner>;
          result.reviews.replace(valueDes);
          break;
        case r'nextReviewCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextReviewCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicOperatorProfileDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicOperatorProfileDtoOutputBuilder();
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


