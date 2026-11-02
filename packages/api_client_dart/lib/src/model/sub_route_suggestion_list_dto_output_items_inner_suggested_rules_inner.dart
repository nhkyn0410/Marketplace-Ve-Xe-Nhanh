//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_route_suggestion_list_dto_output_items_inner_suggested_rules_inner.g.dart';

/// SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner
///
/// Properties:
/// * [vehicleTypeId] 
/// * [seatType] 
/// * [validFrom] 
/// * [validTo] 
/// * [price] 
@BuiltValue()
abstract class SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner implements Built<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner, SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder> {
  @BuiltValueField(wireName: r'vehicleTypeId')
  String? get vehicleTypeId;

  @BuiltValueField(wireName: r'seatType')
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum? get seatType;
  // enum seatTypeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'validFrom')
  DateTime? get validFrom;

  @BuiltValueField(wireName: r'validTo')
  DateTime? get validTo;

  @BuiltValueField(wireName: r'price')
  int get price;

  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner._();

  factory SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner([void updates(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder b)]) = _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner> get serializer => _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSerializer();
}

class _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSerializer implements PrimitiveSerializer<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner> {
  @override
  final Iterable<Type> types = const [SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner, _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner];

  @override
  final String wireName = r'SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicleTypeId';
    yield object.vehicleTypeId == null ? null : serializers.serialize(
      object.vehicleTypeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'seatType';
    yield object.seatType == null ? null : serializers.serialize(
      object.seatType,
      specifiedType: const FullType.nullable(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum),
    );
    yield r'validFrom';
    yield object.validFrom == null ? null : serializers.serialize(
      object.validFrom,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'validTo';
    yield object.validTo == null ? null : serializers.serialize(
      object.validTo,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicleTypeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleTypeId = valueDes;
          break;
        case r'seatType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum),
          ) as SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum?;
          if (valueDes == null) continue;
          result.seatType = valueDes;
          break;
        case r'validFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.validFrom = valueDes;
          break;
        case r'validTo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.validTo = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder();
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


class SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum SEAT = _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum BED = _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum BED_DOUBLE = _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum CABIN = _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum CABIN_DOUBLE = _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN_DOUBLE;

  static Serializer<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum> get serializer => _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumSerializer;

  const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum._(String name): super(name);

  static BuiltSet<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum> get values => _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumValues;
  static SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum valueOf(String name) => _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumValueOf(name);
}

