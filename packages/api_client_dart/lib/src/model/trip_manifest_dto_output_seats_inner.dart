//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_manifest_dto_output_seats_inner.g.dart';

/// TripManifestDtoOutputSeatsInner
///
/// Properties:
/// * [code] 
/// * [deck] 
/// * [row] 
/// * [column] 
@BuiltValue()
abstract class TripManifestDtoOutputSeatsInner implements Built<TripManifestDtoOutputSeatsInner, TripManifestDtoOutputSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'deck')
  int get deck;

  @BuiltValueField(wireName: r'row')
  int get row;

  @BuiltValueField(wireName: r'column')
  int get column;

  TripManifestDtoOutputSeatsInner._();

  factory TripManifestDtoOutputSeatsInner([void updates(TripManifestDtoOutputSeatsInnerBuilder b)]) = _$TripManifestDtoOutputSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripManifestDtoOutputSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripManifestDtoOutputSeatsInner> get serializer => _$TripManifestDtoOutputSeatsInnerSerializer();
}

class _$TripManifestDtoOutputSeatsInnerSerializer implements PrimitiveSerializer<TripManifestDtoOutputSeatsInner> {
  @override
  final Iterable<Type> types = const [TripManifestDtoOutputSeatsInner, _$TripManifestDtoOutputSeatsInner];

  @override
  final String wireName = r'TripManifestDtoOutputSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripManifestDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'deck';
    yield serializers.serialize(
      object.deck,
      specifiedType: const FullType(int),
    );
    yield r'row';
    yield serializers.serialize(
      object.row,
      specifiedType: const FullType(int),
    );
    yield r'column';
    yield serializers.serialize(
      object.column,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripManifestDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripManifestDtoOutputSeatsInnerBuilder result,
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
        case r'deck':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deck = valueDes;
          break;
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.row = valueDes;
          break;
        case r'column':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.column = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripManifestDtoOutputSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripManifestDtoOutputSeatsInnerBuilder();
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


