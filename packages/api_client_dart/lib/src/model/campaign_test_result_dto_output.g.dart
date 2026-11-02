// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_test_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignTestResultDtoOutput extends CampaignTestResultDtoOutput {
  @override
  final int pushDevices;

  factory _$CampaignTestResultDtoOutput(
          [void Function(CampaignTestResultDtoOutputBuilder)? updates]) =>
      (CampaignTestResultDtoOutputBuilder()..update(updates))._build();

  _$CampaignTestResultDtoOutput._({required this.pushDevices}) : super._();
  @override
  CampaignTestResultDtoOutput rebuild(
          void Function(CampaignTestResultDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignTestResultDtoOutputBuilder toBuilder() =>
      CampaignTestResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignTestResultDtoOutput &&
        pushDevices == other.pushDevices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pushDevices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignTestResultDtoOutput')
          ..add('pushDevices', pushDevices))
        .toString();
  }
}

class CampaignTestResultDtoOutputBuilder
    implements
        Builder<CampaignTestResultDtoOutput,
            CampaignTestResultDtoOutputBuilder> {
  _$CampaignTestResultDtoOutput? _$v;

  int? _pushDevices;
  int? get pushDevices => _$this._pushDevices;
  set pushDevices(int? pushDevices) => _$this._pushDevices = pushDevices;

  CampaignTestResultDtoOutputBuilder() {
    CampaignTestResultDtoOutput._defaults(this);
  }

  CampaignTestResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pushDevices = $v.pushDevices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignTestResultDtoOutput other) {
    _$v = other as _$CampaignTestResultDtoOutput;
  }

  @override
  void update(void Function(CampaignTestResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignTestResultDtoOutput build() => _build();

  _$CampaignTestResultDtoOutput _build() {
    final _$result = _$v ??
        _$CampaignTestResultDtoOutput._(
          pushDevices: BuiltValueNullFieldError.checkNotNull(
              pushDevices, r'CampaignTestResultDtoOutput', 'pushDevices'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
