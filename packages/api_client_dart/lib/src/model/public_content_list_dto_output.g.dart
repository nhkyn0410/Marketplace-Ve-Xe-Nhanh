// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_content_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicContentListDtoOutput extends PublicContentListDtoOutput {
  @override
  final BuiltList<PublicContentListDtoOutputItemsInner> items;

  factory _$PublicContentListDtoOutput(
          [void Function(PublicContentListDtoOutputBuilder)? updates]) =>
      (PublicContentListDtoOutputBuilder()..update(updates))._build();

  _$PublicContentListDtoOutput._({required this.items}) : super._();
  @override
  PublicContentListDtoOutput rebuild(
          void Function(PublicContentListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicContentListDtoOutputBuilder toBuilder() =>
      PublicContentListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicContentListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PublicContentListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PublicContentListDtoOutputBuilder
    implements
        Builder<PublicContentListDtoOutput, PublicContentListDtoOutputBuilder> {
  _$PublicContentListDtoOutput? _$v;

  ListBuilder<PublicContentListDtoOutputItemsInner>? _items;
  ListBuilder<PublicContentListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PublicContentListDtoOutputItemsInner>();
  set items(ListBuilder<PublicContentListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PublicContentListDtoOutputBuilder() {
    PublicContentListDtoOutput._defaults(this);
  }

  PublicContentListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicContentListDtoOutput other) {
    _$v = other as _$PublicContentListDtoOutput;
  }

  @override
  void update(void Function(PublicContentListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicContentListDtoOutput build() => _build();

  _$PublicContentListDtoOutput _build() {
    _$PublicContentListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PublicContentListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicContentListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
