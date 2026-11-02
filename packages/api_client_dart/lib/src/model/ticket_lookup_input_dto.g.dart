// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupInputDto extends TicketLookupInputDto {
  @override
  final String lookupToken;
  @override
  final String? bookingId;

  factory _$TicketLookupInputDto(
          [void Function(TicketLookupInputDtoBuilder)? updates]) =>
      (TicketLookupInputDtoBuilder()..update(updates))._build();

  _$TicketLookupInputDto._({required this.lookupToken, this.bookingId})
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
        lookupToken == other.lookupToken &&
        bookingId == other.bookingId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lookupToken.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupInputDto')
          ..add('lookupToken', lookupToken)
          ..add('bookingId', bookingId))
        .toString();
  }
}

class TicketLookupInputDtoBuilder
    implements Builder<TicketLookupInputDto, TicketLookupInputDtoBuilder> {
  _$TicketLookupInputDto? _$v;

  String? _lookupToken;
  String? get lookupToken => _$this._lookupToken;
  set lookupToken(String? lookupToken) => _$this._lookupToken = lookupToken;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  TicketLookupInputDtoBuilder() {
    TicketLookupInputDto._defaults(this);
  }

  TicketLookupInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lookupToken = $v.lookupToken;
      _bookingId = $v.bookingId;
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
          lookupToken: BuiltValueNullFieldError.checkNotNull(
              lookupToken, r'TicketLookupInputDto', 'lookupToken'),
          bookingId: bookingId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
