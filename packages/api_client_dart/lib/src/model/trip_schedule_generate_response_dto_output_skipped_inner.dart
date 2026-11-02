//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_generate_response_dto_output_skipped_inner.g.dart';

/// TripScheduleGenerateResponseDtoOutputSkippedInner
///
/// Properties:
/// * [serviceDate] 
/// * [reason] 
@BuiltValue()
abstract class TripScheduleGenerateResponseDtoOutputSkippedInner implements Built<TripScheduleGenerateResponseDtoOutputSkippedInner, TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder> {
  @BuiltValueField(wireName: r'serviceDate')
  Date get serviceDate;

  @BuiltValueField(wireName: r'reason')
  TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum get reason;
  // enum reasonEnum {  EXISTS,  PAST,  VEHICLE_CONFLICT,  };

  TripScheduleGenerateResponseDtoOutputSkippedInner._();

  factory TripScheduleGenerateResponseDtoOutputSkippedInner([void updates(TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder b)]) = _$TripScheduleGenerateResponseDtoOutputSkippedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleGenerateResponseDtoOutputSkippedInner> get serializer => _$TripScheduleGenerateResponseDtoOutputSkippedInnerSerializer();
}

class _$TripScheduleGenerateResponseDtoOutputSkippedInnerSerializer implements PrimitiveSerializer<TripScheduleGenerateResponseDtoOutputSkippedInner> {
  @override
  final Iterable<Type> types = const [TripScheduleGenerateResponseDtoOutputSkippedInner, _$TripScheduleGenerateResponseDtoOutputSkippedInner];

  @override
  final String wireName = r'TripScheduleGenerateResponseDtoOutputSkippedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutputSkippedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'serviceDate';
    yield serializers.serialize(
      object.serviceDate,
      specifiedType: const FullType(Date),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutputSkippedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'serviceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.serviceDate = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum),
          ) as TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripScheduleGenerateResponseDtoOutputSkippedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder();
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


class TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXISTS')
  static const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum EXISTS = _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_EXISTS;
  @BuiltValueEnumConst(wireName: r'PAST')
  static const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum PAST = _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_PAST;
  @BuiltValueEnumConst(wireName: r'VEHICLE_CONFLICT')
  static const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum VEHICLE_CONFLICT = _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_VEHICLE_CONFLICT;

  static Serializer<TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum> get serializer => _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumSerializer;

  const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum._(String name): super(name);

  static BuiltSet<TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum> get values => _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumValues;
  static TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum valueOf(String name) => _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumValueOf(name);
}

