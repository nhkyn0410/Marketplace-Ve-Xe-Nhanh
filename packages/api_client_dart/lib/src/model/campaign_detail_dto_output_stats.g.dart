// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_detail_dto_output_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignDetailDtoOutputStats extends CampaignDetailDtoOutputStats {
  @override
  final int read;
  @override
  final int pushSent;
  @override
  final int pushPending;
  @override
  final int pushFailed;
  @override
  final int pushSkipped;

  factory _$CampaignDetailDtoOutputStats(
          [void Function(CampaignDetailDtoOutputStatsBuilder)? updates]) =>
      (CampaignDetailDtoOutputStatsBuilder()..update(updates))._build();

  _$CampaignDetailDtoOutputStats._(
      {required this.read,
      required this.pushSent,
      required this.pushPending,
      required this.pushFailed,
      required this.pushSkipped})
      : super._();
  @override
  CampaignDetailDtoOutputStats rebuild(
          void Function(CampaignDetailDtoOutputStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignDetailDtoOutputStatsBuilder toBuilder() =>
      CampaignDetailDtoOutputStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignDetailDtoOutputStats &&
        read == other.read &&
        pushSent == other.pushSent &&
        pushPending == other.pushPending &&
        pushFailed == other.pushFailed &&
        pushSkipped == other.pushSkipped;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jc(_$hash, pushSent.hashCode);
    _$hash = $jc(_$hash, pushPending.hashCode);
    _$hash = $jc(_$hash, pushFailed.hashCode);
    _$hash = $jc(_$hash, pushSkipped.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignDetailDtoOutputStats')
          ..add('read', read)
          ..add('pushSent', pushSent)
          ..add('pushPending', pushPending)
          ..add('pushFailed', pushFailed)
          ..add('pushSkipped', pushSkipped))
        .toString();
  }
}

class CampaignDetailDtoOutputStatsBuilder
    implements
        Builder<CampaignDetailDtoOutputStats,
            CampaignDetailDtoOutputStatsBuilder> {
  _$CampaignDetailDtoOutputStats? _$v;

  int? _read;
  int? get read => _$this._read;
  set read(int? read) => _$this._read = read;

  int? _pushSent;
  int? get pushSent => _$this._pushSent;
  set pushSent(int? pushSent) => _$this._pushSent = pushSent;

  int? _pushPending;
  int? get pushPending => _$this._pushPending;
  set pushPending(int? pushPending) => _$this._pushPending = pushPending;

  int? _pushFailed;
  int? get pushFailed => _$this._pushFailed;
  set pushFailed(int? pushFailed) => _$this._pushFailed = pushFailed;

  int? _pushSkipped;
  int? get pushSkipped => _$this._pushSkipped;
  set pushSkipped(int? pushSkipped) => _$this._pushSkipped = pushSkipped;

  CampaignDetailDtoOutputStatsBuilder() {
    CampaignDetailDtoOutputStats._defaults(this);
  }

  CampaignDetailDtoOutputStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _read = $v.read;
      _pushSent = $v.pushSent;
      _pushPending = $v.pushPending;
      _pushFailed = $v.pushFailed;
      _pushSkipped = $v.pushSkipped;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignDetailDtoOutputStats other) {
    _$v = other as _$CampaignDetailDtoOutputStats;
  }

  @override
  void update(void Function(CampaignDetailDtoOutputStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignDetailDtoOutputStats build() => _build();

  _$CampaignDetailDtoOutputStats _build() {
    final _$result = _$v ??
        _$CampaignDetailDtoOutputStats._(
          read: BuiltValueNullFieldError.checkNotNull(
              read, r'CampaignDetailDtoOutputStats', 'read'),
          pushSent: BuiltValueNullFieldError.checkNotNull(
              pushSent, r'CampaignDetailDtoOutputStats', 'pushSent'),
          pushPending: BuiltValueNullFieldError.checkNotNull(
              pushPending, r'CampaignDetailDtoOutputStats', 'pushPending'),
          pushFailed: BuiltValueNullFieldError.checkNotNull(
              pushFailed, r'CampaignDetailDtoOutputStats', 'pushFailed'),
          pushSkipped: BuiltValueNullFieldError.checkNotNull(
              pushSkipped, r'CampaignDetailDtoOutputStats', 'pushSkipped'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
