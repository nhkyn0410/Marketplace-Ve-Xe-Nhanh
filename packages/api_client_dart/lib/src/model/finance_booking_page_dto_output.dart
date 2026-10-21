//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/finance_booking_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_booking_page_dto_output.g.dart';

/// FinanceBookingPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class FinanceBookingPageDtoOutput implements Built<FinanceBookingPageDtoOutput, FinanceBookingPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<FinanceBookingPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  FinanceBookingPageDtoOutput._();

  factory FinanceBookingPageDtoOutput([void updates(FinanceBookingPageDtoOutputBuilder b)]) = _$FinanceBookingPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceBookingPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceBookingPageDtoOutput> get serializer => _$FinanceBookingPageDtoOutputSerializer();
}

class _$FinanceBookingPageDtoOutputSerializer implements PrimitiveSerializer<FinanceBookingPageDtoOutput> {
  @override
  final Iterable<Type> types = const [FinanceBookingPageDtoOutput, _$FinanceBookingPageDtoOutput];

  @override
  final String wireName = r'FinanceBookingPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(FinanceBookingPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceBookingPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinanceBookingPageDtoOutputItemsInner)]),
          ) as BuiltList<FinanceBookingPageDtoOutputItemsInner>;
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
  FinanceBookingPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceBookingPageDtoOutputBuilder();
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


