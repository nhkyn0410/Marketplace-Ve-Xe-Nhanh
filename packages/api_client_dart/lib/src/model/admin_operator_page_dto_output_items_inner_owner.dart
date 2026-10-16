//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_page_dto_output_items_inner_owner.g.dart';

/// AdminOperatorPageDtoOutputItemsInnerOwner
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [email] 
/// * [credentialDeliveryPending] 
@BuiltValue()
abstract class AdminOperatorPageDtoOutputItemsInnerOwner implements Built<AdminOperatorPageDtoOutputItemsInnerOwner, AdminOperatorPageDtoOutputItemsInnerOwnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'credentialDeliveryPending')
  bool get credentialDeliveryPending;

  AdminOperatorPageDtoOutputItemsInnerOwner._();

  factory AdminOperatorPageDtoOutputItemsInnerOwner([void updates(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder b)]) = _$AdminOperatorPageDtoOutputItemsInnerOwner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorPageDtoOutputItemsInnerOwnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorPageDtoOutputItemsInnerOwner> get serializer => _$AdminOperatorPageDtoOutputItemsInnerOwnerSerializer();
}

class _$AdminOperatorPageDtoOutputItemsInnerOwnerSerializer implements PrimitiveSerializer<AdminOperatorPageDtoOutputItemsInnerOwner> {
  @override
  final Iterable<Type> types = const [AdminOperatorPageDtoOutputItemsInnerOwner, _$AdminOperatorPageDtoOutputItemsInnerOwner];

  @override
  final String wireName = r'AdminOperatorPageDtoOutputItemsInnerOwner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorPageDtoOutputItemsInnerOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'credentialDeliveryPending';
    yield serializers.serialize(
      object.credentialDeliveryPending,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorPageDtoOutputItemsInnerOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorPageDtoOutputItemsInnerOwnerBuilder result,
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
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'credentialDeliveryPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.credentialDeliveryPending = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorPageDtoOutputItemsInnerOwner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorPageDtoOutputItemsInnerOwnerBuilder();
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


