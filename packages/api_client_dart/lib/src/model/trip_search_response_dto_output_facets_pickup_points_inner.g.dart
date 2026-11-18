// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_facets_pickup_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputFacetsPickupPointsInner
    extends TripSearchResponseDtoOutputFacetsPickupPointsInner {
  @override
  final String name;
  @override
  final int count;

  factory _$TripSearchResponseDtoOutputFacetsPickupPointsInner(
          [void Function(
                  TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder()
            ..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputFacetsPickupPointsInner._(
      {required this.name, required this.count})
      : super._();
  @override
  TripSearchResponseDtoOutputFacetsPickupPointsInner rebuild(
          void Function(
                  TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder toBuilder() =>
      TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputFacetsPickupPointsInner &&
        name == other.name &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputFacetsPickupPointsInner')
          ..add('name', name)
          ..add('count', count))
        .toString();
  }
}

class TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder
    implements
        Builder<TripSearchResponseDtoOutputFacetsPickupPointsInner,
            TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder> {
  _$TripSearchResponseDtoOutputFacetsPickupPointsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder() {
    TripSearchResponseDtoOutputFacetsPickupPointsInner._defaults(this);
  }

  TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputFacetsPickupPointsInner other) {
    _$v = other as _$TripSearchResponseDtoOutputFacetsPickupPointsInner;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputFacetsPickupPointsInner build() => _build();

  _$TripSearchResponseDtoOutputFacetsPickupPointsInner _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputFacetsPickupPointsInner._(
          name: BuiltValueNullFieldError.checkNotNull(name,
              r'TripSearchResponseDtoOutputFacetsPickupPointsInner', 'name'),
          count: BuiltValueNullFieldError.checkNotNull(count,
              r'TripSearchResponseDtoOutputFacetsPickupPointsInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
