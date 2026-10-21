//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_stop_point_proposal_list_dto_output_items_inner_nearby_inner.g.dart';

/// AdminStopPointProposalListDtoOutputItemsInnerNearbyInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [latitude] 
/// * [longitude] 
/// * [distanceMeters] 
/// * [routeCount] 
@BuiltValue()
abstract class AdminStopPointProposalListDtoOutputItemsInnerNearbyInner implements Built<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner, AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'distanceMeters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  AdminStopPointProposalListDtoOutputItemsInnerNearbyInner._();

  factory AdminStopPointProposalListDtoOutputItemsInnerNearbyInner([void updates(AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder b)]) = _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner> get serializer => _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerSerializer();
}

class _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerSerializer implements PrimitiveSerializer<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner> {
  @override
  final Iterable<Type> types = const [AdminStopPointProposalListDtoOutputItemsInnerNearbyInner, _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner];

  @override
  final String wireName = r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStopPointProposalListDtoOutputItemsInnerNearbyInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'distanceMeters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'routeCount';
    yield serializers.serialize(
      object.routeCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStopPointProposalListDtoOutputItemsInnerNearbyInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'distanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'routeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.routeCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStopPointProposalListDtoOutputItemsInnerNearbyInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder();
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


