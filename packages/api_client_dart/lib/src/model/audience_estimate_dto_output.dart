//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audience_estimate_dto_output.g.dart';

/// AudienceEstimateDtoOutput
///
/// Properties:
/// * [recipients] 
/// * [withPush] 
/// * [optedOut] 
/// * [capped] 
@BuiltValue()
abstract class AudienceEstimateDtoOutput implements Built<AudienceEstimateDtoOutput, AudienceEstimateDtoOutputBuilder> {
  @BuiltValueField(wireName: r'recipients')
  int get recipients;

  @BuiltValueField(wireName: r'withPush')
  int get withPush;

  @BuiltValueField(wireName: r'optedOut')
  int get optedOut;

  @BuiltValueField(wireName: r'capped')
  int get capped;

  AudienceEstimateDtoOutput._();

  factory AudienceEstimateDtoOutput([void updates(AudienceEstimateDtoOutputBuilder b)]) = _$AudienceEstimateDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AudienceEstimateDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AudienceEstimateDtoOutput> get serializer => _$AudienceEstimateDtoOutputSerializer();
}

class _$AudienceEstimateDtoOutputSerializer implements PrimitiveSerializer<AudienceEstimateDtoOutput> {
  @override
  final Iterable<Type> types = const [AudienceEstimateDtoOutput, _$AudienceEstimateDtoOutput];

  @override
  final String wireName = r'AudienceEstimateDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AudienceEstimateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recipients';
    yield serializers.serialize(
      object.recipients,
      specifiedType: const FullType(int),
    );
    yield r'withPush';
    yield serializers.serialize(
      object.withPush,
      specifiedType: const FullType(int),
    );
    yield r'optedOut';
    yield serializers.serialize(
      object.optedOut,
      specifiedType: const FullType(int),
    );
    yield r'capped';
    yield serializers.serialize(
      object.capped,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AudienceEstimateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AudienceEstimateDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recipients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recipients = valueDes;
          break;
        case r'withPush':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withPush = valueDes;
          break;
        case r'optedOut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.optedOut = valueDes;
          break;
        case r'capped':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.capped = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AudienceEstimateDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AudienceEstimateDtoOutputBuilder();
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


