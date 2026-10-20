//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_dispute_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_dispute_page_dto_output.g.dart';

/// PassengerDisputePageDtoOutput
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PassengerDisputePageDtoOutput
    implements
        Built<PassengerDisputePageDtoOutput,
            PassengerDisputePageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PassengerDisputePageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  PassengerDisputePageDtoOutput._();

  factory PassengerDisputePageDtoOutput(
          [void updates(PassengerDisputePageDtoOutputBuilder b)]) =
      _$PassengerDisputePageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerDisputePageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerDisputePageDtoOutput> get serializer =>
      _$PassengerDisputePageDtoOutputSerializer();
}

class _$PassengerDisputePageDtoOutputSerializer
    implements PrimitiveSerializer<PassengerDisputePageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PassengerDisputePageDtoOutput,
    _$PassengerDisputePageDtoOutput
  ];

  @override
  final String wireName = r'PassengerDisputePageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerDisputePageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(PassengerDisputePageDtoOutputItemsInner)]),
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
    PassengerDisputePageDtoOutput object, {
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
    required PassengerDisputePageDtoOutputBuilder result,
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
                BuiltList, [FullType(PassengerDisputePageDtoOutputItemsInner)]),
          ) as BuiltList<PassengerDisputePageDtoOutputItemsInner>;
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
  PassengerDisputePageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerDisputePageDtoOutputBuilder();
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
