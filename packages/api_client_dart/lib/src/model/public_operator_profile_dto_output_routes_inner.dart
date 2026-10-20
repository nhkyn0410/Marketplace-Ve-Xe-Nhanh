//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_operator_profile_dto_output_routes_inner.g.dart';

/// PublicOperatorProfileDtoOutputRoutesInner
///
/// Properties:
/// * [routeId]
/// * [name]
@BuiltValue()
abstract class PublicOperatorProfileDtoOutputRoutesInner
    implements
        Built<PublicOperatorProfileDtoOutputRoutesInner,
            PublicOperatorProfileDtoOutputRoutesInnerBuilder> {
  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'name')
  String get name;

  PublicOperatorProfileDtoOutputRoutesInner._();

  factory PublicOperatorProfileDtoOutputRoutesInner(
          [void updates(PublicOperatorProfileDtoOutputRoutesInnerBuilder b)]) =
      _$PublicOperatorProfileDtoOutputRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicOperatorProfileDtoOutputRoutesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicOperatorProfileDtoOutputRoutesInner> get serializer =>
      _$PublicOperatorProfileDtoOutputRoutesInnerSerializer();
}

class _$PublicOperatorProfileDtoOutputRoutesInnerSerializer
    implements PrimitiveSerializer<PublicOperatorProfileDtoOutputRoutesInner> {
  @override
  final Iterable<Type> types = const [
    PublicOperatorProfileDtoOutputRoutesInner,
    _$PublicOperatorProfileDtoOutputRoutesInner
  ];

  @override
  final String wireName = r'PublicOperatorProfileDtoOutputRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicOperatorProfileDtoOutputRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeId';
    yield serializers.serialize(
      object.routeId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicOperatorProfileDtoOutputRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicOperatorProfileDtoOutputRoutesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicOperatorProfileDtoOutputRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicOperatorProfileDtoOutputRoutesInnerBuilder();
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
