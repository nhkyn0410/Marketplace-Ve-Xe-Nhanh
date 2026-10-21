// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_facets.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputFacets
    extends TripSearchResponseDtoOutputFacets {
  @override
  final BuiltList<TripSearchResponseDtoOutputFacetsOperatorsInner> operators;
  @override
  final int? priceMin;
  @override
  final int? priceMax;

  factory _$TripSearchResponseDtoOutputFacets(
          [void Function(TripSearchResponseDtoOutputFacetsBuilder)? updates]) =>
      (TripSearchResponseDtoOutputFacetsBuilder()..update(updates))._build();

  _$TripSearchResponseDtoOutputFacets._(
      {required this.operators, this.priceMin, this.priceMax})
      : super._();
  @override
  TripSearchResponseDtoOutputFacets rebuild(
          void Function(TripSearchResponseDtoOutputFacetsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputFacetsBuilder toBuilder() =>
      TripSearchResponseDtoOutputFacetsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputFacets &&
        operators == other.operators &&
        priceMin == other.priceMin &&
        priceMax == other.priceMax;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operators.hashCode);
    _$hash = $jc(_$hash, priceMin.hashCode);
    _$hash = $jc(_$hash, priceMax.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripSearchResponseDtoOutputFacets')
          ..add('operators', operators)
          ..add('priceMin', priceMin)
          ..add('priceMax', priceMax))
        .toString();
  }
}

class TripSearchResponseDtoOutputFacetsBuilder
    implements
        Builder<TripSearchResponseDtoOutputFacets,
            TripSearchResponseDtoOutputFacetsBuilder> {
  _$TripSearchResponseDtoOutputFacets? _$v;

  ListBuilder<TripSearchResponseDtoOutputFacetsOperatorsInner>? _operators;
  ListBuilder<TripSearchResponseDtoOutputFacetsOperatorsInner> get operators =>
      _$this._operators ??=
          ListBuilder<TripSearchResponseDtoOutputFacetsOperatorsInner>();
  set operators(
          ListBuilder<TripSearchResponseDtoOutputFacetsOperatorsInner>?
              operators) =>
      _$this._operators = operators;

  int? _priceMin;
  int? get priceMin => _$this._priceMin;
  set priceMin(int? priceMin) => _$this._priceMin = priceMin;

  int? _priceMax;
  int? get priceMax => _$this._priceMax;
  set priceMax(int? priceMax) => _$this._priceMax = priceMax;

  TripSearchResponseDtoOutputFacetsBuilder() {
    TripSearchResponseDtoOutputFacets._defaults(this);
  }

  TripSearchResponseDtoOutputFacetsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operators = $v.operators.toBuilder();
      _priceMin = $v.priceMin;
      _priceMax = $v.priceMax;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputFacets other) {
    _$v = other as _$TripSearchResponseDtoOutputFacets;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputFacetsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputFacets build() => _build();

  _$TripSearchResponseDtoOutputFacets _build() {
    _$TripSearchResponseDtoOutputFacets _$result;
    try {
      _$result = _$v ??
          _$TripSearchResponseDtoOutputFacets._(
            operators: operators.build(),
            priceMin: priceMin,
            priceMax: priceMax,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operators';
        operators.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripSearchResponseDtoOutputFacets', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
