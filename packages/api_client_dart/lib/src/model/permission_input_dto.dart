//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_input_dto.g.dart';

/// PermissionInputDto
///
/// Properties:
/// * [enabled] 
/// * [maxPercent] 
/// * [maxAmount] 
/// * [routeIds] 
/// * [maxDurationDays] 
/// * [monthlyBudget] 
@BuiltValue()
abstract class PermissionInputDto implements Built<PermissionInputDto, PermissionInputDtoBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'maxPercent')
  int? get maxPercent;

  @BuiltValueField(wireName: r'maxAmount')
  int? get maxAmount;

  @BuiltValueField(wireName: r'routeIds')
  BuiltList<String>? get routeIds;

  @BuiltValueField(wireName: r'maxDurationDays')
  int? get maxDurationDays;

  @BuiltValueField(wireName: r'monthlyBudget')
  int? get monthlyBudget;

  PermissionInputDto._();

  factory PermissionInputDto([void updates(PermissionInputDtoBuilder b)]) = _$PermissionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionInputDtoBuilder b) => b
      ..routeIds = ListBuilder()
      ..maxDurationDays = 30;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionInputDto> get serializer => _$PermissionInputDtoSerializer();
}

class _$PermissionInputDtoSerializer implements PrimitiveSerializer<PermissionInputDto> {
  @override
  final Iterable<Type> types = const [PermissionInputDto, _$PermissionInputDto];

  @override
  final String wireName = r'PermissionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.maxPercent != null) {
      yield r'maxPercent';
      yield serializers.serialize(
        object.maxPercent,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.maxAmount != null) {
      yield r'maxAmount';
      yield serializers.serialize(
        object.maxAmount,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.routeIds != null) {
      yield r'routeIds';
      yield serializers.serialize(
        object.routeIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.maxDurationDays != null) {
      yield r'maxDurationDays';
      yield serializers.serialize(
        object.maxDurationDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.monthlyBudget != null) {
      yield r'monthlyBudget';
      yield serializers.serialize(
        object.monthlyBudget,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PermissionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermissionInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.routeIds.replace(valueDes);
          break;
        case r'maxDurationDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  PermissionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionInputDtoBuilder();
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


