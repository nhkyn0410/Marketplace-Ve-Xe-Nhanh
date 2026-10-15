// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_list_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminApplicationListResponseDtoOutput
    extends AdminApplicationListResponseDtoOutput {
  @override
  final BuiltList<AdminApplicationListResponseDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$AdminApplicationListResponseDtoOutput(
          [void Function(AdminApplicationListResponseDtoOutputBuilder)?
              updates]) =>
      (AdminApplicationListResponseDtoOutputBuilder()..update(updates))
          ._build();

  _$AdminApplicationListResponseDtoOutput._(
      {required this.items, this.nextCursor})
      : super._();
  @override
  AdminApplicationListResponseDtoOutput rebuild(
          void Function(AdminApplicationListResponseDtoOutputBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationListResponseDtoOutputBuilder toBuilder() =>
      AdminApplicationListResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationListResponseDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationListResponseDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminApplicationListResponseDtoOutputBuilder
    implements
        Builder<AdminApplicationListResponseDtoOutput,
            AdminApplicationListResponseDtoOutputBuilder> {
  _$AdminApplicationListResponseDtoOutput? _$v;

  ListBuilder<AdminApplicationListResponseDtoOutputItemsInner>? _items;
  ListBuilder<AdminApplicationListResponseDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminApplicationListResponseDtoOutputItemsInner>();
  set items(
          ListBuilder<AdminApplicationListResponseDtoOutputItemsInner>?
              items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminApplicationListResponseDtoOutputBuilder() {
    AdminApplicationListResponseDtoOutput._defaults(this);
  }

  AdminApplicationListResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationListResponseDtoOutput other) {
    _$v = other as _$AdminApplicationListResponseDtoOutput;
  }

  @override
  void update(
      void Function(AdminApplicationListResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationListResponseDtoOutput build() => _build();

  _$AdminApplicationListResponseDtoOutput _build() {
    _$AdminApplicationListResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminApplicationListResponseDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminApplicationListResponseDtoOutput',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
