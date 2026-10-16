// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_change_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BankChangeInputDto extends BankChangeInputDto {
  @override
  final String bankName;
  @override
  final String accountNumber;
  @override
  final String accountHolder;
  @override
  final String reason;

  factory _$BankChangeInputDto(
          [void Function(BankChangeInputDtoBuilder)? updates]) =>
      (BankChangeInputDtoBuilder()..update(updates))._build();

  _$BankChangeInputDto._(
      {required this.bankName,
      required this.accountNumber,
      required this.accountHolder,
      required this.reason})
      : super._();
  @override
  BankChangeInputDto rebuild(
          void Function(BankChangeInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BankChangeInputDtoBuilder toBuilder() =>
      BankChangeInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BankChangeInputDto &&
        bankName == other.bankName &&
        accountNumber == other.accountNumber &&
        accountHolder == other.accountHolder &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BankChangeInputDto')
          ..add('bankName', bankName)
          ..add('accountNumber', accountNumber)
          ..add('accountHolder', accountHolder)
          ..add('reason', reason))
        .toString();
  }
}

class BankChangeInputDtoBuilder
    implements Builder<BankChangeInputDto, BankChangeInputDtoBuilder> {
  _$BankChangeInputDto? _$v;

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

  BankChangeInputDtoBuilder() {
    BankChangeInputDto._defaults(this);
  }

  BankChangeInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankName = $v.bankName;
      _accountNumber = $v.accountNumber;
      _accountHolder = $v.accountHolder;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BankChangeInputDto other) {
    _$v = other as _$BankChangeInputDto;
  }

  @override
  void update(void Function(BankChangeInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BankChangeInputDto build() => _build();

  _$BankChangeInputDto _build() {
    final _$result = _$v ??
        _$BankChangeInputDto._(
          bankName: BuiltValueNullFieldError.checkNotNull(
              bankName, r'BankChangeInputDto', 'bankName'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(
              accountNumber, r'BankChangeInputDto', 'accountNumber'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(
              accountHolder, r'BankChangeInputDto', 'accountHolder'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'BankChangeInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
