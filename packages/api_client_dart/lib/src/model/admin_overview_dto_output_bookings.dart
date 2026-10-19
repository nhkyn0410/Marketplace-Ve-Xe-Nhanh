//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output_bookings.g.dart';

/// AdminOverviewDtoOutputBookings
///
/// Properties:
/// * [total] 
/// * [confirmed] 
/// * [cancelledOrExpired] 
@BuiltValue()
abstract class AdminOverviewDtoOutputBookings implements Built<AdminOverviewDtoOutputBookings, AdminOverviewDtoOutputBookingsBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'confirmed')
  int get confirmed;

  @BuiltValueField(wireName: r'cancelledOrExpired')
  int get cancelledOrExpired;

  AdminOverviewDtoOutputBookings._();

  factory AdminOverviewDtoOutputBookings([void updates(AdminOverviewDtoOutputBookingsBuilder b)]) = _$AdminOverviewDtoOutputBookings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputBookingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutputBookings> get serializer => _$AdminOverviewDtoOutputBookingsSerializer();
}

class _$AdminOverviewDtoOutputBookingsSerializer implements PrimitiveSerializer<AdminOverviewDtoOutputBookings> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutputBookings, _$AdminOverviewDtoOutputBookings];

  @override
  final String wireName = r'AdminOverviewDtoOutputBookings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutputBookings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'confirmed';
    yield serializers.serialize(
      object.confirmed,
      specifiedType: const FullType(int),
    );
    yield r'cancelledOrExpired';
    yield serializers.serialize(
      object.cancelledOrExpired,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutputBookings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputBookingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.confirmed = valueDes;
          break;
        case r'cancelledOrExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelledOrExpired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutputBookings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputBookingsBuilder();
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


