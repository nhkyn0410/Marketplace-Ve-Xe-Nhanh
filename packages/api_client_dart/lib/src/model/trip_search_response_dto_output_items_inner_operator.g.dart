// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_items_inner_operator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputItemsInnerOperator
    extends TripSearchResponseDtoOutputItemsInnerOperator {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;

  factory _$TripSearchResponseDtoOutputItemsInnerOperator(
          [void Function(TripSearchResponseDtoOutputItemsInnerOperatorBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputItemsInnerOperatorBuilder()..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputItemsInnerOperator._(
      {required this.id, required this.name, required this.slug})
      : super._();
  @override
  TripSearchResponseDtoOutputItemsInnerOperator rebuild(
          void Function(TripSearchResponseDtoOutputItemsInnerOperatorBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputItemsInnerOperatorBuilder toBuilder() =>
      TripSearchResponseDtoOutputItemsInnerOperatorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputItemsInnerOperator &&
        id == other.id &&
        name == other.name &&
        slug == other.slug;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputItemsInnerOperator')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug))
        .toString();
  }
}

class TripSearchResponseDtoOutputItemsInnerOperatorBuilder
    implements
        Builder<TripSearchResponseDtoOutputItemsInnerOperator,
            TripSearchResponseDtoOutputItemsInnerOperatorBuilder> {
  _$TripSearchResponseDtoOutputItemsInnerOperator? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  TripSearchResponseDtoOutputItemsInnerOperatorBuilder() {
    TripSearchResponseDtoOutputItemsInnerOperator._defaults(this);
  }

  TripSearchResponseDtoOutputItemsInnerOperatorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputItemsInnerOperator other) {
    _$v = other as _$TripSearchResponseDtoOutputItemsInnerOperator;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputItemsInnerOperatorBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputItemsInnerOperator build() => _build();

  _$TripSearchResponseDtoOutputItemsInnerOperator _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputItemsInnerOperator._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TripSearchResponseDtoOutputItemsInnerOperator', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripSearchResponseDtoOutputItemsInnerOperator', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'TripSearchResponseDtoOutputItemsInnerOperator', 'slug'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
