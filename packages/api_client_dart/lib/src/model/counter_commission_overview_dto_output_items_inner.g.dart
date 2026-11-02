// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_commission_overview_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterCommissionOverviewDtoOutputItemsInner
    extends CounterCommissionOverviewDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String receiptId;
  @override
  final String? commissionRuleId;
  @override
  final int rateBps;
  @override
  final String basis;
  @override
  final String amount;
  @override
  final DateTime createdAt;

  factory _$CounterCommissionOverviewDtoOutputItemsInner(
          [void Function(CounterCommissionOverviewDtoOutputItemsInnerBuilder)?
              updates]) =>
      (CounterCommissionOverviewDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$CounterCommissionOverviewDtoOutputItemsInner._(
      {required this.id,
      required this.bookingId,
      required this.receiptId,
      this.commissionRuleId,
      required this.rateBps,
      required this.basis,
      required this.amount,
      required this.createdAt})
      : super._();
  @override
  CounterCommissionOverviewDtoOutputItemsInner rebuild(
          void Function(CounterCommissionOverviewDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterCommissionOverviewDtoOutputItemsInnerBuilder toBuilder() =>
      CounterCommissionOverviewDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterCommissionOverviewDtoOutputItemsInner &&
        id == other.id &&
        bookingId == other.bookingId &&
        receiptId == other.receiptId &&
        commissionRuleId == other.commissionRuleId &&
        rateBps == other.rateBps &&
        basis == other.basis &&
        amount == other.amount &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, receiptId.hashCode);
    _$hash = $jc(_$hash, commissionRuleId.hashCode);
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterCommissionOverviewDtoOutputItemsInner')
          ..add('id', id)
          ..add('bookingId', bookingId)
          ..add('receiptId', receiptId)
          ..add('commissionRuleId', commissionRuleId)
          ..add('rateBps', rateBps)
          ..add('basis', basis)
          ..add('amount', amount)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CounterCommissionOverviewDtoOutputItemsInnerBuilder
    implements
        Builder<CounterCommissionOverviewDtoOutputItemsInner,
            CounterCommissionOverviewDtoOutputItemsInnerBuilder> {
  _$CounterCommissionOverviewDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _receiptId;
  String? get receiptId => _$this._receiptId;
  set receiptId(String? receiptId) => _$this._receiptId = receiptId;

  String? _commissionRuleId;
  String? get commissionRuleId => _$this._commissionRuleId;
  set commissionRuleId(String? commissionRuleId) =>
      _$this._commissionRuleId = commissionRuleId;

  int? _rateBps;
  int? get rateBps => _$this._rateBps;
  set rateBps(int? rateBps) => _$this._rateBps = rateBps;

  String? _basis;
  String? get basis => _$this._basis;
  set basis(String? basis) => _$this._basis = basis;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CounterCommissionOverviewDtoOutputItemsInnerBuilder() {
    CounterCommissionOverviewDtoOutputItemsInner._defaults(this);
  }

  CounterCommissionOverviewDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _bookingId = $v.bookingId;
      _receiptId = $v.receiptId;
      _commissionRuleId = $v.commissionRuleId;
      _rateBps = $v.rateBps;
      _basis = $v.basis;
      _amount = $v.amount;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterCommissionOverviewDtoOutputItemsInner other) {
    _$v = other as _$CounterCommissionOverviewDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(CounterCommissionOverviewDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterCommissionOverviewDtoOutputItemsInner build() => _build();

  _$CounterCommissionOverviewDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$CounterCommissionOverviewDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CounterCommissionOverviewDtoOutputItemsInner', 'id'),
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'CounterCommissionOverviewDtoOutputItemsInner', 'bookingId'),
          receiptId: BuiltValueNullFieldError.checkNotNull(receiptId,
              r'CounterCommissionOverviewDtoOutputItemsInner', 'receiptId'),
          commissionRuleId: commissionRuleId,
          rateBps: BuiltValueNullFieldError.checkNotNull(rateBps,
              r'CounterCommissionOverviewDtoOutputItemsInner', 'rateBps'),
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'CounterCommissionOverviewDtoOutputItemsInner', 'basis'),
          amount: BuiltValueNullFieldError.checkNotNull(amount,
              r'CounterCommissionOverviewDtoOutputItemsInner', 'amount'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'CounterCommissionOverviewDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
