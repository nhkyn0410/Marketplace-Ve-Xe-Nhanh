// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_route_suggestion_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubRouteSuggestionListDtoOutput
    extends SubRouteSuggestionListDtoOutput {
  @override
  final BuiltList<SubRouteSuggestionListDtoOutputItemsInner> items;

  factory _$SubRouteSuggestionListDtoOutput(
          [void Function(SubRouteSuggestionListDtoOutputBuilder)? updates]) =>
      (SubRouteSuggestionListDtoOutputBuilder()..update(updates))._build();

  _$SubRouteSuggestionListDtoOutput._({required this.items}) : super._();
  @override
  SubRouteSuggestionListDtoOutput rebuild(
          void Function(SubRouteSuggestionListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubRouteSuggestionListDtoOutputBuilder toBuilder() =>
      SubRouteSuggestionListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubRouteSuggestionListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'SubRouteSuggestionListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class SubRouteSuggestionListDtoOutputBuilder
    implements
        Builder<SubRouteSuggestionListDtoOutput,
            SubRouteSuggestionListDtoOutputBuilder> {
  _$SubRouteSuggestionListDtoOutput? _$v;

  ListBuilder<SubRouteSuggestionListDtoOutputItemsInner>? _items;
  ListBuilder<SubRouteSuggestionListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<SubRouteSuggestionListDtoOutputItemsInner>();
  set items(ListBuilder<SubRouteSuggestionListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  SubRouteSuggestionListDtoOutputBuilder() {
    SubRouteSuggestionListDtoOutput._defaults(this);
  }

  SubRouteSuggestionListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubRouteSuggestionListDtoOutput other) {
    _$v = other as _$SubRouteSuggestionListDtoOutput;
  }

  @override
  void update(void Function(SubRouteSuggestionListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubRouteSuggestionListDtoOutput build() => _build();

  _$SubRouteSuggestionListDtoOutput _build() {
    _$SubRouteSuggestionListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SubRouteSuggestionListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubRouteSuggestionListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
