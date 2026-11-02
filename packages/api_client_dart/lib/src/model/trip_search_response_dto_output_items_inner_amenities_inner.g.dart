// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_items_inner_amenities_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner
    extends TripSearchResponseDtoOutputItemsInnerAmenitiesInner {
  @override
  final String id;
  @override
  final String name;

  factory _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner(
          [void Function(
                  TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder()
            ..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner._(
      {required this.id, required this.name})
      : super._();
  @override
  TripSearchResponseDtoOutputItemsInnerAmenitiesInner rebuild(
          void Function(
                  TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder toBuilder() =>
      TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputItemsInnerAmenitiesInner &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputItemsInnerAmenitiesInner')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder
    implements
        Builder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner,
            TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder> {
  _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder() {
    TripSearchResponseDtoOutputItemsInnerAmenitiesInner._defaults(this);
  }

  TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputItemsInnerAmenitiesInner other) {
    _$v = other as _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputItemsInnerAmenitiesInner build() => _build();

  _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TripSearchResponseDtoOutputItemsInnerAmenitiesInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name,
              r'TripSearchResponseDtoOutputItemsInnerAmenitiesInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
