//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/sales_office_list_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sales_office_list_dto_output.g.dart';

/// SalesOfficeListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class SalesOfficeListDtoOutput implements Built<SalesOfficeListDtoOutput, SalesOfficeListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SalesOfficeListDtoOutputItemsInner> get items;

  SalesOfficeListDtoOutput._();

  factory SalesOfficeListDtoOutput([void updates(SalesOfficeListDtoOutputBuilder b)]) = _$SalesOfficeListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalesOfficeListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalesOfficeListDtoOutput> get serializer => _$SalesOfficeListDtoOutputSerializer();
}

class _$SalesOfficeListDtoOutputSerializer implements PrimitiveSerializer<SalesOfficeListDtoOutput> {
  @override
  final Iterable<Type> types = const [SalesOfficeListDtoOutput, _$SalesOfficeListDtoOutput];

  @override
  final String wireName = r'SalesOfficeListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalesOfficeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SalesOfficeListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalesOfficeListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalesOfficeListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SalesOfficeListDtoOutputItemsInner)]),
          ) as BuiltList<SalesOfficeListDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalesOfficeListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalesOfficeListDtoOutputBuilder();
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


