//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_province_dto_output.g.dart';

/// AdminProvinceDtoOutput
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [wardCount] 
/// * [stopPointCount] 
@BuiltValue()
abstract class AdminProvinceDtoOutput implements Built<AdminProvinceDtoOutput, AdminProvinceDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminProvinceDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'wardCount')
  int get wardCount;

  @BuiltValueField(wireName: r'stopPointCount')
  int get stopPointCount;

  AdminProvinceDtoOutput._();

  factory AdminProvinceDtoOutput([void updates(AdminProvinceDtoOutputBuilder b)]) = _$AdminProvinceDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminProvinceDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminProvinceDtoOutput> get serializer => _$AdminProvinceDtoOutputSerializer();
}

class _$AdminProvinceDtoOutputSerializer implements PrimitiveSerializer<AdminProvinceDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminProvinceDtoOutput, _$AdminProvinceDtoOutput];

  @override
  final String wireName = r'AdminProvinceDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminProvinceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminProvinceDtoOutputStatusEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'wardCount';
    yield serializers.serialize(
      object.wardCount,
      specifiedType: const FullType(int),
    );
    yield r'stopPointCount';
    yield serializers.serialize(
      object.stopPointCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminProvinceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminProvinceDtoOutputBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminProvinceDtoOutputStatusEnum),
          ) as AdminProvinceDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'wardCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.wardCount = valueDes;
          break;
        case r'stopPointCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stopPointCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminProvinceDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminProvinceDtoOutputBuilder();
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


class AdminProvinceDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminProvinceDtoOutputStatusEnum ACTIVE = _$adminProvinceDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminProvinceDtoOutputStatusEnum INACTIVE = _$adminProvinceDtoOutputStatusEnum_INACTIVE;

  static Serializer<AdminProvinceDtoOutputStatusEnum> get serializer => _$adminProvinceDtoOutputStatusEnumSerializer;

  const AdminProvinceDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminProvinceDtoOutputStatusEnum> get values => _$adminProvinceDtoOutputStatusEnumValues;
  static AdminProvinceDtoOutputStatusEnum valueOf(String name) => _$adminProvinceDtoOutputStatusEnumValueOf(name);
}

