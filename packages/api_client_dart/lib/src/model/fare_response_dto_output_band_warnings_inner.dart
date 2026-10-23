//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fare_response_dto_output_band_warnings_inner.g.dart';

/// FareResponseDtoOutputBandWarningsInner
///
/// Properties:
/// * [ruleIndex] 
/// * [price] 
/// * [bandId] 
/// * [bandName] 
/// * [minPrice] 
/// * [maxPrice] 
/// * [effectiveFrom] 
/// * [effectiveTo] 
/// * [message] 
@BuiltValue()
abstract class FareResponseDtoOutputBandWarningsInner implements Built<FareResponseDtoOutputBandWarningsInner, FareResponseDtoOutputBandWarningsInnerBuilder> {
  @BuiltValueField(wireName: r'ruleIndex')
  int get ruleIndex;

  @BuiltValueField(wireName: r'price')
  int get price;

  @BuiltValueField(wireName: r'bandId')
  String get bandId;

  @BuiltValueField(wireName: r'bandName')
  String get bandName;

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

  FareResponseDtoOutputBandWarningsInner._();

  factory FareResponseDtoOutputBandWarningsInner([void updates(FareResponseDtoOutputBandWarningsInnerBuilder b)]) = _$FareResponseDtoOutputBandWarningsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FareResponseDtoOutputBandWarningsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FareResponseDtoOutputBandWarningsInner> get serializer => _$FareResponseDtoOutputBandWarningsInnerSerializer();
}

class _$FareResponseDtoOutputBandWarningsInnerSerializer implements PrimitiveSerializer<FareResponseDtoOutputBandWarningsInner> {
  @override
  final Iterable<Type> types = const [FareResponseDtoOutputBandWarningsInner, _$FareResponseDtoOutputBandWarningsInner];

  @override
  final String wireName = r'FareResponseDtoOutputBandWarningsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FareResponseDtoOutputBandWarningsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ruleIndex';
    yield serializers.serialize(
      object.ruleIndex,
      specifiedType: const FullType(int),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
    yield r'bandId';
    yield serializers.serialize(
      object.bandId,
      specifiedType: const FullType(String),
    );
    yield r'bandName';
    yield serializers.serialize(
      object.bandName,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FareResponseDtoOutputBandWarningsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FareResponseDtoOutputBandWarningsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ruleIndex':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ruleIndex = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.price = valueDes;
          break;
        case r'bandId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bandId = valueDes;
          break;
        case r'bandName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bandName = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FareResponseDtoOutputBandWarningsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FareResponseDtoOutputBandWarningsInnerBuilder();
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


