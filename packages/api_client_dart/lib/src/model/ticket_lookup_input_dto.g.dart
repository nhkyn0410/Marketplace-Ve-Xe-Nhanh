// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupInputDto extends TicketLookupInputDto {
  @override
  final String bookingCode;
  @override
  final String? phone;
  @override
  final String? email;

  factory _$TicketLookupInputDto(
          [void Function(TicketLookupInputDtoBuilder)? updates]) =>
      (TicketLookupInputDtoBuilder()..update(updates))._build();

  _$TicketLookupInputDto._({required this.bookingCode, this.phone, this.email})
      : super._();
  @override
  TicketLookupInputDto rebuild(
          void Function(TicketLookupInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupInputDtoBuilder toBuilder() =>
      TicketLookupInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupInputDto &&
        bookingCode == other.bookingCode &&
        phone == other.phone &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupInputDto')
          ..add('bookingCode', bookingCode)
          ..add('phone', phone)
          ..add('email', email))
        .toString();
  }
}

class TicketLookupInputDtoBuilder
    implements Builder<TicketLookupInputDto, TicketLookupInputDtoBuilder> {
  _$TicketLookupInputDto? _$v;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  TicketLookupInputDtoBuilder() {
    TicketLookupInputDto._defaults(this);
  }

  TicketLookupInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingCode = $v.bookingCode;
      _phone = $v.phone;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupInputDto other) {
    _$v = other as _$TicketLookupInputDto;
  }

  @override
  void update(void Function(TicketLookupInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupInputDto build() => _build();

  _$TicketLookupInputDto _build() {
    final _$result = _$v ??
        _$TicketLookupInputDto._(
          bookingCode: BuiltValueNullFieldError.checkNotNull(
              bookingCode, r'TicketLookupInputDto', 'bookingCode'),
          phone: phone,
          email: email,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
