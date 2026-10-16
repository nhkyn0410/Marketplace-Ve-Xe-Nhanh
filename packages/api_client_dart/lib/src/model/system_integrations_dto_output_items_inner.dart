//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'system_integrations_dto_output_items_inner.g.dart';

/// SystemIntegrationsDtoOutputItemsInner
///
/// Properties:
/// * [key] 
/// * [name] 
/// * [category] 
/// * [status] 
/// * [latencyMs] 
/// * [detail] 
@BuiltValue()
abstract class SystemIntegrationsDtoOutputItemsInner implements Built<SystemIntegrationsDtoOutputItemsInner, SystemIntegrationsDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'status')
  SystemIntegrationsDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  UP,  DOWN,  CONFIGURED,  LOCAL,  NOT_CONFIGURED,  NOT_INTEGRATED,  DISABLED,  };

  @BuiltValueField(wireName: r'latencyMs')
  int? get latencyMs;

  @BuiltValueField(wireName: r'detail')
  String get detail;

  SystemIntegrationsDtoOutputItemsInner._();

  factory SystemIntegrationsDtoOutputItemsInner([void updates(SystemIntegrationsDtoOutputItemsInnerBuilder b)]) = _$SystemIntegrationsDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SystemIntegrationsDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SystemIntegrationsDtoOutputItemsInner> get serializer => _$SystemIntegrationsDtoOutputItemsInnerSerializer();
}

class _$SystemIntegrationsDtoOutputItemsInnerSerializer implements PrimitiveSerializer<SystemIntegrationsDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [SystemIntegrationsDtoOutputItemsInner, _$SystemIntegrationsDtoOutputItemsInner];

  @override
  final String wireName = r'SystemIntegrationsDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SystemIntegrationsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SystemIntegrationsDtoOutputItemsInnerStatusEnum),
    );
    yield r'latencyMs';
    yield object.latencyMs == null ? null : serializers.serialize(
      object.latencyMs,
      specifiedType: const FullType.nullable(int),
    );
    yield r'detail';
    yield serializers.serialize(
      object.detail,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SystemIntegrationsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SystemIntegrationsDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SystemIntegrationsDtoOutputItemsInnerStatusEnum),
          ) as SystemIntegrationsDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'latencyMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.latencyMs = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.detail = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SystemIntegrationsDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SystemIntegrationsDtoOutputItemsInnerBuilder();
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


class SystemIntegrationsDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UP')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum UP = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_UP;
  @BuiltValueEnumConst(wireName: r'DOWN')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum DOWN = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DOWN;
  @BuiltValueEnumConst(wireName: r'CONFIGURED')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum CONFIGURED = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_CONFIGURED;
  @BuiltValueEnumConst(wireName: r'LOCAL')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum LOCAL = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_LOCAL;
  @BuiltValueEnumConst(wireName: r'NOT_CONFIGURED')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum NOT_CONFIGURED = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_CONFIGURED;
  @BuiltValueEnumConst(wireName: r'NOT_INTEGRATED')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum NOT_INTEGRATED = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_NOT_INTEGRATED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const SystemIntegrationsDtoOutputItemsInnerStatusEnum DISABLED = _$systemIntegrationsDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<SystemIntegrationsDtoOutputItemsInnerStatusEnum> get serializer => _$systemIntegrationsDtoOutputItemsInnerStatusEnumSerializer;

  const SystemIntegrationsDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<SystemIntegrationsDtoOutputItemsInnerStatusEnum> get values => _$systemIntegrationsDtoOutputItemsInnerStatusEnumValues;
  static SystemIntegrationsDtoOutputItemsInnerStatusEnum valueOf(String name) => _$systemIntegrationsDtoOutputItemsInnerStatusEnumValueOf(name);
}

