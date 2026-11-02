// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_profile_response_dto_output_bank_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorProfileResponseDtoOutputBankAccount
    extends OperatorProfileResponseDtoOutputBankAccount {
  @override
  final String bankName;
  @override
  final String accountNumberMasked;
  @override
  final String accountHolder;
  @override
  final DateTime? verifiedAt;

  factory _$OperatorProfileResponseDtoOutputBankAccount(
          [void Function(OperatorProfileResponseDtoOutputBankAccountBuilder)?
              updates]) =>
      (OperatorProfileResponseDtoOutputBankAccountBuilder()..update(updates))
          ._build();

  _$OperatorProfileResponseDtoOutputBankAccount._(
      {required this.bankName,
      required this.accountNumberMasked,
      required this.accountHolder,
      this.verifiedAt})
      : super._();
  @override
  OperatorProfileResponseDtoOutputBankAccount rebuild(
          void Function(OperatorProfileResponseDtoOutputBankAccountBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorProfileResponseDtoOutputBankAccountBuilder toBuilder() =>
      OperatorProfileResponseDtoOutputBankAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorProfileResponseDtoOutputBankAccount &&
        bankName == other.bankName &&
        accountNumberMasked == other.accountNumberMasked &&
        accountHolder == other.accountHolder &&
        verifiedAt == other.verifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumberMasked.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorProfileResponseDtoOutputBankAccount')
          ..add('bankName', bankName)
          ..add('accountNumberMasked', accountNumberMasked)
          ..add('accountHolder', accountHolder)
          ..add('verifiedAt', verifiedAt))
        .toString();
  }
}

class OperatorProfileResponseDtoOutputBankAccountBuilder
    implements
        Builder<OperatorProfileResponseDtoOutputBankAccount,
            OperatorProfileResponseDtoOutputBankAccountBuilder> {
  _$OperatorProfileResponseDtoOutputBankAccount? _$v;

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

  DateTime? _verifiedAt;
  DateTime? get verifiedAt => _$this._verifiedAt;
  set verifiedAt(DateTime? verifiedAt) => _$this._verifiedAt = verifiedAt;

  OperatorProfileResponseDtoOutputBankAccountBuilder() {
    OperatorProfileResponseDtoOutputBankAccount._defaults(this);
  }

  OperatorProfileResponseDtoOutputBankAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumberMasked = $v.accountNumberMasked;
      _accountHolder = $v.accountHolder;
      _verifiedAt = $v.verifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorProfileResponseDtoOutputBankAccount other) {
    _$v = other as _$OperatorProfileResponseDtoOutputBankAccount;
  }

  @override
  void update(
      void Function(OperatorProfileResponseDtoOutputBankAccountBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorProfileResponseDtoOutputBankAccount build() => _build();

  _$OperatorProfileResponseDtoOutputBankAccount _build() {
    final _$result = _$v ??
        _$OperatorProfileResponseDtoOutputBankAccount._(
          bankName: BuiltValueNullFieldError.checkNotNull(bankName,
              r'OperatorProfileResponseDtoOutputBankAccount', 'bankName'),
          accountNumberMasked: BuiltValueNullFieldError.checkNotNull(
              accountNumberMasked,
              r'OperatorProfileResponseDtoOutputBankAccount',
              'accountNumberMasked'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'OperatorProfileResponseDtoOutputBankAccount', 'accountHolder'),
          verifiedAt: verifiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
