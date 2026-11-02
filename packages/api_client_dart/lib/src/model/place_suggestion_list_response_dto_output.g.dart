// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion_list_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlaceSuggestionListResponseDtoOutput
    extends PlaceSuggestionListResponseDtoOutput {
  @override
  final BuiltList<PlaceSuggestionListResponseDtoOutputItemsInner> items;

  factory _$PlaceSuggestionListResponseDtoOutput(
          [void Function(PlaceSuggestionListResponseDtoOutputBuilder)?
              updates]) =>
      (PlaceSuggestionListResponseDtoOutputBuilder()..update(updates))._build();

  _$PlaceSuggestionListResponseDtoOutput._({required this.items}) : super._();
  @override
  PlaceSuggestionListResponseDtoOutput rebuild(
          void Function(PlaceSuggestionListResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaceSuggestionListResponseDtoOutputBuilder toBuilder() =>
      PlaceSuggestionListResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlaceSuggestionListResponseDtoOutput &&
        items == other.items;
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
    return (newBuiltValueToStringHelper(r'PlaceSuggestionListResponseDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PlaceSuggestionListResponseDtoOutputBuilder
    implements
        Builder<PlaceSuggestionListResponseDtoOutput,
            PlaceSuggestionListResponseDtoOutputBuilder> {
  _$PlaceSuggestionListResponseDtoOutput? _$v;

  ListBuilder<PlaceSuggestionListResponseDtoOutputItemsInner>? _items;
  ListBuilder<PlaceSuggestionListResponseDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<PlaceSuggestionListResponseDtoOutputItemsInner>();
  set items(
          ListBuilder<PlaceSuggestionListResponseDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PlaceSuggestionListResponseDtoOutputBuilder() {
    PlaceSuggestionListResponseDtoOutput._defaults(this);
  }

  PlaceSuggestionListResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlaceSuggestionListResponseDtoOutput other) {
    _$v = other as _$PlaceSuggestionListResponseDtoOutput;
  }

  @override
  void update(
      void Function(PlaceSuggestionListResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlaceSuggestionListResponseDtoOutput build() => _build();

  _$PlaceSuggestionListResponseDtoOutput _build() {
    _$PlaceSuggestionListResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PlaceSuggestionListResponseDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlaceSuggestionListResponseDtoOutput',
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
