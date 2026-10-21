// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PreferencesDtoOutput extends PreferencesDtoOutput {
  @override
  final BuiltList<PreferencesDtoOutputItemsInner> items;

  factory _$PreferencesDtoOutput(
          [void Function(PreferencesDtoOutputBuilder)? updates]) =>
      (PreferencesDtoOutputBuilder()..update(updates))._build();

  _$PreferencesDtoOutput._({required this.items}) : super._();
  @override
  PreferencesDtoOutput rebuild(
          void Function(PreferencesDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreferencesDtoOutputBuilder toBuilder() =>
      PreferencesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PreferencesDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PreferencesDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PreferencesDtoOutputBuilder
    implements Builder<PreferencesDtoOutput, PreferencesDtoOutputBuilder> {
  _$PreferencesDtoOutput? _$v;

  ListBuilder<PreferencesDtoOutputItemsInner>? _items;
  ListBuilder<PreferencesDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PreferencesDtoOutputItemsInner>();
  set items(ListBuilder<PreferencesDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PreferencesDtoOutputBuilder() {
    PreferencesDtoOutput._defaults(this);
  }

  PreferencesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PreferencesDtoOutput other) {
    _$v = other as _$PreferencesDtoOutput;
  }

  @override
  void update(void Function(PreferencesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PreferencesDtoOutput build() => _build();

  _$PreferencesDtoOutput _build() {
    _$PreferencesDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PreferencesDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PreferencesDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
