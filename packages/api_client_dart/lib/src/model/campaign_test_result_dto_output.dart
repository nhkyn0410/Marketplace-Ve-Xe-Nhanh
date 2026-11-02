//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_test_result_dto_output.g.dart';

/// CampaignTestResultDtoOutput
///
/// Properties:
/// * [pushDevices] 
@BuiltValue()
abstract class CampaignTestResultDtoOutput implements Built<CampaignTestResultDtoOutput, CampaignTestResultDtoOutputBuilder> {
  @BuiltValueField(wireName: r'pushDevices')
  int get pushDevices;

  CampaignTestResultDtoOutput._();

  factory CampaignTestResultDtoOutput([void updates(CampaignTestResultDtoOutputBuilder b)]) = _$CampaignTestResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignTestResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignTestResultDtoOutput> get serializer => _$CampaignTestResultDtoOutputSerializer();
}

class _$CampaignTestResultDtoOutputSerializer implements PrimitiveSerializer<CampaignTestResultDtoOutput> {
  @override
  final Iterable<Type> types = const [CampaignTestResultDtoOutput, _$CampaignTestResultDtoOutput];

  @override
  final String wireName = r'CampaignTestResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignTestResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pushDevices';
    yield serializers.serialize(
      object.pushDevices,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignTestResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignTestResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pushDevices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pushDevices = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignTestResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignTestResultDtoOutputBuilder();
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


