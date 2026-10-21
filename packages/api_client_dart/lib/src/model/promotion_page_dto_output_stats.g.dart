// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_page_dto_output_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionPageDtoOutputStats extends PromotionPageDtoOutputStats {
  @override
  final int running;
  @override
  final int scheduled;
  @override
  final int drafts;
  @override
  final int paused;
  @override
  final int redemptions;
  @override
  final int discount;
  @override
  final int revenue;

  factory _$PromotionPageDtoOutputStats(
          [void Function(PromotionPageDtoOutputStatsBuilder)? updates]) =>
      (PromotionPageDtoOutputStatsBuilder()..update(updates))._build();

  _$PromotionPageDtoOutputStats._(
      {required this.running,
      required this.scheduled,
      required this.drafts,
      required this.paused,
      required this.redemptions,
      required this.discount,
      required this.revenue})
      : super._();
  @override
  PromotionPageDtoOutputStats rebuild(
          void Function(PromotionPageDtoOutputStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionPageDtoOutputStatsBuilder toBuilder() =>
      PromotionPageDtoOutputStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionPageDtoOutputStats &&
        running == other.running &&
        scheduled == other.scheduled &&
        drafts == other.drafts &&
        paused == other.paused &&
        redemptions == other.redemptions &&
        discount == other.discount &&
        revenue == other.revenue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, running.hashCode);
    _$hash = $jc(_$hash, scheduled.hashCode);
    _$hash = $jc(_$hash, drafts.hashCode);
    _$hash = $jc(_$hash, paused.hashCode);
    _$hash = $jc(_$hash, redemptions.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, revenue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionPageDtoOutputStats')
          ..add('running', running)
          ..add('scheduled', scheduled)
          ..add('drafts', drafts)
          ..add('paused', paused)
          ..add('redemptions', redemptions)
          ..add('discount', discount)
          ..add('revenue', revenue))
        .toString();
  }
}

class PromotionPageDtoOutputStatsBuilder
    implements
        Builder<PromotionPageDtoOutputStats,
            PromotionPageDtoOutputStatsBuilder> {
  _$PromotionPageDtoOutputStats? _$v;

  int? _running;
  int? get running => _$this._running;
  set running(int? running) => _$this._running = running;

  int? _scheduled;
  int? get scheduled => _$this._scheduled;
  set scheduled(int? scheduled) => _$this._scheduled = scheduled;

  int? _drafts;
  int? get drafts => _$this._drafts;
  set drafts(int? drafts) => _$this._drafts = drafts;

  int? _paused;
  int? get paused => _$this._paused;
  set paused(int? paused) => _$this._paused = paused;

  int? _redemptions;
  int? get redemptions => _$this._redemptions;
  set redemptions(int? redemptions) => _$this._redemptions = redemptions;

  int? _discount;
  int? get discount => _$this._discount;
  set discount(int? discount) => _$this._discount = discount;

  int? _revenue;
  int? get revenue => _$this._revenue;
  set revenue(int? revenue) => _$this._revenue = revenue;

  PromotionPageDtoOutputStatsBuilder() {
    PromotionPageDtoOutputStats._defaults(this);
  }

  PromotionPageDtoOutputStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _running = $v.running;
      _scheduled = $v.scheduled;
      _drafts = $v.drafts;
      _paused = $v.paused;
      _redemptions = $v.redemptions;
      _discount = $v.discount;
      _revenue = $v.revenue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionPageDtoOutputStats other) {
    _$v = other as _$PromotionPageDtoOutputStats;
  }

  @override
  void update(void Function(PromotionPageDtoOutputStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionPageDtoOutputStats build() => _build();

  _$PromotionPageDtoOutputStats _build() {
    final _$result = _$v ??
        _$PromotionPageDtoOutputStats._(
          running: BuiltValueNullFieldError.checkNotNull(
              running, r'PromotionPageDtoOutputStats', 'running'),
          scheduled: BuiltValueNullFieldError.checkNotNull(
              scheduled, r'PromotionPageDtoOutputStats', 'scheduled'),
          drafts: BuiltValueNullFieldError.checkNotNull(
              drafts, r'PromotionPageDtoOutputStats', 'drafts'),
          paused: BuiltValueNullFieldError.checkNotNull(
              paused, r'PromotionPageDtoOutputStats', 'paused'),
          redemptions: BuiltValueNullFieldError.checkNotNull(
              redemptions, r'PromotionPageDtoOutputStats', 'redemptions'),
          discount: BuiltValueNullFieldError.checkNotNull(
              discount, r'PromotionPageDtoOutputStats', 'discount'),
          revenue: BuiltValueNullFieldError.checkNotNull(
              revenue, r'PromotionPageDtoOutputStats', 'revenue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
