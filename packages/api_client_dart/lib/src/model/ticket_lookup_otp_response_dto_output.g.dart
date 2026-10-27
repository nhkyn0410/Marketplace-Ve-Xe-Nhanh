// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_otp_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupOtpResponseDtoOutput
    extends TicketLookupOtpResponseDtoOutput {
  @override
  final String maskedEmail;
  @override
  final int expiresInSeconds;
  @override
  final int resendAfterSeconds;
  @override
  final int maxAttempts;

  factory _$TicketLookupOtpResponseDtoOutput(
          [void Function(TicketLookupOtpResponseDtoOutputBuilder)? updates]) =>
      (TicketLookupOtpResponseDtoOutputBuilder()..update(updates))._build();

  _$TicketLookupOtpResponseDtoOutput._(
      {required this.maskedEmail,
      required this.expiresInSeconds,
      required this.resendAfterSeconds,
      required this.maxAttempts})
      : super._();
  @override
  TicketLookupOtpResponseDtoOutput rebuild(
          void Function(TicketLookupOtpResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupOtpResponseDtoOutputBuilder toBuilder() =>
      TicketLookupOtpResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupOtpResponseDtoOutput &&
        maskedEmail == other.maskedEmail &&
        expiresInSeconds == other.expiresInSeconds &&
        resendAfterSeconds == other.resendAfterSeconds &&
        maxAttempts == other.maxAttempts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maskedEmail.hashCode);
    _$hash = $jc(_$hash, expiresInSeconds.hashCode);
    _$hash = $jc(_$hash, resendAfterSeconds.hashCode);
    _$hash = $jc(_$hash, maxAttempts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupOtpResponseDtoOutput')
          ..add('maskedEmail', maskedEmail)
          ..add('expiresInSeconds', expiresInSeconds)
          ..add('resendAfterSeconds', resendAfterSeconds)
          ..add('maxAttempts', maxAttempts))
        .toString();
  }
}

class TicketLookupOtpResponseDtoOutputBuilder
    implements
        Builder<TicketLookupOtpResponseDtoOutput,
            TicketLookupOtpResponseDtoOutputBuilder> {
  _$TicketLookupOtpResponseDtoOutput? _$v;

  String? _maskedEmail;
  String? get maskedEmail => _$this._maskedEmail;
  set maskedEmail(String? maskedEmail) => _$this._maskedEmail = maskedEmail;

  int? _expiresInSeconds;
  int? get expiresInSeconds => _$this._expiresInSeconds;
  set expiresInSeconds(int? expiresInSeconds) =>
      _$this._expiresInSeconds = expiresInSeconds;

  int? _resendAfterSeconds;
  int? get resendAfterSeconds => _$this._resendAfterSeconds;
  set resendAfterSeconds(int? resendAfterSeconds) =>
      _$this._resendAfterSeconds = resendAfterSeconds;

  int? _maxAttempts;
  int? get maxAttempts => _$this._maxAttempts;
  set maxAttempts(int? maxAttempts) => _$this._maxAttempts = maxAttempts;

  TicketLookupOtpResponseDtoOutputBuilder() {
    TicketLookupOtpResponseDtoOutput._defaults(this);
  }

  TicketLookupOtpResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maskedEmail = $v.maskedEmail;
      _expiresInSeconds = $v.expiresInSeconds;
      _resendAfterSeconds = $v.resendAfterSeconds;
      _maxAttempts = $v.maxAttempts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupOtpResponseDtoOutput other) {
    _$v = other as _$TicketLookupOtpResponseDtoOutput;
  }

  @override
  void update(void Function(TicketLookupOtpResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupOtpResponseDtoOutput build() => _build();

  _$TicketLookupOtpResponseDtoOutput _build() {
    final _$result = _$v ??
        _$TicketLookupOtpResponseDtoOutput._(
          maskedEmail: BuiltValueNullFieldError.checkNotNull(
              maskedEmail, r'TicketLookupOtpResponseDtoOutput', 'maskedEmail'),
          expiresInSeconds: BuiltValueNullFieldError.checkNotNull(
              expiresInSeconds,
              r'TicketLookupOtpResponseDtoOutput',
              'expiresInSeconds'),
          resendAfterSeconds: BuiltValueNullFieldError.checkNotNull(
              resendAfterSeconds,
              r'TicketLookupOtpResponseDtoOutput',
              'resendAfterSeconds'),
          maxAttempts: BuiltValueNullFieldError.checkNotNull(
              maxAttempts, r'TicketLookupOtpResponseDtoOutput', 'maxAttempts'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
