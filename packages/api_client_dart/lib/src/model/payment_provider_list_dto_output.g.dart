// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentProviderListDtoOutput extends PaymentProviderListDtoOutput {
  @override
  final BuiltList<PaymentProviderListDtoOutputItemsInner> items;

  factory _$PaymentProviderListDtoOutput(
          [void Function(PaymentProviderListDtoOutputBuilder)? updates]) =>
      (PaymentProviderListDtoOutputBuilder()..update(updates))._build();

  _$PaymentProviderListDtoOutput._({required this.items}) : super._();
  @override
  PaymentProviderListDtoOutput rebuild(
          void Function(PaymentProviderListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentProviderListDtoOutputBuilder toBuilder() =>
      PaymentProviderListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentProviderListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PaymentProviderListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class PaymentProviderListDtoOutputBuilder
    implements
        Builder<PaymentProviderListDtoOutput,
            PaymentProviderListDtoOutputBuilder> {
  _$PaymentProviderListDtoOutput? _$v;

  ListBuilder<PaymentProviderListDtoOutputItemsInner>? _items;
  ListBuilder<PaymentProviderListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PaymentProviderListDtoOutputItemsInner>();
  set items(ListBuilder<PaymentProviderListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  PaymentProviderListDtoOutputBuilder() {
    PaymentProviderListDtoOutput._defaults(this);
  }

  PaymentProviderListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentProviderListDtoOutput other) {
    _$v = other as _$PaymentProviderListDtoOutput;
  }

  @override
  void update(void Function(PaymentProviderListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentProviderListDtoOutput build() => _build();

  _$PaymentProviderListDtoOutput _build() {
    _$PaymentProviderListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PaymentProviderListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentProviderListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
