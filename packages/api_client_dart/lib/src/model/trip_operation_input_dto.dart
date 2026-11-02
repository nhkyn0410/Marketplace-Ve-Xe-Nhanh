//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_operation_input_dto.g.dart';

/// TripOperationInputDto
///
/// Properties:
/// * [status] 
/// * [note] 
@BuiltValue()
abstract class TripOperationInputDto implements Built<TripOperationInputDto, TripOperationInputDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  TripOperationInputDtoStatusEnum get status;
  // enum statusEnum {  BOARDING,  DEPARTED,  IN_PROGRESS,  COMPLETED,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  TripOperationInputDto._();

  factory TripOperationInputDto([void updates(TripOperationInputDtoBuilder b)]) = _$TripOperationInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripOperationInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripOperationInputDto> get serializer => _$TripOperationInputDtoSerializer();
}

class _$TripOperationInputDtoSerializer implements PrimitiveSerializer<TripOperationInputDto> {
  @override
  final Iterable<Type> types = const [TripOperationInputDto, _$TripOperationInputDto];

  @override
  final String wireName = r'TripOperationInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripOperationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TripOperationInputDtoStatusEnum),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripOperationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripOperationInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripOperationInputDtoStatusEnum),
          ) as TripOperationInputDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripOperationInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripOperationInputDtoBuilder();
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


class TripOperationInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOARDING')
  static const TripOperationInputDtoStatusEnum BOARDING = _$tripOperationInputDtoStatusEnum_BOARDING;
  @BuiltValueEnumConst(wireName: r'DEPARTED')
  static const TripOperationInputDtoStatusEnum DEPARTED = _$tripOperationInputDtoStatusEnum_DEPARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TripOperationInputDtoStatusEnum IN_PROGRESS = _$tripOperationInputDtoStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const TripOperationInputDtoStatusEnum COMPLETED = _$tripOperationInputDtoStatusEnum_COMPLETED;

  static Serializer<TripOperationInputDtoStatusEnum> get serializer => _$tripOperationInputDtoStatusEnumSerializer;

  const TripOperationInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<TripOperationInputDtoStatusEnum> get values => _$tripOperationInputDtoStatusEnumValues;
  static TripOperationInputDtoStatusEnum valueOf(String name) => _$tripOperationInputDtoStatusEnumValueOf(name);
}

