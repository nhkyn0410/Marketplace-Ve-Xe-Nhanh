//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bank_change_approve_dto.g.dart';

/// AdminBankChangeApproveDto
///
/// Properties:
/// * [changeId] 
@BuiltValue()
abstract class AdminBankChangeApproveDto implements Built<AdminBankChangeApproveDto, AdminBankChangeApproveDtoBuilder> {
  @BuiltValueField(wireName: r'changeId')
  String get changeId;

  AdminBankChangeApproveDto._();

  factory AdminBankChangeApproveDto([void updates(AdminBankChangeApproveDtoBuilder b)]) = _$AdminBankChangeApproveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBankChangeApproveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBankChangeApproveDto> get serializer => _$AdminBankChangeApproveDtoSerializer();
}

class _$AdminBankChangeApproveDtoSerializer implements PrimitiveSerializer<AdminBankChangeApproveDto> {
  @override
  final Iterable<Type> types = const [AdminBankChangeApproveDto, _$AdminBankChangeApproveDto];

  @override
  final String wireName = r'AdminBankChangeApproveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBankChangeApproveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changeId';
    yield serializers.serialize(
      object.changeId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBankChangeApproveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminBankChangeApproveDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBankChangeApproveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBankChangeApproveDtoBuilder();
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


