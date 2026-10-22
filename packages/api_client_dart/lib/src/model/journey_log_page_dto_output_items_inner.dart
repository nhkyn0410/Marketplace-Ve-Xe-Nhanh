//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_log_page_dto_output_items_inner.g.dart';

/// JourneyLogPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [operatorId] 
/// * [tripId] 
/// * [employeeId] 
/// * [stopSequence] 
/// * [actualAt] 
/// * [createdAt] 
/// * [vehicleStatus] 
/// * [note] 
/// * [delayMinutes] 
@BuiltValue()
abstract class JourneyLogPageDtoOutputItemsInner implements Built<JourneyLogPageDtoOutputItemsInner, JourneyLogPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'stopSequence')
  int? get stopSequence;

  @BuiltValueField(wireName: r'actualAt')
  DateTime get actualAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'vehicleStatus')
  String? get vehicleStatus;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'delayMinutes')
  int get delayMinutes;

  JourneyLogPageDtoOutputItemsInner._();

  factory JourneyLogPageDtoOutputItemsInner([void updates(JourneyLogPageDtoOutputItemsInnerBuilder b)]) = _$JourneyLogPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyLogPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyLogPageDtoOutputItemsInner> get serializer => _$JourneyLogPageDtoOutputItemsInnerSerializer();
}

class _$JourneyLogPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<JourneyLogPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [JourneyLogPageDtoOutputItemsInner, _$JourneyLogPageDtoOutputItemsInner];

  @override
  final String wireName = r'JourneyLogPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyLogPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'stopSequence';
    yield object.stopSequence == null ? null : serializers.serialize(
      object.stopSequence,
      specifiedType: const FullType.nullable(int),
    );
    yield r'actualAt';
    yield serializers.serialize(
      object.actualAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'vehicleStatus';
    yield object.vehicleStatus == null ? null : serializers.serialize(
      object.vehicleStatus,
      specifiedType: const FullType.nullable(String),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'delayMinutes';
    yield serializers.serialize(
      object.delayMinutes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JourneyLogPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyLogPageDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'stopSequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.stopSequence = valueDes;
          break;
        case r'actualAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.actualAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'vehicleStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleStatus = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'delayMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.delayMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JourneyLogPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyLogPageDtoOutputItemsInnerBuilder();
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


