//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output_today.g.dart';

/// OperatorOverviewDtoOutputToday
///
/// Properties:
/// * [trips] 
/// * [running] 
/// * [ticketsSold] 
/// * [seats] 
@BuiltValue()
abstract class OperatorOverviewDtoOutputToday implements Built<OperatorOverviewDtoOutputToday, OperatorOverviewDtoOutputTodayBuilder> {
  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'running')
  int get running;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  OperatorOverviewDtoOutputToday._();

  factory OperatorOverviewDtoOutputToday([void updates(OperatorOverviewDtoOutputTodayBuilder b)]) = _$OperatorOverviewDtoOutputToday;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputTodayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutputToday> get serializer => _$OperatorOverviewDtoOutputTodaySerializer();
}

class _$OperatorOverviewDtoOutputTodaySerializer implements PrimitiveSerializer<OperatorOverviewDtoOutputToday> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutputToday, _$OperatorOverviewDtoOutputToday];

  @override
  final String wireName = r'OperatorOverviewDtoOutputToday';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutputToday object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'running';
    yield serializers.serialize(
      object.running,
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
    OperatorOverviewDtoOutputToday object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputTodayBuilder result,
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
        case r'running':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.running = valueDes;
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
  OperatorOverviewDtoOutputToday deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputTodayBuilder();
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


