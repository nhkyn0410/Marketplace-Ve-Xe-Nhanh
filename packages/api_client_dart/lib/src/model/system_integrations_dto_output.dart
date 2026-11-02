//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/system_integrations_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'system_integrations_dto_output.g.dart';

/// SystemIntegrationsDtoOutput
///
/// Properties:
/// * [checkedAt] 
/// * [environment] 
/// * [items] 
@BuiltValue()
abstract class SystemIntegrationsDtoOutput implements Built<SystemIntegrationsDtoOutput, SystemIntegrationsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'checkedAt')
  DateTime get checkedAt;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'items')
  BuiltList<SystemIntegrationsDtoOutputItemsInner> get items;

  SystemIntegrationsDtoOutput._();

  factory SystemIntegrationsDtoOutput([void updates(SystemIntegrationsDtoOutputBuilder b)]) = _$SystemIntegrationsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SystemIntegrationsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SystemIntegrationsDtoOutput> get serializer => _$SystemIntegrationsDtoOutputSerializer();
}

class _$SystemIntegrationsDtoOutputSerializer implements PrimitiveSerializer<SystemIntegrationsDtoOutput> {
  @override
  final Iterable<Type> types = const [SystemIntegrationsDtoOutput, _$SystemIntegrationsDtoOutput];

  @override
  final String wireName = r'SystemIntegrationsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SystemIntegrationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkedAt';
    yield serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SystemIntegrationsDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SystemIntegrationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SystemIntegrationsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.checkedAt = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SystemIntegrationsDtoOutputItemsInner)]),
          ) as BuiltList<SystemIntegrationsDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SystemIntegrationsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SystemIntegrationsDtoOutputBuilder();
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


