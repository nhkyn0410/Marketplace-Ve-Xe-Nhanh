//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output_escrow.g.dart';

/// AdminOverviewDtoOutputEscrow
///
/// Properties:
/// * [held] 
/// * [eligible] 
/// * [pending] 
/// * [onHold] 
/// * [commissionInRange] 
@BuiltValue()
abstract class AdminOverviewDtoOutputEscrow implements Built<AdminOverviewDtoOutputEscrow, AdminOverviewDtoOutputEscrowBuilder> {
  @BuiltValueField(wireName: r'held')
  int get held;

  @BuiltValueField(wireName: r'eligible')
  int get eligible;

  @BuiltValueField(wireName: r'pending')
  int get pending;

  @BuiltValueField(wireName: r'onHold')
  int get onHold;

  @BuiltValueField(wireName: r'commissionInRange')
  int get commissionInRange;

  AdminOverviewDtoOutputEscrow._();

  factory AdminOverviewDtoOutputEscrow([void updates(AdminOverviewDtoOutputEscrowBuilder b)]) = _$AdminOverviewDtoOutputEscrow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputEscrowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutputEscrow> get serializer => _$AdminOverviewDtoOutputEscrowSerializer();
}

class _$AdminOverviewDtoOutputEscrowSerializer implements PrimitiveSerializer<AdminOverviewDtoOutputEscrow> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutputEscrow, _$AdminOverviewDtoOutputEscrow];

  @override
  final String wireName = r'AdminOverviewDtoOutputEscrow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutputEscrow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'held';
    yield serializers.serialize(
      object.held,
      specifiedType: const FullType(int),
    );
    yield r'eligible';
    yield serializers.serialize(
      object.eligible,
      specifiedType: const FullType(int),
    );
    yield r'pending';
    yield serializers.serialize(
      object.pending,
      specifiedType: const FullType(int),
    );
    yield r'onHold';
    yield serializers.serialize(
      object.onHold,
      specifiedType: const FullType(int),
    );
    yield r'commissionInRange';
    yield serializers.serialize(
      object.commissionInRange,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutputEscrow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputEscrowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'held':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.held = valueDes;
          break;
        case r'eligible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.eligible = valueDes;
          break;
        case r'pending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pending = valueDes;
          break;
        case r'onHold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onHold = valueDes;
          break;
        case r'commissionInRange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionInRange = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutputEscrow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputEscrowBuilder();
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


