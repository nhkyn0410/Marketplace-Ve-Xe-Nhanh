//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_page_dto_output_period.g.dart';

/// AdminRoutePageDtoOutputPeriod
///
/// Properties:
/// * [from] 
/// * [to] 
@BuiltValue()
abstract class AdminRoutePageDtoOutputPeriod implements Built<AdminRoutePageDtoOutputPeriod, AdminRoutePageDtoOutputPeriodBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  AdminRoutePageDtoOutputPeriod._();

  factory AdminRoutePageDtoOutputPeriod([void updates(AdminRoutePageDtoOutputPeriodBuilder b)]) = _$AdminRoutePageDtoOutputPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRoutePageDtoOutputPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRoutePageDtoOutputPeriod> get serializer => _$AdminRoutePageDtoOutputPeriodSerializer();
}

class _$AdminRoutePageDtoOutputPeriodSerializer implements PrimitiveSerializer<AdminRoutePageDtoOutputPeriod> {
  @override
  final Iterable<Type> types = const [AdminRoutePageDtoOutputPeriod, _$AdminRoutePageDtoOutputPeriod];

  @override
  final String wireName = r'AdminRoutePageDtoOutputPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRoutePageDtoOutputPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRoutePageDtoOutputPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRoutePageDtoOutputPeriodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRoutePageDtoOutputPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRoutePageDtoOutputPeriodBuilder();
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


