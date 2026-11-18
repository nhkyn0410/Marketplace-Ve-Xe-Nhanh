//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_reviews_dto_output_pending_items_inner.g.dart';

/// PassengerReviewsDtoOutputPendingItemsInner
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [routeName] 
/// * [vehicleTypeName] 
/// * [departureAt] 
@BuiltValue()
abstract class PassengerReviewsDtoOutputPendingItemsInner implements Built<PassengerReviewsDtoOutputPendingItemsInner, PassengerReviewsDtoOutputPendingItemsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'vehicleTypeName')
  String? get vehicleTypeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  PassengerReviewsDtoOutputPendingItemsInner._();

  factory PassengerReviewsDtoOutputPendingItemsInner([void updates(PassengerReviewsDtoOutputPendingItemsInnerBuilder b)]) = _$PassengerReviewsDtoOutputPendingItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerReviewsDtoOutputPendingItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerReviewsDtoOutputPendingItemsInner> get serializer => _$PassengerReviewsDtoOutputPendingItemsInnerSerializer();
}

class _$PassengerReviewsDtoOutputPendingItemsInnerSerializer implements PrimitiveSerializer<PassengerReviewsDtoOutputPendingItemsInner> {
  @override
  final Iterable<Type> types = const [PassengerReviewsDtoOutputPendingItemsInner, _$PassengerReviewsDtoOutputPendingItemsInner];

  @override
  final String wireName = r'PassengerReviewsDtoOutputPendingItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerReviewsDtoOutputPendingItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'vehicleTypeName';
    yield object.vehicleTypeName == null ? null : serializers.serialize(
      object.vehicleTypeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerReviewsDtoOutputPendingItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerReviewsDtoOutputPendingItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'vehicleTypeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleTypeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerReviewsDtoOutputPendingItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerReviewsDtoOutputPendingItemsInnerBuilder();
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


