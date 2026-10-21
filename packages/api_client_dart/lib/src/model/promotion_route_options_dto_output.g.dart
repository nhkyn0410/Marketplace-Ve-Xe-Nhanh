// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_route_options_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionRouteOptionsDtoOutput extends PromotionRouteOptionsDtoOutput {
  @override
  final BuiltList<PromotionRouteOptionsDtoOutputItemsInner> items;

  factory _$PromotionRouteOptionsDtoOutput(
          [void Function(PromotionRouteOptionsDtoOutputBuilder)? updates]) =>
      (PromotionRouteOptionsDtoOutputBuilder()..update(updates))._build();

  _$PromotionRouteOptionsDtoOutput._({required this.items}) : super._();
  @override
  PromotionRouteOptionsDtoOutput rebuild(
          void Function(PromotionRouteOptionsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionRouteOptionsDtoOutputBuilder toBuilder() =>
      PromotionRouteOptionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionRouteOptionsDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PromotionRouteOptionsDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PromotionRouteOptionsDtoOutputBuilder
    implements
        Builder<PromotionRouteOptionsDtoOutput,
            PromotionRouteOptionsDtoOutputBuilder> {
  _$PromotionRouteOptionsDtoOutput? _$v;

  ListBuilder<PromotionRouteOptionsDtoOutputItemsInner>? _items;
  ListBuilder<PromotionRouteOptionsDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PromotionRouteOptionsDtoOutputItemsInner>();
  set items(ListBuilder<PromotionRouteOptionsDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PromotionRouteOptionsDtoOutputBuilder() {
    PromotionRouteOptionsDtoOutput._defaults(this);
  }

  PromotionRouteOptionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionRouteOptionsDtoOutput other) {
    _$v = other as _$PromotionRouteOptionsDtoOutput;
  }

  @override
  void update(void Function(PromotionRouteOptionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionRouteOptionsDtoOutput build() => _build();

  _$PromotionRouteOptionsDtoOutput _build() {
    _$PromotionRouteOptionsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PromotionRouteOptionsDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PromotionRouteOptionsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
