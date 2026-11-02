//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_passenger_detail_dto_output.g.dart';

/// AdminPassengerDetailDtoOutput
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
/// * [emailVerified] 
/// * [phone] 
/// * [loyaltyPoints] 
/// * [savedPassengerCount] 
/// * [bookingCount] 
/// * [ticketCount] 
/// * [supportTicketCount] 
/// * [totalPaid] 
@BuiltValue()
abstract class AdminPassengerDetailDtoOutput implements Built<AdminPassengerDetailDtoOutput, AdminPassengerDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'providers')
  BuiltList<String> get providers;

  @BuiltValueField(wireName: r'status')
  AdminPassengerDetailDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'lockedReason')
  String? get lockedReason;

  @BuiltValueField(wireName: r'lockedAt')
  DateTime? get lockedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  @BuiltValueField(wireName: r'emailVerified')
  bool get emailVerified;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'loyaltyPoints')
  int? get loyaltyPoints;

  @BuiltValueField(wireName: r'savedPassengerCount')
  int get savedPassengerCount;

  @BuiltValueField(wireName: r'bookingCount')
  int get bookingCount;

  @BuiltValueField(wireName: r'ticketCount')
  int get ticketCount;

  @BuiltValueField(wireName: r'supportTicketCount')
  int get supportTicketCount;

  @BuiltValueField(wireName: r'totalPaid')
  int? get totalPaid;

  AdminPassengerDetailDtoOutput._();

  factory AdminPassengerDetailDtoOutput([void updates(AdminPassengerDetailDtoOutputBuilder b)]) = _$AdminPassengerDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPassengerDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPassengerDetailDtoOutput> get serializer => _$AdminPassengerDetailDtoOutputSerializer();
}

class _$AdminPassengerDetailDtoOutputSerializer implements PrimitiveSerializer<AdminPassengerDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPassengerDetailDtoOutput, _$AdminPassengerDetailDtoOutput];

  @override
  final String wireName = r'AdminPassengerDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPassengerDetailDtoOutput object, {
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
      specifiedType: const FullType(AdminPassengerDetailDtoOutputStatusEnum),
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
    yield r'emailVerified';
    yield serializers.serialize(
      object.emailVerified,
      specifiedType: const FullType(bool),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'loyaltyPoints';
    yield object.loyaltyPoints == null ? null : serializers.serialize(
      object.loyaltyPoints,
      specifiedType: const FullType.nullable(int),
    );
    yield r'savedPassengerCount';
    yield serializers.serialize(
      object.savedPassengerCount,
      specifiedType: const FullType(int),
    );
    yield r'bookingCount';
    yield serializers.serialize(
      object.bookingCount,
      specifiedType: const FullType(int),
    );
    yield r'ticketCount';
    yield serializers.serialize(
      object.ticketCount,
      specifiedType: const FullType(int),
    );
    yield r'supportTicketCount';
    yield serializers.serialize(
      object.supportTicketCount,
      specifiedType: const FullType(int),
    );
    yield r'totalPaid';
    yield object.totalPaid == null ? null : serializers.serialize(
      object.totalPaid,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPassengerDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPassengerDetailDtoOutputBuilder result,
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
            specifiedType: const FullType(AdminPassengerDetailDtoOutputStatusEnum),
          ) as AdminPassengerDetailDtoOutputStatusEnum;
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
        case r'emailVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailVerified = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'loyaltyPoints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.loyaltyPoints = valueDes;
          break;
        case r'savedPassengerCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.savedPassengerCount = valueDes;
          break;
        case r'bookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingCount = valueDes;
          break;
        case r'ticketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketCount = valueDes;
          break;
        case r'supportTicketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.supportTicketCount = valueDes;
          break;
        case r'totalPaid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalPaid = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPassengerDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPassengerDetailDtoOutputBuilder();
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


class AdminPassengerDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminPassengerDetailDtoOutputStatusEnum ACTIVE = _$adminPassengerDetailDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminPassengerDetailDtoOutputStatusEnum LOCKED = _$adminPassengerDetailDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminPassengerDetailDtoOutputStatusEnum DISABLED = _$adminPassengerDetailDtoOutputStatusEnum_DISABLED;

  static Serializer<AdminPassengerDetailDtoOutputStatusEnum> get serializer => _$adminPassengerDetailDtoOutputStatusEnumSerializer;

  const AdminPassengerDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminPassengerDetailDtoOutputStatusEnum> get values => _$adminPassengerDetailDtoOutputStatusEnumValues;
  static AdminPassengerDetailDtoOutputStatusEnum valueOf(String name) => _$adminPassengerDetailDtoOutputStatusEnumValueOf(name);
}

