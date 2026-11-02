// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignPageDtoOutput extends CampaignPageDtoOutput {
  @override
  final BuiltList<CampaignPageDtoOutputItemsInner> items;
  @override
  final int total;
  @override
  final int offset;
  @override
  final int limit;

  factory _$CampaignPageDtoOutput(
          [void Function(CampaignPageDtoOutputBuilder)? updates]) =>
      (CampaignPageDtoOutputBuilder()..update(updates))._build();

  _$CampaignPageDtoOutput._(
      {required this.items,
      required this.total,
      required this.offset,
      required this.limit})
      : super._();
  @override
  CampaignPageDtoOutput rebuild(
          void Function(CampaignPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignPageDtoOutputBuilder toBuilder() =>
      CampaignPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignPageDtoOutput &&
        items == other.items &&
        total == other.total &&
        offset == other.offset &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignPageDtoOutput')
          ..add('items', items)
          ..add('total', total)
          ..add('offset', offset)
          ..add('limit', limit))
        .toString();
  }
}

class CampaignPageDtoOutputBuilder
    implements Builder<CampaignPageDtoOutput, CampaignPageDtoOutputBuilder> {
  _$CampaignPageDtoOutput? _$v;

  ListBuilder<CampaignPageDtoOutputItemsInner>? _items;
  ListBuilder<CampaignPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CampaignPageDtoOutputItemsInner>();
  set items(ListBuilder<CampaignPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  CampaignPageDtoOutputBuilder() {
    CampaignPageDtoOutput._defaults(this);
  }

  CampaignPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _offset = $v.offset;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignPageDtoOutput other) {
    _$v = other as _$CampaignPageDtoOutput;
  }

  @override
  void update(void Function(CampaignPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignPageDtoOutput build() => _build();

  _$CampaignPageDtoOutput _build() {
    _$CampaignPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CampaignPageDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'CampaignPageDtoOutput', 'total'),
            offset: BuiltValueNullFieldError.checkNotNull(
                offset, r'CampaignPageDtoOutput', 'offset'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'CampaignPageDtoOutput', 'limit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CampaignPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
