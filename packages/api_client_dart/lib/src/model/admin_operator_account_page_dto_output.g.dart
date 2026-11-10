// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_account_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorAccountPageDtoOutput
    extends AdminOperatorAccountPageDtoOutput {
  @override
  final BuiltList<AdminOperatorAccountPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final BuiltList<AdminVehicleImageListDtoOutputOperatorsInner> operators;

  factory _$AdminOperatorAccountPageDtoOutput(
          [void Function(AdminOperatorAccountPageDtoOutputBuilder)? updates]) =>
      (AdminOperatorAccountPageDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorAccountPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.operators})
      : super._();
  @override
  AdminOperatorAccountPageDtoOutput rebuild(
          void Function(AdminOperatorAccountPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorAccountPageDtoOutputBuilder toBuilder() =>
      AdminOperatorAccountPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorAccountPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminOperatorAccountPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('operators', operators))
        .toString();
  }
}

class AdminOperatorAccountPageDtoOutputBuilder
    implements
        Builder<AdminOperatorAccountPageDtoOutput,
            AdminOperatorAccountPageDtoOutputBuilder> {
  _$AdminOperatorAccountPageDtoOutput? _$v;

  ListBuilder<AdminOperatorAccountPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminOperatorAccountPageDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminOperatorAccountPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminOperatorAccountPageDtoOutputItemsInner>? items) =>
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

  AdminOperatorAccountPageDtoOutputBuilder() {
    AdminOperatorAccountPageDtoOutput._defaults(this);
  }

  AdminOperatorAccountPageDtoOutputBuilder get _$this {
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
  void replace(AdminOperatorAccountPageDtoOutput other) {
    _$v = other as _$AdminOperatorAccountPageDtoOutput;
  }

  @override
  void update(
      void Function(AdminOperatorAccountPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorAccountPageDtoOutput build() => _build();

  _$AdminOperatorAccountPageDtoOutput _build() {
    _$AdminOperatorAccountPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorAccountPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminOperatorAccountPageDtoOutput', 'total'),
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
            r'AdminOperatorAccountPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
