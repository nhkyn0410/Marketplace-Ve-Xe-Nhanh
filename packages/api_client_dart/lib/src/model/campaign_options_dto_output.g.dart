// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_options_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignOptionsDtoOutput extends CampaignOptionsDtoOutput {
  @override
  final BuiltList<CampaignOptionsDtoOutputPromotionsInner> promotions;
  @override
  final BuiltList<CampaignOptionsDtoOutputArticlesInner> articles;

  factory _$CampaignOptionsDtoOutput(
          [void Function(CampaignOptionsDtoOutputBuilder)? updates]) =>
      (CampaignOptionsDtoOutputBuilder()..update(updates))._build();

  _$CampaignOptionsDtoOutput._(
      {required this.promotions, required this.articles})
      : super._();
  @override
  CampaignOptionsDtoOutput rebuild(
          void Function(CampaignOptionsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignOptionsDtoOutputBuilder toBuilder() =>
      CampaignOptionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignOptionsDtoOutput &&
        promotions == other.promotions &&
        articles == other.articles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, promotions.hashCode);
    _$hash = $jc(_$hash, articles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignOptionsDtoOutput')
          ..add('promotions', promotions)
          ..add('articles', articles))
        .toString();
  }
}

class CampaignOptionsDtoOutputBuilder
    implements
        Builder<CampaignOptionsDtoOutput, CampaignOptionsDtoOutputBuilder> {
  _$CampaignOptionsDtoOutput? _$v;

  ListBuilder<CampaignOptionsDtoOutputPromotionsInner>? _promotions;
  ListBuilder<CampaignOptionsDtoOutputPromotionsInner> get promotions =>
      _$this._promotions ??=
          ListBuilder<CampaignOptionsDtoOutputPromotionsInner>();
  set promotions(
          ListBuilder<CampaignOptionsDtoOutputPromotionsInner>? promotions) =>
      _$this._promotions = promotions;

  ListBuilder<CampaignOptionsDtoOutputArticlesInner>? _articles;
  ListBuilder<CampaignOptionsDtoOutputArticlesInner> get articles =>
      _$this._articles ??= ListBuilder<CampaignOptionsDtoOutputArticlesInner>();
  set articles(ListBuilder<CampaignOptionsDtoOutputArticlesInner>? articles) =>
      _$this._articles = articles;

  CampaignOptionsDtoOutputBuilder() {
    CampaignOptionsDtoOutput._defaults(this);
  }

  CampaignOptionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _promotions = $v.promotions.toBuilder();
      _articles = $v.articles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignOptionsDtoOutput other) {
    _$v = other as _$CampaignOptionsDtoOutput;
  }

  @override
  void update(void Function(CampaignOptionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignOptionsDtoOutput build() => _build();

  _$CampaignOptionsDtoOutput _build() {
    _$CampaignOptionsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CampaignOptionsDtoOutput._(
            promotions: promotions.build(),
            articles: articles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'promotions';
        promotions.build();
        _$failedField = 'articles';
        articles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CampaignOptionsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
