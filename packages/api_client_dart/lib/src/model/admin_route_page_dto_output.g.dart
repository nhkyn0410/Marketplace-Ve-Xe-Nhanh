// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRoutePageDtoOutput extends AdminRoutePageDtoOutput {
  @override
  final BuiltList<AdminRoutePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final AdminRoutePageDtoOutputPeriod period;

  factory _$AdminRoutePageDtoOutput(
          [void Function(AdminRoutePageDtoOutputBuilder)? updates]) =>
      (AdminRoutePageDtoOutputBuilder()..update(updates))._build();

  _$AdminRoutePageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.period})
      : super._();
  @override
  AdminRoutePageDtoOutput rebuild(
          void Function(AdminRoutePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRoutePageDtoOutputBuilder toBuilder() =>
      AdminRoutePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRoutePageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        period == other.period;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRoutePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('period', period))
        .toString();
  }
}

class AdminRoutePageDtoOutputBuilder
    implements
        Builder<AdminRoutePageDtoOutput, AdminRoutePageDtoOutputBuilder> {
  _$AdminRoutePageDtoOutput? _$v;

  ListBuilder<AdminRoutePageDtoOutputItemsInner>? _items;
  ListBuilder<AdminRoutePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminRoutePageDtoOutputItemsInner>();
  set items(ListBuilder<AdminRoutePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminRoutePageDtoOutputPeriodBuilder? _period;
  AdminRoutePageDtoOutputPeriodBuilder get period =>
      _$this._period ??= AdminRoutePageDtoOutputPeriodBuilder();
  set period(AdminRoutePageDtoOutputPeriodBuilder? period) =>
      _$this._period = period;

  AdminRoutePageDtoOutputBuilder() {
    AdminRoutePageDtoOutput._defaults(this);
  }

  AdminRoutePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _period = $v.period.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRoutePageDtoOutput other) {
    _$v = other as _$AdminRoutePageDtoOutput;
  }

  @override
  void update(void Function(AdminRoutePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRoutePageDtoOutput build() => _build();

  _$AdminRoutePageDtoOutput _build() {
    _$AdminRoutePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminRoutePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminRoutePageDtoOutput', 'total'),
            period: period.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'period';
        period.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminRoutePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
