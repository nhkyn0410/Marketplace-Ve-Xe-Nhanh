// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_stop_point_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorStopPointListDtoOutput
    extends AdminOperatorStopPointListDtoOutput {
  @override
  final BuiltList<AdminOperatorStopPointListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminOperatorStopPointListDtoOutput(
          [void Function(AdminOperatorStopPointListDtoOutputBuilder)?
              updates]) =>
      (AdminOperatorStopPointListDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorStopPointListDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminOperatorStopPointListDtoOutput rebuild(
          void Function(AdminOperatorStopPointListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorStopPointListDtoOutputBuilder toBuilder() =>
      AdminOperatorStopPointListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorStopPointListDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorStopPointListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminOperatorStopPointListDtoOutputBuilder
    implements
        Builder<AdminOperatorStopPointListDtoOutput,
            AdminOperatorStopPointListDtoOutputBuilder> {
  _$AdminOperatorStopPointListDtoOutput? _$v;

  ListBuilder<AdminOperatorStopPointListDtoOutputItemsInner>? _items;
  ListBuilder<AdminOperatorStopPointListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminOperatorStopPointListDtoOutputItemsInner>();
  set items(
          ListBuilder<AdminOperatorStopPointListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminOperatorStopPointListDtoOutputBuilder() {
    AdminOperatorStopPointListDtoOutput._defaults(this);
  }

  AdminOperatorStopPointListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorStopPointListDtoOutput other) {
    _$v = other as _$AdminOperatorStopPointListDtoOutput;
  }

  @override
  void update(
      void Function(AdminOperatorStopPointListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorStopPointListDtoOutput build() => _build();

  _$AdminOperatorStopPointListDtoOutput _build() {
    _$AdminOperatorStopPointListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorStopPointListDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminOperatorStopPointListDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AdminOperatorStopPointListDtoOutput',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
