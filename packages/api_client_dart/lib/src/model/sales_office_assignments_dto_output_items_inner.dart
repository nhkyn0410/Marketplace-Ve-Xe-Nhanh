//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sales_office_assignments_dto_output_items_inner.g.dart';

/// SalesOfficeAssignmentsDtoOutputItemsInner
///
/// Properties:
/// * [employeeId] 
/// * [username] 
/// * [status] 
@BuiltValue()
abstract class SalesOfficeAssignmentsDtoOutputItemsInner implements Built<SalesOfficeAssignmentsDtoOutputItemsInner, SalesOfficeAssignmentsDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'status')
  SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  SalesOfficeAssignmentsDtoOutputItemsInner._();

  factory SalesOfficeAssignmentsDtoOutputItemsInner([void updates(SalesOfficeAssignmentsDtoOutputItemsInnerBuilder b)]) = _$SalesOfficeAssignmentsDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalesOfficeAssignmentsDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalesOfficeAssignmentsDtoOutputItemsInner> get serializer => _$SalesOfficeAssignmentsDtoOutputItemsInnerSerializer();
}

class _$SalesOfficeAssignmentsDtoOutputItemsInnerSerializer implements PrimitiveSerializer<SalesOfficeAssignmentsDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [SalesOfficeAssignmentsDtoOutputItemsInner, _$SalesOfficeAssignmentsDtoOutputItemsInner];

  @override
  final String wireName = r'SalesOfficeAssignmentsDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalesOfficeAssignmentsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalesOfficeAssignmentsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalesOfficeAssignmentsDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum),
          ) as SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum;
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
  SalesOfficeAssignmentsDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalesOfficeAssignmentsDtoOutputItemsInnerBuilder();
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


class SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum ACTIVE = _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum LOCKED = _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum DISABLED = _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum> get serializer => _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumSerializer;

  const SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum> get values => _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumValues;
  static SalesOfficeAssignmentsDtoOutputItemsInnerStatusEnum valueOf(String name) => _$salesOfficeAssignmentsDtoOutputItemsInnerStatusEnumValueOf(name);
}

