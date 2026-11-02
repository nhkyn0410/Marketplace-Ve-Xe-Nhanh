//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/operator_profile_response_dto_output_bank_account.dart';
import 'package:api_client_dart/src/model/operator_profile_response_dto_output_bank_change.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_application_detail_dto_output_documents_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_profile_response_dto_output.g.dart';

/// OperatorProfileResponseDtoOutput
///
/// Properties:
/// * [id] 
/// * [slug] 
/// * [displayName] 
/// * [legalName] 
/// * [taxCode] 
/// * [hotline] 
/// * [publicEmail] 
/// * [address] 
/// * [description] 
/// * [logoUrl] 
/// * [status] 
/// * [suspendedReason] 
/// * [approvedAt] 
/// * [documents] 
/// * [bankAccount] 
/// * [bankChange] 
@BuiltValue()
abstract class OperatorProfileResponseDtoOutput implements Built<OperatorProfileResponseDtoOutput, OperatorProfileResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'legalName')
  String? get legalName;

  @BuiltValueField(wireName: r'taxCode')
  String? get taxCode;

  @BuiltValueField(wireName: r'hotline')
  String? get hotline;

  @BuiltValueField(wireName: r'publicEmail')
  String? get publicEmail;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'status')
  OperatorProfileResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'suspendedReason')
  String? get suspendedReason;

  @BuiltValueField(wireName: r'approvedAt')
  DateTime? get approvedAt;

  @BuiltValueField(wireName: r'documents')
  BuiltList<AdminApplicationDetailDtoOutputDocumentsInner> get documents;

  @BuiltValueField(wireName: r'bankAccount')
  OperatorProfileResponseDtoOutputBankAccount? get bankAccount;

  @BuiltValueField(wireName: r'bankChange')
  OperatorProfileResponseDtoOutputBankChange? get bankChange;

  OperatorProfileResponseDtoOutput._();

  factory OperatorProfileResponseDtoOutput([void updates(OperatorProfileResponseDtoOutputBuilder b)]) = _$OperatorProfileResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorProfileResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorProfileResponseDtoOutput> get serializer => _$OperatorProfileResponseDtoOutputSerializer();
}

class _$OperatorProfileResponseDtoOutputSerializer implements PrimitiveSerializer<OperatorProfileResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [OperatorProfileResponseDtoOutput, _$OperatorProfileResponseDtoOutput];

  @override
  final String wireName = r'OperatorProfileResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorProfileResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
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
    yield r'hotline';
    yield object.hotline == null ? null : serializers.serialize(
      object.hotline,
      specifiedType: const FullType.nullable(String),
    );
    yield r'publicEmail';
    yield object.publicEmail == null ? null : serializers.serialize(
      object.publicEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'logoUrl';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OperatorProfileResponseDtoOutputStatusEnum),
    );
    yield r'suspendedReason';
    yield object.suspendedReason == null ? null : serializers.serialize(
      object.suspendedReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'approvedAt';
    yield object.approvedAt == null ? null : serializers.serialize(
      object.approvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDocumentsInner)]),
    );
    yield r'bankAccount';
    yield object.bankAccount == null ? null : serializers.serialize(
      object.bankAccount,
      specifiedType: const FullType.nullable(OperatorProfileResponseDtoOutputBankAccount),
    );
    yield r'bankChange';
    yield object.bankChange == null ? null : serializers.serialize(
      object.bankChange,
      specifiedType: const FullType.nullable(OperatorProfileResponseDtoOutputBankChange),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorProfileResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorProfileResponseDtoOutputBuilder result,
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
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
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
        case r'publicEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicEmail = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'logoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorProfileResponseDtoOutputStatusEnum),
          ) as OperatorProfileResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'suspendedReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suspendedReason = valueDes;
          break;
        case r'approvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.approvedAt = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminApplicationDetailDtoOutputDocumentsInner)]),
          ) as BuiltList<AdminApplicationDetailDtoOutputDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        case r'bankAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OperatorProfileResponseDtoOutputBankAccount),
          ) as OperatorProfileResponseDtoOutputBankAccount?;
          if (valueDes == null) continue;
          result.bankAccount.replace(valueDes);
          break;
        case r'bankChange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OperatorProfileResponseDtoOutputBankChange),
          ) as OperatorProfileResponseDtoOutputBankChange?;
          if (valueDes == null) continue;
          result.bankChange.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorProfileResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorProfileResponseDtoOutputBuilder();
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


class OperatorProfileResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const OperatorProfileResponseDtoOutputStatusEnum ACTIVE = _$operatorProfileResponseDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const OperatorProfileResponseDtoOutputStatusEnum SUSPENDED = _$operatorProfileResponseDtoOutputStatusEnum_SUSPENDED;

  static Serializer<OperatorProfileResponseDtoOutputStatusEnum> get serializer => _$operatorProfileResponseDtoOutputStatusEnumSerializer;

  const OperatorProfileResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<OperatorProfileResponseDtoOutputStatusEnum> get values => _$operatorProfileResponseDtoOutputStatusEnumValues;
  static OperatorProfileResponseDtoOutputStatusEnum valueOf(String name) => _$operatorProfileResponseDtoOutputStatusEnumValueOf(name);
}

