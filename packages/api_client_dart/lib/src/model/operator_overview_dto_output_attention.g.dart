// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output_attention.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorOverviewDtoOutputAttention
    extends OperatorOverviewDtoOutputAttention {
  @override
  final int tripsWithoutDriver;
  @override
  final int draftTrips;
  @override
  final int pendingRefunds;

  factory _$OperatorOverviewDtoOutputAttention(
          [void Function(OperatorOverviewDtoOutputAttentionBuilder)?
              updates]) =>
      (OperatorOverviewDtoOutputAttentionBuilder()..update(updates))._build();

  _$OperatorOverviewDtoOutputAttention._(
      {required this.tripsWithoutDriver,
      required this.draftTrips,
      required this.pendingRefunds})
      : super._();
  @override
  OperatorOverviewDtoOutputAttention rebuild(
          void Function(OperatorOverviewDtoOutputAttentionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputAttentionBuilder toBuilder() =>
      OperatorOverviewDtoOutputAttentionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutputAttention &&
        tripsWithoutDriver == other.tripsWithoutDriver &&
        draftTrips == other.draftTrips &&
        pendingRefunds == other.pendingRefunds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripsWithoutDriver.hashCode);
    _$hash = $jc(_$hash, draftTrips.hashCode);
    _$hash = $jc(_$hash, pendingRefunds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorOverviewDtoOutputAttention')
          ..add('tripsWithoutDriver', tripsWithoutDriver)
          ..add('draftTrips', draftTrips)
          ..add('pendingRefunds', pendingRefunds))
        .toString();
  }
}

class OperatorOverviewDtoOutputAttentionBuilder
    implements
        Builder<OperatorOverviewDtoOutputAttention,
            OperatorOverviewDtoOutputAttentionBuilder> {
  _$OperatorOverviewDtoOutputAttention? _$v;

  int? _tripsWithoutDriver;
  int? get tripsWithoutDriver => _$this._tripsWithoutDriver;
  set tripsWithoutDriver(int? tripsWithoutDriver) =>
      _$this._tripsWithoutDriver = tripsWithoutDriver;

  int? _draftTrips;
  int? get draftTrips => _$this._draftTrips;
  set draftTrips(int? draftTrips) => _$this._draftTrips = draftTrips;

  int? _pendingRefunds;
  int? get pendingRefunds => _$this._pendingRefunds;
  set pendingRefunds(int? pendingRefunds) =>
      _$this._pendingRefunds = pendingRefunds;

  OperatorOverviewDtoOutputAttentionBuilder() {
    OperatorOverviewDtoOutputAttention._defaults(this);
  }

  OperatorOverviewDtoOutputAttentionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripsWithoutDriver = $v.tripsWithoutDriver;
      _draftTrips = $v.draftTrips;
      _pendingRefunds = $v.pendingRefunds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutputAttention other) {
    _$v = other as _$OperatorOverviewDtoOutputAttention;
  }

  @override
  void update(
      void Function(OperatorOverviewDtoOutputAttentionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutputAttention build() => _build();

  _$OperatorOverviewDtoOutputAttention _build() {
    final _$result = _$v ??
        _$OperatorOverviewDtoOutputAttention._(
          tripsWithoutDriver: BuiltValueNullFieldError.checkNotNull(
              tripsWithoutDriver,
              r'OperatorOverviewDtoOutputAttention',
              'tripsWithoutDriver'),
          draftTrips: BuiltValueNullFieldError.checkNotNull(
              draftTrips, r'OperatorOverviewDtoOutputAttention', 'draftTrips'),
          pendingRefunds: BuiltValueNullFieldError.checkNotNull(pendingRefunds,
              r'OperatorOverviewDtoOutputAttention', 'pendingRefunds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
