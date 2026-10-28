//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_detail_dto_output_seat_summary.g.dart';

/// AdminTripDetailDtoOutputSeatSummary
///
/// Properties:
/// * [available] 
/// * [holding] 
/// * [booked] 
/// * [checkedIn] 
/// * [blocked] 
@BuiltValue()
abstract class AdminTripDetailDtoOutputSeatSummary implements Built<AdminTripDetailDtoOutputSeatSummary, AdminTripDetailDtoOutputSeatSummaryBuilder> {
  @BuiltValueField(wireName: r'available')
  int get available;

  @BuiltValueField(wireName: r'holding')
  int get holding;

  @BuiltValueField(wireName: r'booked')
  int get booked;

  @BuiltValueField(wireName: r'checkedIn')
  int get checkedIn;

  @BuiltValueField(wireName: r'blocked')
  int get blocked;

  AdminTripDetailDtoOutputSeatSummary._();

  factory AdminTripDetailDtoOutputSeatSummary([void updates(AdminTripDetailDtoOutputSeatSummaryBuilder b)]) = _$AdminTripDetailDtoOutputSeatSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripDetailDtoOutputSeatSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripDetailDtoOutputSeatSummary> get serializer => _$AdminTripDetailDtoOutputSeatSummarySerializer();
}

class _$AdminTripDetailDtoOutputSeatSummarySerializer implements PrimitiveSerializer<AdminTripDetailDtoOutputSeatSummary> {
  @override
  final Iterable<Type> types = const [AdminTripDetailDtoOutputSeatSummary, _$AdminTripDetailDtoOutputSeatSummary];

  @override
  final String wireName = r'AdminTripDetailDtoOutputSeatSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripDetailDtoOutputSeatSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(int),
    );
    yield r'holding';
    yield serializers.serialize(
      object.holding,
      specifiedType: const FullType(int),
    );
    yield r'booked';
    yield serializers.serialize(
      object.booked,
      specifiedType: const FullType(int),
    );
    yield r'checkedIn';
    yield serializers.serialize(
      object.checkedIn,
      specifiedType: const FullType(int),
    );
    yield r'blocked';
    yield serializers.serialize(
      object.blocked,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripDetailDtoOutputSeatSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripDetailDtoOutputSeatSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.available = valueDes;
          break;
        case r'holding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.holding = valueDes;
          break;
        case r'booked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.booked = valueDes;
          break;
        case r'checkedIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checkedIn = valueDes;
          break;
        case r'blocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.blocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripDetailDtoOutputSeatSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripDetailDtoOutputSeatSummaryBuilder();
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


