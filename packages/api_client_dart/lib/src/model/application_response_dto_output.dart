//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/application_response_dto_output_documents_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_response_dto_output.g.dart';

/// ApplicationResponseDtoOutput
///
/// Properties:
/// * [applicationCode] 
/// * [status] 
/// * [operatorName] 
/// * [contactName] 
/// * [contactEmail] 
/// * [contactEmailVerifiedAt] 
/// * [legalName] 
/// * [taxCode] 
/// * [hotline] 
/// * [address] 
/// * [displayName] 
/// * [description] 
/// * [bankName] 
/// * [bankAccountNumberMasked] 
/// * [bankAccountHolder] 
/// * [documents] 
/// * [missing] 
/// * [reviewNote] 
/// * [createdAt] 
/// * [submittedAt] 
/// * [updatedAt] 
/// * [linkExpiresAt] 
@BuiltValue()
abstract class ApplicationResponseDtoOutput implements Built<ApplicationResponseDtoOutput, ApplicationResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  @BuiltValueField(wireName: r'status')
  ApplicationResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  DRAFT,  SUBMITTED,  NEEDS_INFO,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'contactName')
  String get contactName;

  @BuiltValueField(wireName: r'contactEmail')
  String get contactEmail;

  @BuiltValueField(wireName: r'contactEmailVerifiedAt')
  DateTime? get contactEmailVerifiedAt;

  @BuiltValueField(wireName: r'legalName')
  String? get legalName;

  @BuiltValueField(wireName: r'taxCode')
  String? get taxCode;

  @BuiltValueField(wireName: r'hotline')
  String? get hotline;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'bankName')
  String? get bankName;

  @BuiltValueField(wireName: r'bankAccountNumberMasked')
  String? get bankAccountNumberMasked;

  @BuiltValueField(wireName: r'bankAccountHolder')
  String? get bankAccountHolder;

  @BuiltValueField(wireName: r'documents')
  BuiltList<ApplicationResponseDtoOutputDocumentsInner> get documents;

  @BuiltValueField(wireName: r'missing')
  BuiltList<String> get missing;

  @BuiltValueField(wireName: r'reviewNote')
  String? get reviewNote;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'linkExpiresAt')
  DateTime get linkExpiresAt;

  ApplicationResponseDtoOutput._();

  factory ApplicationResponseDtoOutput([void updates(ApplicationResponseDtoOutputBuilder b)]) = _$ApplicationResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationResponseDtoOutput> get serializer => _$ApplicationResponseDtoOutputSerializer();
}

class _$ApplicationResponseDtoOutputSerializer implements PrimitiveSerializer<ApplicationResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [ApplicationResponseDtoOutput, _$ApplicationResponseDtoOutput];

  @override
  final String wireName = r'ApplicationResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicationCode';
    yield serializers.serialize(
      object.applicationCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApplicationResponseDtoOutputStatusEnum),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
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
    yield r'contactEmailVerifiedAt';
    yield object.contactEmailVerifiedAt == null ? null : serializers.serialize(
      object.contactEmailVerifiedAt,
      specifiedType: const FullType.nullable(DateTime),
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
    yield r'hotline';
    yield object.hotline == null ? null : serializers.serialize(
      object.hotline,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(String),
    );
    yield r'displayName';
    yield object.displayName == null ? null : serializers.serialize(
      object.displayName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bankName';
    yield object.bankName == null ? null : serializers.serialize(
      object.bankName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bankAccountNumberMasked';
    yield object.bankAccountNumberMasked == null ? null : serializers.serialize(
      object.bankAccountNumberMasked,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bankAccountHolder';
    yield object.bankAccountHolder == null ? null : serializers.serialize(
      object.bankAccountHolder,
      specifiedType: const FullType.nullable(String),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [FullType(ApplicationResponseDtoOutputDocumentsInner)]),
    );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'reviewNote';
    yield object.reviewNote == null ? null : serializers.serialize(
      object.reviewNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'submittedAt';
    yield object.submittedAt == null ? null : serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'linkExpiresAt';
    yield serializers.serialize(
      object.linkExpiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(ApplicationResponseDtoOutputStatusEnum),
          ) as ApplicationResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
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
        case r'contactEmailVerifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.contactEmailVerifiedAt = valueDes;
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
        case r'hotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hotline = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'bankName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankName = valueDes;
          break;
        case r'bankAccountNumberMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankAccountNumberMasked = valueDes;
          break;
        case r'bankAccountHolder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankAccountHolder = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApplicationResponseDtoOutputDocumentsInner)]),
          ) as BuiltList<ApplicationResponseDtoOutputDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        case r'missing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.missing.replace(valueDes);
          break;
        case r'reviewNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewNote = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'linkExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.linkExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationResponseDtoOutputBuilder();
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


class ApplicationResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ApplicationResponseDtoOutputStatusEnum DRAFT = _$applicationResponseDtoOutputStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const ApplicationResponseDtoOutputStatusEnum SUBMITTED = _$applicationResponseDtoOutputStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'NEEDS_INFO')
  static const ApplicationResponseDtoOutputStatusEnum NEEDS_INFO = _$applicationResponseDtoOutputStatusEnum_NEEDS_INFO;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const ApplicationResponseDtoOutputStatusEnum APPROVED = _$applicationResponseDtoOutputStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ApplicationResponseDtoOutputStatusEnum REJECTED = _$applicationResponseDtoOutputStatusEnum_REJECTED;

  static Serializer<ApplicationResponseDtoOutputStatusEnum> get serializer => _$applicationResponseDtoOutputStatusEnumSerializer;

  const ApplicationResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<ApplicationResponseDtoOutputStatusEnum> get values => _$applicationResponseDtoOutputStatusEnumValues;
  static ApplicationResponseDtoOutputStatusEnum valueOf(String name) => _$applicationResponseDtoOutputStatusEnumValueOf(name);
}

