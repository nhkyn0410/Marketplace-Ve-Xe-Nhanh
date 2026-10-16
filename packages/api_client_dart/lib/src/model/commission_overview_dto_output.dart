//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/commission_overview_dto_output_default.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/commission_overview_dto_output_overrides_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_overview_dto_output.g.dart';

/// CommissionOverviewDtoOutput
///
/// Properties:
/// * [default_] 
/// * [overrides] 
@BuiltValue()
abstract class CommissionOverviewDtoOutput implements Built<CommissionOverviewDtoOutput, CommissionOverviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'default')
  CommissionOverviewDtoOutputDefault? get default_;

  @BuiltValueField(wireName: r'overrides')
  BuiltList<CommissionOverviewDtoOutputOverridesInner> get overrides;

  CommissionOverviewDtoOutput._();

  factory CommissionOverviewDtoOutput([void updates(CommissionOverviewDtoOutputBuilder b)]) = _$CommissionOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionOverviewDtoOutput> get serializer => _$CommissionOverviewDtoOutputSerializer();
}

class _$CommissionOverviewDtoOutputSerializer implements PrimitiveSerializer<CommissionOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [CommissionOverviewDtoOutput, _$CommissionOverviewDtoOutput];

  @override
  final String wireName = r'CommissionOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'default';
    yield object.default_ == null ? null : serializers.serialize(
      object.default_,
      specifiedType: const FullType.nullable(CommissionOverviewDtoOutputDefault),
    );
    yield r'overrides';
    yield serializers.serialize(
      object.overrides,
      specifiedType: const FullType(BuiltList, [FullType(CommissionOverviewDtoOutputOverridesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionOverviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionOverviewDtoOutputDefault),
          ) as CommissionOverviewDtoOutputDefault?;
          if (valueDes == null) continue;
          result.default_.replace(valueDes);
          break;
        case r'overrides':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionOverviewDtoOutputOverridesInner)]),
          ) as BuiltList<CommissionOverviewDtoOutputOverridesInner>;
          result.overrides.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionOverviewDtoOutputBuilder();
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


