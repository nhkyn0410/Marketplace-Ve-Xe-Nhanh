// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_dispute_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerDisputeListDtoOutput extends CustomerDisputeListDtoOutput {
  @override
  final BuiltList<DisputePageDtoOutputItemsInner> items;

  factory _$CustomerDisputeListDtoOutput(
          [void Function(CustomerDisputeListDtoOutputBuilder)? updates]) =>
      (CustomerDisputeListDtoOutputBuilder()..update(updates))._build();

  _$CustomerDisputeListDtoOutput._({required this.items}) : super._();
  @override
  CustomerDisputeListDtoOutput rebuild(
          void Function(CustomerDisputeListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerDisputeListDtoOutputBuilder toBuilder() =>
      CustomerDisputeListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerDisputeListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'CustomerDisputeListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class CustomerDisputeListDtoOutputBuilder
    implements
        Builder<CustomerDisputeListDtoOutput,
            CustomerDisputeListDtoOutputBuilder> {
  _$CustomerDisputeListDtoOutput? _$v;

  ListBuilder<DisputePageDtoOutputItemsInner>? _items;
  ListBuilder<DisputePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<DisputePageDtoOutputItemsInner>();
  set items(ListBuilder<DisputePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  CustomerDisputeListDtoOutputBuilder() {
    CustomerDisputeListDtoOutput._defaults(this);
  }

  CustomerDisputeListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerDisputeListDtoOutput other) {
    _$v = other as _$CustomerDisputeListDtoOutput;
  }

  @override
  void update(void Function(CustomerDisputeListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerDisputeListDtoOutput build() => _build();

  _$CustomerDisputeListDtoOutput _build() {
    _$CustomerDisputeListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CustomerDisputeListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CustomerDisputeListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
