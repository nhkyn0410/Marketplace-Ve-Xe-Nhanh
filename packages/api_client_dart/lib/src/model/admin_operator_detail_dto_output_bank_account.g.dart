// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_detail_dto_output_bank_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorDetailDtoOutputBankAccount
    extends AdminOperatorDetailDtoOutputBankAccount {
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolder;
  @override
  final DateTime? verifiedAt;

  factory _$AdminOperatorDetailDtoOutputBankAccount(
          [void Function(AdminOperatorDetailDtoOutputBankAccountBuilder)?
              updates]) =>
      (AdminOperatorDetailDtoOutputBankAccountBuilder()..update(updates))
          ._build();

  _$AdminOperatorDetailDtoOutputBankAccount._(
      {required this.bankName,
      required this.accountNumber,
      required this.accountHolder,
      this.verifiedAt})
      : super._();
  @override
  AdminOperatorDetailDtoOutputBankAccount rebuild(
          void Function(AdminOperatorDetailDtoOutputBankAccountBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorDetailDtoOutputBankAccountBuilder toBuilder() =>
      AdminOperatorDetailDtoOutputBankAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorDetailDtoOutputBankAccount &&
        bankName == other.bankName &&
        accountNumber == other.accountNumber &&
        accountHolder == other.accountHolder &&
        verifiedAt == other.verifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOperatorDetailDtoOutputBankAccount')
          ..add('bankName', bankName)
          ..add('accountNumber', accountNumber)
          ..add('accountHolder', accountHolder)
          ..add('verifiedAt', verifiedAt))
        .toString();
  }
}

class AdminOperatorDetailDtoOutputBankAccountBuilder
    implements
        Builder<AdminOperatorDetailDtoOutputBankAccount,
            AdminOperatorDetailDtoOutputBankAccountBuilder> {
  _$AdminOperatorDetailDtoOutputBankAccount? _$v;

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

  DateTime? _verifiedAt;
  DateTime? get verifiedAt => _$this._verifiedAt;
  set verifiedAt(DateTime? verifiedAt) => _$this._verifiedAt = verifiedAt;

  AdminOperatorDetailDtoOutputBankAccountBuilder() {
    AdminOperatorDetailDtoOutputBankAccount._defaults(this);
  }

  AdminOperatorDetailDtoOutputBankAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumber = $v.accountNumber;
      _accountHolder = $v.accountHolder;
      _verifiedAt = $v.verifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorDetailDtoOutputBankAccount other) {
    _$v = other as _$AdminOperatorDetailDtoOutputBankAccount;
  }

  @override
  void update(
      void Function(AdminOperatorDetailDtoOutputBankAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorDetailDtoOutputBankAccount build() => _build();

  _$AdminOperatorDetailDtoOutputBankAccount _build() {
    final _$result = _$v ??
        _$AdminOperatorDetailDtoOutputBankAccount._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'AdminOperatorDetailDtoOutputBankAccount', 'bankName'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(accountNumber,
              r'AdminOperatorDetailDtoOutputBankAccount', 'accountNumber'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'AdminOperatorDetailDtoOutputBankAccount', 'accountHolder'),
          verifiedAt: verifiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
