//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_input_dto.g.dart';

/// CancellationInputDto
///
/// Properties:
/// * [ticketIds] 
/// * [expectedRefund] 
/// * [reason] 
@BuiltValue()
abstract class CancellationInputDto implements Built<CancellationInputDto, CancellationInputDtoBuilder> {
  @BuiltValueField(wireName: r'ticketIds')
  BuiltList<String> get ticketIds;

  @BuiltValueField(wireName: r'expectedRefund')
  int get expectedRefund;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CancellationInputDto._();

  factory CancellationInputDto([void updates(CancellationInputDtoBuilder b)]) = _$CancellationInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationInputDto> get serializer => _$CancellationInputDtoSerializer();
}

class _$CancellationInputDtoSerializer implements PrimitiveSerializer<CancellationInputDto> {
  @override
  final Iterable<Type> types = const [CancellationInputDto, _$CancellationInputDto];

  @override
  final String wireName = r'CancellationInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketIds';
    yield serializers.serialize(
      object.ticketIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'expectedRefund';
    yield serializers.serialize(
      object.expectedRefund,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.ticketIds.replace(valueDes);
          break;
        case r'expectedRefund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRefund = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationInputDtoBuilder();
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


