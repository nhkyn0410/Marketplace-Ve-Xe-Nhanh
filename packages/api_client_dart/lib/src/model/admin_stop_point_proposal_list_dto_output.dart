//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_stop_point_proposal_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_stop_point_proposal_list_dto_output.g.dart';

/// AdminStopPointProposalListDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
@BuiltValue()
abstract class AdminStopPointProposalListDtoOutput implements Built<AdminStopPointProposalListDtoOutput, AdminStopPointProposalListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminStopPointProposalListDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  AdminStopPointProposalListDtoOutput._();

  factory AdminStopPointProposalListDtoOutput([void updates(AdminStopPointProposalListDtoOutputBuilder b)]) = _$AdminStopPointProposalListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStopPointProposalListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStopPointProposalListDtoOutput> get serializer => _$AdminStopPointProposalListDtoOutputSerializer();
}

class _$AdminStopPointProposalListDtoOutputSerializer implements PrimitiveSerializer<AdminStopPointProposalListDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminStopPointProposalListDtoOutput, _$AdminStopPointProposalListDtoOutput];

  @override
  final String wireName = r'AdminStopPointProposalListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStopPointProposalListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminStopPointProposalListDtoOutputItemsInner)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStopPointProposalListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminStopPointProposalListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminStopPointProposalListDtoOutputItemsInner)]),
          ) as BuiltList<AdminStopPointProposalListDtoOutputItemsInner>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStopPointProposalListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStopPointProposalListDtoOutputBuilder();
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


