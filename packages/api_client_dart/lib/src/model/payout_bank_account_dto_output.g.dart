// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_bank_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutBankAccountDtoOutput extends PayoutBankAccountDtoOutput {
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolder;

  factory _$PayoutBankAccountDtoOutput(
          [void Function(PayoutBankAccountDtoOutputBuilder)? updates]) =>
      (PayoutBankAccountDtoOutputBuilder()..update(updates))._build();

  _$PayoutBankAccountDtoOutput._(
      {required this.bankName,
      required this.accountNumber,
      required this.accountHolder})
      : super._();
  @override
  PayoutBankAccountDtoOutput rebuild(
          void Function(PayoutBankAccountDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutBankAccountDtoOutputBuilder toBuilder() =>
      PayoutBankAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutBankAccountDtoOutput &&
        bankName == other.bankName &&
        accountNumber == other.accountNumber &&
        accountHolder == other.accountHolder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutBankAccountDtoOutput')
          ..add('bankName', bankName)
          ..add('accountNumber', accountNumber)
          ..add('accountHolder', accountHolder))
        .toString();
  }
}

class PayoutBankAccountDtoOutputBuilder
    implements
        Builder<PayoutBankAccountDtoOutput, PayoutBankAccountDtoOutputBuilder> {
  _$PayoutBankAccountDtoOutput? _$v;

  String? _bankName;
  String? get bankName => _$this._bankName;
  set bankName(String? bankName) => _$this._bankName = bankName;

  String? _accountNumber;
  String? get accountNumber => _$this._accountNumber;
  set accountNumber(String? accountNumber) =>
      _$this._accountNumber = accountNumber;

  String? _accountHolder;
  String? get accountHolder => _$this._accountHolder;
  set accountHolder(String? accountHolder) =>
      _$this._accountHolder = accountHolder;

  PayoutBankAccountDtoOutputBuilder() {
    PayoutBankAccountDtoOutput._defaults(this);
  }

  PayoutBankAccountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumber = $v.accountNumber;
      _accountHolder = $v.accountHolder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutBankAccountDtoOutput other) {
    _$v = other as _$PayoutBankAccountDtoOutput;
  }

  @override
  void update(void Function(PayoutBankAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutBankAccountDtoOutput build() => _build();

  _$PayoutBankAccountDtoOutput _build() {
    final _$result = _$v ??
        _$PayoutBankAccountDtoOutput._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'PayoutBankAccountDtoOutput', 'bankName'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(
              accountNumber, r'PayoutBankAccountDtoOutput', 'accountNumber'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(
              accountHolder, r'PayoutBankAccountDtoOutput', 'accountHolder'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
