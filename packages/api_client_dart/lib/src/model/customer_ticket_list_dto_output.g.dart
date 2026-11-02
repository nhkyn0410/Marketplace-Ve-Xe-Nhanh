// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ticket_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerTicketListDtoOutput extends CustomerTicketListDtoOutput {
  @override
  final BuiltList<CustomerTicketListDtoOutputItemsInner> items;

  factory _$CustomerTicketListDtoOutput(
          [void Function(CustomerTicketListDtoOutputBuilder)? updates]) =>
      (CustomerTicketListDtoOutputBuilder()..update(updates))._build();

  _$CustomerTicketListDtoOutput._({required this.items}) : super._();
  @override
  CustomerTicketListDtoOutput rebuild(
          void Function(CustomerTicketListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerTicketListDtoOutputBuilder toBuilder() =>
      CustomerTicketListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerTicketListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'CustomerTicketListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class CustomerTicketListDtoOutputBuilder
    implements
        Builder<CustomerTicketListDtoOutput,
            CustomerTicketListDtoOutputBuilder> {
  _$CustomerTicketListDtoOutput? _$v;

  ListBuilder<CustomerTicketListDtoOutputItemsInner>? _items;
  ListBuilder<CustomerTicketListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CustomerTicketListDtoOutputItemsInner>();
  set items(ListBuilder<CustomerTicketListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  CustomerTicketListDtoOutputBuilder() {
    CustomerTicketListDtoOutput._defaults(this);
  }

  CustomerTicketListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerTicketListDtoOutput other) {
    _$v = other as _$CustomerTicketListDtoOutput;
  }

  @override
  void update(void Function(CustomerTicketListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerTicketListDtoOutput build() => _build();

  _$CustomerTicketListDtoOutput _build() {
    _$CustomerTicketListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CustomerTicketListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CustomerTicketListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
