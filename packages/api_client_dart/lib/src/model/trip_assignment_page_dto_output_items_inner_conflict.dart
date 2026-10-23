//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_assignment_page_dto_output_items_inner_conflict.g.dart';

/// TripAssignmentPageDtoOutputItemsInnerConflict
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [arrivalAt] 
@BuiltValue()
abstract class TripAssignmentPageDtoOutputItemsInnerConflict implements Built<TripAssignmentPageDtoOutputItemsInnerConflict, TripAssignmentPageDtoOutputItemsInnerConflictBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'arrivalAt')
  DateTime get arrivalAt;

  TripAssignmentPageDtoOutputItemsInnerConflict._();

  factory TripAssignmentPageDtoOutputItemsInnerConflict([void updates(TripAssignmentPageDtoOutputItemsInnerConflictBuilder b)]) = _$TripAssignmentPageDtoOutputItemsInnerConflict;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripAssignmentPageDtoOutputItemsInnerConflictBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripAssignmentPageDtoOutputItemsInnerConflict> get serializer => _$TripAssignmentPageDtoOutputItemsInnerConflictSerializer();
}

class _$TripAssignmentPageDtoOutputItemsInnerConflictSerializer implements PrimitiveSerializer<TripAssignmentPageDtoOutputItemsInnerConflict> {
  @override
  final Iterable<Type> types = const [TripAssignmentPageDtoOutputItemsInnerConflict, _$TripAssignmentPageDtoOutputItemsInnerConflict];

  @override
  final String wireName = r'TripAssignmentPageDtoOutputItemsInnerConflict';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInnerConflict object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'arrivalAt';
    yield serializers.serialize(
      object.arrivalAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInnerConflict object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripAssignmentPageDtoOutputItemsInnerConflictBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'arrivalAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.arrivalAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripAssignmentPageDtoOutputItemsInnerConflict deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripAssignmentPageDtoOutputItemsInnerConflictBuilder();
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


