// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_page_dto_output_items_inner_bank.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutPageDtoOutputItemsInnerBank
    extends PayoutPageDtoOutputItemsInnerBank {
  @override
  final String bankName;
  @override
  final String accountNumberMasked;
  @override
  final String accountHolder;

  factory _$PayoutPageDtoOutputItemsInnerBank(
          [void Function(PayoutPageDtoOutputItemsInnerBankBuilder)? updates]) =>
      (PayoutPageDtoOutputItemsInnerBankBuilder()..update(updates))._build();

  _$PayoutPageDtoOutputItemsInnerBank._(
      {required this.bankName,
      required this.accountNumberMasked,
      required this.accountHolder})
      : super._();
  @override
  PayoutPageDtoOutputItemsInnerBank rebuild(
          void Function(PayoutPageDtoOutputItemsInnerBankBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutPageDtoOutputItemsInnerBankBuilder toBuilder() =>
      PayoutPageDtoOutputItemsInnerBankBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutPageDtoOutputItemsInnerBank &&
        bankName == other.bankName &&
        accountNumberMasked == other.accountNumberMasked &&
        accountHolder == other.accountHolder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumberMasked.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutPageDtoOutputItemsInnerBank')
          ..add('bankName', bankName)
          ..add('accountNumberMasked', accountNumberMasked)
          ..add('accountHolder', accountHolder))
        .toString();
  }
}

class PayoutPageDtoOutputItemsInnerBankBuilder
    implements
        Builder<PayoutPageDtoOutputItemsInnerBank,
            PayoutPageDtoOutputItemsInnerBankBuilder> {
  _$PayoutPageDtoOutputItemsInnerBank? _$v;

  String? _bankName;
  String? get bankName => _$this._bankName;
  set bankName(String? bankName) => _$this._bankName = bankName;

  String? _accountNumberMasked;
  String? get accountNumberMasked => _$this._accountNumberMasked;
  set accountNumberMasked(String? accountNumberMasked) =>
      _$this._accountNumberMasked = accountNumberMasked;

  String? _accountHolder;
  String? get accountHolder => _$this._accountHolder;
  set accountHolder(String? accountHolder) =>
      _$this._accountHolder = accountHolder;

  PayoutPageDtoOutputItemsInnerBankBuilder() {
    PayoutPageDtoOutputItemsInnerBank._defaults(this);
  }

  PayoutPageDtoOutputItemsInnerBankBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumberMasked = $v.accountNumberMasked;
      _accountHolder = $v.accountHolder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutPageDtoOutputItemsInnerBank other) {
    _$v = other as _$PayoutPageDtoOutputItemsInnerBank;
  }

  @override
  void update(
      void Function(PayoutPageDtoOutputItemsInnerBankBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutPageDtoOutputItemsInnerBank build() => _build();

  _$PayoutPageDtoOutputItemsInnerBank _build() {
    final _$result = _$v ??
        _$PayoutPageDtoOutputItemsInnerBank._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'PayoutPageDtoOutputItemsInnerBank', 'bankName'),
          accountNumberMasked: BuiltValueNullFieldError.checkNotNull(
              accountNumberMasked,
              r'PayoutPageDtoOutputItemsInnerBank',
              'accountNumberMasked'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'PayoutPageDtoOutputItemsInnerBank', 'accountHolder'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
