//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/loyalty_report_dto_output_totals.dart';
import 'package:api_client_dart/src/model/loyalty_report_dto_output_months_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_report_dto_output.g.dart';

/// LoyaltyReportDtoOutput
///
/// Properties:
/// * [year] 
/// * [quarter] 
/// * [tier] 
/// * [months] 
/// * [totals] 
@BuiltValue()
abstract class LoyaltyReportDtoOutput implements Built<LoyaltyReportDtoOutput, LoyaltyReportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'year')
  int get year;

  @BuiltValueField(wireName: r'quarter')
  int get quarter;

  @BuiltValueField(wireName: r'tier')
  LoyaltyReportDtoOutputTierEnum? get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'months')
  BuiltList<LoyaltyReportDtoOutputMonthsInner> get months;

  @BuiltValueField(wireName: r'totals')
  LoyaltyReportDtoOutputTotals get totals;

  LoyaltyReportDtoOutput._();

  factory LoyaltyReportDtoOutput([void updates(LoyaltyReportDtoOutputBuilder b)]) = _$LoyaltyReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyReportDtoOutput> get serializer => _$LoyaltyReportDtoOutputSerializer();
}

class _$LoyaltyReportDtoOutputSerializer implements PrimitiveSerializer<LoyaltyReportDtoOutput> {
  @override
  final Iterable<Type> types = const [LoyaltyReportDtoOutput, _$LoyaltyReportDtoOutput];

  @override
  final String wireName = r'LoyaltyReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'year';
    yield serializers.serialize(
      object.year,
      specifiedType: const FullType(int),
    );
    yield r'quarter';
    yield serializers.serialize(
      object.quarter,
      specifiedType: const FullType(int),
    );
    yield r'tier';
    yield object.tier == null ? null : serializers.serialize(
      object.tier,
      specifiedType: const FullType.nullable(LoyaltyReportDtoOutputTierEnum),
    );
    yield r'months';
    yield serializers.serialize(
      object.months,
      specifiedType: const FullType(BuiltList, [FullType(LoyaltyReportDtoOutputMonthsInner)]),
    );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(LoyaltyReportDtoOutputTotals),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoyaltyReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.year = valueDes;
          break;
        case r'quarter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quarter = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(LoyaltyReportDtoOutputTierEnum),
          ) as LoyaltyReportDtoOutputTierEnum?;
          if (valueDes == null) continue;
          result.tier = valueDes;
          break;
        case r'months':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LoyaltyReportDtoOutputMonthsInner)]),
          ) as BuiltList<LoyaltyReportDtoOutputMonthsInner>;
          result.months.replace(valueDes);
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoyaltyReportDtoOutputTotals),
          ) as LoyaltyReportDtoOutputTotals;
          result.totals.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoyaltyReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyReportDtoOutputBuilder();
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


class LoyaltyReportDtoOutputTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const LoyaltyReportDtoOutputTierEnum BRONZE = _$loyaltyReportDtoOutputTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const LoyaltyReportDtoOutputTierEnum SILVER = _$loyaltyReportDtoOutputTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const LoyaltyReportDtoOutputTierEnum GOLD = _$loyaltyReportDtoOutputTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const LoyaltyReportDtoOutputTierEnum PLATINUM = _$loyaltyReportDtoOutputTierEnum_PLATINUM;

  static Serializer<LoyaltyReportDtoOutputTierEnum> get serializer => _$loyaltyReportDtoOutputTierEnumSerializer;

  const LoyaltyReportDtoOutputTierEnum._(String name): super(name);

  static BuiltSet<LoyaltyReportDtoOutputTierEnum> get values => _$loyaltyReportDtoOutputTierEnumValues;
  static LoyaltyReportDtoOutputTierEnum valueOf(String name) => _$loyaltyReportDtoOutputTierEnumValueOf(name);
}

