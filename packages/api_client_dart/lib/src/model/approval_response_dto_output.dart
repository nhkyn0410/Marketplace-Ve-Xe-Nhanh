//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_response_dto_output.g.dart';

/// ApprovalResponseDtoOutput
///
/// Properties:
/// * [applicationCode] 
/// * [status] 
/// * [operatorId] 
/// * [operatorSlug] 
/// * [ownerUsername] 
/// * [credentialDeliveryPending] 
@BuiltValue()
abstract class ApprovalResponseDtoOutput implements Built<ApprovalResponseDtoOutput, ApprovalResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'applicationCode')
  String get applicationCode;

  @BuiltValueField(wireName: r'status')
  ApprovalResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  APPROVED,  };

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'ownerUsername')
  String get ownerUsername;

  @BuiltValueField(wireName: r'credentialDeliveryPending')
  bool get credentialDeliveryPending;

  ApprovalResponseDtoOutput._();

  factory ApprovalResponseDtoOutput([void updates(ApprovalResponseDtoOutputBuilder b)]) = _$ApprovalResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApprovalResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApprovalResponseDtoOutput> get serializer => _$ApprovalResponseDtoOutputSerializer();
}

class _$ApprovalResponseDtoOutputSerializer implements PrimitiveSerializer<ApprovalResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [ApprovalResponseDtoOutput, _$ApprovalResponseDtoOutput];

  @override
  final String wireName = r'ApprovalResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApprovalResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicationCode';
    yield serializers.serialize(
      object.applicationCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApprovalResponseDtoOutputStatusEnum),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
      specifiedType: const FullType(String),
    );
    yield r'ownerUsername';
    yield serializers.serialize(
      object.ownerUsername,
      specifiedType: const FullType(String),
    );
    yield r'credentialDeliveryPending';
    yield serializers.serialize(
      object.credentialDeliveryPending,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApprovalResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApprovalResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applicationCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.applicationCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApprovalResponseDtoOutputStatusEnum),
          ) as ApprovalResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
          break;
        case r'ownerUsername':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerUsername = valueDes;
          break;
        case r'credentialDeliveryPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.credentialDeliveryPending = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApprovalResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApprovalResponseDtoOutputBuilder();
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


class ApprovalResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const ApprovalResponseDtoOutputStatusEnum APPROVED = _$approvalResponseDtoOutputStatusEnum_APPROVED;

  static Serializer<ApprovalResponseDtoOutputStatusEnum> get serializer => _$approvalResponseDtoOutputStatusEnumSerializer;

  const ApprovalResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<ApprovalResponseDtoOutputStatusEnum> get values => _$approvalResponseDtoOutputStatusEnumValues;
  static ApprovalResponseDtoOutputStatusEnum valueOf(String name) => _$approvalResponseDtoOutputStatusEnumValueOf(name);
}

