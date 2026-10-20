//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reconciliation_page_dto_output_items_inner_issues_inner.g.dart';

/// ReconciliationPageDtoOutputItemsInnerIssuesInner
///
/// Properties:
/// * [checkpoint]
/// * [entityId]
/// * [operatorId]
/// * [expected]
/// * [actual]
@BuiltValue()
abstract class ReconciliationPageDtoOutputItemsInnerIssuesInner
    implements
        Built<ReconciliationPageDtoOutputItemsInnerIssuesInner,
            ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder> {
  @BuiltValueField(wireName: r'checkpoint')
  String get checkpoint;

  @BuiltValueField(wireName: r'entityId')
  String get entityId;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'expected')
  String get expected;

  @BuiltValueField(wireName: r'actual')
  String get actual;

  ReconciliationPageDtoOutputItemsInnerIssuesInner._();

  factory ReconciliationPageDtoOutputItemsInnerIssuesInner(
          [void updates(
              ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder b)]) =
      _$ReconciliationPageDtoOutputItemsInnerIssuesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReconciliationPageDtoOutputItemsInnerIssuesInner>
      get serializer =>
          _$ReconciliationPageDtoOutputItemsInnerIssuesInnerSerializer();
}

class _$ReconciliationPageDtoOutputItemsInnerIssuesInnerSerializer
    implements
        PrimitiveSerializer<ReconciliationPageDtoOutputItemsInnerIssuesInner> {
  @override
  final Iterable<Type> types = const [
    ReconciliationPageDtoOutputItemsInnerIssuesInner,
    _$ReconciliationPageDtoOutputItemsInnerIssuesInner
  ];

  @override
  final String wireName = r'ReconciliationPageDtoOutputItemsInnerIssuesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReconciliationPageDtoOutputItemsInnerIssuesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkpoint';
    yield serializers.serialize(
      object.checkpoint,
      specifiedType: const FullType(String),
    );
    yield r'entityId';
    yield serializers.serialize(
      object.entityId,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'expected';
    yield serializers.serialize(
      object.expected,
      specifiedType: const FullType(String),
    );
    yield r'actual';
    yield serializers.serialize(
      object.actual,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReconciliationPageDtoOutputItemsInnerIssuesInner object, {
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
    required ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checkpoint = valueDes;
          break;
        case r'entityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityId = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'expected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expected = valueDes;
          break;
        case r'actual':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actual = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReconciliationPageDtoOutputItemsInnerIssuesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReconciliationPageDtoOutputItemsInnerIssuesInnerBuilder();
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
