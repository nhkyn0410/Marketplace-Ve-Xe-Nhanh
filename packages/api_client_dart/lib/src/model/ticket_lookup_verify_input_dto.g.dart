// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_verify_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupVerifyInputDto extends TicketLookupVerifyInputDto {
  @override
  final String? bookingCode;
  @override
  final String email;
  @override
  final String otp;

  factory _$TicketLookupVerifyInputDto(
          [void Function(TicketLookupVerifyInputDtoBuilder)? updates]) =>
      (TicketLookupVerifyInputDtoBuilder()..update(updates))._build();

  _$TicketLookupVerifyInputDto._(
      {this.bookingCode, required this.email, required this.otp})
      : super._();
  @override
  TicketLookupVerifyInputDto rebuild(
          void Function(TicketLookupVerifyInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupVerifyInputDtoBuilder toBuilder() =>
      TicketLookupVerifyInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupVerifyInputDto &&
        bookingCode == other.bookingCode &&
        email == other.email &&
        otp == other.otp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupVerifyInputDto')
          ..add('bookingCode', bookingCode)
          ..add('email', email)
          ..add('otp', otp))
        .toString();
  }
}

class TicketLookupVerifyInputDtoBuilder
    implements
        Builder<TicketLookupVerifyInputDto, TicketLookupVerifyInputDtoBuilder> {
  _$TicketLookupVerifyInputDto? _$v;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  TicketLookupVerifyInputDtoBuilder() {
    TicketLookupVerifyInputDto._defaults(this);
  }

  TicketLookupVerifyInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingCode = $v.bookingCode;
      _email = $v.email;
      _otp = $v.otp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupVerifyInputDto other) {
    _$v = other as _$TicketLookupVerifyInputDto;
  }

  @override
  void update(void Function(TicketLookupVerifyInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupVerifyInputDto build() => _build();

  _$TicketLookupVerifyInputDto _build() {
    final _$result = _$v ??
        _$TicketLookupVerifyInputDto._(
          bookingCode: bookingCode,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'TicketLookupVerifyInputDto', 'email'),
          otp: BuiltValueNullFieldError.checkNotNull(
              otp, r'TicketLookupVerifyInputDto', 'otp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
