//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_application_list_response_dto_output_items_inner.g.dart';

/// AdminApplicationListResponseDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [applicationCode] 
/// * [status] 
/// * [operatorName] 
/// * [legalName] 
/// * [taxCode] 
/// * [contactName] 
/// * [contactEmail] 
/// * [submittedAt] 
/// * [reviewedAt] 
/// * [duplicates] 
@BuiltValue()
abstract class AdminApplicationListResponseDtoOutputItemsInner implements Built<AdminApplicationListResponseDtoOutputItemsInner, AdminApplicationListResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  @BuiltValueField(wireName: r'status')
  AdminApplicationListResponseDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  SUBMITTED,  NEEDS_INFO,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'legalName')
  String? get legalName;

  @BuiltValueField(wireName: r'taxCode')
  String? get taxCode;

  @BuiltValueField(wireName: r'contactName')
  String get contactName;

  @BuiltValueField(wireName: r'contactEmail')
  String get contactEmail;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime? get reviewedAt;

  @BuiltValueField(wireName: r'duplicates')
  BuiltList<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum> get duplicates;
  // enum duplicatesEnum {  CONTACT_EMAIL,  TAX_CODE,  BANK_ACCOUNT,  };

  AdminApplicationListResponseDtoOutputItemsInner._();

  factory AdminApplicationListResponseDtoOutputItemsInner([void updates(AdminApplicationListResponseDtoOutputItemsInnerBuilder b)]) = _$AdminApplicationListResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApplicationListResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApplicationListResponseDtoOutputItemsInner> get serializer => _$AdminApplicationListResponseDtoOutputItemsInnerSerializer();
}

class _$AdminApplicationListResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminApplicationListResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminApplicationListResponseDtoOutputItemsInner, _$AdminApplicationListResponseDtoOutputItemsInner];

  @override
  final String wireName = r'AdminApplicationListResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApplicationListResponseDtoOutputItemsInner object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminApplicationListResponseDtoOutputItemsInnerStatusEnum),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'legalName';
    yield object.legalName == null ? null : serializers.serialize(
      object.legalName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'taxCode';
    yield object.taxCode == null ? null : serializers.serialize(
      object.taxCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'contactName';
    yield serializers.serialize(
      object.contactName,
      specifiedType: const FullType(String),
    );
    yield r'contactEmail';
    yield serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType(String),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reviewedAt';
    yield object.reviewedAt == null ? null : serializers.serialize(
      object.reviewedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'duplicates';
    yield serializers.serialize(
      object.duplicates,
      specifiedType: const FullType(BuiltList, [FullType(AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApplicationListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminApplicationListResponseDtoOutputItemsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminApplicationListResponseDtoOutputItemsInnerStatusEnum),
          ) as AdminApplicationListResponseDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'legalName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalName = valueDes;
          break;
        case r'taxCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxCode = valueDes;
          break;
        case r'contactName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactName = valueDes;
          break;
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEmail = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'reviewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'duplicates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum)]),
          ) as BuiltList<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>;
          result.duplicates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApplicationListResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApplicationListResponseDtoOutputItemsInnerBuilder();
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


class AdminApplicationListResponseDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum DRAFT = _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum SUBMITTED = _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'NEEDS_INFO')
  static const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum NEEDS_INFO = _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_NEEDS_INFO;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum APPROVED = _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum REJECTED = _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_REJECTED;

  static Serializer<AdminApplicationListResponseDtoOutputItemsInnerStatusEnum> get serializer => _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumSerializer;

  const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminApplicationListResponseDtoOutputItemsInnerStatusEnum> get values => _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumValues;
  static AdminApplicationListResponseDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumValueOf(name);
}

class AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONTACT_EMAIL')
  static const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum CONTACT_EMAIL = _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_CONTACT_EMAIL;
  @BuiltValueEnumConst(wireName: r'TAX_CODE')
  static const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum TAX_CODE = _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_TAX_CODE;
  @BuiltValueEnumConst(wireName: r'BANK_ACCOUNT')
  static const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum BANK_ACCOUNT = _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_BANK_ACCOUNT;

  static Serializer<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum> get serializer => _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumSerializer;

  const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum._(String name): super(name);

  static BuiltSet<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum> get values => _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumValues;
  static AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum valueOf(String name) => _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumValueOf(name);
}

