// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_employee_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEmployeePageDtoOutput extends AdminEmployeePageDtoOutput {
  @override
  final BuiltList<AdminEmployeePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final BuiltList<AdminVehicleImageListDtoOutputOperatorsInner> operators;

  factory _$AdminEmployeePageDtoOutput(
          [void Function(AdminEmployeePageDtoOutputBuilder)? updates]) =>
      (AdminEmployeePageDtoOutputBuilder()..update(updates))._build();

  _$AdminEmployeePageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.operators})
      : super._();
  @override
  AdminEmployeePageDtoOutput rebuild(
          void Function(AdminEmployeePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminEmployeePageDtoOutputBuilder toBuilder() =>
      AdminEmployeePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmployeePageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        operators == other.operators;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, operators.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEmployeePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('operators', operators))
        .toString();
  }
}

class AdminEmployeePageDtoOutputBuilder
    implements
        Builder<AdminEmployeePageDtoOutput, AdminEmployeePageDtoOutputBuilder> {
  _$AdminEmployeePageDtoOutput? _$v;

  ListBuilder<AdminEmployeePageDtoOutputItemsInner>? _items;
  ListBuilder<AdminEmployeePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminEmployeePageDtoOutputItemsInner>();
  set items(ListBuilder<AdminEmployeePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>? _operators;
  ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner> get operators =>
      _$this._operators ??=
          ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>();
  set operators(
          ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>?
              operators) =>
      _$this._operators = operators;

  AdminEmployeePageDtoOutputBuilder() {
    AdminEmployeePageDtoOutput._defaults(this);
  }

  AdminEmployeePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _operators = $v.operators.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmployeePageDtoOutput other) {
    _$v = other as _$AdminEmployeePageDtoOutput;
  }

  @override
  void update(void Function(AdminEmployeePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmployeePageDtoOutput build() => _build();

  _$AdminEmployeePageDtoOutput _build() {
    _$AdminEmployeePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminEmployeePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminEmployeePageDtoOutput', 'total'),
            operators: operators.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'operators';
        operators.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminEmployeePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
