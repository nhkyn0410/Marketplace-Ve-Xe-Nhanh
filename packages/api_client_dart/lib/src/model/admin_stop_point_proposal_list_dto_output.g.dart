// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stop_point_proposal_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminStopPointProposalListDtoOutput
    extends AdminStopPointProposalListDtoOutput {
  @override
  final BuiltList<AdminStopPointProposalListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminStopPointProposalListDtoOutput(
          [void Function(AdminStopPointProposalListDtoOutputBuilder)?
              updates]) =>
      (AdminStopPointProposalListDtoOutputBuilder()..update(updates))._build();

  _$AdminStopPointProposalListDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminStopPointProposalListDtoOutput rebuild(
          void Function(AdminStopPointProposalListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminStopPointProposalListDtoOutputBuilder toBuilder() =>
      AdminStopPointProposalListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStopPointProposalListDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminStopPointProposalListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminStopPointProposalListDtoOutputBuilder
    implements
        Builder<AdminStopPointProposalListDtoOutput,
            AdminStopPointProposalListDtoOutputBuilder> {
  _$AdminStopPointProposalListDtoOutput? _$v;

  ListBuilder<AdminStopPointProposalListDtoOutputItemsInner>? _items;
  ListBuilder<AdminStopPointProposalListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminStopPointProposalListDtoOutputItemsInner>();
  set items(
          ListBuilder<AdminStopPointProposalListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminStopPointProposalListDtoOutputBuilder() {
    AdminStopPointProposalListDtoOutput._defaults(this);
  }

  AdminStopPointProposalListDtoOutputBuilder get _$this {
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
  void replace(AdminStopPointProposalListDtoOutput other) {
    _$v = other as _$AdminStopPointProposalListDtoOutput;
  }

  @override
  void update(
      void Function(AdminStopPointProposalListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStopPointProposalListDtoOutput build() => _build();

  _$AdminStopPointProposalListDtoOutput _build() {
    _$AdminStopPointProposalListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminStopPointProposalListDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminStopPointProposalListDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AdminStopPointProposalListDtoOutput',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
