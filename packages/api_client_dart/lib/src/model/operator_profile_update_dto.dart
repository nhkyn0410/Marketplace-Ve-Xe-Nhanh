//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_profile_update_dto.g.dart';

/// OperatorProfileUpdateDto
///
/// Properties:
/// * [displayName] 
/// * [hotline] 
/// * [publicEmail] 
/// * [address] 
/// * [description] 
@BuiltValue()
abstract class OperatorProfileUpdateDto implements Built<OperatorProfileUpdateDto, OperatorProfileUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'hotline')
  String get hotline;

  @BuiltValueField(wireName: r'publicEmail')
  String get publicEmail;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'description')
  String? get description;

  OperatorProfileUpdateDto._();

  factory OperatorProfileUpdateDto([void updates(OperatorProfileUpdateDtoBuilder b)]) = _$OperatorProfileUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorProfileUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorProfileUpdateDto> get serializer => _$OperatorProfileUpdateDtoSerializer();
}

class _$OperatorProfileUpdateDtoSerializer implements PrimitiveSerializer<OperatorProfileUpdateDto> {
  @override
  final Iterable<Type> types = const [OperatorProfileUpdateDto, _$OperatorProfileUpdateDto];

  @override
  final String wireName = r'OperatorProfileUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorProfileUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'hotline';
    yield serializers.serialize(
      object.hotline,
      specifiedType: const FullType(String),
    );
    yield r'publicEmail';
    yield serializers.serialize(
      object.publicEmail,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorProfileUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorProfileUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'hotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hotline = valueDes;
          break;
        case r'publicEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicEmail = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorProfileUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorProfileUpdateDtoBuilder();
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


