// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewInputDto extends ReviewInputDto {
  @override
  final int rating;
  @override
  final String? comment;

  factory _$ReviewInputDto([void Function(ReviewInputDtoBuilder)? updates]) =>
      (ReviewInputDtoBuilder()..update(updates))._build();

  _$ReviewInputDto._({required this.rating, this.comment}) : super._();
  @override
  ReviewInputDto rebuild(void Function(ReviewInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewInputDtoBuilder toBuilder() => ReviewInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewInputDto &&
        rating == other.rating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewInputDto')
          ..add('rating', rating)
          ..add('comment', comment))
        .toString();
  }
}

class ReviewInputDtoBuilder
    implements Builder<ReviewInputDto, ReviewInputDtoBuilder> {
  _$ReviewInputDto? _$v;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  ReviewInputDtoBuilder() {
    ReviewInputDto._defaults(this);
  }

  ReviewInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rating = $v.rating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewInputDto other) {
    _$v = other as _$ReviewInputDto;
  }

  @override
  void update(void Function(ReviewInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewInputDto build() => _build();

  _$ReviewInputDto _build() {
    final _$result = _$v ??
        _$ReviewInputDto._(
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'ReviewInputDto', 'rating'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
