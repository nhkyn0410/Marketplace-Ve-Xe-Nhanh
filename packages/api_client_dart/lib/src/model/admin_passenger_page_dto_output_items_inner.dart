//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_passenger_page_dto_output_items_inner.g.dart';

/// AdminPassengerPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [email] 
/// * [providers] 
/// * [status] 
/// * [lockedReason] 
/// * [lockedAt] 
/// * [createdAt] 
/// * [lastLoginAt] 
@BuiltValue()
abstract class AdminPassengerPageDtoOutputItemsInner implements Built<AdminPassengerPageDtoOutputItemsInner, AdminPassengerPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'providers')
  BuiltList<String> get providers;

  @BuiltValueField(wireName: r'status')
  AdminPassengerPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'lockedReason')
  String? get lockedReason;

  @BuiltValueField(wireName: r'lockedAt')
  DateTime? get lockedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  AdminPassengerPageDtoOutputItemsInner._();

  factory AdminPassengerPageDtoOutputItemsInner([void updates(AdminPassengerPageDtoOutputItemsInnerBuilder b)]) = _$AdminPassengerPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPassengerPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPassengerPageDtoOutputItemsInner> get serializer => _$AdminPassengerPageDtoOutputItemsInnerSerializer();
}

class _$AdminPassengerPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminPassengerPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminPassengerPageDtoOutputItemsInner, _$AdminPassengerPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminPassengerPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPassengerPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'providers';
    yield serializers.serialize(
      object.providers,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPassengerPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'lockedReason';
    yield object.lockedReason == null ? null : serializers.serialize(
      object.lockedReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lockedAt';
    yield object.lockedAt == null ? null : serializers.serialize(
      object.lockedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastLoginAt';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPassengerPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPassengerPageDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'providers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.providers.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPassengerPageDtoOutputItemsInnerStatusEnum),
          ) as AdminPassengerPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'lockedReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lockedReason = valueDes;
          break;
        case r'lockedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lockedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPassengerPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPassengerPageDtoOutputItemsInnerBuilder();
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


class AdminPassengerPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminPassengerPageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminPassengerPageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminPassengerPageDtoOutputItemsInnerStatusEnum LOCKED = _$adminPassengerPageDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminPassengerPageDtoOutputItemsInnerStatusEnum DISABLED = _$adminPassengerPageDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<AdminPassengerPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminPassengerPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminPassengerPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminPassengerPageDtoOutputItemsInnerStatusEnum> get values => _$adminPassengerPageDtoOutputItemsInnerStatusEnumValues;
  static AdminPassengerPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminPassengerPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

