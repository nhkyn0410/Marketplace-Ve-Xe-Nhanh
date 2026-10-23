// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckInResultDtoOutput extends CheckInResultDtoOutput {
  @override
  final TicketVerifyResultDtoOutputTicket? ticket;
  @override
  final int checkedInCount;
  @override
  final int ticketCount;

  factory _$CheckInResultDtoOutput(
          [void Function(CheckInResultDtoOutputBuilder)? updates]) =>
      (CheckInResultDtoOutputBuilder()..update(updates))._build();

  _$CheckInResultDtoOutput._(
      {this.ticket, required this.checkedInCount, required this.ticketCount})
      : super._();
  @override
  CheckInResultDtoOutput rebuild(
          void Function(CheckInResultDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckInResultDtoOutputBuilder toBuilder() =>
      CheckInResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckInResultDtoOutput &&
        ticket == other.ticket &&
        checkedInCount == other.checkedInCount &&
        ticketCount == other.ticketCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticket.hashCode);
    _$hash = $jc(_$hash, checkedInCount.hashCode);
    _$hash = $jc(_$hash, ticketCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckInResultDtoOutput')
          ..add('ticket', ticket)
          ..add('checkedInCount', checkedInCount)
          ..add('ticketCount', ticketCount))
        .toString();
  }
}

class CheckInResultDtoOutputBuilder
    implements Builder<CheckInResultDtoOutput, CheckInResultDtoOutputBuilder> {
  _$CheckInResultDtoOutput? _$v;

  TicketVerifyResultDtoOutputTicketBuilder? _ticket;
  TicketVerifyResultDtoOutputTicketBuilder get ticket =>
      _$this._ticket ??= TicketVerifyResultDtoOutputTicketBuilder();
  set ticket(TicketVerifyResultDtoOutputTicketBuilder? ticket) =>
      _$this._ticket = ticket;

  int? _checkedInCount;
  int? get checkedInCount => _$this._checkedInCount;
  set checkedInCount(int? checkedInCount) =>
      _$this._checkedInCount = checkedInCount;

  int? _ticketCount;
  int? get ticketCount => _$this._ticketCount;
  set ticketCount(int? ticketCount) => _$this._ticketCount = ticketCount;

  CheckInResultDtoOutputBuilder() {
    CheckInResultDtoOutput._defaults(this);
  }

  CheckInResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticket = $v.ticket?.toBuilder();
      _checkedInCount = $v.checkedInCount;
      _ticketCount = $v.ticketCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckInResultDtoOutput other) {
    _$v = other as _$CheckInResultDtoOutput;
  }

  @override
  void update(void Function(CheckInResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckInResultDtoOutput build() => _build();

  _$CheckInResultDtoOutput _build() {
    _$CheckInResultDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CheckInResultDtoOutput._(
            ticket: _ticket?.build(),
            checkedInCount: BuiltValueNullFieldError.checkNotNull(
                checkedInCount, r'CheckInResultDtoOutput', 'checkedInCount'),
            ticketCount: BuiltValueNullFieldError.checkNotNull(
                ticketCount, r'CheckInResultDtoOutput', 'ticketCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticket';
        _ticket?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckInResultDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
