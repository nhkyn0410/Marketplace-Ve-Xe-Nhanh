//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output_next_week.g.dart';

/// OperatorOverviewDtoOutputNextWeek
///
/// Properties:
/// * [trips] 
/// * [ticketsSold] 
/// * [seats] 
@BuiltValue()
abstract class OperatorOverviewDtoOutputNextWeek implements Built<OperatorOverviewDtoOutputNextWeek, OperatorOverviewDtoOutputNextWeekBuilder> {
  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  OperatorOverviewDtoOutputNextWeek._();

  factory OperatorOverviewDtoOutputNextWeek([void updates(OperatorOverviewDtoOutputNextWeekBuilder b)]) = _$OperatorOverviewDtoOutputNextWeek;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputNextWeekBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutputNextWeek> get serializer => _$OperatorOverviewDtoOutputNextWeekSerializer();
}

class _$OperatorOverviewDtoOutputNextWeekSerializer implements PrimitiveSerializer<OperatorOverviewDtoOutputNextWeek> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutputNextWeek, _$OperatorOverviewDtoOutputNextWeek];

  @override
  final String wireName = r'OperatorOverviewDtoOutputNextWeek';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutputNextWeek object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorOverviewDtoOutputNextWeek object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputNextWeekBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
          break;
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorOverviewDtoOutputNextWeek deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputNextWeekBuilder();
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


