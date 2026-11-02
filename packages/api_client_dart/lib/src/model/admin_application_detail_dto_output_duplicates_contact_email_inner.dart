//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_application_detail_dto_output_duplicates_contact_email_inner.g.dart';

/// AdminApplicationDetailDtoOutputDuplicatesContactEmailInner
///
/// Properties:
/// * [id] 
/// * [applicationCode] 
/// * [operatorName] 
/// * [status] 
@BuiltValue()
abstract class AdminApplicationDetailDtoOutputDuplicatesContactEmailInner implements Built<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner, AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'status')
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  SUBMITTED,  NEEDS_INFO,  APPROVED,  REJECTED,  };

  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner._();

  factory AdminApplicationDetailDtoOutputDuplicatesContactEmailInner([void updates(AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder b)]) = _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner> get serializer => _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerSerializer();
}

class _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerSerializer implements PrimitiveSerializer<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner> {
  @override
  final Iterable<Type> types = const [AdminApplicationDetailDtoOutputDuplicatesContactEmailInner, _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner];

  @override
  final String wireName = r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApplicationDetailDtoOutputDuplicatesContactEmailInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'applicationCode';
    yield serializers.serialize(
      object.applicationCode,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApplicationDetailDtoOutputDuplicatesContactEmailInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder result,
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
        case r'applicationCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.applicationCode = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum),
          ) as AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder();
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


class AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum DRAFT = _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum SUBMITTED = _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'NEEDS_INFO')
  static const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum NEEDS_INFO = _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_NEEDS_INFO;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum APPROVED = _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum REJECTED = _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_REJECTED;

  static Serializer<AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum> get serializer => _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumSerializer;

  const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum> get values => _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumValues;
  static AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum valueOf(String name) => _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumValueOf(name);
}

