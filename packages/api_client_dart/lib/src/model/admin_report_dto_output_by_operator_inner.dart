//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_by_operator_inner.g.dart';

/// AdminReportDtoOutputByOperatorInner
///
/// Properties:
/// * [operatorId]
/// * [operatorName]
/// * [trips]
/// * [ticketsSold]
/// * [seats]
/// * [gmv]
/// * [refunded]
/// * [averageRating]
/// * [reviewCount]
@BuiltValue()
abstract class AdminReportDtoOutputByOperatorInner
    implements
        Built<AdminReportDtoOutputByOperatorInner,
            AdminReportDtoOutputByOperatorInnerBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'gmv')
  int get gmv;

  @BuiltValueField(wireName: r'refunded')
  int get refunded;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  AdminReportDtoOutputByOperatorInner._();

  factory AdminReportDtoOutputByOperatorInner(
          [void updates(AdminReportDtoOutputByOperatorInnerBuilder b)]) =
      _$AdminReportDtoOutputByOperatorInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputByOperatorInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputByOperatorInner> get serializer =>
      _$AdminReportDtoOutputByOperatorInnerSerializer();
}

class _$AdminReportDtoOutputByOperatorInnerSerializer
    implements PrimitiveSerializer<AdminReportDtoOutputByOperatorInner> {
  @override
  final Iterable<Type> types = const [
    AdminReportDtoOutputByOperatorInner,
    _$AdminReportDtoOutputByOperatorInner
  ];

  @override
  final String wireName = r'AdminReportDtoOutputByOperatorInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputByOperatorInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
    yield r'gmv';
    yield serializers.serialize(
      object.gmv,
      specifiedType: const FullType(int),
    );
    yield r'refunded';
    yield serializers.serialize(
      object.refunded,
      specifiedType: const FullType(int),
    );
    yield r'averageRating';
    yield object.averageRating == null
        ? null
        : serializers.serialize(
            object.averageRating,
            specifiedType: const FullType.nullable(num),
          );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputByOperatorInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputByOperatorInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
          break;
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        case r'gmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmv = valueDes;
          break;
        case r'refunded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refunded = valueDes;
          break;
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputByOperatorInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputByOperatorInnerBuilder();
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
