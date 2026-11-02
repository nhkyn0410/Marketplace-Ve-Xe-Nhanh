// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_voucher_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserVoucherPageDtoOutput extends UserVoucherPageDtoOutput {
  @override
  final BuiltList<UserVoucherPageDtoOutputItemsInner> items;
  @override
  final int total;

  factory _$UserVoucherPageDtoOutput(
          [void Function(UserVoucherPageDtoOutputBuilder)? updates]) =>
      (UserVoucherPageDtoOutputBuilder()..update(updates))._build();

  _$UserVoucherPageDtoOutput._({required this.items, required this.total})
      : super._();
  @override
  UserVoucherPageDtoOutput rebuild(
          void Function(UserVoucherPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserVoucherPageDtoOutputBuilder toBuilder() =>
      UserVoucherPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserVoucherPageDtoOutput &&
        items == other.items &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserVoucherPageDtoOutput')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class UserVoucherPageDtoOutputBuilder
    implements
        Builder<UserVoucherPageDtoOutput, UserVoucherPageDtoOutputBuilder> {
  _$UserVoucherPageDtoOutput? _$v;

  ListBuilder<UserVoucherPageDtoOutputItemsInner>? _items;
  ListBuilder<UserVoucherPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<UserVoucherPageDtoOutputItemsInner>();
  set items(ListBuilder<UserVoucherPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  UserVoucherPageDtoOutputBuilder() {
    UserVoucherPageDtoOutput._defaults(this);
  }

  UserVoucherPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserVoucherPageDtoOutput other) {
    _$v = other as _$UserVoucherPageDtoOutput;
  }

  @override
  void update(void Function(UserVoucherPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserVoucherPageDtoOutput build() => _build();

  _$UserVoucherPageDtoOutput _build() {
    _$UserVoucherPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$UserVoucherPageDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'UserVoucherPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserVoucherPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
