// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bank_change_dto_output_requested.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBankChangeDtoOutputRequested
    extends AdminBankChangeDtoOutputRequested {
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolder;
  @override
  final String? reason;
  @override
  final DateTime requestedAt;
  @override
  final String? requestedBy;

  factory _$AdminBankChangeDtoOutputRequested(
          [void Function(AdminBankChangeDtoOutputRequestedBuilder)? updates]) =>
      (AdminBankChangeDtoOutputRequestedBuilder()..update(updates))._build();

  _$AdminBankChangeDtoOutputRequested._(
      {required this.bankName,
      required this.accountNumber,
      required this.accountHolder,
      this.reason,
      required this.requestedAt,
      this.requestedBy})
      : super._();
  @override
  AdminBankChangeDtoOutputRequested rebuild(
          void Function(AdminBankChangeDtoOutputRequestedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminBankChangeDtoOutputRequestedBuilder toBuilder() =>
      AdminBankChangeDtoOutputRequestedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBankChangeDtoOutputRequested &&
        bankName == other.bankName &&
        accountNumber == other.accountNumber &&
        accountHolder == other.accountHolder &&
        reason == other.reason &&
        requestedAt == other.requestedAt &&
        requestedBy == other.requestedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, requestedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBankChangeDtoOutputRequested')
          ..add('bankName', bankName)
          ..add('accountNumber', accountNumber)
          ..add('accountHolder', accountHolder)
          ..add('reason', reason)
          ..add('requestedAt', requestedAt)
          ..add('requestedBy', requestedBy))
        .toString();
  }
}

class AdminBankChangeDtoOutputRequestedBuilder
    implements
        Builder<AdminBankChangeDtoOutputRequested,
            AdminBankChangeDtoOutputRequestedBuilder> {
  _$AdminBankChangeDtoOutputRequested? _$v;

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

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  String? _requestedBy;
  String? get requestedBy => _$this._requestedBy;
  set requestedBy(String? requestedBy) => _$this._requestedBy = requestedBy;

  AdminBankChangeDtoOutputRequestedBuilder() {
    AdminBankChangeDtoOutputRequested._defaults(this);
  }

  AdminBankChangeDtoOutputRequestedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumber = $v.accountNumber;
      _accountHolder = $v.accountHolder;
      _reason = $v.reason;
      _requestedAt = $v.requestedAt;
      _requestedBy = $v.requestedBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBankChangeDtoOutputRequested other) {
    _$v = other as _$AdminBankChangeDtoOutputRequested;
  }

  @override
  void update(
      void Function(AdminBankChangeDtoOutputRequestedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBankChangeDtoOutputRequested build() => _build();

  _$AdminBankChangeDtoOutputRequested _build() {
    final _$result = _$v ??
        _$AdminBankChangeDtoOutputRequested._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'AdminBankChangeDtoOutputRequested', 'bankName'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(accountNumber,
              r'AdminBankChangeDtoOutputRequested', 'accountNumber'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'AdminBankChangeDtoOutputRequested', 'accountHolder'),
          reason: reason,
          requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt, r'AdminBankChangeDtoOutputRequested', 'requestedAt'),
          requestedBy: requestedBy,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
