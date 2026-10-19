//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_rule_update_dto.g.dart';

/// CommissionRuleUpdateDto
///
/// Properties:
/// * [rateBps] 
/// * [effectiveFrom] 
/// * [effectiveTo] 
/// * [reason] 
@BuiltValue()
abstract class CommissionRuleUpdateDto implements Built<CommissionRuleUpdateDto, CommissionRuleUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'rateBps')
  int get rateBps;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'effectiveTo')
  DateTime? get effectiveTo;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  CommissionRuleUpdateDto._();

  factory CommissionRuleUpdateDto([void updates(CommissionRuleUpdateDtoBuilder b)]) = _$CommissionRuleUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionRuleUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionRuleUpdateDto> get serializer => _$CommissionRuleUpdateDtoSerializer();
}

class _$CommissionRuleUpdateDtoSerializer implements PrimitiveSerializer<CommissionRuleUpdateDto> {
  @override
  final Iterable<Type> types = const [CommissionRuleUpdateDto, _$CommissionRuleUpdateDto];

  @override
  final String wireName = r'CommissionRuleUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionRuleUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBps';
    yield serializers.serialize(
      object.rateBps,
      specifiedType: const FullType(int),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'effectiveTo';
    yield object.effectiveTo == null ? null : serializers.serialize(
      object.effectiveTo,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionRuleUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionRuleUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBps = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'effectiveTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveTo = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionRuleUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionRuleUpdateDtoBuilder();
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


