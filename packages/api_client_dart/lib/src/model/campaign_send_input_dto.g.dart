// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_send_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignSendInputDto extends CampaignSendInputDto {
  @override
  final DateTime? scheduledAt;

  factory _$CampaignSendInputDto(
          [void Function(CampaignSendInputDtoBuilder)? updates]) =>
      (CampaignSendInputDtoBuilder()..update(updates))._build();

  _$CampaignSendInputDto._({this.scheduledAt}) : super._();
  @override
  CampaignSendInputDto rebuild(
          void Function(CampaignSendInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignSendInputDtoBuilder toBuilder() =>
      CampaignSendInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignSendInputDto && scheduledAt == other.scheduledAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scheduledAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignSendInputDto')
          ..add('scheduledAt', scheduledAt))
        .toString();
  }
}

class CampaignSendInputDtoBuilder
    implements Builder<CampaignSendInputDto, CampaignSendInputDtoBuilder> {
  _$CampaignSendInputDto? _$v;

  DateTime? _scheduledAt;
  DateTime? get scheduledAt => _$this._scheduledAt;
  set scheduledAt(DateTime? scheduledAt) => _$this._scheduledAt = scheduledAt;

  CampaignSendInputDtoBuilder() {
    CampaignSendInputDto._defaults(this);
  }

  CampaignSendInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scheduledAt = $v.scheduledAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignSendInputDto other) {
    _$v = other as _$CampaignSendInputDto;
  }

  @override
  void update(void Function(CampaignSendInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignSendInputDto build() => _build();

  _$CampaignSendInputDto _build() {
    final _$result = _$v ??
        _$CampaignSendInputDto._(
          scheduledAt: scheduledAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
