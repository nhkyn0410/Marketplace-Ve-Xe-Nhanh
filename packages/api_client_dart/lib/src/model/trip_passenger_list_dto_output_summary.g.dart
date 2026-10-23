// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger_list_dto_output_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripPassengerListDtoOutputSummary
    extends TripPassengerListDtoOutputSummary {
  @override
  final int sold;
  @override
  final int checkedIn;
  @override
  final int notBoarded;
  @override
  final int noShow;

  factory _$TripPassengerListDtoOutputSummary(
          [void Function(TripPassengerListDtoOutputSummaryBuilder)? updates]) =>
      (TripPassengerListDtoOutputSummaryBuilder()..update(updates))._build();

  _$TripPassengerListDtoOutputSummary._(
      {required this.sold,
      required this.checkedIn,
      required this.notBoarded,
      required this.noShow})
      : super._();
  @override
  TripPassengerListDtoOutputSummary rebuild(
          void Function(TripPassengerListDtoOutputSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripPassengerListDtoOutputSummaryBuilder toBuilder() =>
      TripPassengerListDtoOutputSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripPassengerListDtoOutputSummary &&
        sold == other.sold &&
        checkedIn == other.checkedIn &&
        notBoarded == other.notBoarded &&
        noShow == other.noShow;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sold.hashCode);
    _$hash = $jc(_$hash, checkedIn.hashCode);
    _$hash = $jc(_$hash, notBoarded.hashCode);
    _$hash = $jc(_$hash, noShow.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripPassengerListDtoOutputSummary')
          ..add('sold', sold)
          ..add('checkedIn', checkedIn)
          ..add('notBoarded', notBoarded)
          ..add('noShow', noShow))
        .toString();
  }
}

class TripPassengerListDtoOutputSummaryBuilder
    implements
        Builder<TripPassengerListDtoOutputSummary,
            TripPassengerListDtoOutputSummaryBuilder> {
  _$TripPassengerListDtoOutputSummary? _$v;

  int? _sold;
  int? get sold => _$this._sold;
  set sold(int? sold) => _$this._sold = sold;

  int? _checkedIn;
  int? get checkedIn => _$this._checkedIn;
  set checkedIn(int? checkedIn) => _$this._checkedIn = checkedIn;

  int? _notBoarded;
  int? get notBoarded => _$this._notBoarded;
  set notBoarded(int? notBoarded) => _$this._notBoarded = notBoarded;

  int? _noShow;
  int? get noShow => _$this._noShow;
  set noShow(int? noShow) => _$this._noShow = noShow;

  TripPassengerListDtoOutputSummaryBuilder() {
    TripPassengerListDtoOutputSummary._defaults(this);
  }

  TripPassengerListDtoOutputSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sold = $v.sold;
      _checkedIn = $v.checkedIn;
      _notBoarded = $v.notBoarded;
      _noShow = $v.noShow;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripPassengerListDtoOutputSummary other) {
    _$v = other as _$TripPassengerListDtoOutputSummary;
  }

  @override
  void update(
      void Function(TripPassengerListDtoOutputSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripPassengerListDtoOutputSummary build() => _build();

  _$TripPassengerListDtoOutputSummary _build() {
    final _$result = _$v ??
        _$TripPassengerListDtoOutputSummary._(
          sold: BuiltValueNullFieldError.checkNotNull(
              sold, r'TripPassengerListDtoOutputSummary', 'sold'),
          checkedIn: BuiltValueNullFieldError.checkNotNull(
              checkedIn, r'TripPassengerListDtoOutputSummary', 'checkedIn'),
          notBoarded: BuiltValueNullFieldError.checkNotNull(
              notBoarded, r'TripPassengerListDtoOutputSummary', 'notBoarded'),
          noShow: BuiltValueNullFieldError.checkNotNull(
              noShow, r'TripPassengerListDtoOutputSummary', 'noShow'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
