// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupSessionDtoOutput extends TicketLookupSessionDtoOutput {
  @override
  final String lookupToken;
  @override
  final DateTime expiresAt;

  factory _$TicketLookupSessionDtoOutput(
          [void Function(TicketLookupSessionDtoOutputBuilder)? updates]) =>
      (TicketLookupSessionDtoOutputBuilder()..update(updates))._build();

  _$TicketLookupSessionDtoOutput._(
      {required this.lookupToken, required this.expiresAt})
      : super._();
  @override
  TicketLookupSessionDtoOutput rebuild(
          void Function(TicketLookupSessionDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupSessionDtoOutputBuilder toBuilder() =>
      TicketLookupSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupSessionDtoOutput &&
        lookupToken == other.lookupToken &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lookupToken.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupSessionDtoOutput')
          ..add('lookupToken', lookupToken)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class TicketLookupSessionDtoOutputBuilder
    implements
        Builder<TicketLookupSessionDtoOutput,
            TicketLookupSessionDtoOutputBuilder> {
  _$TicketLookupSessionDtoOutput? _$v;

  String? _lookupToken;
  String? get lookupToken => _$this._lookupToken;
  set lookupToken(String? lookupToken) => _$this._lookupToken = lookupToken;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  TicketLookupSessionDtoOutputBuilder() {
    TicketLookupSessionDtoOutput._defaults(this);
  }

  TicketLookupSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lookupToken = $v.lookupToken;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupSessionDtoOutput other) {
    _$v = other as _$TicketLookupSessionDtoOutput;
  }

  @override
  void update(void Function(TicketLookupSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupSessionDtoOutput build() => _build();

  _$TicketLookupSessionDtoOutput _build() {
    final _$result = _$v ??
        _$TicketLookupSessionDtoOutput._(
          lookupToken: BuiltValueNullFieldError.checkNotNull(
              lookupToken, r'TicketLookupSessionDtoOutput', 'lookupToken'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'TicketLookupSessionDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
