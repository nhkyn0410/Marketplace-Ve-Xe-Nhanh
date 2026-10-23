// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_assignment_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeAssignmentListDtoOutput
    extends EmployeeAssignmentListDtoOutput {
  @override
  final BuiltList<EmployeeAssignmentListDtoOutputItemsInner> items;

  factory _$EmployeeAssignmentListDtoOutput(
          [void Function(EmployeeAssignmentListDtoOutputBuilder)? updates]) =>
      (EmployeeAssignmentListDtoOutputBuilder()..update(updates))._build();

  _$EmployeeAssignmentListDtoOutput._({required this.items}) : super._();
  @override
  EmployeeAssignmentListDtoOutput rebuild(
          void Function(EmployeeAssignmentListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeAssignmentListDtoOutputBuilder toBuilder() =>
      EmployeeAssignmentListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeAssignmentListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'EmployeeAssignmentListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class EmployeeAssignmentListDtoOutputBuilder
    implements
        Builder<EmployeeAssignmentListDtoOutput,
            EmployeeAssignmentListDtoOutputBuilder> {
  _$EmployeeAssignmentListDtoOutput? _$v;

  ListBuilder<EmployeeAssignmentListDtoOutputItemsInner>? _items;
  ListBuilder<EmployeeAssignmentListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<EmployeeAssignmentListDtoOutputItemsInner>();
  set items(ListBuilder<EmployeeAssignmentListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  EmployeeAssignmentListDtoOutputBuilder() {
    EmployeeAssignmentListDtoOutput._defaults(this);
  }

  EmployeeAssignmentListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeAssignmentListDtoOutput other) {
    _$v = other as _$EmployeeAssignmentListDtoOutput;
  }

  @override
  void update(void Function(EmployeeAssignmentListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeAssignmentListDtoOutput build() => _build();

  _$EmployeeAssignmentListDtoOutput _build() {
    _$EmployeeAssignmentListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$EmployeeAssignmentListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EmployeeAssignmentListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
