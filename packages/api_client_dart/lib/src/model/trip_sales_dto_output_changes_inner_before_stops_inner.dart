//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_sales_dto_output_changes_inner_before_stops_inner.g.dart';

/// TripSalesDtoOutputChangesInnerBeforeStopsInner
///
/// Properties:
/// * [sequence] 
/// * [name] 
@BuiltValue()
abstract class TripSalesDtoOutputChangesInnerBeforeStopsInner implements Built<TripSalesDtoOutputChangesInnerBeforeStopsInner, TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  TripSalesDtoOutputChangesInnerBeforeStopsInner._();

  factory TripSalesDtoOutputChangesInnerBeforeStopsInner([void updates(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder b)]) = _$TripSalesDtoOutputChangesInnerBeforeStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSalesDtoOutputChangesInnerBeforeStopsInner> get serializer => _$TripSalesDtoOutputChangesInnerBeforeStopsInnerSerializer();
}

class _$TripSalesDtoOutputChangesInnerBeforeStopsInnerSerializer implements PrimitiveSerializer<TripSalesDtoOutputChangesInnerBeforeStopsInner> {
  @override
  final Iterable<Type> types = const [TripSalesDtoOutputChangesInnerBeforeStopsInner, _$TripSalesDtoOutputChangesInnerBeforeStopsInner];

  @override
  final String wireName = r'TripSalesDtoOutputChangesInnerBeforeStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSalesDtoOutputChangesInnerBeforeStopsInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSalesDtoOutputChangesInnerBeforeStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSalesDtoOutputChangesInnerBeforeStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder();
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


