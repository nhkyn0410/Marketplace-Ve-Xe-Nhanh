//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_overview_dto_output_default.g.dart';

/// CommissionOverviewDtoOutputDefault
///
/// Properties:
/// * [rateBps] 
/// * [effectiveFrom] 
@BuiltValue()
abstract class CommissionOverviewDtoOutputDefault implements Built<CommissionOverviewDtoOutputDefault, CommissionOverviewDtoOutputDefaultBuilder> {
  @BuiltValueField(wireName: r'rateBps')
  int get rateBps;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  CommissionOverviewDtoOutputDefault._();

  factory CommissionOverviewDtoOutputDefault([void updates(CommissionOverviewDtoOutputDefaultBuilder b)]) = _$CommissionOverviewDtoOutputDefault;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionOverviewDtoOutputDefaultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionOverviewDtoOutputDefault> get serializer => _$CommissionOverviewDtoOutputDefaultSerializer();
}

class _$CommissionOverviewDtoOutputDefaultSerializer implements PrimitiveSerializer<CommissionOverviewDtoOutputDefault> {
  @override
  final Iterable<Type> types = const [CommissionOverviewDtoOutputDefault, _$CommissionOverviewDtoOutputDefault];

  @override
  final String wireName = r'CommissionOverviewDtoOutputDefault';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionOverviewDtoOutputDefault object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBps';
    yield serializers.serialize(
      object.rateBps,
      specifiedType: const FullType(int),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionOverviewDtoOutputDefault object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionOverviewDtoOutputDefaultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBps = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionOverviewDtoOutputDefault deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionOverviewDtoOutputDefaultBuilder();
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


