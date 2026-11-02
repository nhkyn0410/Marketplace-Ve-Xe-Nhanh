//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/fare_band_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fare_band_list_dto_output.g.dart';

/// FareBandListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class FareBandListDtoOutput implements Built<FareBandListDtoOutput, FareBandListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<FareBandListDtoOutputItemsInner> get items;

  FareBandListDtoOutput._();

  factory FareBandListDtoOutput([void updates(FareBandListDtoOutputBuilder b)]) = _$FareBandListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FareBandListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FareBandListDtoOutput> get serializer => _$FareBandListDtoOutputSerializer();
}

class _$FareBandListDtoOutputSerializer implements PrimitiveSerializer<FareBandListDtoOutput> {
  @override
  final Iterable<Type> types = const [FareBandListDtoOutput, _$FareBandListDtoOutput];

  @override
  final String wireName = r'FareBandListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FareBandListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(FareBandListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FareBandListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FareBandListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FareBandListDtoOutputItemsInner)]),
          ) as BuiltList<FareBandListDtoOutputItemsInner>;
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
  FareBandListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FareBandListDtoOutputBuilder();
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


