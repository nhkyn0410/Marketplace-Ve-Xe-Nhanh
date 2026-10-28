//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_passenger_booking_page_dto_output_items_inner_passengers_inner.g.dart';

/// AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner
///
/// Properties:
/// * [fullName] 
/// * [seatCode] 
/// * [ticketStatus] 
@BuiltValue()
abstract class AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner implements Built<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner, AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'ticketStatus')
  String? get ticketStatus;

  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner._();

  factory AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner([void updates(AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder b)]) = _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner> get serializer => _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerSerializer();
}

class _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerSerializer implements PrimitiveSerializer<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner> {
  @override
  final Iterable<Type> types = const [AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner, _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner];

  @override
  final String wireName = r'AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'ticketStatus';
    yield object.ticketStatus == null ? null : serializers.serialize(
      object.ticketStatus,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'ticketStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ticketStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder();
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


