// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_operator_list_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeaturedOperatorListResponseDtoOutputItemsInner
    extends FeaturedOperatorListResponseDtoOutputItemsInner {
  @override
  final String operatorId;
  @override
  final String displayName;
  @override
  final num? averageRating;
  @override
  final int reviewCount;
  @override
  final BuiltList<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>
      routes;

  factory _$FeaturedOperatorListResponseDtoOutputItemsInner(
          [void Function(
                  FeaturedOperatorListResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (FeaturedOperatorListResponseDtoOutputItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$FeaturedOperatorListResponseDtoOutputItemsInner._(
      {required this.operatorId,
      required this.displayName,
      this.averageRating,
      required this.reviewCount,
      required this.routes})
      : super._();
  @override
  FeaturedOperatorListResponseDtoOutputItemsInner rebuild(
          void Function(FeaturedOperatorListResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeaturedOperatorListResponseDtoOutputItemsInnerBuilder toBuilder() =>
      FeaturedOperatorListResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeaturedOperatorListResponseDtoOutputItemsInner &&
        operatorId == other.operatorId &&
        displayName == other.displayName &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount &&
        routes == other.routes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jc(_$hash, routes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'FeaturedOperatorListResponseDtoOutputItemsInner')
          ..add('operatorId', operatorId)
          ..add('displayName', displayName)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount)
          ..add('routes', routes))
        .toString();
  }
}

class FeaturedOperatorListResponseDtoOutputItemsInnerBuilder
    implements
        Builder<FeaturedOperatorListResponseDtoOutputItemsInner,
            FeaturedOperatorListResponseDtoOutputItemsInnerBuilder> {
  _$FeaturedOperatorListResponseDtoOutputItemsInner? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>?
      _routes;
  ListBuilder<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>
      get routes => _$this._routes ??= ListBuilder<
          FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>();
  set routes(
          ListBuilder<
                  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner>?
              routes) =>
      _$this._routes = routes;

  FeaturedOperatorListResponseDtoOutputItemsInnerBuilder() {
    FeaturedOperatorListResponseDtoOutputItemsInner._defaults(this);
  }

  FeaturedOperatorListResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _displayName = $v.displayName;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _routes = $v.routes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeaturedOperatorListResponseDtoOutputItemsInner other) {
    _$v = other as _$FeaturedOperatorListResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(FeaturedOperatorListResponseDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  FeaturedOperatorListResponseDtoOutputItemsInner build() => _build();

  _$FeaturedOperatorListResponseDtoOutputItemsInner _build() {
    _$FeaturedOperatorListResponseDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$FeaturedOperatorListResponseDtoOutputItemsInner._(
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId,
                r'FeaturedOperatorListResponseDtoOutputItemsInner',
                'operatorId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName,
                r'FeaturedOperatorListResponseDtoOutputItemsInner',
                'displayName'),
            averageRating: averageRating,
            reviewCount: BuiltValueNullFieldError.checkNotNull(
                reviewCount,
                r'FeaturedOperatorListResponseDtoOutputItemsInner',
                'reviewCount'),
            routes: routes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routes';
        routes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FeaturedOperatorListResponseDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
