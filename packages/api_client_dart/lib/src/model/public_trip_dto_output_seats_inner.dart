//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_seats_inner.g.dart';

/// PublicTripDtoOutputSeatsInner
///
/// Properties:
/// * [code] 
/// * [deck] 
/// * [row] 
/// * [column] 
/// * [type] 
/// * [status] 
/// * [price] 
@BuiltValue()
abstract class PublicTripDtoOutputSeatsInner implements Built<PublicTripDtoOutputSeatsInner, PublicTripDtoOutputSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'deck')
  int get deck;

  @BuiltValueField(wireName: r'row')
  int get row;

  @BuiltValueField(wireName: r'column')
  int get column;

  @BuiltValueField(wireName: r'type')
  PublicTripDtoOutputSeatsInnerTypeEnum get type;
  // enum typeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'status')
  PublicTripDtoOutputSeatsInnerStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  UNAVAILABLE,  };

  @BuiltValueField(wireName: r'price')
  int? get price;

  PublicTripDtoOutputSeatsInner._();

  factory PublicTripDtoOutputSeatsInner([void updates(PublicTripDtoOutputSeatsInnerBuilder b)]) = _$PublicTripDtoOutputSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputSeatsInner> get serializer => _$PublicTripDtoOutputSeatsInnerSerializer();
}

class _$PublicTripDtoOutputSeatsInnerSerializer implements PrimitiveSerializer<PublicTripDtoOutputSeatsInner> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputSeatsInner, _$PublicTripDtoOutputSeatsInner];

  @override
  final String wireName = r'PublicTripDtoOutputSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'deck';
    yield serializers.serialize(
      object.deck,
      specifiedType: const FullType(int),
    );
    yield r'row';
    yield serializers.serialize(
      object.row,
      specifiedType: const FullType(int),
    );
    yield r'column';
    yield serializers.serialize(
      object.column,
      specifiedType: const FullType(int),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PublicTripDtoOutputSeatsInnerTypeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PublicTripDtoOutputSeatsInnerStatusEnum),
    );
    yield r'price';
    yield object.price == null ? null : serializers.serialize(
      object.price,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputSeatsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'deck':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deck = valueDes;
          break;
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.row = valueDes;
          break;
        case r'column':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.column = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputSeatsInnerTypeEnum),
          ) as PublicTripDtoOutputSeatsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputSeatsInnerStatusEnum),
          ) as PublicTripDtoOutputSeatsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.price = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutputSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputSeatsInnerBuilder();
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


class PublicTripDtoOutputSeatsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const PublicTripDtoOutputSeatsInnerTypeEnum SEAT = _$publicTripDtoOutputSeatsInnerTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const PublicTripDtoOutputSeatsInnerTypeEnum BED = _$publicTripDtoOutputSeatsInnerTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const PublicTripDtoOutputSeatsInnerTypeEnum BED_DOUBLE = _$publicTripDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const PublicTripDtoOutputSeatsInnerTypeEnum CABIN = _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const PublicTripDtoOutputSeatsInnerTypeEnum CABIN_DOUBLE = _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;

  static Serializer<PublicTripDtoOutputSeatsInnerTypeEnum> get serializer => _$publicTripDtoOutputSeatsInnerTypeEnumSerializer;

  const PublicTripDtoOutputSeatsInnerTypeEnum._(String name): super(name);

  static BuiltSet<PublicTripDtoOutputSeatsInnerTypeEnum> get values => _$publicTripDtoOutputSeatsInnerTypeEnumValues;
  static PublicTripDtoOutputSeatsInnerTypeEnum valueOf(String name) => _$publicTripDtoOutputSeatsInnerTypeEnumValueOf(name);
}

class PublicTripDtoOutputSeatsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const PublicTripDtoOutputSeatsInnerStatusEnum AVAILABLE = _$publicTripDtoOutputSeatsInnerStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const PublicTripDtoOutputSeatsInnerStatusEnum UNAVAILABLE = _$publicTripDtoOutputSeatsInnerStatusEnum_UNAVAILABLE;

  static Serializer<PublicTripDtoOutputSeatsInnerStatusEnum> get serializer => _$publicTripDtoOutputSeatsInnerStatusEnumSerializer;

  const PublicTripDtoOutputSeatsInnerStatusEnum._(String name): super(name);

  static BuiltSet<PublicTripDtoOutputSeatsInnerStatusEnum> get values => _$publicTripDtoOutputSeatsInnerStatusEnumValues;
  static PublicTripDtoOutputSeatsInnerStatusEnum valueOf(String name) => _$publicTripDtoOutputSeatsInnerStatusEnumValueOf(name);
}

