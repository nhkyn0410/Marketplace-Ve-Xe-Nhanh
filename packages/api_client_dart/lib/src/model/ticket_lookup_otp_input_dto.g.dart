// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_otp_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupOtpInputDto extends TicketLookupOtpInputDto {
  @override
  final String? bookingCode;
  @override
  final String email;

  factory _$TicketLookupOtpInputDto(
          [void Function(TicketLookupOtpInputDtoBuilder)? updates]) =>
      (TicketLookupOtpInputDtoBuilder()..update(updates))._build();

  _$TicketLookupOtpInputDto._({this.bookingCode, required this.email})
      : super._();
  @override
  TicketLookupOtpInputDto rebuild(
          void Function(TicketLookupOtpInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupOtpInputDtoBuilder toBuilder() =>
      TicketLookupOtpInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupOtpInputDto &&
        bookingCode == other.bookingCode &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupOtpInputDto')
          ..add('bookingCode', bookingCode)
          ..add('email', email))
        .toString();
  }
}

class TicketLookupOtpInputDtoBuilder
    implements
        Builder<TicketLookupOtpInputDto, TicketLookupOtpInputDtoBuilder> {
  _$TicketLookupOtpInputDto? _$v;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  TicketLookupOtpInputDtoBuilder() {
    TicketLookupOtpInputDto._defaults(this);
  }

  TicketLookupOtpInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingCode = $v.bookingCode;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupOtpInputDto other) {
    _$v = other as _$TicketLookupOtpInputDto;
  }

  @override
  void update(void Function(TicketLookupOtpInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupOtpInputDto build() => _build();

  _$TicketLookupOtpInputDto _build() {
    final _$result = _$v ??
        _$TicketLookupOtpInputDto._(
          bookingCode: bookingCode,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'TicketLookupOtpInputDto', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
