// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_review_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerReviewDtoOutput extends CustomerReviewDtoOutput {
  @override
  final CustomerReviewDtoOutputReview? review;
  @override
  final bool canReview;

  factory _$CustomerReviewDtoOutput(
          [void Function(CustomerReviewDtoOutputBuilder)? updates]) =>
      (CustomerReviewDtoOutputBuilder()..update(updates))._build();

  _$CustomerReviewDtoOutput._({this.review, required this.canReview})
      : super._();
  @override
  CustomerReviewDtoOutput rebuild(
          void Function(CustomerReviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerReviewDtoOutputBuilder toBuilder() =>
      CustomerReviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerReviewDtoOutput &&
        review == other.review &&
        canReview == other.canReview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, review.hashCode);
    _$hash = $jc(_$hash, canReview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerReviewDtoOutput')
          ..add('review', review)
          ..add('canReview', canReview))
        .toString();
  }
}

class CustomerReviewDtoOutputBuilder
    implements
        Builder<CustomerReviewDtoOutput, CustomerReviewDtoOutputBuilder> {
  _$CustomerReviewDtoOutput? _$v;

  CustomerReviewDtoOutputReviewBuilder? _review;
  CustomerReviewDtoOutputReviewBuilder get review =>
      _$this._review ??= CustomerReviewDtoOutputReviewBuilder();
  set review(CustomerReviewDtoOutputReviewBuilder? review) =>
      _$this._review = review;

  bool? _canReview;
  bool? get canReview => _$this._canReview;
  set canReview(bool? canReview) => _$this._canReview = canReview;

  CustomerReviewDtoOutputBuilder() {
    CustomerReviewDtoOutput._defaults(this);
  }

  CustomerReviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _review = $v.review?.toBuilder();
      _canReview = $v.canReview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerReviewDtoOutput other) {
    _$v = other as _$CustomerReviewDtoOutput;
  }

  @override
  void update(void Function(CustomerReviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerReviewDtoOutput build() => _build();

  _$CustomerReviewDtoOutput _build() {
    _$CustomerReviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CustomerReviewDtoOutput._(
            review: _review?.build(),
            canReview: BuiltValueNullFieldError.checkNotNull(
                canReview, r'CustomerReviewDtoOutput', 'canReview'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'review';
        _review?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CustomerReviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
