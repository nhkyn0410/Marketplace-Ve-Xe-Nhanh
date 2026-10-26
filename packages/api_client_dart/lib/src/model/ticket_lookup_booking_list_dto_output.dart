//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_lookup_booking_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_booking_list_dto_output.g.dart';

/// TicketLookupBookingListDtoOutput
///
/// Properties:
/// * [maskedEmail] 
/// * [scope] 
/// * [hasAccount] 
/// * [items] 
@BuiltValue()
abstract class TicketLookupBookingListDtoOutput implements Built<TicketLookupBookingListDtoOutput, TicketLookupBookingListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'maskedEmail')
  String get maskedEmail;

  @BuiltValueField(wireName: r'scope')
  TicketLookupBookingListDtoOutputScopeEnum get scope;
  // enum scopeEnum {  BOOKING,  EMAIL,  };

  @BuiltValueField(wireName: r'hasAccount')
  bool get hasAccount;

  @BuiltValueField(wireName: r'items')
  BuiltList<TicketLookupBookingListDtoOutputItemsInner> get items;

  TicketLookupBookingListDtoOutput._();

  factory TicketLookupBookingListDtoOutput([void updates(TicketLookupBookingListDtoOutputBuilder b)]) = _$TicketLookupBookingListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupBookingListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupBookingListDtoOutput> get serializer => _$TicketLookupBookingListDtoOutputSerializer();
}

class _$TicketLookupBookingListDtoOutputSerializer implements PrimitiveSerializer<TicketLookupBookingListDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketLookupBookingListDtoOutput, _$TicketLookupBookingListDtoOutput];

  @override
  final String wireName = r'TicketLookupBookingListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupBookingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'maskedEmail';
    yield serializers.serialize(
      object.maskedEmail,
      specifiedType: const FullType(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(TicketLookupBookingListDtoOutputScopeEnum),
    );
    yield r'hasAccount';
    yield serializers.serialize(
      object.hasAccount,
      specifiedType: const FullType(bool),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TicketLookupBookingListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketLookupBookingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupBookingListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maskedEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maskedEmail = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketLookupBookingListDtoOutputScopeEnum),
          ) as TicketLookupBookingListDtoOutputScopeEnum;
          result.scope = valueDes;
          break;
        case r'hasAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasAccount = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TicketLookupBookingListDtoOutputItemsInner)]),
          ) as BuiltList<TicketLookupBookingListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketLookupBookingListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupBookingListDtoOutputBuilder();
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


class TicketLookupBookingListDtoOutputScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const TicketLookupBookingListDtoOutputScopeEnum BOOKING = _$ticketLookupBookingListDtoOutputScopeEnum_BOOKING;
  @BuiltValueEnumConst(wireName: r'EMAIL')
  static const TicketLookupBookingListDtoOutputScopeEnum EMAIL = _$ticketLookupBookingListDtoOutputScopeEnum_EMAIL;

  static Serializer<TicketLookupBookingListDtoOutputScopeEnum> get serializer => _$ticketLookupBookingListDtoOutputScopeEnumSerializer;

  const TicketLookupBookingListDtoOutputScopeEnum._(String name): super(name);

  static BuiltSet<TicketLookupBookingListDtoOutputScopeEnum> get values => _$ticketLookupBookingListDtoOutputScopeEnumValues;
  static TicketLookupBookingListDtoOutputScopeEnum valueOf(String name) => _$ticketLookupBookingListDtoOutputScopeEnumValueOf(name);
}

