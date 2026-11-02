//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_segment.g.dart';

/// PublicTripDtoOutputSegment
///
/// Properties:
/// * [pickupSequence] 
/// * [dropoffSequence] 
/// * [title] 
@BuiltValue()
abstract class PublicTripDtoOutputSegment implements Built<PublicTripDtoOutputSegment, PublicTripDtoOutputSegmentBuilder> {
  @BuiltValueField(wireName: r'pickupSequence')
  int get pickupSequence;

  @BuiltValueField(wireName: r'dropoffSequence')
  int get dropoffSequence;

  @BuiltValueField(wireName: r'title')
  String get title;

  PublicTripDtoOutputSegment._();

  factory PublicTripDtoOutputSegment([void updates(PublicTripDtoOutputSegmentBuilder b)]) = _$PublicTripDtoOutputSegment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputSegmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputSegment> get serializer => _$PublicTripDtoOutputSegmentSerializer();
}

class _$PublicTripDtoOutputSegmentSerializer implements PrimitiveSerializer<PublicTripDtoOutputSegment> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputSegment, _$PublicTripDtoOutputSegment];

  @override
  final String wireName = r'PublicTripDtoOutputSegment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputSegment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pickupSequence';
    yield serializers.serialize(
      object.pickupSequence,
      specifiedType: const FullType(int),
    );
    yield r'dropoffSequence';
    yield serializers.serialize(
      object.dropoffSequence,
      specifiedType: const FullType(int),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputSegment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputSegmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pickupSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pickupSequence = valueDes;
          break;
        case r'dropoffSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dropoffSequence = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutputSegment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputSegmentBuilder();
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


