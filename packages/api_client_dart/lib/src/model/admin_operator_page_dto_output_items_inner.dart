//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_operator_page_dto_output_items_inner_owner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_page_dto_output_items_inner.g.dart';

/// AdminOperatorPageDtoOutputItemsInner
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
@BuiltValue()
abstract class AdminOperatorPageDtoOutputItemsInner implements Built<AdminOperatorPageDtoOutputItemsInner, AdminOperatorPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'status')
  AdminOperatorPageDtoOutputItemsInnerStatusEnum get status;
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

  AdminOperatorPageDtoOutputItemsInner._();

  factory AdminOperatorPageDtoOutputItemsInner([void updates(AdminOperatorPageDtoOutputItemsInnerBuilder b)]) = _$AdminOperatorPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorPageDtoOutputItemsInner> get serializer => _$AdminOperatorPageDtoOutputItemsInnerSerializer();
}

class _$AdminOperatorPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminOperatorPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminOperatorPageDtoOutputItemsInner, _$AdminOperatorPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminOperatorPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorPageDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminOperatorPageDtoOutputItemsInnerStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminOperatorPageDtoOutputItemsInnerStatusEnum),
          ) as AdminOperatorPageDtoOutputItemsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorPageDtoOutputItemsInnerBuilder();
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


class AdminOperatorPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorPageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminOperatorPageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorPageDtoOutputItemsInnerStatusEnum SUSPENDED = _$adminOperatorPageDtoOutputItemsInnerStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminOperatorPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminOperatorPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorPageDtoOutputItemsInnerStatusEnum> get values => _$adminOperatorPageDtoOutputItemsInnerStatusEnumValues;
  static AdminOperatorPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminOperatorPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

