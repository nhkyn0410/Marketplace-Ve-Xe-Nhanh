// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_confirm_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutConfirmInputDto extends PayoutConfirmInputDto {
  @override
  final String bankReference;
  @override
  final DateTime transferredAt;
  @override
  final String note;

  factory _$PayoutConfirmInputDto(
          [void Function(PayoutConfirmInputDtoBuilder)? updates]) =>
      (PayoutConfirmInputDtoBuilder()..update(updates))._build();

  _$PayoutConfirmInputDto._(
      {required this.bankReference,
      required this.transferredAt,
      required this.note})
      : super._();
  @override
  PayoutConfirmInputDto rebuild(
          void Function(PayoutConfirmInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutConfirmInputDtoBuilder toBuilder() =>
      PayoutConfirmInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutConfirmInputDto &&
        bankReference == other.bankReference &&
        transferredAt == other.transferredAt &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, transferredAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutConfirmInputDto')
          ..add('bankReference', bankReference)
          ..add('transferredAt', transferredAt)
          ..add('note', note))
        .toString();
  }
}

class PayoutConfirmInputDtoBuilder
    implements Builder<PayoutConfirmInputDto, PayoutConfirmInputDtoBuilder> {
  _$PayoutConfirmInputDto? _$v;

  String? _bankReference;
  String? get bankReference => _$this._bankReference;
  set bankReference(String? bankReference) =>
      _$this._bankReference = bankReference;

  DateTime? _transferredAt;
  DateTime? get transferredAt => _$this._transferredAt;
  set transferredAt(DateTime? transferredAt) =>
      _$this._transferredAt = transferredAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  PayoutConfirmInputDtoBuilder() {
    PayoutConfirmInputDto._defaults(this);
  }

  PayoutConfirmInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankReference = $v.bankReference;
      _transferredAt = $v.transferredAt;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutConfirmInputDto other) {
    _$v = other as _$PayoutConfirmInputDto;
  }

  @override
  void update(void Function(PayoutConfirmInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutConfirmInputDto build() => _build();

  _$PayoutConfirmInputDto _build() {
    final _$result = _$v ??
        _$PayoutConfirmInputDto._(
          bankReference: BuiltValueNullFieldError.checkNotNull(
              bankReference, r'PayoutConfirmInputDto', 'bankReference'),
          transferredAt: BuiltValueNullFieldError.checkNotNull(
              transferredAt, r'PayoutConfirmInputDto', 'transferredAt'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'PayoutConfirmInputDto', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
