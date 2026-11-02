//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/application_update_input_dto_documents_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_update_input_dto.g.dart';

/// ApplicationUpdateInputDto
///
/// Properties:
/// * [legalName] 
/// * [taxCode] 
/// * [hotline] 
/// * [address] 
/// * [displayName] 
/// * [description] 
/// * [bankName] 
/// * [bankAccountNumber] 
/// * [bankAccountHolder] 
/// * [documents] 
@BuiltValue()
abstract class ApplicationUpdateInputDto implements Built<ApplicationUpdateInputDto, ApplicationUpdateInputDtoBuilder> {
  @BuiltValueField(wireName: r'legalName')
  String? get legalName;

  @BuiltValueField(wireName: r'taxCode')
  String? get taxCode;

  @BuiltValueField(wireName: r'hotline')
  String? get hotline;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'bankName')
  String? get bankName;

  @BuiltValueField(wireName: r'bankAccountNumber')
  String? get bankAccountNumber;

  @BuiltValueField(wireName: r'bankAccountHolder')
  String? get bankAccountHolder;

  @BuiltValueField(wireName: r'documents')
  BuiltList<ApplicationUpdateInputDtoDocumentsInner> get documents;

  ApplicationUpdateInputDto._();

  factory ApplicationUpdateInputDto([void updates(ApplicationUpdateInputDtoBuilder b)]) = _$ApplicationUpdateInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApplicationUpdateInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApplicationUpdateInputDto> get serializer => _$ApplicationUpdateInputDtoSerializer();
}

class _$ApplicationUpdateInputDtoSerializer implements PrimitiveSerializer<ApplicationUpdateInputDto> {
  @override
  final Iterable<Type> types = const [ApplicationUpdateInputDto, _$ApplicationUpdateInputDto];

  @override
  final String wireName = r'ApplicationUpdateInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApplicationUpdateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'hotline';
    yield object.hotline == null ? null : serializers.serialize(
      object.hotline,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(String),
    );
    yield r'displayName';
    yield object.displayName == null ? null : serializers.serialize(
      object.displayName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bankName';
    yield object.bankName == null ? null : serializers.serialize(
      object.bankName,
      specifiedType: const FullType.nullable(String),
    );
    if (object.bankAccountNumber != null) {
      yield r'bankAccountNumber';
      yield serializers.serialize(
        object.bankAccountNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'bankAccountHolder';
    yield object.bankAccountHolder == null ? null : serializers.serialize(
      object.bankAccountHolder,
      specifiedType: const FullType.nullable(String),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [FullType(ApplicationUpdateInputDtoDocumentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApplicationUpdateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApplicationUpdateInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'hotline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hotline = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'bankName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankName = valueDes;
          break;
        case r'bankAccountNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankAccountNumber = valueDes;
          break;
        case r'bankAccountHolder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankAccountHolder = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApplicationUpdateInputDtoDocumentsInner)]),
          ) as BuiltList<ApplicationUpdateInputDtoDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApplicationUpdateInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApplicationUpdateInputDtoBuilder();
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


