//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_report_dto_output_months_inner.g.dart';

/// LoyaltyReportDtoOutputMonthsInner
///
/// Properties:
/// * [issued] 
/// * [redeemed] 
/// * [expired] 
/// * [vouchersRedeemed] 
/// * [vouchersUsed] 
/// * [platformDiscount] 
/// * [month] 
@BuiltValue()
abstract class LoyaltyReportDtoOutputMonthsInner implements Built<LoyaltyReportDtoOutputMonthsInner, LoyaltyReportDtoOutputMonthsInnerBuilder> {
  @BuiltValueField(wireName: r'issued')
  int get issued;

  @BuiltValueField(wireName: r'redeemed')
  int get redeemed;

  @BuiltValueField(wireName: r'expired')
  int get expired;

  @BuiltValueField(wireName: r'vouchersRedeemed')
  int get vouchersRedeemed;

  @BuiltValueField(wireName: r'vouchersUsed')
  int get vouchersUsed;

  @BuiltValueField(wireName: r'platformDiscount')
  int get platformDiscount;

  @BuiltValueField(wireName: r'month')
  String get month;

  LoyaltyReportDtoOutputMonthsInner._();

  factory LoyaltyReportDtoOutputMonthsInner([void updates(LoyaltyReportDtoOutputMonthsInnerBuilder b)]) = _$LoyaltyReportDtoOutputMonthsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyReportDtoOutputMonthsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyReportDtoOutputMonthsInner> get serializer => _$LoyaltyReportDtoOutputMonthsInnerSerializer();
}

class _$LoyaltyReportDtoOutputMonthsInnerSerializer implements PrimitiveSerializer<LoyaltyReportDtoOutputMonthsInner> {
  @override
  final Iterable<Type> types = const [LoyaltyReportDtoOutputMonthsInner, _$LoyaltyReportDtoOutputMonthsInner];

  @override
  final String wireName = r'LoyaltyReportDtoOutputMonthsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyReportDtoOutputMonthsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'issued';
    yield serializers.serialize(
      object.issued,
      specifiedType: const FullType(int),
    );
    yield r'redeemed';
    yield serializers.serialize(
      object.redeemed,
      specifiedType: const FullType(int),
    );
    yield r'expired';
    yield serializers.serialize(
      object.expired,
      specifiedType: const FullType(int),
    );
    yield r'vouchersRedeemed';
    yield serializers.serialize(
      object.vouchersRedeemed,
      specifiedType: const FullType(int),
    );
    yield r'vouchersUsed';
    yield serializers.serialize(
      object.vouchersUsed,
      specifiedType: const FullType(int),
    );
    yield r'platformDiscount';
    yield serializers.serialize(
      object.platformDiscount,
      specifiedType: const FullType(int),
    );
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoyaltyReportDtoOutputMonthsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyReportDtoOutputMonthsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'issued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.issued = valueDes;
          break;
        case r'redeemed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.redeemed = valueDes;
          break;
        case r'expired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expired = valueDes;
          break;
        case r'vouchersRedeemed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vouchersRedeemed = valueDes;
          break;
        case r'vouchersUsed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vouchersUsed = valueDes;
          break;
        case r'platformDiscount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.platformDiscount = valueDes;
          break;
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.month = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoyaltyReportDtoOutputMonthsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyReportDtoOutputMonthsInnerBuilder();
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


