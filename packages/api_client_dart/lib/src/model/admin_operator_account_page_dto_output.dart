//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_operator_account_page_dto_output_items_inner.dart';
import 'package:api_client_dart/src/model/admin_vehicle_image_list_dto_output_operators_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_account_page_dto_output.g.dart';

/// AdminOperatorAccountPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
/// * [operators] 
@BuiltValue()
abstract class AdminOperatorAccountPageDtoOutput implements Built<AdminOperatorAccountPageDtoOutput, AdminOperatorAccountPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminOperatorAccountPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'operators')
  BuiltList<AdminVehicleImageListDtoOutputOperatorsInner> get operators;

  AdminOperatorAccountPageDtoOutput._();

  factory AdminOperatorAccountPageDtoOutput([void updates(AdminOperatorAccountPageDtoOutputBuilder b)]) = _$AdminOperatorAccountPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorAccountPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorAccountPageDtoOutput> get serializer => _$AdminOperatorAccountPageDtoOutputSerializer();
}

class _$AdminOperatorAccountPageDtoOutputSerializer implements PrimitiveSerializer<AdminOperatorAccountPageDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOperatorAccountPageDtoOutput, _$AdminOperatorAccountPageDtoOutput];

  @override
  final String wireName = r'AdminOperatorAccountPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorAccountPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminOperatorAccountPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'operators';
    yield serializers.serialize(
      object.operators,
      specifiedType: const FullType(BuiltList, [FullType(AdminVehicleImageListDtoOutputOperatorsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorAccountPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorAccountPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOperatorAccountPageDtoOutputItemsInner)]),
          ) as BuiltList<AdminOperatorAccountPageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'operators':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminVehicleImageListDtoOutputOperatorsInner)]),
          ) as BuiltList<AdminVehicleImageListDtoOutputOperatorsInner>;
          result.operators.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorAccountPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorAccountPageDtoOutputBuilder();
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


