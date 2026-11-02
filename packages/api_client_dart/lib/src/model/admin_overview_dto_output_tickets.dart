//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output_tickets.g.dart';

/// AdminOverviewDtoOutputTickets
///
/// Properties:
/// * [issued] 
/// * [refunded] 
@BuiltValue()
abstract class AdminOverviewDtoOutputTickets implements Built<AdminOverviewDtoOutputTickets, AdminOverviewDtoOutputTicketsBuilder> {
  @BuiltValueField(wireName: r'issued')
  int get issued;

  @BuiltValueField(wireName: r'refunded')
  int get refunded;

  AdminOverviewDtoOutputTickets._();

  factory AdminOverviewDtoOutputTickets([void updates(AdminOverviewDtoOutputTicketsBuilder b)]) = _$AdminOverviewDtoOutputTickets;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputTicketsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutputTickets> get serializer => _$AdminOverviewDtoOutputTicketsSerializer();
}

class _$AdminOverviewDtoOutputTicketsSerializer implements PrimitiveSerializer<AdminOverviewDtoOutputTickets> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutputTickets, _$AdminOverviewDtoOutputTickets];

  @override
  final String wireName = r'AdminOverviewDtoOutputTickets';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutputTickets object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'issued';
    yield serializers.serialize(
      object.issued,
      specifiedType: const FullType(int),
    );
    yield r'refunded';
    yield serializers.serialize(
      object.refunded,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutputTickets object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputTicketsBuilder result,
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
        case r'refunded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refunded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutputTickets deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputTicketsBuilder();
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


