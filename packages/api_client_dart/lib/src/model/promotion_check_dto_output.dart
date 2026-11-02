//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_check_dto_output.g.dart';

/// PromotionCheckDtoOutput
///
/// Properties:
/// * [code] 
/// * [name] 
/// * [discount] 
/// * [total] 
@BuiltValue()
abstract class PromotionCheckDtoOutput implements Built<PromotionCheckDtoOutput, PromotionCheckDtoOutputBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discount')
  int get discount;

  @BuiltValueField(wireName: r'total')
  int get total;

  PromotionCheckDtoOutput._();

  factory PromotionCheckDtoOutput([void updates(PromotionCheckDtoOutputBuilder b)]) = _$PromotionCheckDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionCheckDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionCheckDtoOutput> get serializer => _$PromotionCheckDtoOutputSerializer();
}

class _$PromotionCheckDtoOutputSerializer implements PrimitiveSerializer<PromotionCheckDtoOutput> {
  @override
  final Iterable<Type> types = const [PromotionCheckDtoOutput, _$PromotionCheckDtoOutput];

  @override
  final String wireName = r'PromotionCheckDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionCheckDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionCheckDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionCheckDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discount = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionCheckDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionCheckDtoOutputBuilder();
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


