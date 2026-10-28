//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_detail_dto_output_manifest_inner.g.dart';

/// AdminTripDetailDtoOutputManifestInner
///
/// Properties:
/// * [ticketCode] 
/// * [seatCode] 
/// * [fullName] 
/// * [phone] 
/// * [status] 
/// * [bookingCode] 
/// * [channel] 
/// * [guest] 
/// * [userId] 
@BuiltValue()
abstract class AdminTripDetailDtoOutputManifestInner implements Built<AdminTripDetailDtoOutputManifestInner, AdminTripDetailDtoOutputManifestInnerBuilder> {
  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'status')
  AdminTripDetailDtoOutputManifestInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'channel')
  AdminTripDetailDtoOutputManifestInnerChannelEnum get channel;
  // enum channelEnum {  ONLINE,  COUNTER,  };

  @BuiltValueField(wireName: r'guest')
  bool get guest;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  AdminTripDetailDtoOutputManifestInner._();

  factory AdminTripDetailDtoOutputManifestInner([void updates(AdminTripDetailDtoOutputManifestInnerBuilder b)]) = _$AdminTripDetailDtoOutputManifestInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripDetailDtoOutputManifestInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripDetailDtoOutputManifestInner> get serializer => _$AdminTripDetailDtoOutputManifestInnerSerializer();
}

class _$AdminTripDetailDtoOutputManifestInnerSerializer implements PrimitiveSerializer<AdminTripDetailDtoOutputManifestInner> {
  @override
  final Iterable<Type> types = const [AdminTripDetailDtoOutputManifestInner, _$AdminTripDetailDtoOutputManifestInner];

  @override
  final String wireName = r'AdminTripDetailDtoOutputManifestInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripDetailDtoOutputManifestInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminTripDetailDtoOutputManifestInnerStatusEnum),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(AdminTripDetailDtoOutputManifestInnerChannelEnum),
    );
    yield r'guest';
    yield serializers.serialize(
      object.guest,
      specifiedType: const FullType(bool),
    );
    yield r'userId';
    yield object.userId == null ? null : serializers.serialize(
      object.userId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripDetailDtoOutputManifestInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripDetailDtoOutputManifestInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTripDetailDtoOutputManifestInnerStatusEnum),
          ) as AdminTripDetailDtoOutputManifestInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTripDetailDtoOutputManifestInnerChannelEnum),
          ) as AdminTripDetailDtoOutputManifestInnerChannelEnum;
          result.channel = valueDes;
          break;
        case r'guest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.guest = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripDetailDtoOutputManifestInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripDetailDtoOutputManifestInnerBuilder();
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


class AdminTripDetailDtoOutputManifestInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum VALID = _$adminTripDetailDtoOutputManifestInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum CANCELLED = _$adminTripDetailDtoOutputManifestInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum CHECKED_IN = _$adminTripDetailDtoOutputManifestInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum NO_SHOW = _$adminTripDetailDtoOutputManifestInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum USED = _$adminTripDetailDtoOutputManifestInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const AdminTripDetailDtoOutputManifestInnerStatusEnum REFUNDED = _$adminTripDetailDtoOutputManifestInnerStatusEnum_REFUNDED;

  static Serializer<AdminTripDetailDtoOutputManifestInnerStatusEnum> get serializer => _$adminTripDetailDtoOutputManifestInnerStatusEnumSerializer;

  const AdminTripDetailDtoOutputManifestInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminTripDetailDtoOutputManifestInnerStatusEnum> get values => _$adminTripDetailDtoOutputManifestInnerStatusEnumValues;
  static AdminTripDetailDtoOutputManifestInnerStatusEnum valueOf(String name) => _$adminTripDetailDtoOutputManifestInnerStatusEnumValueOf(name);
}

class AdminTripDetailDtoOutputManifestInnerChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const AdminTripDetailDtoOutputManifestInnerChannelEnum ONLINE = _$adminTripDetailDtoOutputManifestInnerChannelEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'COUNTER')
  static const AdminTripDetailDtoOutputManifestInnerChannelEnum COUNTER = _$adminTripDetailDtoOutputManifestInnerChannelEnum_COUNTER;

  static Serializer<AdminTripDetailDtoOutputManifestInnerChannelEnum> get serializer => _$adminTripDetailDtoOutputManifestInnerChannelEnumSerializer;

  const AdminTripDetailDtoOutputManifestInnerChannelEnum._(String name): super(name);

  static BuiltSet<AdminTripDetailDtoOutputManifestInnerChannelEnum> get values => _$adminTripDetailDtoOutputManifestInnerChannelEnumValues;
  static AdminTripDetailDtoOutputManifestInnerChannelEnum valueOf(String name) => _$adminTripDetailDtoOutputManifestInnerChannelEnumValueOf(name);
}

