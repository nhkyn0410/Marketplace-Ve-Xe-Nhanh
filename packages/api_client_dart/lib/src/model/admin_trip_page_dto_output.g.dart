// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trip_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTripPageDtoOutput extends AdminTripPageDtoOutput {
  @override
  final BuiltList<AdminTripPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final AdminRoutePageDtoOutputPeriod period;

  factory _$AdminTripPageDtoOutput(
          [void Function(AdminTripPageDtoOutputBuilder)? updates]) =>
      (AdminTripPageDtoOutputBuilder()..update(updates))._build();

  _$AdminTripPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.period})
      : super._();
  @override
  AdminTripPageDtoOutput rebuild(
          void Function(AdminTripPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminTripPageDtoOutputBuilder toBuilder() =>
      AdminTripPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTripPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminTripPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('period', period))
        .toString();
  }
}

class AdminTripPageDtoOutputBuilder
    implements Builder<AdminTripPageDtoOutput, AdminTripPageDtoOutputBuilder> {
  _$AdminTripPageDtoOutput? _$v;

  ListBuilder<AdminTripPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminTripPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminTripPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminTripPageDtoOutputItemsInner>? items) =>
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

  AdminTripPageDtoOutputBuilder() {
    AdminTripPageDtoOutput._defaults(this);
  }

  AdminTripPageDtoOutputBuilder get _$this {
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
  void replace(AdminTripPageDtoOutput other) {
    _$v = other as _$AdminTripPageDtoOutput;
  }

  @override
  void update(void Function(AdminTripPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTripPageDtoOutput build() => _build();

  _$AdminTripPageDtoOutput _build() {
    _$AdminTripPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminTripPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminTripPageDtoOutput', 'total'),
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
            r'AdminTripPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
