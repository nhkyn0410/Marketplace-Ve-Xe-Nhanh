//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/passenger_ticket_page_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_ticket_page_dto_output.g.dart';

/// PassengerTicketPageDtoOutput
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PassengerTicketPageDtoOutput
    implements
        Built<PassengerTicketPageDtoOutput,
            PassengerTicketPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PassengerTicketPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  PassengerTicketPageDtoOutput._();

  factory PassengerTicketPageDtoOutput(
          [void updates(PassengerTicketPageDtoOutputBuilder b)]) =
      _$PassengerTicketPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerTicketPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerTicketPageDtoOutput> get serializer =>
      _$PassengerTicketPageDtoOutputSerializer();
}

class _$PassengerTicketPageDtoOutputSerializer
    implements PrimitiveSerializer<PassengerTicketPageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PassengerTicketPageDtoOutput,
    _$PassengerTicketPageDtoOutput
  ];

  @override
  final String wireName = r'PassengerTicketPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerTicketPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(PassengerTicketPageDtoOutputItemsInner)]),
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
    PassengerTicketPageDtoOutput object, {
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
    required PassengerTicketPageDtoOutputBuilder result,
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
                BuiltList, [FullType(PassengerTicketPageDtoOutputItemsInner)]),
          ) as BuiltList<PassengerTicketPageDtoOutputItemsInner>;
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
  PassengerTicketPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerTicketPageDtoOutputBuilder();
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
