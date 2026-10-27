// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_route_list_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PopularRouteListResponseDtoOutput
    extends PopularRouteListResponseDtoOutput {
  @override
  final BuiltList<PopularRouteListResponseDtoOutputItemsInner> items;

  factory _$PopularRouteListResponseDtoOutput(
          [void Function(PopularRouteListResponseDtoOutputBuilder)? updates]) =>
      (PopularRouteListResponseDtoOutputBuilder()..update(updates))._build();

  _$PopularRouteListResponseDtoOutput._({required this.items}) : super._();
  @override
  PopularRouteListResponseDtoOutput rebuild(
          void Function(PopularRouteListResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PopularRouteListResponseDtoOutputBuilder toBuilder() =>
      PopularRouteListResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PopularRouteListResponseDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PopularRouteListResponseDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PopularRouteListResponseDtoOutputBuilder
    implements
        Builder<PopularRouteListResponseDtoOutput,
            PopularRouteListResponseDtoOutputBuilder> {
  _$PopularRouteListResponseDtoOutput? _$v;

  ListBuilder<PopularRouteListResponseDtoOutputItemsInner>? _items;
  ListBuilder<PopularRouteListResponseDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<PopularRouteListResponseDtoOutputItemsInner>();
  set items(ListBuilder<PopularRouteListResponseDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PopularRouteListResponseDtoOutputBuilder() {
    PopularRouteListResponseDtoOutput._defaults(this);
  }

  PopularRouteListResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PopularRouteListResponseDtoOutput other) {
    _$v = other as _$PopularRouteListResponseDtoOutput;
  }

  @override
  void update(
      void Function(PopularRouteListResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PopularRouteListResponseDtoOutput build() => _build();

  _$PopularRouteListResponseDtoOutput _build() {
    _$PopularRouteListResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PopularRouteListResponseDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PopularRouteListResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
