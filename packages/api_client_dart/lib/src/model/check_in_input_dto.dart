//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_input_dto.g.dart';

/// CheckInInputDto
///
/// Properties:
/// * [tripId] 
/// * [code] 
/// * [status] 
@BuiltValue()
abstract class CheckInInputDto implements Built<CheckInInputDto, CheckInInputDtoBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'status')
  CheckInInputDtoStatusEnum get status;
  // enum statusEnum {  CHECKED_IN,  NO_SHOW,  };

  CheckInInputDto._();

  factory CheckInInputDto([void updates(CheckInInputDtoBuilder b)]) = _$CheckInInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckInInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckInInputDto> get serializer => _$CheckInInputDtoSerializer();
}

class _$CheckInInputDtoSerializer implements PrimitiveSerializer<CheckInInputDto> {
  @override
  final Iterable<Type> types = const [CheckInInputDto, _$CheckInInputDto];

  @override
  final String wireName = r'CheckInInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckInInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CheckInInputDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckInInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckInInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckInInputDtoStatusEnum),
          ) as CheckInInputDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckInInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckInInputDtoBuilder();
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


class CheckInInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const CheckInInputDtoStatusEnum CHECKED_IN = _$checkInInputDtoStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const CheckInInputDtoStatusEnum NO_SHOW = _$checkInInputDtoStatusEnum_NO_SHOW;

  static Serializer<CheckInInputDtoStatusEnum> get serializer => _$checkInInputDtoStatusEnumSerializer;

  const CheckInInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<CheckInInputDtoStatusEnum> get values => _$checkInInputDtoStatusEnumValues;
  static CheckInInputDtoStatusEnum valueOf(String name) => _$checkInInputDtoStatusEnumValueOf(name);
}

