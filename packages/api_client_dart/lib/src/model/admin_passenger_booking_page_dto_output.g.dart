// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_booking_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPassengerBookingPageDtoOutput
    extends AdminPassengerBookingPageDtoOutput {
  @override
  final BuiltList<AdminPassengerBookingPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminPassengerBookingPageDtoOutput(
          [void Function(AdminPassengerBookingPageDtoOutputBuilder)?
              updates]) =>
      (AdminPassengerBookingPageDtoOutputBuilder()..update(updates))._build();

  _$AdminPassengerBookingPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminPassengerBookingPageDtoOutput rebuild(
          void Function(AdminPassengerBookingPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerBookingPageDtoOutputBuilder toBuilder() =>
      AdminPassengerBookingPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPassengerBookingPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPassengerBookingPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminPassengerBookingPageDtoOutputBuilder
    implements
        Builder<AdminPassengerBookingPageDtoOutput,
            AdminPassengerBookingPageDtoOutputBuilder> {
  _$AdminPassengerBookingPageDtoOutput? _$v;

  ListBuilder<AdminPassengerBookingPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminPassengerBookingPageDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminPassengerBookingPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminPassengerBookingPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminPassengerBookingPageDtoOutputBuilder() {
    AdminPassengerBookingPageDtoOutput._defaults(this);
  }

  AdminPassengerBookingPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPassengerBookingPageDtoOutput other) {
    _$v = other as _$AdminPassengerBookingPageDtoOutput;
  }

  @override
  void update(
      void Function(AdminPassengerBookingPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerBookingPageDtoOutput build() => _build();

  _$AdminPassengerBookingPageDtoOutput _build() {
    _$AdminPassengerBookingPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPassengerBookingPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminPassengerBookingPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPassengerBookingPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
