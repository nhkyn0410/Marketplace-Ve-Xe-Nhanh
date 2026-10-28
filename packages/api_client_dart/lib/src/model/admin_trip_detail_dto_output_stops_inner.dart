//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_trip_detail_dto_output_stops_inner.g.dart';

/// AdminTripDetailDtoOutputStopsInner
///
/// Properties:
/// * [sequence] 
/// * [name] 
/// * [address] 
/// * [plannedAt] 
/// * [allowPickup] 
/// * [allowDropoff] 
@BuiltValue()
abstract class AdminTripDetailDtoOutputStopsInner implements Built<AdminTripDetailDtoOutputStopsInner, AdminTripDetailDtoOutputStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'plannedAt')
  DateTime get plannedAt;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  AdminTripDetailDtoOutputStopsInner._();

  factory AdminTripDetailDtoOutputStopsInner([void updates(AdminTripDetailDtoOutputStopsInnerBuilder b)]) = _$AdminTripDetailDtoOutputStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTripDetailDtoOutputStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTripDetailDtoOutputStopsInner> get serializer => _$AdminTripDetailDtoOutputStopsInnerSerializer();
}

class _$AdminTripDetailDtoOutputStopsInnerSerializer implements PrimitiveSerializer<AdminTripDetailDtoOutputStopsInner> {
  @override
  final Iterable<Type> types = const [AdminTripDetailDtoOutputStopsInner, _$AdminTripDetailDtoOutputStopsInner];

  @override
  final String wireName = r'AdminTripDetailDtoOutputStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTripDetailDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'plannedAt';
    yield serializers.serialize(
      object.plannedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'allowPickup';
    yield serializers.serialize(
      object.allowPickup,
      specifiedType: const FullType(bool),
    );
    yield r'allowDropoff';
    yield serializers.serialize(
      object.allowDropoff,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTripDetailDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTripDetailDtoOutputStopsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'plannedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.plannedAt = valueDes;
          break;
        case r'allowPickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowPickup = valueDes;
          break;
        case r'allowDropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowDropoff = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTripDetailDtoOutputStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTripDetailDtoOutputStopsInnerBuilder();
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


