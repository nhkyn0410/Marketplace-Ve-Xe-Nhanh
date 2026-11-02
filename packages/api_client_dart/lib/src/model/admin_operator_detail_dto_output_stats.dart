//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_detail_dto_output_stats.g.dart';

/// AdminOperatorDetailDtoOutputStats
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [trips] 
/// * [completedTrips] 
/// * [cancelledTrips] 
/// * [seats] 
/// * [ticketsSold] 
/// * [ticketRevenue] 
/// * [refunded] 
/// * [averageRating] 
/// * [reviewCount] 
@BuiltValue()
abstract class AdminOperatorDetailDtoOutputStats implements Built<AdminOperatorDetailDtoOutputStats, AdminOperatorDetailDtoOutputStatsBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  @BuiltValueField(wireName: r'completedTrips')
  int get completedTrips;

  @BuiltValueField(wireName: r'cancelledTrips')
  int get cancelledTrips;

  @BuiltValueField(wireName: r'seats')
  int get seats;

  @BuiltValueField(wireName: r'ticketsSold')
  int get ticketsSold;

  @BuiltValueField(wireName: r'ticketRevenue')
  int? get ticketRevenue;

  @BuiltValueField(wireName: r'refunded')
  int? get refunded;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  AdminOperatorDetailDtoOutputStats._();

  factory AdminOperatorDetailDtoOutputStats([void updates(AdminOperatorDetailDtoOutputStatsBuilder b)]) = _$AdminOperatorDetailDtoOutputStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorDetailDtoOutputStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorDetailDtoOutputStats> get serializer => _$AdminOperatorDetailDtoOutputStatsSerializer();
}

class _$AdminOperatorDetailDtoOutputStatsSerializer implements PrimitiveSerializer<AdminOperatorDetailDtoOutputStats> {
  @override
  final Iterable<Type> types = const [AdminOperatorDetailDtoOutputStats, _$AdminOperatorDetailDtoOutputStats];

  @override
  final String wireName = r'AdminOperatorDetailDtoOutputStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorDetailDtoOutputStats object, {
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
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'completedTrips';
    yield serializers.serialize(
      object.completedTrips,
      specifiedType: const FullType(int),
    );
    yield r'cancelledTrips';
    yield serializers.serialize(
      object.cancelledTrips,
      specifiedType: const FullType(int),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(int),
    );
    yield r'ticketsSold';
    yield serializers.serialize(
      object.ticketsSold,
      specifiedType: const FullType(int),
    );
    yield r'ticketRevenue';
    yield object.ticketRevenue == null ? null : serializers.serialize(
      object.ticketRevenue,
      specifiedType: const FullType.nullable(int),
    );
    yield r'refunded';
    yield object.refunded == null ? null : serializers.serialize(
      object.refunded,
      specifiedType: const FullType.nullable(int),
    );
    yield r'averageRating';
    yield object.averageRating == null ? null : serializers.serialize(
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
    AdminOperatorDetailDtoOutputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorDetailDtoOutputStatsBuilder result,
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
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
          break;
        case r'completedTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completedTrips = valueDes;
          break;
        case r'cancelledTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelledTrips = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.seats = valueDes;
          break;
        case r'ticketsSold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketsSold = valueDes;
          break;
        case r'ticketRevenue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ticketRevenue = valueDes;
          break;
        case r'refunded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  AdminOperatorDetailDtoOutputStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorDetailDtoOutputStatsBuilder();
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


