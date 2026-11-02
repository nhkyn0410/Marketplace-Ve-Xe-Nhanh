//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_passenger_list_dto_output_summary.g.dart';

/// TripPassengerListDtoOutputSummary
///
/// Properties:
/// * [sold] 
/// * [checkedIn] 
/// * [notBoarded] 
/// * [noShow] 
@BuiltValue()
abstract class TripPassengerListDtoOutputSummary implements Built<TripPassengerListDtoOutputSummary, TripPassengerListDtoOutputSummaryBuilder> {
  @BuiltValueField(wireName: r'sold')
  int get sold;

  @BuiltValueField(wireName: r'checkedIn')
  int get checkedIn;

  @BuiltValueField(wireName: r'notBoarded')
  int get notBoarded;

  @BuiltValueField(wireName: r'noShow')
  int get noShow;

  TripPassengerListDtoOutputSummary._();

  factory TripPassengerListDtoOutputSummary([void updates(TripPassengerListDtoOutputSummaryBuilder b)]) = _$TripPassengerListDtoOutputSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripPassengerListDtoOutputSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripPassengerListDtoOutputSummary> get serializer => _$TripPassengerListDtoOutputSummarySerializer();
}

class _$TripPassengerListDtoOutputSummarySerializer implements PrimitiveSerializer<TripPassengerListDtoOutputSummary> {
  @override
  final Iterable<Type> types = const [TripPassengerListDtoOutputSummary, _$TripPassengerListDtoOutputSummary];

  @override
  final String wireName = r'TripPassengerListDtoOutputSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripPassengerListDtoOutputSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sold';
    yield serializers.serialize(
      object.sold,
      specifiedType: const FullType(int),
    );
    yield r'checkedIn';
    yield serializers.serialize(
      object.checkedIn,
      specifiedType: const FullType(int),
    );
    yield r'notBoarded';
    yield serializers.serialize(
      object.notBoarded,
      specifiedType: const FullType(int),
    );
    yield r'noShow';
    yield serializers.serialize(
      object.noShow,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripPassengerListDtoOutputSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripPassengerListDtoOutputSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sold = valueDes;
          break;
        case r'checkedIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checkedIn = valueDes;
          break;
        case r'notBoarded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.notBoarded = valueDes;
          break;
        case r'noShow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noShow = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripPassengerListDtoOutputSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripPassengerListDtoOutputSummaryBuilder();
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


