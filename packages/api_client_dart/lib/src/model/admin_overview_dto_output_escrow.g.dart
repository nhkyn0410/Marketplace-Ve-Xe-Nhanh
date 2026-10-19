// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output_escrow.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutputEscrow extends AdminOverviewDtoOutputEscrow {
  @override
  final int held;
  @override
  final int eligible;
  @override
  final int pending;
  @override
  final int onHold;
  @override
  final int commissionInRange;

  factory _$AdminOverviewDtoOutputEscrow(
          [void Function(AdminOverviewDtoOutputEscrowBuilder)? updates]) =>
      (AdminOverviewDtoOutputEscrowBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutputEscrow._(
      {required this.held,
      required this.eligible,
      required this.pending,
      required this.onHold,
      required this.commissionInRange})
      : super._();
  @override
  AdminOverviewDtoOutputEscrow rebuild(
          void Function(AdminOverviewDtoOutputEscrowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputEscrowBuilder toBuilder() =>
      AdminOverviewDtoOutputEscrowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutputEscrow &&
        held == other.held &&
        eligible == other.eligible &&
        pending == other.pending &&
        onHold == other.onHold &&
        commissionInRange == other.commissionInRange;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, held.hashCode);
    _$hash = $jc(_$hash, eligible.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jc(_$hash, onHold.hashCode);
    _$hash = $jc(_$hash, commissionInRange.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutputEscrow')
          ..add('held', held)
          ..add('eligible', eligible)
          ..add('pending', pending)
          ..add('onHold', onHold)
          ..add('commissionInRange', commissionInRange))
        .toString();
  }
}

class AdminOverviewDtoOutputEscrowBuilder
    implements
        Builder<AdminOverviewDtoOutputEscrow,
            AdminOverviewDtoOutputEscrowBuilder> {
  _$AdminOverviewDtoOutputEscrow? _$v;

  int? _held;
  int? get held => _$this._held;
  set held(int? held) => _$this._held = held;

  int? _eligible;
  int? get eligible => _$this._eligible;
  set eligible(int? eligible) => _$this._eligible = eligible;

  int? _pending;
  int? get pending => _$this._pending;
  set pending(int? pending) => _$this._pending = pending;

  int? _onHold;
  int? get onHold => _$this._onHold;
  set onHold(int? onHold) => _$this._onHold = onHold;

  int? _commissionInRange;
  int? get commissionInRange => _$this._commissionInRange;
  set commissionInRange(int? commissionInRange) =>
      _$this._commissionInRange = commissionInRange;

  AdminOverviewDtoOutputEscrowBuilder() {
    AdminOverviewDtoOutputEscrow._defaults(this);
  }

  AdminOverviewDtoOutputEscrowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _held = $v.held;
      _eligible = $v.eligible;
      _pending = $v.pending;
      _onHold = $v.onHold;
      _commissionInRange = $v.commissionInRange;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutputEscrow other) {
    _$v = other as _$AdminOverviewDtoOutputEscrow;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputEscrowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutputEscrow build() => _build();

  _$AdminOverviewDtoOutputEscrow _build() {
    final _$result = _$v ??
        _$AdminOverviewDtoOutputEscrow._(
          held: BuiltValueNullFieldError.checkNotNull(
              held, r'AdminOverviewDtoOutputEscrow', 'held'),
          eligible: BuiltValueNullFieldError.checkNotNull(
              eligible, r'AdminOverviewDtoOutputEscrow', 'eligible'),
          pending: BuiltValueNullFieldError.checkNotNull(
              pending, r'AdminOverviewDtoOutputEscrow', 'pending'),
          onHold: BuiltValueNullFieldError.checkNotNull(
              onHold, r'AdminOverviewDtoOutputEscrow', 'onHold'),
          commissionInRange: BuiltValueNullFieldError.checkNotNull(
              commissionInRange,
              r'AdminOverviewDtoOutputEscrow',
              'commissionInRange'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
