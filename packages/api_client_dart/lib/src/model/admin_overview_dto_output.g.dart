// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutput extends AdminOverviewDtoOutput {
  @override
  final int gmv;
  @override
  final int previousGmv;
  @override
  final AdminOverviewDtoOutputBookings bookings;
  @override
  final AdminOverviewDtoOutputTickets tickets;
  @override
  final AdminOverviewDtoOutputEscrow escrow;
  @override
  final BuiltList<AdminOverviewDtoOutputDailyInner> daily;
  @override
  final AdminOverviewDtoOutputQueues queues;

  factory _$AdminOverviewDtoOutput(
          [void Function(AdminOverviewDtoOutputBuilder)? updates]) =>
      (AdminOverviewDtoOutputBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutput._(
      {required this.gmv,
      required this.previousGmv,
      required this.bookings,
      required this.tickets,
      required this.escrow,
      required this.daily,
      required this.queues})
      : super._();
  @override
  AdminOverviewDtoOutput rebuild(
          void Function(AdminOverviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputBuilder toBuilder() =>
      AdminOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutput &&
        gmv == other.gmv &&
        previousGmv == other.previousGmv &&
        bookings == other.bookings &&
        tickets == other.tickets &&
        escrow == other.escrow &&
        daily == other.daily &&
        queues == other.queues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jc(_$hash, previousGmv.hashCode);
    _$hash = $jc(_$hash, bookings.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, escrow.hashCode);
    _$hash = $jc(_$hash, daily.hashCode);
    _$hash = $jc(_$hash, queues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutput')
          ..add('gmv', gmv)
          ..add('previousGmv', previousGmv)
          ..add('bookings', bookings)
          ..add('tickets', tickets)
          ..add('escrow', escrow)
          ..add('daily', daily)
          ..add('queues', queues))
        .toString();
  }
}

class AdminOverviewDtoOutputBuilder
    implements Builder<AdminOverviewDtoOutput, AdminOverviewDtoOutputBuilder> {
  _$AdminOverviewDtoOutput? _$v;

  int? _gmv;
  int? get gmv => _$this._gmv;
  set gmv(int? gmv) => _$this._gmv = gmv;

  int? _previousGmv;
  int? get previousGmv => _$this._previousGmv;
  set previousGmv(int? previousGmv) => _$this._previousGmv = previousGmv;

  AdminOverviewDtoOutputBookingsBuilder? _bookings;
  AdminOverviewDtoOutputBookingsBuilder get bookings =>
      _$this._bookings ??= AdminOverviewDtoOutputBookingsBuilder();
  set bookings(AdminOverviewDtoOutputBookingsBuilder? bookings) =>
      _$this._bookings = bookings;

  AdminOverviewDtoOutputTicketsBuilder? _tickets;
  AdminOverviewDtoOutputTicketsBuilder get tickets =>
      _$this._tickets ??= AdminOverviewDtoOutputTicketsBuilder();
  set tickets(AdminOverviewDtoOutputTicketsBuilder? tickets) =>
      _$this._tickets = tickets;

  AdminOverviewDtoOutputEscrowBuilder? _escrow;
  AdminOverviewDtoOutputEscrowBuilder get escrow =>
      _$this._escrow ??= AdminOverviewDtoOutputEscrowBuilder();
  set escrow(AdminOverviewDtoOutputEscrowBuilder? escrow) =>
      _$this._escrow = escrow;

  ListBuilder<AdminOverviewDtoOutputDailyInner>? _daily;
  ListBuilder<AdminOverviewDtoOutputDailyInner> get daily =>
      _$this._daily ??= ListBuilder<AdminOverviewDtoOutputDailyInner>();
  set daily(ListBuilder<AdminOverviewDtoOutputDailyInner>? daily) =>
      _$this._daily = daily;

  AdminOverviewDtoOutputQueuesBuilder? _queues;
  AdminOverviewDtoOutputQueuesBuilder get queues =>
      _$this._queues ??= AdminOverviewDtoOutputQueuesBuilder();
  set queues(AdminOverviewDtoOutputQueuesBuilder? queues) =>
      _$this._queues = queues;

  AdminOverviewDtoOutputBuilder() {
    AdminOverviewDtoOutput._defaults(this);
  }

  AdminOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gmv = $v.gmv;
      _previousGmv = $v.previousGmv;
      _bookings = $v.bookings.toBuilder();
      _tickets = $v.tickets.toBuilder();
      _escrow = $v.escrow.toBuilder();
      _daily = $v.daily.toBuilder();
      _queues = $v.queues.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutput other) {
    _$v = other as _$AdminOverviewDtoOutput;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutput build() => _build();

  _$AdminOverviewDtoOutput _build() {
    _$AdminOverviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOverviewDtoOutput._(
            gmv: BuiltValueNullFieldError.checkNotNull(
                gmv, r'AdminOverviewDtoOutput', 'gmv'),
            previousGmv: BuiltValueNullFieldError.checkNotNull(
                previousGmv, r'AdminOverviewDtoOutput', 'previousGmv'),
            bookings: bookings.build(),
            tickets: tickets.build(),
            escrow: escrow.build(),
            daily: daily.build(),
            queues: queues.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bookings';
        bookings.build();
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'escrow';
        escrow.build();
        _$failedField = 'daily';
        daily.build();
        _$failedField = 'queues';
        queues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOverviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
