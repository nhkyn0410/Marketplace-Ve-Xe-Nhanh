//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_assignment_page_dto_output_items_inner_driver.g.dart';

/// TripAssignmentPageDtoOutputItemsInnerDriver
///
/// Properties:
/// * [employeeId] 
/// * [username] 
/// * [status] 
@BuiltValue()
abstract class TripAssignmentPageDtoOutputItemsInnerDriver implements Built<TripAssignmentPageDtoOutputItemsInnerDriver, TripAssignmentPageDtoOutputItemsInnerDriverBuilder> {
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'status')
  TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  TripAssignmentPageDtoOutputItemsInnerDriver._();

  factory TripAssignmentPageDtoOutputItemsInnerDriver([void updates(TripAssignmentPageDtoOutputItemsInnerDriverBuilder b)]) = _$TripAssignmentPageDtoOutputItemsInnerDriver;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripAssignmentPageDtoOutputItemsInnerDriverBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripAssignmentPageDtoOutputItemsInnerDriver> get serializer => _$TripAssignmentPageDtoOutputItemsInnerDriverSerializer();
}

class _$TripAssignmentPageDtoOutputItemsInnerDriverSerializer implements PrimitiveSerializer<TripAssignmentPageDtoOutputItemsInnerDriver> {
  @override
  final Iterable<Type> types = const [TripAssignmentPageDtoOutputItemsInnerDriver, _$TripAssignmentPageDtoOutputItemsInnerDriver];

  @override
  final String wireName = r'TripAssignmentPageDtoOutputItemsInnerDriver';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInnerDriver object, {
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
      specifiedType: const FullType(TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripAssignmentPageDtoOutputItemsInnerDriver object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripAssignmentPageDtoOutputItemsInnerDriverBuilder result,
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
            specifiedType: const FullType(TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum),
          ) as TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum;
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
  TripAssignmentPageDtoOutputItemsInnerDriver deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripAssignmentPageDtoOutputItemsInnerDriverBuilder();
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


class TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum ACTIVE = _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum LOCKED = _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum DISABLED = _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnum_DISABLED;

  static Serializer<TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum> get serializer => _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumSerializer;

  const TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum._(String name): super(name);

  static BuiltSet<TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum> get values => _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumValues;
  static TripAssignmentPageDtoOutputItemsInnerDriverStatusEnum valueOf(String name) => _$tripAssignmentPageDtoOutputItemsInnerDriverStatusEnumValueOf(name);
}

