//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_page_dto_output.g.dart';

/// OperatorBookingPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class OperatorBookingPageDtoOutput implements Built<OperatorBookingPageDtoOutput, OperatorBookingPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<OperatorBookingPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  OperatorBookingPageDtoOutput._();

  factory OperatorBookingPageDtoOutput([void updates(OperatorBookingPageDtoOutputBuilder b)]) = _$OperatorBookingPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingPageDtoOutput> get serializer => _$OperatorBookingPageDtoOutputSerializer();
}

class _$OperatorBookingPageDtoOutputSerializer implements PrimitiveSerializer<OperatorBookingPageDtoOutput> {
  @override
  final Iterable<Type> types = const [OperatorBookingPageDtoOutput, _$OperatorBookingPageDtoOutput];

  @override
  final String wireName = r'OperatorBookingPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(OperatorBookingPageDtoOutputItemsInner)]),
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
    OperatorBookingPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorBookingPageDtoOutputItemsInner)]),
          ) as BuiltList<OperatorBookingPageDtoOutputItemsInner>;
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
  OperatorBookingPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingPageDtoOutputBuilder();
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


