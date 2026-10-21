//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_overview_dto_output_attention.g.dart';

/// OperatorOverviewDtoOutputAttention
///
/// Properties:
/// * [tripsWithoutDriver] 
/// * [draftTrips] 
/// * [pendingRefunds] 
@BuiltValue()
abstract class OperatorOverviewDtoOutputAttention implements Built<OperatorOverviewDtoOutputAttention, OperatorOverviewDtoOutputAttentionBuilder> {
  @BuiltValueField(wireName: r'tripsWithoutDriver')
  int get tripsWithoutDriver;

  @BuiltValueField(wireName: r'draftTrips')
  int get draftTrips;

  @BuiltValueField(wireName: r'pendingRefunds')
  int get pendingRefunds;

  OperatorOverviewDtoOutputAttention._();

  factory OperatorOverviewDtoOutputAttention([void updates(OperatorOverviewDtoOutputAttentionBuilder b)]) = _$OperatorOverviewDtoOutputAttention;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorOverviewDtoOutputAttentionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorOverviewDtoOutputAttention> get serializer => _$OperatorOverviewDtoOutputAttentionSerializer();
}

class _$OperatorOverviewDtoOutputAttentionSerializer implements PrimitiveSerializer<OperatorOverviewDtoOutputAttention> {
  @override
  final Iterable<Type> types = const [OperatorOverviewDtoOutputAttention, _$OperatorOverviewDtoOutputAttention];

  @override
  final String wireName = r'OperatorOverviewDtoOutputAttention';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorOverviewDtoOutputAttention object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripsWithoutDriver';
    yield serializers.serialize(
      object.tripsWithoutDriver,
      specifiedType: const FullType(int),
    );
    yield r'draftTrips';
    yield serializers.serialize(
      object.draftTrips,
      specifiedType: const FullType(int),
    );
    yield r'pendingRefunds';
    yield serializers.serialize(
      object.pendingRefunds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorOverviewDtoOutputAttention object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorOverviewDtoOutputAttentionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripsWithoutDriver':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripsWithoutDriver = valueDes;
          break;
        case r'draftTrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.draftTrips = valueDes;
          break;
        case r'pendingRefunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingRefunds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorOverviewDtoOutputAttention deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorOverviewDtoOutputAttentionBuilder();
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


