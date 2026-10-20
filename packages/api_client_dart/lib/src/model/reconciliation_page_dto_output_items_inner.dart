//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/reconciliation_page_dto_output_items_inner_issues_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reconciliation_page_dto_output_items_inner.g.dart';

/// ReconciliationPageDtoOutputItemsInner
///
/// Properties:
/// * [runId]
/// * [source_]
/// * [status]
/// * [checkpoint]
/// * [paymentsChecked]
/// * [paymentErrors]
/// * [ledgerEntriesChecked]
/// * [payoutsChecked]
/// * [issueCount]
/// * [issues]
/// * [error]
/// * [startedAt]
/// * [finishedAt]
/// * [createdAt]
@BuiltValue()
abstract class ReconciliationPageDtoOutputItemsInner
    implements
        Built<ReconciliationPageDtoOutputItemsInner,
            ReconciliationPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'runId')
  String get runId;

  @BuiltValueField(wireName: r'source')
  ReconciliationPageDtoOutputItemsInnerSource_Enum get source_;
  // enum source_Enum {  MANUAL,  SCHEDULED,  };

  @BuiltValueField(wireName: r'status')
  ReconciliationPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  QUEUED,  RUNNING,  COMPLETED,  FAILED,  };

  @BuiltValueField(wireName: r'checkpoint')
  String get checkpoint;

  @BuiltValueField(wireName: r'paymentsChecked')
  int get paymentsChecked;

  @BuiltValueField(wireName: r'paymentErrors')
  int get paymentErrors;

  @BuiltValueField(wireName: r'ledgerEntriesChecked')
  int get ledgerEntriesChecked;

  @BuiltValueField(wireName: r'payoutsChecked')
  int get payoutsChecked;

  @BuiltValueField(wireName: r'issueCount')
  int get issueCount;

  @BuiltValueField(wireName: r'issues')
  BuiltList<ReconciliationPageDtoOutputItemsInnerIssuesInner> get issues;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'finishedAt')
  DateTime? get finishedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ReconciliationPageDtoOutputItemsInner._();

  factory ReconciliationPageDtoOutputItemsInner(
          [void updates(ReconciliationPageDtoOutputItemsInnerBuilder b)]) =
      _$ReconciliationPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReconciliationPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReconciliationPageDtoOutputItemsInner> get serializer =>
      _$ReconciliationPageDtoOutputItemsInnerSerializer();
}

class _$ReconciliationPageDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<ReconciliationPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    ReconciliationPageDtoOutputItemsInner,
    _$ReconciliationPageDtoOutputItemsInner
  ];

  @override
  final String wireName = r'ReconciliationPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReconciliationPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'runId';
    yield serializers.serialize(
      object.runId,
      specifiedType: const FullType(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType:
          const FullType(ReconciliationPageDtoOutputItemsInnerSource_Enum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(ReconciliationPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'checkpoint';
    yield serializers.serialize(
      object.checkpoint,
      specifiedType: const FullType(String),
    );
    yield r'paymentsChecked';
    yield serializers.serialize(
      object.paymentsChecked,
      specifiedType: const FullType(int),
    );
    yield r'paymentErrors';
    yield serializers.serialize(
      object.paymentErrors,
      specifiedType: const FullType(int),
    );
    yield r'ledgerEntriesChecked';
    yield serializers.serialize(
      object.ledgerEntriesChecked,
      specifiedType: const FullType(int),
    );
    yield r'payoutsChecked';
    yield serializers.serialize(
      object.payoutsChecked,
      specifiedType: const FullType(int),
    );
    yield r'issueCount';
    yield serializers.serialize(
      object.issueCount,
      specifiedType: const FullType(int),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList,
          [FullType(ReconciliationPageDtoOutputItemsInnerIssuesInner)]),
    );
    yield r'error';
    yield object.error == null
        ? null
        : serializers.serialize(
            object.error,
            specifiedType: const FullType.nullable(String),
          );
    yield r'startedAt';
    yield object.startedAt == null
        ? null
        : serializers.serialize(
            object.startedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'finishedAt';
    yield object.finishedAt == null
        ? null
        : serializers.serialize(
            object.finishedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReconciliationPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReconciliationPageDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'runId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.runId = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                ReconciliationPageDtoOutputItemsInnerSource_Enum),
          ) as ReconciliationPageDtoOutputItemsInnerSource_Enum;
          result.source_ = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ReconciliationPageDtoOutputItemsInnerStatusEnum),
          ) as ReconciliationPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'checkpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checkpoint = valueDes;
          break;
        case r'paymentsChecked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentsChecked = valueDes;
          break;
        case r'paymentErrors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentErrors = valueDes;
          break;
        case r'ledgerEntriesChecked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ledgerEntriesChecked = valueDes;
          break;
        case r'payoutsChecked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payoutsChecked = valueDes;
          break;
        case r'issueCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.issueCount = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(ReconciliationPageDtoOutputItemsInnerIssuesInner)]),
          ) as BuiltList<ReconciliationPageDtoOutputItemsInnerIssuesInner>;
          result.issues.replace(valueDes);
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'finishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.finishedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReconciliationPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReconciliationPageDtoOutputItemsInnerBuilder();
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

class ReconciliationPageDtoOutputItemsInnerSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const ReconciliationPageDtoOutputItemsInnerSource_Enum MANUAL =
      _$reconciliationPageDtoOutputItemsInnerSourceEnum_MANUAL;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const ReconciliationPageDtoOutputItemsInnerSource_Enum SCHEDULED =
      _$reconciliationPageDtoOutputItemsInnerSourceEnum_SCHEDULED;

  static Serializer<ReconciliationPageDtoOutputItemsInnerSource_Enum>
      get serializer =>
          _$reconciliationPageDtoOutputItemsInnerSourceEnumSerializer;

  const ReconciliationPageDtoOutputItemsInnerSource_Enum._(String name)
      : super(name);

  static BuiltSet<ReconciliationPageDtoOutputItemsInnerSource_Enum>
      get values => _$reconciliationPageDtoOutputItemsInnerSourceEnumValues;
  static ReconciliationPageDtoOutputItemsInnerSource_Enum valueOf(
          String name) =>
      _$reconciliationPageDtoOutputItemsInnerSourceEnumValueOf(name);
}

class ReconciliationPageDtoOutputItemsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'QUEUED')
  static const ReconciliationPageDtoOutputItemsInnerStatusEnum QUEUED =
      _$reconciliationPageDtoOutputItemsInnerStatusEnum_QUEUED;
  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const ReconciliationPageDtoOutputItemsInnerStatusEnum RUNNING =
      _$reconciliationPageDtoOutputItemsInnerStatusEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const ReconciliationPageDtoOutputItemsInnerStatusEnum COMPLETED =
      _$reconciliationPageDtoOutputItemsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const ReconciliationPageDtoOutputItemsInnerStatusEnum FAILED =
      _$reconciliationPageDtoOutputItemsInnerStatusEnum_FAILED;

  static Serializer<ReconciliationPageDtoOutputItemsInnerStatusEnum>
      get serializer =>
          _$reconciliationPageDtoOutputItemsInnerStatusEnumSerializer;

  const ReconciliationPageDtoOutputItemsInnerStatusEnum._(String name)
      : super(name);

  static BuiltSet<ReconciliationPageDtoOutputItemsInnerStatusEnum> get values =>
      _$reconciliationPageDtoOutputItemsInnerStatusEnumValues;
  static ReconciliationPageDtoOutputItemsInnerStatusEnum valueOf(String name) =>
      _$reconciliationPageDtoOutputItemsInnerStatusEnumValueOf(name);
}
