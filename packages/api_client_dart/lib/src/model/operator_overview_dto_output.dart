//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/operator_overview_dto_output_next_week.dart';
import 'package:api_client_dart/src/model/operator_overview_dto_output_today.dart';
import 'package:api_client_dart/src/model/operator_overview_dto_output_month.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/operator_overview_dto_output_attention.dart';
import 'package:api_client_dart/src/model/operator_overview_dto_output_upcoming_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output.g.dart';

/// OperatorOverviewDtoOutput
///
/// Properties:
/// * [today] 
/// * [nextWeek] 
/// * [month] 
/// * [attention] 
/// * [upcoming] 
@BuiltValue()
abstract class OperatorOverviewDtoOutput implements Built<OperatorOverviewDtoOutput, OperatorOverviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'today')
  OperatorOverviewDtoOutputToday get today;

  @BuiltValueField(wireName: r'nextWeek')
  OperatorOverviewDtoOutputNextWeek get nextWeek;

  @BuiltValueField(wireName: r'month')
  OperatorOverviewDtoOutputMonth get month;

  @BuiltValueField(wireName: r'attention')
  OperatorOverviewDtoOutputAttention get attention;

  @BuiltValueField(wireName: r'upcoming')
  BuiltList<OperatorOverviewDtoOutputUpcomingInner> get upcoming;

  OperatorOverviewDtoOutput._();

  factory OperatorOverviewDtoOutput([void updates(OperatorOverviewDtoOutputBuilder b)]) = _$OperatorOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutput> get serializer => _$OperatorOverviewDtoOutputSerializer();
}

class _$OperatorOverviewDtoOutputSerializer implements PrimitiveSerializer<OperatorOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutput, _$OperatorOverviewDtoOutput];

  @override
  final String wireName = r'OperatorOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(OperatorOverviewDtoOutputToday),
    );
    yield r'nextWeek';
    yield serializers.serialize(
      object.nextWeek,
      specifiedType: const FullType(OperatorOverviewDtoOutputNextWeek),
    );
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(OperatorOverviewDtoOutputMonth),
    );
    yield r'attention';
    yield serializers.serialize(
      object.attention,
      specifiedType: const FullType(OperatorOverviewDtoOutputAttention),
    );
    yield r'upcoming';
    yield serializers.serialize(
      object.upcoming,
      specifiedType: const FullType(BuiltList, [FullType(OperatorOverviewDtoOutputUpcomingInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'today':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorOverviewDtoOutputToday),
          ) as OperatorOverviewDtoOutputToday;
          result.today.replace(valueDes);
          break;
        case r'nextWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorOverviewDtoOutputNextWeek),
          ) as OperatorOverviewDtoOutputNextWeek;
          result.nextWeek.replace(valueDes);
          break;
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorOverviewDtoOutputMonth),
          ) as OperatorOverviewDtoOutputMonth;
          result.month.replace(valueDes);
          break;
        case r'attention':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorOverviewDtoOutputAttention),
          ) as OperatorOverviewDtoOutputAttention;
          result.attention.replace(valueDes);
          break;
        case r'upcoming':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorOverviewDtoOutputUpcomingInner)]),
          ) as BuiltList<OperatorOverviewDtoOutputUpcomingInner>;
          result.upcoming.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputBuilder();
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


