//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_overview_dto_output_bookings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_overview_dto_output_tickets.dart';
import 'package:api_client_dart/src/model/admin_overview_dto_output_escrow.dart';
import 'package:api_client_dart/src/model/admin_overview_dto_output_queues.dart';
import 'package:api_client_dart/src/model/admin_overview_dto_output_daily_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output.g.dart';

/// AdminOverviewDtoOutput
///
/// Properties:
/// * [gmv] 
/// * [previousGmv] 
/// * [bookings] 
/// * [tickets] 
/// * [escrow] 
/// * [daily] 
/// * [queues] 
@BuiltValue()
abstract class AdminOverviewDtoOutput implements Built<AdminOverviewDtoOutput, AdminOverviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'gmv')
  int get gmv;

  @BuiltValueField(wireName: r'previousGmv')
  int get previousGmv;

  @BuiltValueField(wireName: r'bookings')
  AdminOverviewDtoOutputBookings get bookings;

  @BuiltValueField(wireName: r'tickets')
  AdminOverviewDtoOutputTickets get tickets;

  @BuiltValueField(wireName: r'escrow')
  AdminOverviewDtoOutputEscrow get escrow;

  @BuiltValueField(wireName: r'daily')
  BuiltList<AdminOverviewDtoOutputDailyInner> get daily;

  @BuiltValueField(wireName: r'queues')
  AdminOverviewDtoOutputQueues get queues;

  AdminOverviewDtoOutput._();

  factory AdminOverviewDtoOutput([void updates(AdminOverviewDtoOutputBuilder b)]) = _$AdminOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutput> get serializer => _$AdminOverviewDtoOutputSerializer();
}

class _$AdminOverviewDtoOutputSerializer implements PrimitiveSerializer<AdminOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutput, _$AdminOverviewDtoOutput];

  @override
  final String wireName = r'AdminOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gmv';
    yield serializers.serialize(
      object.gmv,
      specifiedType: const FullType(int),
    );
    yield r'previousGmv';
    yield serializers.serialize(
      object.previousGmv,
      specifiedType: const FullType(int),
    );
    yield r'bookings';
    yield serializers.serialize(
      object.bookings,
      specifiedType: const FullType(AdminOverviewDtoOutputBookings),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(AdminOverviewDtoOutputTickets),
    );
    yield r'escrow';
    yield serializers.serialize(
      object.escrow,
      specifiedType: const FullType(AdminOverviewDtoOutputEscrow),
    );
    yield r'daily';
    yield serializers.serialize(
      object.daily,
      specifiedType: const FullType(BuiltList, [FullType(AdminOverviewDtoOutputDailyInner)]),
    );
    yield r'queues';
    yield serializers.serialize(
      object.queues,
      specifiedType: const FullType(AdminOverviewDtoOutputQueues),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmv = valueDes;
          break;
        case r'previousGmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.previousGmv = valueDes;
          break;
        case r'bookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewDtoOutputBookings),
          ) as AdminOverviewDtoOutputBookings;
          result.bookings.replace(valueDes);
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewDtoOutputTickets),
          ) as AdminOverviewDtoOutputTickets;
          result.tickets.replace(valueDes);
          break;
        case r'escrow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewDtoOutputEscrow),
          ) as AdminOverviewDtoOutputEscrow;
          result.escrow.replace(valueDes);
          break;
        case r'daily':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOverviewDtoOutputDailyInner)]),
          ) as BuiltList<AdminOverviewDtoOutputDailyInner>;
          result.daily.replace(valueDes);
          break;
        case r'queues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewDtoOutputQueues),
          ) as AdminOverviewDtoOutputQueues;
          result.queues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputBuilder();
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


