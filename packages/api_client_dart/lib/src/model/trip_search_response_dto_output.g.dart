// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutput extends TripSearchResponseDtoOutput {
  @override
  final BuiltList<TripSearchResponseDtoOutputItemsInner> items;
  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final TripSearchResponseDtoOutputFacets facets;
  @override
  final TripSearchResponseDtoOutputWidenedToProvince widenedToProvince;

  factory _$TripSearchResponseDtoOutput(
          [void Function(TripSearchResponseDtoOutputBuilder)? updates]) =>
      (TripSearchResponseDtoOutputBuilder()..update(updates))._build();

  _$TripSearchResponseDtoOutput._(
      {required this.items,
      required this.total,
      required this.page,
      required this.limit,
      required this.facets,
      required this.widenedToProvince})
      : super._();
  @override
  TripSearchResponseDtoOutput rebuild(
          void Function(TripSearchResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputBuilder toBuilder() =>
      TripSearchResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutput &&
        items == other.items &&
        total == other.total &&
        page == other.page &&
        limit == other.limit &&
        facets == other.facets &&
        widenedToProvince == other.widenedToProvince;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, facets.hashCode);
    _$hash = $jc(_$hash, widenedToProvince.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripSearchResponseDtoOutput')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('limit', limit)
          ..add('facets', facets)
          ..add('widenedToProvince', widenedToProvince))
        .toString();
  }
}

class TripSearchResponseDtoOutputBuilder
    implements
        Builder<TripSearchResponseDtoOutput,
            TripSearchResponseDtoOutputBuilder> {
  _$TripSearchResponseDtoOutput? _$v;

  ListBuilder<TripSearchResponseDtoOutputItemsInner>? _items;
  ListBuilder<TripSearchResponseDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<TripSearchResponseDtoOutputItemsInner>();
  set items(ListBuilder<TripSearchResponseDtoOutputItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  TripSearchResponseDtoOutputFacetsBuilder? _facets;
  TripSearchResponseDtoOutputFacetsBuilder get facets =>
      _$this._facets ??= TripSearchResponseDtoOutputFacetsBuilder();
  set facets(TripSearchResponseDtoOutputFacetsBuilder? facets) =>
      _$this._facets = facets;

  TripSearchResponseDtoOutputWidenedToProvinceBuilder? _widenedToProvince;
  TripSearchResponseDtoOutputWidenedToProvinceBuilder get widenedToProvince =>
      _$this._widenedToProvince ??=
          TripSearchResponseDtoOutputWidenedToProvinceBuilder();
  set widenedToProvince(
          TripSearchResponseDtoOutputWidenedToProvinceBuilder?
              widenedToProvince) =>
      _$this._widenedToProvince = widenedToProvince;

  TripSearchResponseDtoOutputBuilder() {
    TripSearchResponseDtoOutput._defaults(this);
  }

  TripSearchResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _limit = $v.limit;
      _facets = $v.facets.toBuilder();
      _widenedToProvince = $v.widenedToProvince.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutput other) {
    _$v = other as _$TripSearchResponseDtoOutput;
  }

  @override
  void update(void Function(TripSearchResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutput build() => _build();

  _$TripSearchResponseDtoOutput _build() {
    _$TripSearchResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripSearchResponseDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'TripSearchResponseDtoOutput', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'TripSearchResponseDtoOutput', 'page'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'TripSearchResponseDtoOutput', 'limit'),
            facets: facets.build(),
            widenedToProvince: widenedToProvince.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'facets';
        facets.build();
        _$failedField = 'widenedToProvince';
        widenedToProvince.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripSearchResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
