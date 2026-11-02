// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_facets_operators_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputFacetsOperatorsInner
    extends TripSearchResponseDtoOutputFacetsOperatorsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int count;

  factory _$TripSearchResponseDtoOutputFacetsOperatorsInner(
          [void Function(
                  TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder()
            ..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputFacetsOperatorsInner._(
      {required this.id, required this.name, required this.count})
      : super._();
  @override
  TripSearchResponseDtoOutputFacetsOperatorsInner rebuild(
          void Function(TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder toBuilder() =>
      TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputFacetsOperatorsInner &&
        id == other.id &&
        name == other.name &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputFacetsOperatorsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('count', count))
        .toString();
  }
}

class TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder
    implements
        Builder<TripSearchResponseDtoOutputFacetsOperatorsInner,
            TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder> {
  _$TripSearchResponseDtoOutputFacetsOperatorsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder() {
    TripSearchResponseDtoOutputFacetsOperatorsInner._defaults(this);
  }

  TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputFacetsOperatorsInner other) {
    _$v = other as _$TripSearchResponseDtoOutputFacetsOperatorsInner;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputFacetsOperatorsInner build() => _build();

  _$TripSearchResponseDtoOutputFacetsOperatorsInner _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputFacetsOperatorsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TripSearchResponseDtoOutputFacetsOperatorsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripSearchResponseDtoOutputFacetsOperatorsInner', 'name'),
          count: BuiltValueNullFieldError.checkNotNull(count,
              r'TripSearchResponseDtoOutputFacetsOperatorsInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
