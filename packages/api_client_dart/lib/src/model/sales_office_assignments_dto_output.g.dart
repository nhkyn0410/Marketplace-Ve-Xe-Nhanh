// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_assignments_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeAssignmentsDtoOutput
    extends SalesOfficeAssignmentsDtoOutput {
  @override
  final BuiltList<SalesOfficeAssignmentsDtoOutputItemsInner> items;

  factory _$SalesOfficeAssignmentsDtoOutput(
          [void Function(SalesOfficeAssignmentsDtoOutputBuilder)? updates]) =>
      (SalesOfficeAssignmentsDtoOutputBuilder()..update(updates))._build();

  _$SalesOfficeAssignmentsDtoOutput._({required this.items}) : super._();
  @override
  SalesOfficeAssignmentsDtoOutput rebuild(
          void Function(SalesOfficeAssignmentsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeAssignmentsDtoOutputBuilder toBuilder() =>
      SalesOfficeAssignmentsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeAssignmentsDtoOutput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesOfficeAssignmentsDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class SalesOfficeAssignmentsDtoOutputBuilder
    implements
        Builder<SalesOfficeAssignmentsDtoOutput,
            SalesOfficeAssignmentsDtoOutputBuilder> {
  _$SalesOfficeAssignmentsDtoOutput? _$v;

  ListBuilder<SalesOfficeAssignmentsDtoOutputItemsInner>? _items;
  ListBuilder<SalesOfficeAssignmentsDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<SalesOfficeAssignmentsDtoOutputItemsInner>();
  set items(ListBuilder<SalesOfficeAssignmentsDtoOutputItemsInner>? items) =>
      _$this._items = items;

  SalesOfficeAssignmentsDtoOutputBuilder() {
    SalesOfficeAssignmentsDtoOutput._defaults(this);
  }

  SalesOfficeAssignmentsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeAssignmentsDtoOutput other) {
    _$v = other as _$SalesOfficeAssignmentsDtoOutput;
  }

  @override
  void update(void Function(SalesOfficeAssignmentsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeAssignmentsDtoOutput build() => _build();

  _$SalesOfficeAssignmentsDtoOutput _build() {
    _$SalesOfficeAssignmentsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SalesOfficeAssignmentsDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalesOfficeAssignmentsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
