//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sales_office_assignments_input_dto.g.dart';

/// SalesOfficeAssignmentsInputDto
///
/// Properties:
/// * [version] 
/// * [employeeIds] 
@BuiltValue()
abstract class SalesOfficeAssignmentsInputDto implements Built<SalesOfficeAssignmentsInputDto, SalesOfficeAssignmentsInputDtoBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'employeeIds')
  BuiltList<String> get employeeIds;

  SalesOfficeAssignmentsInputDto._();

  factory SalesOfficeAssignmentsInputDto([void updates(SalesOfficeAssignmentsInputDtoBuilder b)]) = _$SalesOfficeAssignmentsInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalesOfficeAssignmentsInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalesOfficeAssignmentsInputDto> get serializer => _$SalesOfficeAssignmentsInputDtoSerializer();
}

class _$SalesOfficeAssignmentsInputDtoSerializer implements PrimitiveSerializer<SalesOfficeAssignmentsInputDto> {
  @override
  final Iterable<Type> types = const [SalesOfficeAssignmentsInputDto, _$SalesOfficeAssignmentsInputDto];

  @override
  final String wireName = r'SalesOfficeAssignmentsInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalesOfficeAssignmentsInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'employeeIds';
    yield serializers.serialize(
      object.employeeIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalesOfficeAssignmentsInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalesOfficeAssignmentsInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'employeeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.employeeIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalesOfficeAssignmentsInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalesOfficeAssignmentsInputDtoBuilder();
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


