//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_bank_change_dto_output_requested.dart';
import 'package:api_client_dart/src/model/admin_operator_detail_dto_output_bank_account.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bank_change_dto_output.g.dart';

/// AdminBankChangeDtoOutput
///
/// Properties:
/// * [changeId] 
/// * [operatorName] 
/// * [legalName] 
/// * [taxCode] 
/// * [current] 
/// * [requested] 
@BuiltValue()
abstract class AdminBankChangeDtoOutput implements Built<AdminBankChangeDtoOutput, AdminBankChangeDtoOutputBuilder> {
  @BuiltValueField(wireName: r'changeId')
  String get changeId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'legalName')
  String? get legalName;

  @BuiltValueField(wireName: r'taxCode')
  String? get taxCode;

  @BuiltValueField(wireName: r'current')
  AdminOperatorDetailDtoOutputBankAccount? get current;

  @BuiltValueField(wireName: r'requested')
  AdminBankChangeDtoOutputRequested get requested;

  AdminBankChangeDtoOutput._();

  factory AdminBankChangeDtoOutput([void updates(AdminBankChangeDtoOutputBuilder b)]) = _$AdminBankChangeDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBankChangeDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBankChangeDtoOutput> get serializer => _$AdminBankChangeDtoOutputSerializer();
}

class _$AdminBankChangeDtoOutputSerializer implements PrimitiveSerializer<AdminBankChangeDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminBankChangeDtoOutput, _$AdminBankChangeDtoOutput];

  @override
  final String wireName = r'AdminBankChangeDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBankChangeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changeId';
    yield serializers.serialize(
      object.changeId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'legalName';
    yield object.legalName == null ? null : serializers.serialize(
      object.legalName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'taxCode';
    yield object.taxCode == null ? null : serializers.serialize(
      object.taxCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'current';
    yield object.current == null ? null : serializers.serialize(
      object.current,
      specifiedType: const FullType.nullable(AdminOperatorDetailDtoOutputBankAccount),
    );
    yield r'requested';
    yield serializers.serialize(
      object.requested,
      specifiedType: const FullType(AdminBankChangeDtoOutputRequested),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBankChangeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminBankChangeDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.changeId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'legalName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalName = valueDes;
          break;
        case r'taxCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxCode = valueDes;
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOperatorDetailDtoOutputBankAccount),
          ) as AdminOperatorDetailDtoOutputBankAccount?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'requested':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminBankChangeDtoOutputRequested),
          ) as AdminBankChangeDtoOutputRequested;
          result.requested.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBankChangeDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBankChangeDtoOutputBuilder();
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


