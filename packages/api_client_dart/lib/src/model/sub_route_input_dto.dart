//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/sub_route_input_dto_from.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_route_input_dto.g.dart';

/// SubRouteInputDto
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [name] 
/// * [nameSource] 
/// * [status] 
/// * [note] 
@BuiltValue()
abstract class SubRouteInputDto implements Built<SubRouteInputDto, SubRouteInputDtoBuilder> {
  @BuiltValueField(wireName: r'from')
  SubRouteInputDtoFrom get from;

  @BuiltValueField(wireName: r'to')
  SubRouteInputDtoFrom get to;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameSource')
  SubRouteInputDtoNameSourceEnum get nameSource;
  // enum nameSourceEnum {  AUTO,  MANUAL,  };

  @BuiltValueField(wireName: r'status')
  SubRouteInputDtoStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  DRAFT,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  SubRouteInputDto._();

  factory SubRouteInputDto([void updates(SubRouteInputDtoBuilder b)]) = _$SubRouteInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubRouteInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubRouteInputDto> get serializer => _$SubRouteInputDtoSerializer();
}

class _$SubRouteInputDtoSerializer implements PrimitiveSerializer<SubRouteInputDto> {
  @override
  final Iterable<Type> types = const [SubRouteInputDto, _$SubRouteInputDto];

  @override
  final String wireName = r'SubRouteInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubRouteInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(SubRouteInputDtoFrom),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(SubRouteInputDtoFrom),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'nameSource';
    yield serializers.serialize(
      object.nameSource,
      specifiedType: const FullType(SubRouteInputDtoNameSourceEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SubRouteInputDtoStatusEnum),
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
    SubRouteInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubRouteInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRouteInputDtoFrom),
          ) as SubRouteInputDtoFrom;
          result.from.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRouteInputDtoFrom),
          ) as SubRouteInputDtoFrom;
          result.to.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'nameSource':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRouteInputDtoNameSourceEnum),
          ) as SubRouteInputDtoNameSourceEnum;
          result.nameSource = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRouteInputDtoStatusEnum),
          ) as SubRouteInputDtoStatusEnum;
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
  SubRouteInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubRouteInputDtoBuilder();
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


class SubRouteInputDtoNameSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTO')
  static const SubRouteInputDtoNameSourceEnum AUTO = _$subRouteInputDtoNameSourceEnum_AUTO;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const SubRouteInputDtoNameSourceEnum MANUAL = _$subRouteInputDtoNameSourceEnum_MANUAL;

  static Serializer<SubRouteInputDtoNameSourceEnum> get serializer => _$subRouteInputDtoNameSourceEnumSerializer;

  const SubRouteInputDtoNameSourceEnum._(String name): super(name);

  static BuiltSet<SubRouteInputDtoNameSourceEnum> get values => _$subRouteInputDtoNameSourceEnumValues;
  static SubRouteInputDtoNameSourceEnum valueOf(String name) => _$subRouteInputDtoNameSourceEnumValueOf(name);
}

class SubRouteInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const SubRouteInputDtoStatusEnum ACTIVE = _$subRouteInputDtoStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const SubRouteInputDtoStatusEnum INACTIVE = _$subRouteInputDtoStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const SubRouteInputDtoStatusEnum DRAFT = _$subRouteInputDtoStatusEnum_DRAFT;

  static Serializer<SubRouteInputDtoStatusEnum> get serializer => _$subRouteInputDtoStatusEnumSerializer;

  const SubRouteInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<SubRouteInputDtoStatusEnum> get values => _$subRouteInputDtoStatusEnumValues;
  static SubRouteInputDtoStatusEnum valueOf(String name) => _$subRouteInputDtoStatusEnumValueOf(name);
}

