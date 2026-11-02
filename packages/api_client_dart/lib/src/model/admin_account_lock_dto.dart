//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_account_lock_dto.g.dart';

/// AdminAccountLockDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class AdminAccountLockDto implements Built<AdminAccountLockDto, AdminAccountLockDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminAccountLockDto._();

  factory AdminAccountLockDto([void updates(AdminAccountLockDtoBuilder b)]) = _$AdminAccountLockDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAccountLockDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAccountLockDto> get serializer => _$AdminAccountLockDtoSerializer();
}

class _$AdminAccountLockDtoSerializer implements PrimitiveSerializer<AdminAccountLockDto> {
  @override
  final Iterable<Type> types = const [AdminAccountLockDto, _$AdminAccountLockDto];

  @override
  final String wireName = r'AdminAccountLockDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAccountLockDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAccountLockDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAccountLockDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAccountLockDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAccountLockDtoBuilder();
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


