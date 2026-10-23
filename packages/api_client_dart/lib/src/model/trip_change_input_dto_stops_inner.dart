//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_change_input_dto_stops_inner.g.dart';

/// TripChangeInputDtoStopsInner
///
/// Properties:
/// * [sequence] 
/// * [catalogStopPointId] 
/// * [stopPointId] 
@BuiltValue()
abstract class TripChangeInputDtoStopsInner implements Built<TripChangeInputDtoStopsInner, TripChangeInputDtoStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  TripChangeInputDtoStopsInner._();

  factory TripChangeInputDtoStopsInner([void updates(TripChangeInputDtoStopsInnerBuilder b)]) = _$TripChangeInputDtoStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripChangeInputDtoStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripChangeInputDtoStopsInner> get serializer => _$TripChangeInputDtoStopsInnerSerializer();
}

class _$TripChangeInputDtoStopsInnerSerializer implements PrimitiveSerializer<TripChangeInputDtoStopsInner> {
  @override
  final Iterable<Type> types = const [TripChangeInputDtoStopsInner, _$TripChangeInputDtoStopsInner];

  @override
  final String wireName = r'TripChangeInputDtoStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripChangeInputDtoStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'catalogStopPointId';
    yield object.catalogStopPointId == null ? null : serializers.serialize(
      object.catalogStopPointId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stopPointId';
    yield object.stopPointId == null ? null : serializers.serialize(
      object.stopPointId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripChangeInputDtoStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripChangeInputDtoStopsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'catalogStopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.catalogStopPointId = valueDes;
          break;
        case r'stopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stopPointId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripChangeInputDtoStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripChangeInputDtoStopsInnerBuilder();
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


