//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_report_dto_output_by_route_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_report_dto_output_totals.dart';
import 'package:api_client_dart/src/model/admin_report_dto_output_by_region_inner.dart';
import 'package:api_client_dart/src/model/admin_report_dto_output_by_operator_inner.dart';
import 'package:api_client_dart/src/model/admin_report_dto_output_payment_methods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output.g.dart';

/// AdminReportDtoOutput
///
/// Properties:
/// * [totals] 
/// * [byOperator] 
/// * [paymentMethods] 
/// * [byRoute] 
/// * [byRegion] 
@BuiltValue()
abstract class AdminReportDtoOutput implements Built<AdminReportDtoOutput, AdminReportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'totals')
  AdminReportDtoOutputTotals get totals;

  @BuiltValueField(wireName: r'byOperator')
  BuiltList<AdminReportDtoOutputByOperatorInner> get byOperator;

  @BuiltValueField(wireName: r'paymentMethods')
  BuiltList<AdminReportDtoOutputPaymentMethodsInner> get paymentMethods;

  @BuiltValueField(wireName: r'byRoute')
  BuiltList<AdminReportDtoOutputByRouteInner> get byRoute;

  @BuiltValueField(wireName: r'byRegion')
  BuiltList<AdminReportDtoOutputByRegionInner> get byRegion;

  AdminReportDtoOutput._();

  factory AdminReportDtoOutput([void updates(AdminReportDtoOutputBuilder b)]) = _$AdminReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutput> get serializer => _$AdminReportDtoOutputSerializer();
}

class _$AdminReportDtoOutputSerializer implements PrimitiveSerializer<AdminReportDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminReportDtoOutput, _$AdminReportDtoOutput];

  @override
  final String wireName = r'AdminReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(AdminReportDtoOutputTotals),
    );
    yield r'byOperator';
    yield serializers.serialize(
      object.byOperator,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByOperatorInner)]),
    );
    yield r'paymentMethods';
    yield serializers.serialize(
      object.paymentMethods,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputPaymentMethodsInner)]),
    );
    yield r'byRoute';
    yield serializers.serialize(
      object.byRoute,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByRouteInner)]),
    );
    yield r'byRegion';
    yield serializers.serialize(
      object.byRegion,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByRegionInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminReportDtoOutputTotals),
          ) as AdminReportDtoOutputTotals;
          result.totals.replace(valueDes);
          break;
        case r'byOperator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByOperatorInner)]),
          ) as BuiltList<AdminReportDtoOutputByOperatorInner>;
          result.byOperator.replace(valueDes);
          break;
        case r'paymentMethods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputPaymentMethodsInner)]),
          ) as BuiltList<AdminReportDtoOutputPaymentMethodsInner>;
          result.paymentMethods.replace(valueDes);
          break;
        case r'byRoute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByRouteInner)]),
          ) as BuiltList<AdminReportDtoOutputByRouteInner>;
          result.byRoute.replace(valueDes);
          break;
        case r'byRegion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReportDtoOutputByRegionInner)]),
          ) as BuiltList<AdminReportDtoOutputByRegionInner>;
          result.byRegion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputBuilder();
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


