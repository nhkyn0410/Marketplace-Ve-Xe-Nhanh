//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_application_detail_dto_output_duplicates_contact_email_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_application_detail_dto_output_duplicates.g.dart';

/// AdminApplicationDetailDtoOutputDuplicates
///
/// Properties:
/// * [contactEmail] 
/// * [taxCode] 
/// * [bankAccount] 
@BuiltValue()
abstract class AdminApplicationDetailDtoOutputDuplicates implements Built<AdminApplicationDetailDtoOutputDuplicates, AdminApplicationDetailDtoOutputDuplicatesBuilder> {
  @BuiltValueField(wireName: r'contactEmail')
  BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner> get contactEmail;

  @BuiltValueField(wireName: r'taxCode')
  BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner> get taxCode;

  @BuiltValueField(wireName: r'bankAccount')
  BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner> get bankAccount;

  AdminApplicationDetailDtoOutputDuplicates._();

  factory AdminApplicationDetailDtoOutputDuplicates([void updates(AdminApplicationDetailDtoOutputDuplicatesBuilder b)]) = _$AdminApplicationDetailDtoOutputDuplicates;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApplicationDetailDtoOutputDuplicatesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApplicationDetailDtoOutputDuplicates> get serializer => _$AdminApplicationDetailDtoOutputDuplicatesSerializer();
}

class _$AdminApplicationDetailDtoOutputDuplicatesSerializer implements PrimitiveSerializer<AdminApplicationDetailDtoOutputDuplicates> {
  @override
  final Iterable<Type> types = const [AdminApplicationDetailDtoOutputDuplicates, _$AdminApplicationDetailDtoOutputDuplicates];

  @override
  final String wireName = r'AdminApplicationDetailDtoOutputDuplicates';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApplicationDetailDtoOutputDuplicates object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contactEmail';
    yield serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
    );
    yield r'taxCode';
    yield serializers.serialize(
      object.taxCode,
      specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
    );
    yield r'bankAccount';
    yield serializers.serialize(
      object.bankAccount,
      specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApplicationDetailDtoOutputDuplicates object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminApplicationDetailDtoOutputDuplicatesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
          ) as BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>;
          result.contactEmail.replace(valueDes);
          break;
        case r'taxCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
          ) as BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>;
          result.taxCode.replace(valueDes);
          break;
        case r'bankAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInner)]),
          ) as BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>;
          result.bankAccount.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApplicationDetailDtoOutputDuplicates deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApplicationDetailDtoOutputDuplicatesBuilder();
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


