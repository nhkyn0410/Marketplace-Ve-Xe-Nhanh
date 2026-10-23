//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_input_dto.g.dart';

/// ReportInputDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class ReportInputDto implements Built<ReportInputDto, ReportInputDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  ReportInputDto._();

  factory ReportInputDto([void updates(ReportInputDtoBuilder b)]) = _$ReportInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportInputDto> get serializer => _$ReportInputDtoSerializer();
}

class _$ReportInputDtoSerializer implements PrimitiveSerializer<ReportInputDto> {
  @override
  final Iterable<Type> types = const [ReportInputDto, _$ReportInputDto];

  @override
  final String wireName = r'ReportInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReportInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReportInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  ReportInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportInputDtoBuilder();
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


