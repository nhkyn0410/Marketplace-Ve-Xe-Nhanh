//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bank_change_reject_dto.g.dart';

/// AdminBankChangeRejectDto
///
/// Properties:
/// * [changeId] 
/// * [reason] 
@BuiltValue()
abstract class AdminBankChangeRejectDto implements Built<AdminBankChangeRejectDto, AdminBankChangeRejectDtoBuilder> {
  @BuiltValueField(wireName: r'changeId')
  String get changeId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminBankChangeRejectDto._();

  factory AdminBankChangeRejectDto([void updates(AdminBankChangeRejectDtoBuilder b)]) = _$AdminBankChangeRejectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBankChangeRejectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBankChangeRejectDto> get serializer => _$AdminBankChangeRejectDtoSerializer();
}

class _$AdminBankChangeRejectDtoSerializer implements PrimitiveSerializer<AdminBankChangeRejectDto> {
  @override
  final Iterable<Type> types = const [AdminBankChangeRejectDto, _$AdminBankChangeRejectDto];

  @override
  final String wireName = r'AdminBankChangeRejectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBankChangeRejectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changeId';
    yield serializers.serialize(
      object.changeId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBankChangeRejectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminBankChangeRejectDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.changeId = valueDes;
          break;
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
  AdminBankChangeRejectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBankChangeRejectDtoBuilder();
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


