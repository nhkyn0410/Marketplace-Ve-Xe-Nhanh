// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_operator_profile_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicOperatorProfileDtoOutput extends PublicOperatorProfileDtoOutput {
  @override
  final String operatorId;
  @override
  final String operatorSlug;
  @override
  final String displayName;
  @override
  final String? logoUrl;
  @override
  final String? description;
  @override
  final String? hotline;
  @override
  final String? publicEmail;
  @override
  final String? address;
  @override
  final PublicOperatorProfileDtoOutputScorecard scorecard;
  @override
  final BuiltList<PublicOperatorProfileDtoOutputRoutesInner> routes;
  @override
  final PublicOperatorProfileDtoOutputServiceTerms? serviceTerms;
  @override
  final BuiltList<PublicOperatorProfileDtoOutputReviewsInner> reviews;
  @override
  final String? nextReviewCursor;

  factory _$PublicOperatorProfileDtoOutput(
          [void Function(PublicOperatorProfileDtoOutputBuilder)? updates]) =>
      (PublicOperatorProfileDtoOutputBuilder()..update(updates))._build();

  _$PublicOperatorProfileDtoOutput._(
      {required this.operatorId,
      required this.operatorSlug,
      required this.displayName,
      this.logoUrl,
      this.description,
      this.hotline,
      this.publicEmail,
      this.address,
      required this.scorecard,
      required this.routes,
      this.serviceTerms,
      required this.reviews,
      this.nextReviewCursor})
      : super._();
  @override
  PublicOperatorProfileDtoOutput rebuild(
          void Function(PublicOperatorProfileDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicOperatorProfileDtoOutputBuilder toBuilder() =>
      PublicOperatorProfileDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicOperatorProfileDtoOutput &&
        operatorId == other.operatorId &&
        operatorSlug == other.operatorSlug &&
        displayName == other.displayName &&
        logoUrl == other.logoUrl &&
        description == other.description &&
        hotline == other.hotline &&
        publicEmail == other.publicEmail &&
        address == other.address &&
        scorecard == other.scorecard &&
        routes == other.routes &&
        serviceTerms == other.serviceTerms &&
        reviews == other.reviews &&
        nextReviewCursor == other.nextReviewCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, scorecard.hashCode);
    _$hash = $jc(_$hash, routes.hashCode);
    _$hash = $jc(_$hash, serviceTerms.hashCode);
    _$hash = $jc(_$hash, reviews.hashCode);
    _$hash = $jc(_$hash, nextReviewCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicOperatorProfileDtoOutput')
          ..add('operatorId', operatorId)
          ..add('operatorSlug', operatorSlug)
          ..add('displayName', displayName)
          ..add('logoUrl', logoUrl)
          ..add('description', description)
          ..add('hotline', hotline)
          ..add('publicEmail', publicEmail)
          ..add('address', address)
          ..add('scorecard', scorecard)
          ..add('routes', routes)
          ..add('serviceTerms', serviceTerms)
          ..add('reviews', reviews)
          ..add('nextReviewCursor', nextReviewCursor))
        .toString();
  }
}

class PublicOperatorProfileDtoOutputBuilder
    implements
        Builder<PublicOperatorProfileDtoOutput,
            PublicOperatorProfileDtoOutputBuilder> {
  _$PublicOperatorProfileDtoOutput? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  PublicOperatorProfileDtoOutputScorecardBuilder? _scorecard;
  PublicOperatorProfileDtoOutputScorecardBuilder get scorecard =>
      _$this._scorecard ??= PublicOperatorProfileDtoOutputScorecardBuilder();
  set scorecard(PublicOperatorProfileDtoOutputScorecardBuilder? scorecard) =>
      _$this._scorecard = scorecard;

  ListBuilder<PublicOperatorProfileDtoOutputRoutesInner>? _routes;
  ListBuilder<PublicOperatorProfileDtoOutputRoutesInner> get routes =>
      _$this._routes ??=
          ListBuilder<PublicOperatorProfileDtoOutputRoutesInner>();
  set routes(ListBuilder<PublicOperatorProfileDtoOutputRoutesInner>? routes) =>
      _$this._routes = routes;

  PublicOperatorProfileDtoOutputServiceTermsBuilder? _serviceTerms;
  PublicOperatorProfileDtoOutputServiceTermsBuilder get serviceTerms =>
      _$this._serviceTerms ??=
          PublicOperatorProfileDtoOutputServiceTermsBuilder();
  set serviceTerms(
          PublicOperatorProfileDtoOutputServiceTermsBuilder? serviceTerms) =>
      _$this._serviceTerms = serviceTerms;

  ListBuilder<PublicOperatorProfileDtoOutputReviewsInner>? _reviews;
  ListBuilder<PublicOperatorProfileDtoOutputReviewsInner> get reviews =>
      _$this._reviews ??=
          ListBuilder<PublicOperatorProfileDtoOutputReviewsInner>();
  set reviews(
          ListBuilder<PublicOperatorProfileDtoOutputReviewsInner>? reviews) =>
      _$this._reviews = reviews;

  String? _nextReviewCursor;
  String? get nextReviewCursor => _$this._nextReviewCursor;
  set nextReviewCursor(String? nextReviewCursor) =>
      _$this._nextReviewCursor = nextReviewCursor;

  PublicOperatorProfileDtoOutputBuilder() {
    PublicOperatorProfileDtoOutput._defaults(this);
  }

  PublicOperatorProfileDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _operatorSlug = $v.operatorSlug;
      _displayName = $v.displayName;
      _logoUrl = $v.logoUrl;
      _description = $v.description;
      _hotline = $v.hotline;
      _publicEmail = $v.publicEmail;
      _address = $v.address;
      _scorecard = $v.scorecard.toBuilder();
      _routes = $v.routes.toBuilder();
      _serviceTerms = $v.serviceTerms?.toBuilder();
      _reviews = $v.reviews.toBuilder();
      _nextReviewCursor = $v.nextReviewCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicOperatorProfileDtoOutput other) {
    _$v = other as _$PublicOperatorProfileDtoOutput;
  }

  @override
  void update(void Function(PublicOperatorProfileDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicOperatorProfileDtoOutput build() => _build();

  _$PublicOperatorProfileDtoOutput _build() {
    _$PublicOperatorProfileDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PublicOperatorProfileDtoOutput._(
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'PublicOperatorProfileDtoOutput', 'operatorId'),
            operatorSlug: BuiltValueNullFieldError.checkNotNull(operatorSlug,
                r'PublicOperatorProfileDtoOutput', 'operatorSlug'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'PublicOperatorProfileDtoOutput', 'displayName'),
            logoUrl: logoUrl,
            description: description,
            hotline: hotline,
            publicEmail: publicEmail,
            address: address,
            scorecard: scorecard.build(),
            routes: routes.build(),
            serviceTerms: _serviceTerms?.build(),
            reviews: reviews.build(),
            nextReviewCursor: nextReviewCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scorecard';
        scorecard.build();
        _$failedField = 'routes';
        routes.build();
        _$failedField = 'serviceTerms';
        _serviceTerms?.build();
        _$failedField = 'reviews';
        reviews.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicOperatorProfileDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
