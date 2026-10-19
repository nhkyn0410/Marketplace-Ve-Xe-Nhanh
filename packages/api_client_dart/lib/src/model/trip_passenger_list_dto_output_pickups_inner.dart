//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_passenger_list_dto_output_pickups_inner.g.dart';

/// TripPassengerListDtoOutputPickupsInner
///
/// Properties:
/// * [sequence] 
/// * [name] 
@BuiltValue()
abstract class TripPassengerListDtoOutputPickupsInner implements Built<TripPassengerListDtoOutputPickupsInner, TripPassengerListDtoOutputPickupsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  TripPassengerListDtoOutputPickupsInner._();

  factory TripPassengerListDtoOutputPickupsInner([void updates(TripPassengerListDtoOutputPickupsInnerBuilder b)]) = _$TripPassengerListDtoOutputPickupsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripPassengerListDtoOutputPickupsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripPassengerListDtoOutputPickupsInner> get serializer => _$TripPassengerListDtoOutputPickupsInnerSerializer();
}

class _$TripPassengerListDtoOutputPickupsInnerSerializer implements PrimitiveSerializer<TripPassengerListDtoOutputPickupsInner> {
  @override
  final Iterable<Type> types = const [TripPassengerListDtoOutputPickupsInner, _$TripPassengerListDtoOutputPickupsInner];

  @override
  final String wireName = r'TripPassengerListDtoOutputPickupsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripPassengerListDtoOutputPickupsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripPassengerListDtoOutputPickupsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripPassengerListDtoOutputPickupsInnerBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripPassengerListDtoOutputPickupsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripPassengerListDtoOutputPickupsInnerBuilder();
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


