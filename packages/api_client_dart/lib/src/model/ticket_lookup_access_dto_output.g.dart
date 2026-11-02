// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_access_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupAccessDtoOutput extends TicketLookupAccessDtoOutput {
  @override
  final String bookingId;
  @override
  final String accessToken;
  @override
  final DateTime expiresAt;

  factory _$TicketLookupAccessDtoOutput(
          [void Function(TicketLookupAccessDtoOutputBuilder)? updates]) =>
      (TicketLookupAccessDtoOutputBuilder()..update(updates))._build();

  _$TicketLookupAccessDtoOutput._(
      {required this.bookingId,
      required this.accessToken,
      required this.expiresAt})
      : super._();
  @override
  TicketLookupAccessDtoOutput rebuild(
          void Function(TicketLookupAccessDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupAccessDtoOutputBuilder toBuilder() =>
      TicketLookupAccessDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupAccessDtoOutput &&
        bookingId == other.bookingId &&
        accessToken == other.accessToken &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupAccessDtoOutput')
          ..add('bookingId', bookingId)
          ..add('accessToken', accessToken)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class TicketLookupAccessDtoOutputBuilder
    implements
        Builder<TicketLookupAccessDtoOutput,
            TicketLookupAccessDtoOutputBuilder> {
  _$TicketLookupAccessDtoOutput? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  TicketLookupAccessDtoOutputBuilder() {
    TicketLookupAccessDtoOutput._defaults(this);
  }

  TicketLookupAccessDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _accessToken = $v.accessToken;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupAccessDtoOutput other) {
    _$v = other as _$TicketLookupAccessDtoOutput;
  }

  @override
  void update(void Function(TicketLookupAccessDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupAccessDtoOutput build() => _build();

  _$TicketLookupAccessDtoOutput _build() {
    final _$result = _$v ??
        _$TicketLookupAccessDtoOutput._(
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'TicketLookupAccessDtoOutput', 'bookingId'),
          accessToken: BuiltValueNullFieldError.checkNotNull(
              accessToken, r'TicketLookupAccessDtoOutput', 'accessToken'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'TicketLookupAccessDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
