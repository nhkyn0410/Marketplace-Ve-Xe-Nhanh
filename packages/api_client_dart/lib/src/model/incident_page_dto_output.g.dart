// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IncidentPageDtoOutput extends IncidentPageDtoOutput {
  @override
  final BuiltList<IncidentPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$IncidentPageDtoOutput(
          [void Function(IncidentPageDtoOutputBuilder)? updates]) =>
      (IncidentPageDtoOutputBuilder()..update(updates))._build();

  _$IncidentPageDtoOutput._({required this.items, this.nextCursor}) : super._();
  @override
  IncidentPageDtoOutput rebuild(
          void Function(IncidentPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentPageDtoOutputBuilder toBuilder() =>
      IncidentPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'IncidentPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class IncidentPageDtoOutputBuilder
    implements Builder<IncidentPageDtoOutput, IncidentPageDtoOutputBuilder> {
  _$IncidentPageDtoOutput? _$v;

  ListBuilder<IncidentPageDtoOutputItemsInner>? _items;
  ListBuilder<IncidentPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<IncidentPageDtoOutputItemsInner>();
  set items(ListBuilder<IncidentPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  IncidentPageDtoOutputBuilder() {
    IncidentPageDtoOutput._defaults(this);
  }

  IncidentPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentPageDtoOutput other) {
    _$v = other as _$IncidentPageDtoOutput;
  }

  @override
  void update(void Function(IncidentPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentPageDtoOutput build() => _build();

  _$IncidentPageDtoOutput _build() {
    _$IncidentPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$IncidentPageDtoOutput._(
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
            r'IncidentPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
