// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_dto_output_transfer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentResponseDtoOutputTransfer
    extends PaymentResponseDtoOutputTransfer {
  @override
  final String qrCode;
  @override
  final String bin;
  @override
  final String accountNumber;
  @override
  final String accountName;
  @override
  final String amount;
  @override
  final String description;
  @override
  final String paymentLinkId;

  factory _$PaymentResponseDtoOutputTransfer(
          [void Function(PaymentResponseDtoOutputTransferBuilder)? updates]) =>
      (PaymentResponseDtoOutputTransferBuilder()..update(updates))._build();

  _$PaymentResponseDtoOutputTransfer._(
      {required this.qrCode,
      required this.bin,
      required this.accountNumber,
      required this.accountName,
      required this.amount,
      required this.description,
      required this.paymentLinkId})
      : super._();
  @override
  PaymentResponseDtoOutputTransfer rebuild(
          void Function(PaymentResponseDtoOutputTransferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentResponseDtoOutputTransferBuilder toBuilder() =>
      PaymentResponseDtoOutputTransferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentResponseDtoOutputTransfer &&
        qrCode == other.qrCode &&
        bin == other.bin &&
        accountNumber == other.accountNumber &&
        accountName == other.accountName &&
        amount == other.amount &&
        description == other.description &&
        paymentLinkId == other.paymentLinkId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, qrCode.hashCode);
    _$hash = $jc(_$hash, bin.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, paymentLinkId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentResponseDtoOutputTransfer')
          ..add('qrCode', qrCode)
          ..add('bin', bin)
          ..add('accountNumber', accountNumber)
          ..add('accountName', accountName)
          ..add('amount', amount)
          ..add('description', description)
          ..add('paymentLinkId', paymentLinkId))
        .toString();
  }
}

class PaymentResponseDtoOutputTransferBuilder
    implements
        Builder<PaymentResponseDtoOutputTransfer,
            PaymentResponseDtoOutputTransferBuilder> {
  _$PaymentResponseDtoOutputTransfer? _$v;

  String? _qrCode;
  String? get qrCode => _$this._qrCode;
  set qrCode(String? qrCode) => _$this._qrCode = qrCode;

  String? _bin;
  String? get bin => _$this._bin;
  set bin(String? bin) => _$this._bin = bin;

  String? _accountNumber;
  String? get accountNumber => _$this._accountNumber;
  set accountNumber(String? accountNumber) =>
      _$this._accountNumber = accountNumber;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _paymentLinkId;
  String? get paymentLinkId => _$this._paymentLinkId;
  set paymentLinkId(String? paymentLinkId) =>
      _$this._paymentLinkId = paymentLinkId;

  PaymentResponseDtoOutputTransferBuilder() {
    PaymentResponseDtoOutputTransfer._defaults(this);
  }

  PaymentResponseDtoOutputTransferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _qrCode = $v.qrCode;
      _bin = $v.bin;
      _accountNumber = $v.accountNumber;
      _accountName = $v.accountName;
      _amount = $v.amount;
      _description = $v.description;
      _paymentLinkId = $v.paymentLinkId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentResponseDtoOutputTransfer other) {
    _$v = other as _$PaymentResponseDtoOutputTransfer;
  }

  @override
  void update(void Function(PaymentResponseDtoOutputTransferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentResponseDtoOutputTransfer build() => _build();

  _$PaymentResponseDtoOutputTransfer _build() {
    final _$result = _$v ??
        _$PaymentResponseDtoOutputTransfer._(
          qrCode: BuiltValueNullFieldError.checkNotNull(
              qrCode, r'PaymentResponseDtoOutputTransfer', 'qrCode'),
          bin: BuiltValueNullFieldError.checkNotNull(
              bin, r'PaymentResponseDtoOutputTransfer', 'bin'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(accountNumber,
              r'PaymentResponseDtoOutputTransfer', 'accountNumber'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'PaymentResponseDtoOutputTransfer', 'accountName'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentResponseDtoOutputTransfer', 'amount'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'PaymentResponseDtoOutputTransfer', 'description'),
          paymentLinkId: BuiltValueNullFieldError.checkNotNull(paymentLinkId,
              r'PaymentResponseDtoOutputTransfer', 'paymentLinkId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
