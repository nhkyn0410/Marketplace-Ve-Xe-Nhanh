//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/operator_report_dto_output_employees_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/operator_report_dto_output_totals.dart';
import 'package:api_client_dart/src/model/operator_report_dto_output_by_route_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_report_dto_output.g.dart';

/// OperatorReportDtoOutput
///
/// Properties:
/// * [totals] 
/// * [byRoute] 
/// * [employees] 
@BuiltValue()
abstract class OperatorReportDtoOutput implements Built<OperatorReportDtoOutput, OperatorReportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'totals')
  OperatorReportDtoOutputTotals get totals;

  @BuiltValueField(wireName: r'byRoute')
  BuiltList<OperatorReportDtoOutputByRouteInner> get byRoute;

  @BuiltValueField(wireName: r'employees')
  BuiltList<OperatorReportDtoOutputEmployeesInner> get employees;

  OperatorReportDtoOutput._();

  factory OperatorReportDtoOutput([void updates(OperatorReportDtoOutputBuilder b)]) = _$OperatorReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorReportDtoOutput> get serializer => _$OperatorReportDtoOutputSerializer();
}

class _$OperatorReportDtoOutputSerializer implements PrimitiveSerializer<OperatorReportDtoOutput> {
  @override
  final Iterable<Type> types = const [OperatorReportDtoOutput, _$OperatorReportDtoOutput];

  @override
  final String wireName = r'OperatorReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(OperatorReportDtoOutputTotals),
    );
    yield r'byRoute';
    yield serializers.serialize(
      object.byRoute,
      specifiedType: const FullType(BuiltList, [FullType(OperatorReportDtoOutputByRouteInner)]),
    );
    yield r'employees';
    yield serializers.serialize(
      object.employees,
      specifiedType: const FullType(BuiltList, [FullType(OperatorReportDtoOutputEmployeesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorReportDtoOutputTotals),
          ) as OperatorReportDtoOutputTotals;
          result.totals.replace(valueDes);
          break;
        case r'byRoute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorReportDtoOutputByRouteInner)]),
          ) as BuiltList<OperatorReportDtoOutputByRouteInner>;
          result.byRoute.replace(valueDes);
          break;
        case r'employees':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorReportDtoOutputEmployeesInner)]),
          ) as BuiltList<OperatorReportDtoOutputEmployeesInner>;
          result.employees.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorReportDtoOutputBuilder();
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


