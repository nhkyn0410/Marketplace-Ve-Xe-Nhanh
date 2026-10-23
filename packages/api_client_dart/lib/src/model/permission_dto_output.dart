//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_dto_output.g.dart';

/// PermissionDtoOutput
///
/// Properties:
/// * [operatorId] 
/// * [operatorName] 
/// * [operatorSlug] 
/// * [enabled] 
/// * [maxPercent] 
/// * [maxAmount] 
/// * [routeIds] 
/// * [routeNames] 
/// * [maxDurationDays] 
/// * [monthlyBudget] 
@BuiltValue()
abstract class PermissionDtoOutput implements Built<PermissionDtoOutput, PermissionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'maxPercent')
  int? get maxPercent;

  @BuiltValueField(wireName: r'maxAmount')
  int? get maxAmount;

  @BuiltValueField(wireName: r'routeIds')
  BuiltList<String> get routeIds;

  @BuiltValueField(wireName: r'routeNames')
  BuiltList<String> get routeNames;

  @BuiltValueField(wireName: r'maxDurationDays')
  int get maxDurationDays;

  @BuiltValueField(wireName: r'monthlyBudget')
  int? get monthlyBudget;

  PermissionDtoOutput._();

  factory PermissionDtoOutput([void updates(PermissionDtoOutputBuilder b)]) = _$PermissionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionDtoOutput> get serializer => _$PermissionDtoOutputSerializer();
}

class _$PermissionDtoOutputSerializer implements PrimitiveSerializer<PermissionDtoOutput> {
  @override
  final Iterable<Type> types = const [PermissionDtoOutput, _$PermissionDtoOutput];

  @override
  final String wireName = r'PermissionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'maxPercent';
    yield object.maxPercent == null ? null : serializers.serialize(
      object.maxPercent,
      specifiedType: const FullType.nullable(int),
    );
    yield r'maxAmount';
    yield object.maxAmount == null ? null : serializers.serialize(
      object.maxAmount,
      specifiedType: const FullType.nullable(int),
    );
    yield r'routeIds';
    yield serializers.serialize(
      object.routeIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'routeNames';
    yield serializers.serialize(
      object.routeNames,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'maxDurationDays';
    yield serializers.serialize(
      object.maxDurationDays,
      specifiedType: const FullType(int),
    );
    yield r'monthlyBudget';
    yield object.monthlyBudget == null ? null : serializers.serialize(
      object.monthlyBudget,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermissionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermissionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'maxPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPercent = valueDes;
          break;
        case r'maxAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxAmount = valueDes;
          break;
        case r'routeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.routeIds.replace(valueDes);
          break;
        case r'routeNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.routeNames.replace(valueDes);
          break;
        case r'maxDurationDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxDurationDays = valueDes;
          break;
        case r'monthlyBudget':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.monthlyBudget = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermissionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionDtoOutputBuilder();
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


