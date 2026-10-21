//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output_month.g.dart';

/// OperatorOverviewDtoOutputMonth
///
/// Properties:
/// * [grossRevenue] 
/// * [ticketsSold] 
/// * [completedTrips] 
@BuiltValue()
abstract class OperatorOverviewDtoOutputMonth implements Built<OperatorOverviewDtoOutputMonth, OperatorOverviewDtoOutputMonthBuilder> {
  @BuiltValueField(wireName: r'grossRevenue')
  int get grossRevenue;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  OperatorOverviewDtoOutputMonth._();

  factory OperatorOverviewDtoOutputMonth([void updates(OperatorOverviewDtoOutputMonthBuilder b)]) = _$OperatorOverviewDtoOutputMonth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputMonthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutputMonth> get serializer => _$OperatorOverviewDtoOutputMonthSerializer();
}

class _$OperatorOverviewDtoOutputMonthSerializer implements PrimitiveSerializer<OperatorOverviewDtoOutputMonth> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutputMonth, _$OperatorOverviewDtoOutputMonth];

  @override
  final String wireName = r'OperatorOverviewDtoOutputMonth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutputMonth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'grossRevenue';
    yield serializers.serialize(
      object.grossRevenue,
      specifiedType: const FullType(int),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'completedTrips';
    yield serializers.serialize(
      object.completedTrips,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorOverviewDtoOutputMonth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputMonthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'grossRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossRevenue = valueDes;
          break;
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'completedTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completedTrips = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorOverviewDtoOutputMonth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputMonthBuilder();
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


