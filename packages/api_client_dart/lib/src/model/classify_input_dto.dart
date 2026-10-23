//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classify_input_dto.g.dart';

/// ClassifyInputDto
///
/// Properties:
/// * [category] 
/// * [priority] 
/// * [handler] 
/// * [assigneeId] 
@BuiltValue()
abstract class ClassifyInputDto implements Built<ClassifyInputDto, ClassifyInputDtoBuilder> {
  @BuiltValueField(wireName: r'category')
  ClassifyInputDtoCategoryEnum get category;
  // enum categoryEnum {  PAYMENT_REFUND,  SCHEDULE,  SERVICE_QUALITY,  TICKET_CHANGE,  OTHER,  };

  @BuiltValueField(wireName: r'priority')
  ClassifyInputDtoPriorityEnum get priority;
  // enum priorityEnum {  LOW,  MEDIUM,  HIGH,  URGENT,  };

  @BuiltValueField(wireName: r'handler')
  ClassifyInputDtoHandlerEnum get handler;
  // enum handlerEnum {  PLATFORM,  OPERATOR,  };

  @BuiltValueField(wireName: r'assigneeId')
  String? get assigneeId;

  ClassifyInputDto._();

  factory ClassifyInputDto([void updates(ClassifyInputDtoBuilder b)]) = _$ClassifyInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClassifyInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClassifyInputDto> get serializer => _$ClassifyInputDtoSerializer();
}

class _$ClassifyInputDtoSerializer implements PrimitiveSerializer<ClassifyInputDto> {
  @override
  final Iterable<Type> types = const [ClassifyInputDto, _$ClassifyInputDto];

  @override
  final String wireName = r'ClassifyInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClassifyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(ClassifyInputDtoCategoryEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(ClassifyInputDtoPriorityEnum),
    );
    yield r'handler';
    yield serializers.serialize(
      object.handler,
      specifiedType: const FullType(ClassifyInputDtoHandlerEnum),
    );
    yield r'assigneeId';
    yield object.assigneeId == null ? null : serializers.serialize(
      object.assigneeId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClassifyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClassifyInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClassifyInputDtoCategoryEnum),
          ) as ClassifyInputDtoCategoryEnum;
          result.category = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClassifyInputDtoPriorityEnum),
          ) as ClassifyInputDtoPriorityEnum;
          result.priority = valueDes;
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClassifyInputDtoHandlerEnum),
          ) as ClassifyInputDtoHandlerEnum;
          result.handler = valueDes;
          break;
        case r'assigneeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assigneeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClassifyInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClassifyInputDtoBuilder();
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


class ClassifyInputDtoCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAYMENT_REFUND')
  static const ClassifyInputDtoCategoryEnum PAYMENT_REFUND = _$classifyInputDtoCategoryEnum_PAYMENT_REFUND;
  @BuiltValueEnumConst(wireName: r'SCHEDULE')
  static const ClassifyInputDtoCategoryEnum SCHEDULE = _$classifyInputDtoCategoryEnum_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'SERVICE_QUALITY')
  static const ClassifyInputDtoCategoryEnum SERVICE_QUALITY = _$classifyInputDtoCategoryEnum_SERVICE_QUALITY;
  @BuiltValueEnumConst(wireName: r'TICKET_CHANGE')
  static const ClassifyInputDtoCategoryEnum TICKET_CHANGE = _$classifyInputDtoCategoryEnum_TICKET_CHANGE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ClassifyInputDtoCategoryEnum OTHER = _$classifyInputDtoCategoryEnum_OTHER;

  static Serializer<ClassifyInputDtoCategoryEnum> get serializer => _$classifyInputDtoCategoryEnumSerializer;

  const ClassifyInputDtoCategoryEnum._(String name): super(name);

  static BuiltSet<ClassifyInputDtoCategoryEnum> get values => _$classifyInputDtoCategoryEnumValues;
  static ClassifyInputDtoCategoryEnum valueOf(String name) => _$classifyInputDtoCategoryEnumValueOf(name);
}

class ClassifyInputDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOW')
  static const ClassifyInputDtoPriorityEnum LOW = _$classifyInputDtoPriorityEnum_LOW;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const ClassifyInputDtoPriorityEnum MEDIUM = _$classifyInputDtoPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'HIGH')
  static const ClassifyInputDtoPriorityEnum HIGH = _$classifyInputDtoPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'URGENT')
  static const ClassifyInputDtoPriorityEnum URGENT = _$classifyInputDtoPriorityEnum_URGENT;

  static Serializer<ClassifyInputDtoPriorityEnum> get serializer => _$classifyInputDtoPriorityEnumSerializer;

  const ClassifyInputDtoPriorityEnum._(String name): super(name);

  static BuiltSet<ClassifyInputDtoPriorityEnum> get values => _$classifyInputDtoPriorityEnumValues;
  static ClassifyInputDtoPriorityEnum valueOf(String name) => _$classifyInputDtoPriorityEnumValueOf(name);
}

class ClassifyInputDtoHandlerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const ClassifyInputDtoHandlerEnum PLATFORM = _$classifyInputDtoHandlerEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const ClassifyInputDtoHandlerEnum OPERATOR = _$classifyInputDtoHandlerEnum_OPERATOR;

  static Serializer<ClassifyInputDtoHandlerEnum> get serializer => _$classifyInputDtoHandlerEnumSerializer;

  const ClassifyInputDtoHandlerEnum._(String name): super(name);

  static BuiltSet<ClassifyInputDtoHandlerEnum> get values => _$classifyInputDtoHandlerEnumValues;
  static ClassifyInputDtoHandlerEnum valueOf(String name) => _$classifyInputDtoHandlerEnumValueOf(name);
}

