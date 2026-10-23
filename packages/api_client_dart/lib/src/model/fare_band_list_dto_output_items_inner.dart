//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fare_band_list_dto_output_items_inner.g.dart';

/// FareBandListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [minPrice] 
/// * [maxPrice] 
/// * [effectiveFrom] 
/// * [effectiveTo] 
/// * [message] 
/// * [reason] 
/// * [status] 
/// * [state] 
/// * [cancelReason] 
/// * [createdBy] 
/// * [createdAt] 
@BuiltValue()
abstract class FareBandListDtoOutputItemsInner implements Built<FareBandListDtoOutputItemsInner, FareBandListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'minPrice')
  int? get minPrice;

  @BuiltValueField(wireName: r'maxPrice')
  int? get maxPrice;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'effectiveTo')
  DateTime get effectiveTo;

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'status')
  FareBandListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  CANCELLED,  };

  @BuiltValueField(wireName: r'state')
  FareBandListDtoOutputItemsInnerStateEnum get state;
  // enum stateEnum {  SCHEDULED,  ACTIVE,  EXPIRED,  CANCELLED,  };

  @BuiltValueField(wireName: r'cancelReason')
  String? get cancelReason;

  @BuiltValueField(wireName: r'createdBy')
  String? get createdBy;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  FareBandListDtoOutputItemsInner._();

  factory FareBandListDtoOutputItemsInner([void updates(FareBandListDtoOutputItemsInnerBuilder b)]) = _$FareBandListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FareBandListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FareBandListDtoOutputItemsInner> get serializer => _$FareBandListDtoOutputItemsInnerSerializer();
}

class _$FareBandListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<FareBandListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [FareBandListDtoOutputItemsInner, _$FareBandListDtoOutputItemsInner];

  @override
  final String wireName = r'FareBandListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FareBandListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'minPrice';
    yield object.minPrice == null ? null : serializers.serialize(
      object.minPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'maxPrice';
    yield object.maxPrice == null ? null : serializers.serialize(
      object.maxPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'effectiveTo';
    yield serializers.serialize(
      object.effectiveTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FareBandListDtoOutputItemsInnerStatusEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(FareBandListDtoOutputItemsInnerStateEnum),
    );
    yield r'cancelReason';
    yield object.cancelReason == null ? null : serializers.serialize(
      object.cancelReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdBy';
    yield object.createdBy == null ? null : serializers.serialize(
      object.createdBy,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FareBandListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FareBandListDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPrice = valueDes;
          break;
        case r'maxPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPrice = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'effectiveTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveTo = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FareBandListDtoOutputItemsInnerStatusEnum),
          ) as FareBandListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FareBandListDtoOutputItemsInnerStateEnum),
          ) as FareBandListDtoOutputItemsInnerStateEnum;
          result.state = valueDes;
          break;
        case r'cancelReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cancelReason = valueDes;
          break;
        case r'createdBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FareBandListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FareBandListDtoOutputItemsInnerBuilder();
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


class FareBandListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const FareBandListDtoOutputItemsInnerStatusEnum ACTIVE = _$fareBandListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const FareBandListDtoOutputItemsInnerStatusEnum CANCELLED = _$fareBandListDtoOutputItemsInnerStatusEnum_CANCELLED;

  static Serializer<FareBandListDtoOutputItemsInnerStatusEnum> get serializer => _$fareBandListDtoOutputItemsInnerStatusEnumSerializer;

  const FareBandListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<FareBandListDtoOutputItemsInnerStatusEnum> get values => _$fareBandListDtoOutputItemsInnerStatusEnumValues;
  static FareBandListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$fareBandListDtoOutputItemsInnerStatusEnumValueOf(name);
}

class FareBandListDtoOutputItemsInnerStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const FareBandListDtoOutputItemsInnerStateEnum SCHEDULED = _$fareBandListDtoOutputItemsInnerStateEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const FareBandListDtoOutputItemsInnerStateEnum ACTIVE = _$fareBandListDtoOutputItemsInnerStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const FareBandListDtoOutputItemsInnerStateEnum EXPIRED = _$fareBandListDtoOutputItemsInnerStateEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const FareBandListDtoOutputItemsInnerStateEnum CANCELLED = _$fareBandListDtoOutputItemsInnerStateEnum_CANCELLED;

  static Serializer<FareBandListDtoOutputItemsInnerStateEnum> get serializer => _$fareBandListDtoOutputItemsInnerStateEnumSerializer;

  const FareBandListDtoOutputItemsInnerStateEnum._(String name): super(name);

  static BuiltSet<FareBandListDtoOutputItemsInnerStateEnum> get values => _$fareBandListDtoOutputItemsInnerStateEnumValues;
  static FareBandListDtoOutputItemsInnerStateEnum valueOf(String name) => _$fareBandListDtoOutputItemsInnerStateEnumValueOf(name);
}

