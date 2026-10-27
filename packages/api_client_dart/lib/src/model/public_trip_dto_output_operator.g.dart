// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_operator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutputOperator extends PublicTripDtoOutputOperator {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? hotline;
  @override
  final num? averageRating;
  @override
  final int reviewCount;

  factory _$PublicTripDtoOutputOperator(
          [void Function(PublicTripDtoOutputOperatorBuilder)? updates]) =>
      (PublicTripDtoOutputOperatorBuilder()..update(updates))._build();

  _$PublicTripDtoOutputOperator._(
      {required this.id,
      required this.name,
      required this.slug,
      this.hotline,
      this.averageRating,
      required this.reviewCount})
      : super._();
  @override
  PublicTripDtoOutputOperator rebuild(
          void Function(PublicTripDtoOutputOperatorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputOperatorBuilder toBuilder() =>
      PublicTripDtoOutputOperatorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputOperator &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        hotline == other.hotline &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicTripDtoOutputOperator')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('hotline', hotline)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount))
        .toString();
  }
}

class PublicTripDtoOutputOperatorBuilder
    implements
        Builder<PublicTripDtoOutputOperator,
            PublicTripDtoOutputOperatorBuilder> {
  _$PublicTripDtoOutputOperator? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  PublicTripDtoOutputOperatorBuilder() {
    PublicTripDtoOutputOperator._defaults(this);
  }

  PublicTripDtoOutputOperatorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _hotline = $v.hotline;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputOperator other) {
    _$v = other as _$PublicTripDtoOutputOperator;
  }

  @override
  void update(void Function(PublicTripDtoOutputOperatorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputOperator build() => _build();

  _$PublicTripDtoOutputOperator _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputOperator._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PublicTripDtoOutputOperator', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PublicTripDtoOutputOperator', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'PublicTripDtoOutputOperator', 'slug'),
          hotline: hotline,
          averageRating: averageRating,
          reviewCount: BuiltValueNullFieldError.checkNotNull(
              reviewCount, r'PublicTripDtoOutputOperator', 'reviewCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
