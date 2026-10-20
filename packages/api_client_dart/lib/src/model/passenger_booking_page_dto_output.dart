//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_booking_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_booking_page_dto_output.g.dart';

/// PassengerBookingPageDtoOutput
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PassengerBookingPageDtoOutput
    implements
        Built<PassengerBookingPageDtoOutput,
            PassengerBookingPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PassengerBookingPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  PassengerBookingPageDtoOutput._();

  factory PassengerBookingPageDtoOutput(
          [void updates(PassengerBookingPageDtoOutputBuilder b)]) =
      _$PassengerBookingPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerBookingPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerBookingPageDtoOutput> get serializer =>
      _$PassengerBookingPageDtoOutputSerializer();
}

class _$PassengerBookingPageDtoOutputSerializer
    implements PrimitiveSerializer<PassengerBookingPageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PassengerBookingPageDtoOutput,
    _$PassengerBookingPageDtoOutput
  ];

  @override
  final String wireName = r'PassengerBookingPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(PassengerBookingPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null
        ? null
        : serializers.serialize(
            object.nextCursor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerBookingPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(PassengerBookingPageDtoOutputItemsInner)]),
          ) as BuiltList<PassengerBookingPageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerBookingPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerBookingPageDtoOutputBuilder();
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
