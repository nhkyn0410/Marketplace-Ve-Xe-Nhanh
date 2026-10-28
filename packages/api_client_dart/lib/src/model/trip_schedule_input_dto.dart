//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_input_dto.g.dart';

/// TripScheduleInputDto
///
/// Properties:
/// * [routeId] 
/// * [vehicleId] 
/// * [departureTime] 
/// * [daysOfWeek] 
/// * [startDate] 
/// * [endDate] 
/// * [onlineSaleCutoffMinutes] 
/// * [note] 
@BuiltValue()
abstract class TripScheduleInputDto implements Built<TripScheduleInputDto, TripScheduleInputDtoBuilder> {
  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'vehicleId')
  String? get vehicleId;

  @BuiltValueField(wireName: r'departureTime')
  String get departureTime;

  @BuiltValueField(wireName: r'daysOfWeek')
  BuiltList<int> get daysOfWeek;

  @BuiltValueField(wireName: r'startDate')
  Date get startDate;

  @BuiltValueField(wireName: r'endDate')
  Date get endDate;

  @BuiltValueField(wireName: r'onlineSaleCutoffMinutes')
  int get onlineSaleCutoffMinutes;

  @BuiltValueField(wireName: r'note')
  String? get note;

  TripScheduleInputDto._();

  factory TripScheduleInputDto([void updates(TripScheduleInputDtoBuilder b)]) = _$TripScheduleInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleInputDto> get serializer => _$TripScheduleInputDtoSerializer();
}

class _$TripScheduleInputDtoSerializer implements PrimitiveSerializer<TripScheduleInputDto> {
  @override
  final Iterable<Type> types = const [TripScheduleInputDto, _$TripScheduleInputDto];

  @override
  final String wireName = r'TripScheduleInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeId';
    yield serializers.serialize(
      object.routeId,
      specifiedType: const FullType(String),
    );
    yield r'vehicleId';
    yield object.vehicleId == null ? null : serializers.serialize(
      object.vehicleId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'departureTime';
    yield serializers.serialize(
      object.departureTime,
      specifiedType: const FullType(String),
    );
    yield r'daysOfWeek';
    yield serializers.serialize(
      object.daysOfWeek,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'startDate';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'endDate';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
    );
    yield r'onlineSaleCutoffMinutes';
    yield serializers.serialize(
      object.onlineSaleCutoffMinutes,
      specifiedType: const FullType(int),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeId = valueDes;
          break;
        case r'vehicleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleId = valueDes;
          break;
        case r'departureTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.departureTime = valueDes;
          break;
        case r'daysOfWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.daysOfWeek.replace(valueDes);
          break;
        case r'startDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'endDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
          break;
        case r'onlineSaleCutoffMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineSaleCutoffMinutes = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripScheduleInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleInputDtoBuilder();
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


