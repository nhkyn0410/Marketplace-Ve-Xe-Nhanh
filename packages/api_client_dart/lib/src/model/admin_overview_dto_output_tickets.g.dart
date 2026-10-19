// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_dto_output_tickets.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewDtoOutputTickets extends AdminOverviewDtoOutputTickets {
  @override
  final int issued;
  @override
  final int refunded;

  factory _$AdminOverviewDtoOutputTickets(
          [void Function(AdminOverviewDtoOutputTicketsBuilder)? updates]) =>
      (AdminOverviewDtoOutputTicketsBuilder()..update(updates))._build();

  _$AdminOverviewDtoOutputTickets._(
      {required this.issued, required this.refunded})
      : super._();
  @override
  AdminOverviewDtoOutputTickets rebuild(
          void Function(AdminOverviewDtoOutputTicketsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewDtoOutputTicketsBuilder toBuilder() =>
      AdminOverviewDtoOutputTicketsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewDtoOutputTickets &&
        issued == other.issued &&
        refunded == other.refunded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, issued.hashCode);
    _$hash = $jc(_$hash, refunded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewDtoOutputTickets')
          ..add('issued', issued)
          ..add('refunded', refunded))
        .toString();
  }
}

class AdminOverviewDtoOutputTicketsBuilder
    implements
        Builder<AdminOverviewDtoOutputTickets,
            AdminOverviewDtoOutputTicketsBuilder> {
  _$AdminOverviewDtoOutputTickets? _$v;

  int? _issued;
  int? get issued => _$this._issued;
  set issued(int? issued) => _$this._issued = issued;

  int? _refunded;
  int? get refunded => _$this._refunded;
  set refunded(int? refunded) => _$this._refunded = refunded;

  AdminOverviewDtoOutputTicketsBuilder() {
    AdminOverviewDtoOutputTickets._defaults(this);
  }

  AdminOverviewDtoOutputTicketsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _issued = $v.issued;
      _refunded = $v.refunded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewDtoOutputTickets other) {
    _$v = other as _$AdminOverviewDtoOutputTickets;
  }

  @override
  void update(void Function(AdminOverviewDtoOutputTicketsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewDtoOutputTickets build() => _build();

  _$AdminOverviewDtoOutputTickets _build() {
    final _$result = _$v ??
        _$AdminOverviewDtoOutputTickets._(
          issued: BuiltValueNullFieldError.checkNotNull(
              issued, r'AdminOverviewDtoOutputTickets', 'issued'),
          refunded: BuiltValueNullFieldError.checkNotNull(
              refunded, r'AdminOverviewDtoOutputTickets', 'refunded'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
