//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fare_band_create_dto.g.dart';

/// FareBandCreateDto
///
/// Properties:
/// * [name] 
/// * [minPrice] 
/// * [maxPrice] 
/// * [effectiveFrom] 
/// * [effectiveTo] 
/// * [message] 
/// * [reason] 
@BuiltValue()
abstract class FareBandCreateDto implements Built<FareBandCreateDto, FareBandCreateDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'minPrice')
  int? get minPrice;

  @BuiltValueField(wireName: r'maxPrice')
  int? get maxPrice;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'effectiveTo')
  DateTime get effectiveTo;

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  FareBandCreateDto._();

  factory FareBandCreateDto([void updates(FareBandCreateDtoBuilder b)]) = _$FareBandCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FareBandCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FareBandCreateDto> get serializer => _$FareBandCreateDtoSerializer();
}

class _$FareBandCreateDtoSerializer implements PrimitiveSerializer<FareBandCreateDto> {
  @override
  final Iterable<Type> types = const [FareBandCreateDto, _$FareBandCreateDto];

  @override
  final String wireName = r'FareBandCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FareBandCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'minPrice';
    yield object.minPrice == null ? null : serializers.serialize(
      object.minPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'maxPrice';
    yield object.maxPrice == null ? null : serializers.serialize(
      object.maxPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'effectiveTo';
    yield serializers.serialize(
      object.effectiveTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
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
    FareBandCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FareBandCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPrice = valueDes;
          break;
        case r'maxPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPrice = valueDes;
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveTo = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
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
  FareBandCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FareBandCreateDtoBuilder();
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


