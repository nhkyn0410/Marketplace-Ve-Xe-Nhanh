// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_payment_methods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReportDtoOutputPaymentMethodsInnerProviderEnum
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_VNPAY =
    const AdminReportDtoOutputPaymentMethodsInnerProviderEnum._('VNPAY');
const AdminReportDtoOutputPaymentMethodsInnerProviderEnum
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_MOMO =
    const AdminReportDtoOutputPaymentMethodsInnerProviderEnum._('MOMO');
const AdminReportDtoOutputPaymentMethodsInnerProviderEnum
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_PAYOS =
    const AdminReportDtoOutputPaymentMethodsInnerProviderEnum._('PAYOS');
const AdminReportDtoOutputPaymentMethodsInnerProviderEnum
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_DEMO =
    const AdminReportDtoOutputPaymentMethodsInnerProviderEnum._('DEMO');

AdminReportDtoOutputPaymentMethodsInnerProviderEnum
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_VNPAY;
    case 'MOMO':
      return _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_MOMO;
    case 'PAYOS':
      return _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_PAYOS;
    case 'DEMO':
      return _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReportDtoOutputPaymentMethodsInnerProviderEnum>
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnumValues = BuiltSet<
        AdminReportDtoOutputPaymentMethodsInnerProviderEnum>(const <AdminReportDtoOutputPaymentMethodsInnerProviderEnum>[
  _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_VNPAY,
  _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_MOMO,
  _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_PAYOS,
  _$adminReportDtoOutputPaymentMethodsInnerProviderEnum_DEMO,
]);

Serializer<AdminReportDtoOutputPaymentMethodsInnerProviderEnum>
    _$adminReportDtoOutputPaymentMethodsInnerProviderEnumSerializer =
    _$AdminReportDtoOutputPaymentMethodsInnerProviderEnumSerializer();

class _$AdminReportDtoOutputPaymentMethodsInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<
            AdminReportDtoOutputPaymentMethodsInnerProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
    'PAYOS': 'PAYOS',
    'DEMO': 'DEMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
    'PAYOS': 'PAYOS',
    'DEMO': 'DEMO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminReportDtoOutputPaymentMethodsInnerProviderEnum
  ];
  @override
  final String wireName = 'AdminReportDtoOutputPaymentMethodsInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminReportDtoOutputPaymentMethodsInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminReportDtoOutputPaymentMethodsInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminReportDtoOutputPaymentMethodsInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminReportDtoOutputPaymentMethodsInner
    extends AdminReportDtoOutputPaymentMethodsInner {
  @override
  final AdminReportDtoOutputPaymentMethodsInnerProviderEnum provider;
  @override
  final int amount;
  @override
  final int count;

  factory _$AdminReportDtoOutputPaymentMethodsInner(
          [void Function(AdminReportDtoOutputPaymentMethodsInnerBuilder)?
              updates]) =>
      (AdminReportDtoOutputPaymentMethodsInnerBuilder()..update(updates))
          ._build();

  _$AdminReportDtoOutputPaymentMethodsInner._(
      {required this.provider, required this.amount, required this.count})
      : super._();
  @override
  AdminReportDtoOutputPaymentMethodsInner rebuild(
          void Function(AdminReportDtoOutputPaymentMethodsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputPaymentMethodsInnerBuilder toBuilder() =>
      AdminReportDtoOutputPaymentMethodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputPaymentMethodsInner &&
        provider == other.provider &&
        amount == other.amount &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminReportDtoOutputPaymentMethodsInner')
          ..add('provider', provider)
          ..add('amount', amount)
          ..add('count', count))
        .toString();
  }
}

class AdminReportDtoOutputPaymentMethodsInnerBuilder
    implements
        Builder<AdminReportDtoOutputPaymentMethodsInner,
            AdminReportDtoOutputPaymentMethodsInnerBuilder> {
  _$AdminReportDtoOutputPaymentMethodsInner? _$v;

  AdminReportDtoOutputPaymentMethodsInnerProviderEnum? _provider;
  AdminReportDtoOutputPaymentMethodsInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(AdminReportDtoOutputPaymentMethodsInnerProviderEnum? provider) =>
      _$this._provider = provider;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  AdminReportDtoOutputPaymentMethodsInnerBuilder() {
    AdminReportDtoOutputPaymentMethodsInner._defaults(this);
  }

  AdminReportDtoOutputPaymentMethodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _amount = $v.amount;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputPaymentMethodsInner other) {
    _$v = other as _$AdminReportDtoOutputPaymentMethodsInner;
  }

  @override
  void update(
      void Function(AdminReportDtoOutputPaymentMethodsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputPaymentMethodsInner build() => _build();

  _$AdminReportDtoOutputPaymentMethodsInner _build() {
    final _$result = _$v ??
        _$AdminReportDtoOutputPaymentMethodsInner._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'AdminReportDtoOutputPaymentMethodsInner', 'provider'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'AdminReportDtoOutputPaymentMethodsInner', 'amount'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'AdminReportDtoOutputPaymentMethodsInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
