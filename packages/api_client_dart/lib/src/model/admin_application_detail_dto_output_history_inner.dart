//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_application_detail_dto_output_history_inner.g.dart';

/// AdminApplicationDetailDtoOutputHistoryInner
///
/// Properties:
/// * [event] 
/// * [at] 
/// * [note] 
@BuiltValue()
abstract class AdminApplicationDetailDtoOutputHistoryInner implements Built<AdminApplicationDetailDtoOutputHistoryInner, AdminApplicationDetailDtoOutputHistoryInnerBuilder> {
  @BuiltValueField(wireName: r'event')
  AdminApplicationDetailDtoOutputHistoryInnerEventEnum get event;
  // enum eventEnum {  CREATED,  EMAIL_VERIFIED,  SUBMITTED,  NEEDS_INFO,  REJECTED,  APPROVED,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminApplicationDetailDtoOutputHistoryInner._();

  factory AdminApplicationDetailDtoOutputHistoryInner([void updates(AdminApplicationDetailDtoOutputHistoryInnerBuilder b)]) = _$AdminApplicationDetailDtoOutputHistoryInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApplicationDetailDtoOutputHistoryInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApplicationDetailDtoOutputHistoryInner> get serializer => _$AdminApplicationDetailDtoOutputHistoryInnerSerializer();
}

class _$AdminApplicationDetailDtoOutputHistoryInnerSerializer implements PrimitiveSerializer<AdminApplicationDetailDtoOutputHistoryInner> {
  @override
  final Iterable<Type> types = const [AdminApplicationDetailDtoOutputHistoryInner, _$AdminApplicationDetailDtoOutputHistoryInner];

  @override
  final String wireName = r'AdminApplicationDetailDtoOutputHistoryInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApplicationDetailDtoOutputHistoryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(AdminApplicationDetailDtoOutputHistoryInnerEventEnum),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApplicationDetailDtoOutputHistoryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminApplicationDetailDtoOutputHistoryInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminApplicationDetailDtoOutputHistoryInnerEventEnum),
          ) as AdminApplicationDetailDtoOutputHistoryInnerEventEnum;
          result.event = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApplicationDetailDtoOutputHistoryInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApplicationDetailDtoOutputHistoryInnerBuilder();
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


class AdminApplicationDetailDtoOutputHistoryInnerEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CREATED')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum CREATED = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_CREATED;
  @BuiltValueEnumConst(wireName: r'EMAIL_VERIFIED')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum EMAIL_VERIFIED = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_EMAIL_VERIFIED;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum SUBMITTED = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'NEEDS_INFO')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum NEEDS_INFO = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_NEEDS_INFO;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum REJECTED = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminApplicationDetailDtoOutputHistoryInnerEventEnum APPROVED = _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_APPROVED;

  static Serializer<AdminApplicationDetailDtoOutputHistoryInnerEventEnum> get serializer => _$adminApplicationDetailDtoOutputHistoryInnerEventEnumSerializer;

  const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._(String name): super(name);

  static BuiltSet<AdminApplicationDetailDtoOutputHistoryInnerEventEnum> get values => _$adminApplicationDetailDtoOutputHistoryInnerEventEnumValues;
  static AdminApplicationDetailDtoOutputHistoryInnerEventEnum valueOf(String name) => _$adminApplicationDetailDtoOutputHistoryInnerEventEnumValueOf(name);
}

