//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_payment_methods_inner.g.dart';

/// AdminReportDtoOutputPaymentMethodsInner
///
/// Properties:
/// * [provider] 
/// * [amount] 
/// * [count] 
@BuiltValue()
abstract class AdminReportDtoOutputPaymentMethodsInner implements Built<AdminReportDtoOutputPaymentMethodsInner, AdminReportDtoOutputPaymentMethodsInnerBuilder> {
  @BuiltValueField(wireName: r'provider')
  AdminReportDtoOutputPaymentMethodsInnerProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  PAYOS,  DEMO,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'count')
  int get count;

  AdminReportDtoOutputPaymentMethodsInner._();

  factory AdminReportDtoOutputPaymentMethodsInner([void updates(AdminReportDtoOutputPaymentMethodsInnerBuilder b)]) = _$AdminReportDtoOutputPaymentMethodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputPaymentMethodsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputPaymentMethodsInner> get serializer => _$AdminReportDtoOutputPaymentMethodsInnerSerializer();
}

class _$AdminReportDtoOutputPaymentMethodsInnerSerializer implements PrimitiveSerializer<AdminReportDtoOutputPaymentMethodsInner> {
  @override
  final Iterable<Type> types = const [AdminReportDtoOutputPaymentMethodsInner, _$AdminReportDtoOutputPaymentMethodsInner];

  @override
  final String wireName = r'AdminReportDtoOutputPaymentMethodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputPaymentMethodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(AdminReportDtoOutputPaymentMethodsInnerProviderEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputPaymentMethodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportDtoOutputPaymentMethodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminReportDtoOutputPaymentMethodsInnerProviderEnum),
          ) as AdminReportDtoOutputPaymentMethodsInnerProviderEnum;
          result.provider = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputPaymentMethodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputPaymentMethodsInnerBuilder();
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


class AdminReportDtoOutputPaymentMethodsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const AdminReportDtoOutputPaymentMethodsInnerProviderEnum VNPAY = _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const AdminReportDtoOutputPaymentMethodsInnerProviderEnum MOMO = _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_MOMO;
  @BuiltValueEnumConst(wireName: r'PAYOS')
  static const AdminReportDtoOutputPaymentMethodsInnerProviderEnum PAYOS = _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_PAYOS;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const AdminReportDtoOutputPaymentMethodsInnerProviderEnum DEMO = _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_DEMO;

  static Serializer<AdminReportDtoOutputPaymentMethodsInnerProviderEnum> get serializer => _$adminReportDtoOutputPaymentMethodsInnerProviderEnumSerializer;

  const AdminReportDtoOutputPaymentMethodsInnerProviderEnum._(String name): super(name);

  static BuiltSet<AdminReportDtoOutputPaymentMethodsInnerProviderEnum> get values => _$adminReportDtoOutputPaymentMethodsInnerProviderEnumValues;
  static AdminReportDtoOutputPaymentMethodsInnerProviderEnum valueOf(String name) => _$adminReportDtoOutputPaymentMethodsInnerProviderEnumValueOf(name);
}

