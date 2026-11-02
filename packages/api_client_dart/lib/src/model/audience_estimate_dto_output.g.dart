// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audience_estimate_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AudienceEstimateDtoOutput extends AudienceEstimateDtoOutput {
  @override
  final int recipients;
  @override
  final int withPush;
  @override
  final int optedOut;
  @override
  final int capped;

  factory _$AudienceEstimateDtoOutput(
          [void Function(AudienceEstimateDtoOutputBuilder)? updates]) =>
      (AudienceEstimateDtoOutputBuilder()..update(updates))._build();

  _$AudienceEstimateDtoOutput._(
      {required this.recipients,
      required this.withPush,
      required this.optedOut,
      required this.capped})
      : super._();
  @override
  AudienceEstimateDtoOutput rebuild(
          void Function(AudienceEstimateDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudienceEstimateDtoOutputBuilder toBuilder() =>
      AudienceEstimateDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudienceEstimateDtoOutput &&
        recipients == other.recipients &&
        withPush == other.withPush &&
        optedOut == other.optedOut &&
        capped == other.capped;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recipients.hashCode);
    _$hash = $jc(_$hash, withPush.hashCode);
    _$hash = $jc(_$hash, optedOut.hashCode);
    _$hash = $jc(_$hash, capped.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AudienceEstimateDtoOutput')
          ..add('recipients', recipients)
          ..add('withPush', withPush)
          ..add('optedOut', optedOut)
          ..add('capped', capped))
        .toString();
  }
}

class AudienceEstimateDtoOutputBuilder
    implements
        Builder<AudienceEstimateDtoOutput, AudienceEstimateDtoOutputBuilder> {
  _$AudienceEstimateDtoOutput? _$v;

  int? _recipients;
  int? get recipients => _$this._recipients;
  set recipients(int? recipients) => _$this._recipients = recipients;

  int? _withPush;
  int? get withPush => _$this._withPush;
  set withPush(int? withPush) => _$this._withPush = withPush;

  int? _optedOut;
  int? get optedOut => _$this._optedOut;
  set optedOut(int? optedOut) => _$this._optedOut = optedOut;

  int? _capped;
  int? get capped => _$this._capped;
  set capped(int? capped) => _$this._capped = capped;

  AudienceEstimateDtoOutputBuilder() {
    AudienceEstimateDtoOutput._defaults(this);
  }

  AudienceEstimateDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recipients = $v.recipients;
      _withPush = $v.withPush;
      _optedOut = $v.optedOut;
      _capped = $v.capped;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AudienceEstimateDtoOutput other) {
    _$v = other as _$AudienceEstimateDtoOutput;
  }

  @override
  void update(void Function(AudienceEstimateDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AudienceEstimateDtoOutput build() => _build();

  _$AudienceEstimateDtoOutput _build() {
    final _$result = _$v ??
        _$AudienceEstimateDtoOutput._(
          recipients: BuiltValueNullFieldError.checkNotNull(
              recipients, r'AudienceEstimateDtoOutput', 'recipients'),
          withPush: BuiltValueNullFieldError.checkNotNull(
              withPush, r'AudienceEstimateDtoOutput', 'withPush'),
          optedOut: BuiltValueNullFieldError.checkNotNull(
              optedOut, r'AudienceEstimateDtoOutput', 'optedOut'),
          capped: BuiltValueNullFieldError.checkNotNull(
              capped, r'AudienceEstimateDtoOutput', 'capped'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
