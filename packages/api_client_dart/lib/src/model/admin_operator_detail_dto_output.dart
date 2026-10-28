//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_operator_detail_dto_output_stats.dart';
import 'package:api_client_dart/src/model/admin_operator_page_dto_output_items_inner_owner.dart';
import 'package:api_client_dart/src/model/admin_operator_detail_dto_output_bank_account.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_detail_dto_output.g.dart';

/// AdminOperatorDetailDtoOutput
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [slug] 
/// * [status] 
/// * [suspendedReason] 
/// * [suspendedAt] 
/// * [approvedAt] 
/// * [applicationId] 
/// * [owner] 
/// * [routeCount] 
/// * [openTripCount] 
/// * [bankChangePending] 
/// * [legalName] 
/// * [taxCode] 
/// * [hotline] 
/// * [publicEmail] 
/// * [address] 
/// * [description] 
/// * [bankAccount] 
/// * [vehicleCount] 
/// * [employeeCount] 
/// * [stats] 
@BuiltValue()
abstract class AdminOperatorDetailDtoOutput implements Built<AdminOperatorDetailDtoOutput, AdminOperatorDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'status')
  AdminOperatorDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'suspendedReason')
  String? get suspendedReason;

  @BuiltValueField(wireName: r'suspendedAt')
  DateTime? get suspendedAt;

  @BuiltValueField(wireName: r'approvedAt')
  DateTime get approvedAt;

  @BuiltValueField(wireName: r'applicationId')
  String? get applicationId;

  @BuiltValueField(wireName: r'owner')
  AdminOperatorPageDtoOutputItemsInnerOwner? get owner;

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  @BuiltValueField(wireName: r'openTripCount')
  int get openTripCount;

  @BuiltValueField(wireName: r'bankChangePending')
  bool get bankChangePending;

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

  @BuiltValueField(wireName: r'bankAccount')
  AdminOperatorDetailDtoOutputBankAccount? get bankAccount;

  @BuiltValueField(wireName: r'vehicleCount')
  int get vehicleCount;

  @BuiltValueField(wireName: r'employeeCount')
  int get employeeCount;

  @BuiltValueField(wireName: r'stats')
  AdminOperatorDetailDtoOutputStats get stats;

  AdminOperatorDetailDtoOutput._();

  factory AdminOperatorDetailDtoOutput([void updates(AdminOperatorDetailDtoOutputBuilder b)]) = _$AdminOperatorDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorDetailDtoOutput> get serializer => _$AdminOperatorDetailDtoOutputSerializer();
}

class _$AdminOperatorDetailDtoOutputSerializer implements PrimitiveSerializer<AdminOperatorDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOperatorDetailDtoOutput, _$AdminOperatorDetailDtoOutput];

  @override
  final String wireName = r'AdminOperatorDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOperatorDetailDtoOutputStatusEnum),
    );
    yield r'suspendedReason';
    yield object.suspendedReason == null ? null : serializers.serialize(
      object.suspendedReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'suspendedAt';
    yield object.suspendedAt == null ? null : serializers.serialize(
      object.suspendedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'approvedAt';
    yield serializers.serialize(
      object.approvedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'applicationId';
    yield object.applicationId == null ? null : serializers.serialize(
      object.applicationId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'owner';
    yield object.owner == null ? null : serializers.serialize(
      object.owner,
      specifiedType: const FullType.nullable(AdminOperatorPageDtoOutputItemsInnerOwner),
    );
    yield r'routeCount';
    yield serializers.serialize(
      object.routeCount,
      specifiedType: const FullType(int),
    );
    yield r'openTripCount';
    yield serializers.serialize(
      object.openTripCount,
      specifiedType: const FullType(int),
    );
    yield r'bankChangePending';
    yield serializers.serialize(
      object.bankChangePending,
      specifiedType: const FullType(bool),
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
    yield r'bankAccount';
    yield object.bankAccount == null ? null : serializers.serialize(
      object.bankAccount,
      specifiedType: const FullType.nullable(AdminOperatorDetailDtoOutputBankAccount),
    );
    yield r'vehicleCount';
    yield serializers.serialize(
      object.vehicleCount,
      specifiedType: const FullType(int),
    );
    yield r'employeeCount';
    yield serializers.serialize(
      object.employeeCount,
      specifiedType: const FullType(int),
    );
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(AdminOperatorDetailDtoOutputStats),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorDetailDtoOutputBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorDetailDtoOutputStatusEnum),
          ) as AdminOperatorDetailDtoOutputStatusEnum;
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
        case r'suspendedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.suspendedAt = valueDes;
          break;
        case r'approvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.approvedAt = valueDes;
          break;
        case r'applicationId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.applicationId = valueDes;
          break;
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOperatorPageDtoOutputItemsInnerOwner),
          ) as AdminOperatorPageDtoOutputItemsInnerOwner?;
          if (valueDes == null) continue;
          result.owner.replace(valueDes);
          break;
        case r'routeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.routeCount = valueDes;
          break;
        case r'openTripCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.openTripCount = valueDes;
          break;
        case r'bankChangePending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bankChangePending = valueDes;
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
        case r'bankAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOperatorDetailDtoOutputBankAccount),
          ) as AdminOperatorDetailDtoOutputBankAccount?;
          if (valueDes == null) continue;
          result.bankAccount.replace(valueDes);
          break;
        case r'vehicleCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicleCount = valueDes;
          break;
        case r'employeeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.employeeCount = valueDes;
          break;
        case r'stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorDetailDtoOutputStats),
          ) as AdminOperatorDetailDtoOutputStats;
          result.stats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorDetailDtoOutputBuilder();
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


class AdminOperatorDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorDetailDtoOutputStatusEnum ACTIVE = _$adminOperatorDetailDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorDetailDtoOutputStatusEnum SUSPENDED = _$adminOperatorDetailDtoOutputStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorDetailDtoOutputStatusEnum> get serializer => _$adminOperatorDetailDtoOutputStatusEnumSerializer;

  const AdminOperatorDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorDetailDtoOutputStatusEnum> get values => _$adminOperatorDetailDtoOutputStatusEnumValues;
  static AdminOperatorDetailDtoOutputStatusEnum valueOf(String name) => _$adminOperatorDetailDtoOutputStatusEnumValueOf(name);
}

