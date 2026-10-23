//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/user_voucher_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_voucher_page_dto_output.g.dart';

/// UserVoucherPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class UserVoucherPageDtoOutput implements Built<UserVoucherPageDtoOutput, UserVoucherPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<UserVoucherPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  UserVoucherPageDtoOutput._();

  factory UserVoucherPageDtoOutput([void updates(UserVoucherPageDtoOutputBuilder b)]) = _$UserVoucherPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserVoucherPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserVoucherPageDtoOutput> get serializer => _$UserVoucherPageDtoOutputSerializer();
}

class _$UserVoucherPageDtoOutputSerializer implements PrimitiveSerializer<UserVoucherPageDtoOutput> {
  @override
  final Iterable<Type> types = const [UserVoucherPageDtoOutput, _$UserVoucherPageDtoOutput];

  @override
  final String wireName = r'UserVoucherPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserVoucherPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(UserVoucherPageDtoOutputItemsInner)]),
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
    UserVoucherPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserVoucherPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserVoucherPageDtoOutputItemsInner)]),
          ) as BuiltList<UserVoucherPageDtoOutputItemsInner>;
          result.items.replace(valueDes);
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
  UserVoucherPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserVoucherPageDtoOutputBuilder();
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


