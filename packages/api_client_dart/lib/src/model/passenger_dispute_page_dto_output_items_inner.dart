//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_dispute_page_dto_output_items_inner.g.dart';

/// PassengerDisputePageDtoOutputItemsInner
///
/// Properties:
/// * [disputeId]
/// * [disputeCode]
/// * [bookingId]
/// * [bookingCode]
/// * [title]
/// * [status]
/// * [responseDueAt]
/// * [updatedAt]
@BuiltValue()
abstract class PassengerDisputePageDtoOutputItemsInner
    implements
        Built<PassengerDisputePageDtoOutputItemsInner,
            PassengerDisputePageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'disputeId')
  String get disputeId;

  @BuiltValueField(wireName: r'disputeCode')
  String get disputeCode;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'responseDueAt')
  DateTime? get responseDueAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  PassengerDisputePageDtoOutputItemsInner._();

  factory PassengerDisputePageDtoOutputItemsInner(
          [void updates(PassengerDisputePageDtoOutputItemsInnerBuilder b)]) =
      _$PassengerDisputePageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerDisputePageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerDisputePageDtoOutputItemsInner> get serializer =>
      _$PassengerDisputePageDtoOutputItemsInnerSerializer();
}

class _$PassengerDisputePageDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<PassengerDisputePageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    PassengerDisputePageDtoOutputItemsInner,
    _$PassengerDisputePageDtoOutputItemsInner
  ];

  @override
  final String wireName = r'PassengerDisputePageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerDisputePageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'disputeId';
    yield serializers.serialize(
      object.disputeId,
      specifiedType: const FullType(String),
    );
    yield r'disputeCode';
    yield serializers.serialize(
      object.disputeCode,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'responseDueAt';
    yield object.responseDueAt == null
        ? null
        : serializers.serialize(
            object.responseDueAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerDisputePageDtoOutputItemsInner object, {
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
    required PassengerDisputePageDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'disputeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disputeId = valueDes;
          break;
        case r'disputeCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disputeCode = valueDes;
          break;
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'responseDueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerDisputePageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerDisputePageDtoOutputItemsInnerBuilder();
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
