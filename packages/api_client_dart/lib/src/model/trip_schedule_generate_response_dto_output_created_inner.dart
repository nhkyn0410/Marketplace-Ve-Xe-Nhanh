//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_generate_response_dto_output_created_inner.g.dart';

/// TripScheduleGenerateResponseDtoOutputCreatedInner
///
/// Properties:
/// * [tripId] 
/// * [serviceDate] 
/// * [departureAt] 
/// * [status] 
/// * [notOpenedReasons] 
@BuiltValue()
abstract class TripScheduleGenerateResponseDtoOutputCreatedInner implements Built<TripScheduleGenerateResponseDtoOutputCreatedInner, TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'serviceDate')
  Date get serviceDate;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'status')
  TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum get status;
  // enum statusEnum {  DRAFT,  OPEN_FOR_SALE,  };

  @BuiltValueField(wireName: r'notOpenedReasons')
  BuiltList<String> get notOpenedReasons;

  TripScheduleGenerateResponseDtoOutputCreatedInner._();

  factory TripScheduleGenerateResponseDtoOutputCreatedInner([void updates(TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder b)]) = _$TripScheduleGenerateResponseDtoOutputCreatedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleGenerateResponseDtoOutputCreatedInner> get serializer => _$TripScheduleGenerateResponseDtoOutputCreatedInnerSerializer();
}

class _$TripScheduleGenerateResponseDtoOutputCreatedInnerSerializer implements PrimitiveSerializer<TripScheduleGenerateResponseDtoOutputCreatedInner> {
  @override
  final Iterable<Type> types = const [TripScheduleGenerateResponseDtoOutputCreatedInner, _$TripScheduleGenerateResponseDtoOutputCreatedInner];

  @override
  final String wireName = r'TripScheduleGenerateResponseDtoOutputCreatedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutputCreatedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'serviceDate';
    yield serializers.serialize(
      object.serviceDate,
      specifiedType: const FullType(Date),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum),
    );
    yield r'notOpenedReasons';
    yield serializers.serialize(
      object.notOpenedReasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleGenerateResponseDtoOutputCreatedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder result,
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
        case r'serviceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.serviceDate = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum),
          ) as TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'notOpenedReasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.notOpenedReasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripScheduleGenerateResponseDtoOutputCreatedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder();
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


class TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum DRAFT = _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'OPEN_FOR_SALE')
  static const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum OPEN_FOR_SALE = _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_OPEN_FOR_SALE;

  static Serializer<TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum> get serializer => _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumSerializer;

  const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum._(String name): super(name);

  static BuiltSet<TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum> get values => _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumValues;
  static TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum valueOf(String name) => _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumValueOf(name);
}

