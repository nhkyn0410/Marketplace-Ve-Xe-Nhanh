// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_promotion_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicPromotionListDtoOutput extends PublicPromotionListDtoOutput {
  @override
  final BuiltList<PublicPromotionListDtoOutputItemsInner> items;

  factory _$PublicPromotionListDtoOutput(
          [void Function(PublicPromotionListDtoOutputBuilder)? updates]) =>
      (PublicPromotionListDtoOutputBuilder()..update(updates))._build();

  _$PublicPromotionListDtoOutput._({required this.items}) : super._();
  @override
  PublicPromotionListDtoOutput rebuild(
          void Function(PublicPromotionListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicPromotionListDtoOutputBuilder toBuilder() =>
      PublicPromotionListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicPromotionListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PublicPromotionListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PublicPromotionListDtoOutputBuilder
    implements
        Builder<PublicPromotionListDtoOutput,
            PublicPromotionListDtoOutputBuilder> {
  _$PublicPromotionListDtoOutput? _$v;

  ListBuilder<PublicPromotionListDtoOutputItemsInner>? _items;
  ListBuilder<PublicPromotionListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PublicPromotionListDtoOutputItemsInner>();
  set items(ListBuilder<PublicPromotionListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PublicPromotionListDtoOutputBuilder() {
    PublicPromotionListDtoOutput._defaults(this);
  }

  PublicPromotionListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicPromotionListDtoOutput other) {
    _$v = other as _$PublicPromotionListDtoOutput;
  }

  @override
  void update(void Function(PublicPromotionListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicPromotionListDtoOutput build() => _build();

  _$PublicPromotionListDtoOutput _build() {
    _$PublicPromotionListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PublicPromotionListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicPromotionListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
