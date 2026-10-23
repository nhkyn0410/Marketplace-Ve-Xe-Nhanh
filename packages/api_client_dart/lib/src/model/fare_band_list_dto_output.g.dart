// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FareBandListDtoOutput extends FareBandListDtoOutput {
  @override
  final BuiltList<FareBandListDtoOutputItemsInner> items;

  factory _$FareBandListDtoOutput(
          [void Function(FareBandListDtoOutputBuilder)? updates]) =>
      (FareBandListDtoOutputBuilder()..update(updates))._build();

  _$FareBandListDtoOutput._({required this.items}) : super._();
  @override
  FareBandListDtoOutput rebuild(
          void Function(FareBandListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FareBandListDtoOutputBuilder toBuilder() =>
      FareBandListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FareBandListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'FareBandListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class FareBandListDtoOutputBuilder
    implements Builder<FareBandListDtoOutput, FareBandListDtoOutputBuilder> {
  _$FareBandListDtoOutput? _$v;

  ListBuilder<FareBandListDtoOutputItemsInner>? _items;
  ListBuilder<FareBandListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<FareBandListDtoOutputItemsInner>();
  set items(ListBuilder<FareBandListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  FareBandListDtoOutputBuilder() {
    FareBandListDtoOutput._defaults(this);
  }

  FareBandListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FareBandListDtoOutput other) {
    _$v = other as _$FareBandListDtoOutput;
  }

  @override
  void update(void Function(FareBandListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FareBandListDtoOutput build() => _build();

  _$FareBandListDtoOutput _build() {
    _$FareBandListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$FareBandListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FareBandListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
