//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_input_dto.g.dart';

/// ApprovalInputDto
///
/// Properties:
/// * [operatorSlug] 
/// * [ownerUsername] 
@BuiltValue()
abstract class ApprovalInputDto implements Built<ApprovalInputDto, ApprovalInputDtoBuilder> {
  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'ownerUsername')
  String get ownerUsername;

  ApprovalInputDto._();

  factory ApprovalInputDto([void updates(ApprovalInputDtoBuilder b)]) = _$ApprovalInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApprovalInputDto> get serializer => _$ApprovalInputDtoSerializer();
}

class _$ApprovalInputDtoSerializer implements PrimitiveSerializer<ApprovalInputDto> {
  @override
  final Iterable<Type> types = const [ApprovalInputDto, _$ApprovalInputDto];

  @override
  final String wireName = r'ApprovalInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApprovalInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
      specifiedType: const FullType(String),
    );
    yield r'ownerUsername';
    yield serializers.serialize(
      object.ownerUsername,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApprovalInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
          break;
        case r'ownerUsername':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerUsername = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApprovalInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalInputDtoBuilder();
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


