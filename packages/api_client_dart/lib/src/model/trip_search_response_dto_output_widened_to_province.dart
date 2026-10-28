//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_widened_to_province.g.dart';

/// TripSearchResponseDtoOutputWidenedToProvince
///
/// Properties:
/// * [from] 
/// * [to] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputWidenedToProvince implements Built<TripSearchResponseDtoOutputWidenedToProvince, TripSearchResponseDtoOutputWidenedToProvinceBuilder> {
  @BuiltValueField(wireName: r'from')
  bool get from;

  @BuiltValueField(wireName: r'to')
  bool get to;

  TripSearchResponseDtoOutputWidenedToProvince._();

  factory TripSearchResponseDtoOutputWidenedToProvince([void updates(TripSearchResponseDtoOutputWidenedToProvinceBuilder b)]) = _$TripSearchResponseDtoOutputWidenedToProvince;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputWidenedToProvinceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputWidenedToProvince> get serializer => _$TripSearchResponseDtoOutputWidenedToProvinceSerializer();
}

class _$TripSearchResponseDtoOutputWidenedToProvinceSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputWidenedToProvince> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputWidenedToProvince, _$TripSearchResponseDtoOutputWidenedToProvince];

  @override
  final String wireName = r'TripSearchResponseDtoOutputWidenedToProvince';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputWidenedToProvince object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(bool),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputWidenedToProvince object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputWidenedToProvinceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputWidenedToProvince deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputWidenedToProvinceBuilder();
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


