// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_sales_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSalesDtoOutput extends TripSalesDtoOutput {
  @override
  final int soldSeats;
  @override
  final int holdingSeats;
  @override
  final int activeBookings;
  @override
  final int pendingBookings;
  @override
  final int refundOnCancel;
  @override
  final BuiltList<TripSalesDtoOutputChangesInner> changes;

  factory _$TripSalesDtoOutput(
          [void Function(TripSalesDtoOutputBuilder)? updates]) =>
      (TripSalesDtoOutputBuilder()..update(updates))._build();

  _$TripSalesDtoOutput._(
      {required this.soldSeats,
      required this.holdingSeats,
      required this.activeBookings,
      required this.pendingBookings,
      required this.refundOnCancel,
      required this.changes})
      : super._();
  @override
  TripSalesDtoOutput rebuild(
          void Function(TripSalesDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSalesDtoOutputBuilder toBuilder() =>
      TripSalesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSalesDtoOutput &&
        soldSeats == other.soldSeats &&
        holdingSeats == other.holdingSeats &&
        activeBookings == other.activeBookings &&
        pendingBookings == other.pendingBookings &&
        refundOnCancel == other.refundOnCancel &&
        changes == other.changes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, soldSeats.hashCode);
    _$hash = $jc(_$hash, holdingSeats.hashCode);
    _$hash = $jc(_$hash, activeBookings.hashCode);
    _$hash = $jc(_$hash, pendingBookings.hashCode);
    _$hash = $jc(_$hash, refundOnCancel.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripSalesDtoOutput')
          ..add('soldSeats', soldSeats)
          ..add('holdingSeats', holdingSeats)
          ..add('activeBookings', activeBookings)
          ..add('pendingBookings', pendingBookings)
          ..add('refundOnCancel', refundOnCancel)
          ..add('changes', changes))
        .toString();
  }
}

class TripSalesDtoOutputBuilder
    implements Builder<TripSalesDtoOutput, TripSalesDtoOutputBuilder> {
  _$TripSalesDtoOutput? _$v;

  int? _soldSeats;
  int? get soldSeats => _$this._soldSeats;
  set soldSeats(int? soldSeats) => _$this._soldSeats = soldSeats;

  int? _holdingSeats;
  int? get holdingSeats => _$this._holdingSeats;
  set holdingSeats(int? holdingSeats) => _$this._holdingSeats = holdingSeats;

  int? _activeBookings;
  int? get activeBookings => _$this._activeBookings;
  set activeBookings(int? activeBookings) =>
      _$this._activeBookings = activeBookings;

  int? _pendingBookings;
  int? get pendingBookings => _$this._pendingBookings;
  set pendingBookings(int? pendingBookings) =>
      _$this._pendingBookings = pendingBookings;

  int? _refundOnCancel;
  int? get refundOnCancel => _$this._refundOnCancel;
  set refundOnCancel(int? refundOnCancel) =>
      _$this._refundOnCancel = refundOnCancel;

  ListBuilder<TripSalesDtoOutputChangesInner>? _changes;
  ListBuilder<TripSalesDtoOutputChangesInner> get changes =>
      _$this._changes ??= ListBuilder<TripSalesDtoOutputChangesInner>();
  set changes(ListBuilder<TripSalesDtoOutputChangesInner>? changes) =>
      _$this._changes = changes;

  TripSalesDtoOutputBuilder() {
    TripSalesDtoOutput._defaults(this);
  }

  TripSalesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _soldSeats = $v.soldSeats;
      _holdingSeats = $v.holdingSeats;
      _activeBookings = $v.activeBookings;
      _pendingBookings = $v.pendingBookings;
      _refundOnCancel = $v.refundOnCancel;
      _changes = $v.changes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSalesDtoOutput other) {
    _$v = other as _$TripSalesDtoOutput;
  }

  @override
  void update(void Function(TripSalesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSalesDtoOutput build() => _build();

  _$TripSalesDtoOutput _build() {
    _$TripSalesDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripSalesDtoOutput._(
            soldSeats: BuiltValueNullFieldError.checkNotNull(
                soldSeats, r'TripSalesDtoOutput', 'soldSeats'),
            holdingSeats: BuiltValueNullFieldError.checkNotNull(
                holdingSeats, r'TripSalesDtoOutput', 'holdingSeats'),
            activeBookings: BuiltValueNullFieldError.checkNotNull(
                activeBookings, r'TripSalesDtoOutput', 'activeBookings'),
            pendingBookings: BuiltValueNullFieldError.checkNotNull(
                pendingBookings, r'TripSalesDtoOutput', 'pendingBookings'),
            refundOnCancel: BuiltValueNullFieldError.checkNotNull(
                refundOnCancel, r'TripSalesDtoOutput', 'refundOnCancel'),
            changes: changes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripSalesDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
