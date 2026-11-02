// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_operator_list_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeaturedOperatorListResponseDtoOutput
    extends FeaturedOperatorListResponseDtoOutput {
  @override
  final BuiltList<FeaturedOperatorListResponseDtoOutputItemsInner> items;

  factory _$FeaturedOperatorListResponseDtoOutput(
          [void Function(FeaturedOperatorListResponseDtoOutputBuilder)?
              updates]) =>
      (FeaturedOperatorListResponseDtoOutputBuilder()..update(updates))
          ._build();

  _$FeaturedOperatorListResponseDtoOutput._({required this.items}) : super._();
  @override
  FeaturedOperatorListResponseDtoOutput rebuild(
          void Function(FeaturedOperatorListResponseDtoOutputBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeaturedOperatorListResponseDtoOutputBuilder toBuilder() =>
      FeaturedOperatorListResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeaturedOperatorListResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(
            r'FeaturedOperatorListResponseDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class FeaturedOperatorListResponseDtoOutputBuilder
    implements
        Builder<FeaturedOperatorListResponseDtoOutput,
            FeaturedOperatorListResponseDtoOutputBuilder> {
  _$FeaturedOperatorListResponseDtoOutput? _$v;

  ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInner>? _items;
  ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInner>();
  set items(
          ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInner>?
              items) =>
      _$this._items = items;

  FeaturedOperatorListResponseDtoOutputBuilder() {
    FeaturedOperatorListResponseDtoOutput._defaults(this);
  }

  FeaturedOperatorListResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeaturedOperatorListResponseDtoOutput other) {
    _$v = other as _$FeaturedOperatorListResponseDtoOutput;
  }

  @override
  void update(
      void Function(FeaturedOperatorListResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeaturedOperatorListResponseDtoOutput build() => _build();

  _$FeaturedOperatorListResponseDtoOutput _build() {
    _$FeaturedOperatorListResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$FeaturedOperatorListResponseDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FeaturedOperatorListResponseDtoOutput',
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
