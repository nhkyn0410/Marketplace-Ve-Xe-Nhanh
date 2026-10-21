// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bank_change_dto_output_current.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBankChangeDtoOutputCurrent
    extends AdminBankChangeDtoOutputCurrent {
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolder;
  @override
  final DateTime? verifiedAt;

  factory _$AdminBankChangeDtoOutputCurrent(
          [void Function(AdminBankChangeDtoOutputCurrentBuilder)? updates]) =>
      (AdminBankChangeDtoOutputCurrentBuilder()..update(updates))._build();

  _$AdminBankChangeDtoOutputCurrent._(
      {required this.bankName,
      required this.accountNumber,
      required this.accountHolder,
      this.verifiedAt})
      : super._();
  @override
  AdminBankChangeDtoOutputCurrent rebuild(
          void Function(AdminBankChangeDtoOutputCurrentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminBankChangeDtoOutputCurrentBuilder toBuilder() =>
      AdminBankChangeDtoOutputCurrentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBankChangeDtoOutputCurrent &&
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
    return (newBuiltValueToStringHelper(r'AdminBankChangeDtoOutputCurrent')
          ..add('bankName', bankName)
          ..add('accountNumber', accountNumber)
          ..add('accountHolder', accountHolder)
          ..add('verifiedAt', verifiedAt))
        .toString();
  }
}

class AdminBankChangeDtoOutputCurrentBuilder
    implements
        Builder<AdminBankChangeDtoOutputCurrent,
            AdminBankChangeDtoOutputCurrentBuilder> {
  _$AdminBankChangeDtoOutputCurrent? _$v;

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

  AdminBankChangeDtoOutputCurrentBuilder() {
    AdminBankChangeDtoOutputCurrent._defaults(this);
  }

  AdminBankChangeDtoOutputCurrentBuilder get _$this {
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
  void replace(AdminBankChangeDtoOutputCurrent other) {
    _$v = other as _$AdminBankChangeDtoOutputCurrent;
  }

  @override
  void update(void Function(AdminBankChangeDtoOutputCurrentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBankChangeDtoOutputCurrent build() => _build();

  _$AdminBankChangeDtoOutputCurrent _build() {
    final _$result = _$v ??
        _$AdminBankChangeDtoOutputCurrent._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'AdminBankChangeDtoOutputCurrent', 'bankName'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(accountNumber,
              r'AdminBankChangeDtoOutputCurrent', 'accountNumber'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'AdminBankChangeDtoOutputCurrent', 'accountHolder'),
          verifiedAt: verifiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
