// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_email_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketEmailResponseDtoOutput extends TicketEmailResponseDtoOutput {
  @override
  final String sentTo;
  @override
  final int resendAfterSeconds;

  factory _$TicketEmailResponseDtoOutput(
          [void Function(TicketEmailResponseDtoOutputBuilder)? updates]) =>
      (TicketEmailResponseDtoOutputBuilder()..update(updates))._build();

  _$TicketEmailResponseDtoOutput._(
      {required this.sentTo, required this.resendAfterSeconds})
      : super._();
  @override
  TicketEmailResponseDtoOutput rebuild(
          void Function(TicketEmailResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketEmailResponseDtoOutputBuilder toBuilder() =>
      TicketEmailResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketEmailResponseDtoOutput &&
        sentTo == other.sentTo &&
        resendAfterSeconds == other.resendAfterSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sentTo.hashCode);
    _$hash = $jc(_$hash, resendAfterSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketEmailResponseDtoOutput')
          ..add('sentTo', sentTo)
          ..add('resendAfterSeconds', resendAfterSeconds))
        .toString();
  }
}

class TicketEmailResponseDtoOutputBuilder
    implements
        Builder<TicketEmailResponseDtoOutput,
            TicketEmailResponseDtoOutputBuilder> {
  _$TicketEmailResponseDtoOutput? _$v;

  String? _sentTo;
  String? get sentTo => _$this._sentTo;
  set sentTo(String? sentTo) => _$this._sentTo = sentTo;

  int? _resendAfterSeconds;
  int? get resendAfterSeconds => _$this._resendAfterSeconds;
  set resendAfterSeconds(int? resendAfterSeconds) =>
      _$this._resendAfterSeconds = resendAfterSeconds;

  TicketEmailResponseDtoOutputBuilder() {
    TicketEmailResponseDtoOutput._defaults(this);
  }

  TicketEmailResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sentTo = $v.sentTo;
      _resendAfterSeconds = $v.resendAfterSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketEmailResponseDtoOutput other) {
    _$v = other as _$TicketEmailResponseDtoOutput;
  }

  @override
  void update(void Function(TicketEmailResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketEmailResponseDtoOutput build() => _build();

  _$TicketEmailResponseDtoOutput _build() {
    final _$result = _$v ??
        _$TicketEmailResponseDtoOutput._(
          sentTo: BuiltValueNullFieldError.checkNotNull(
              sentTo, r'TicketEmailResponseDtoOutput', 'sentTo'),
          resendAfterSeconds: BuiltValueNullFieldError.checkNotNull(
              resendAfterSeconds,
              r'TicketEmailResponseDtoOutput',
              'resendAfterSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
