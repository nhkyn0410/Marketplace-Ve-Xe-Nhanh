//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/route_response_dto_output_sub_routes_inner_fare.dart';
import 'package:api_client_dart/src/model/route_response_dto_output_sub_routes_inner_from.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_response_dto_output_sub_routes_inner.g.dart';

/// RouteResponseDtoOutputSubRoutesInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [nameSource] 
/// * [status] 
/// * [totalDistanceMeters] 
/// * [totalDurationSeconds] 
/// * [from] 
/// * [to] 
/// * [needsReview] 
/// * [fare] 
@BuiltValue()
abstract class RouteResponseDtoOutputSubRoutesInner implements Built<RouteResponseDtoOutputSubRoutesInner, RouteResponseDtoOutputSubRoutesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameSource')
  RouteResponseDtoOutputSubRoutesInnerNameSourceEnum get nameSource;
  // enum nameSourceEnum {  AUTO,  MANUAL,  };

  @BuiltValueField(wireName: r'status')
  RouteResponseDtoOutputSubRoutesInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  DRAFT,  };

  @BuiltValueField(wireName: r'totalDistanceMeters')
  int get totalDistanceMeters;

  @BuiltValueField(wireName: r'totalDurationSeconds')
  int get totalDurationSeconds;

  @BuiltValueField(wireName: r'from')
  RouteResponseDtoOutputSubRoutesInnerFrom get from;

  @BuiltValueField(wireName: r'to')
  RouteResponseDtoOutputSubRoutesInnerFrom get to;

  @BuiltValueField(wireName: r'needsReview')
  bool get needsReview;

  @BuiltValueField(wireName: r'fare')
  RouteResponseDtoOutputSubRoutesInnerFare? get fare;

  RouteResponseDtoOutputSubRoutesInner._();

  factory RouteResponseDtoOutputSubRoutesInner([void updates(RouteResponseDtoOutputSubRoutesInnerBuilder b)]) = _$RouteResponseDtoOutputSubRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteResponseDtoOutputSubRoutesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteResponseDtoOutputSubRoutesInner> get serializer => _$RouteResponseDtoOutputSubRoutesInnerSerializer();
}

class _$RouteResponseDtoOutputSubRoutesInnerSerializer implements PrimitiveSerializer<RouteResponseDtoOutputSubRoutesInner> {
  @override
  final Iterable<Type> types = const [RouteResponseDtoOutputSubRoutesInner, _$RouteResponseDtoOutputSubRoutesInner];

  @override
  final String wireName = r'RouteResponseDtoOutputSubRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteResponseDtoOutputSubRoutesInner object, {
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
    yield r'nameSource';
    yield serializers.serialize(
      object.nameSource,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerNameSourceEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerStatusEnum),
    );
    yield r'totalDistanceMeters';
    yield serializers.serialize(
      object.totalDistanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'totalDurationSeconds';
    yield serializers.serialize(
      object.totalDurationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
    );
    yield r'needsReview';
    yield serializers.serialize(
      object.needsReview,
      specifiedType: const FullType(bool),
    );
    yield r'fare';
    yield object.fare == null ? null : serializers.serialize(
      object.fare,
      specifiedType: const FullType.nullable(RouteResponseDtoOutputSubRoutesInnerFare),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteResponseDtoOutputSubRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteResponseDtoOutputSubRoutesInnerBuilder result,
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
        case r'nameSource':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerNameSourceEnum),
          ) as RouteResponseDtoOutputSubRoutesInnerNameSourceEnum;
          result.nameSource = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerStatusEnum),
          ) as RouteResponseDtoOutputSubRoutesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'totalDistanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDistanceMeters = valueDes;
          break;
        case r'totalDurationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDurationSeconds = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
          ) as RouteResponseDtoOutputSubRoutesInnerFrom;
          result.from.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFrom),
          ) as RouteResponseDtoOutputSubRoutesInnerFrom;
          result.to.replace(valueDes);
          break;
        case r'needsReview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.needsReview = valueDes;
          break;
        case r'fare':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RouteResponseDtoOutputSubRoutesInnerFare),
          ) as RouteResponseDtoOutputSubRoutesInnerFare?;
          if (valueDes == null) continue;
          result.fare.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteResponseDtoOutputSubRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteResponseDtoOutputSubRoutesInnerBuilder();
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


class RouteResponseDtoOutputSubRoutesInnerNameSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTO')
  static const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum AUTO = _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_AUTO;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum MANUAL = _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_MANUAL;

  static Serializer<RouteResponseDtoOutputSubRoutesInnerNameSourceEnum> get serializer => _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumSerializer;

  const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum._(String name): super(name);

  static BuiltSet<RouteResponseDtoOutputSubRoutesInnerNameSourceEnum> get values => _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumValues;
  static RouteResponseDtoOutputSubRoutesInnerNameSourceEnum valueOf(String name) => _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumValueOf(name);
}

class RouteResponseDtoOutputSubRoutesInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const RouteResponseDtoOutputSubRoutesInnerStatusEnum ACTIVE = _$routeResponseDtoOutputSubRoutesInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const RouteResponseDtoOutputSubRoutesInnerStatusEnum INACTIVE = _$routeResponseDtoOutputSubRoutesInnerStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const RouteResponseDtoOutputSubRoutesInnerStatusEnum DRAFT = _$routeResponseDtoOutputSubRoutesInnerStatusEnum_DRAFT;

  static Serializer<RouteResponseDtoOutputSubRoutesInnerStatusEnum> get serializer => _$routeResponseDtoOutputSubRoutesInnerStatusEnumSerializer;

  const RouteResponseDtoOutputSubRoutesInnerStatusEnum._(String name): super(name);

  static BuiltSet<RouteResponseDtoOutputSubRoutesInnerStatusEnum> get values => _$routeResponseDtoOutputSubRoutesInnerStatusEnumValues;
  static RouteResponseDtoOutputSubRoutesInnerStatusEnum valueOf(String name) => _$routeResponseDtoOutputSubRoutesInnerStatusEnumValueOf(name);
}

