// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_operator_profile_dto_output_service_terms.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicOperatorProfileDtoOutputServiceTerms
    extends PublicOperatorProfileDtoOutputServiceTerms {
  @override
  final String title;
  @override
  final String contentMarkdown;

  factory _$PublicOperatorProfileDtoOutputServiceTerms(
          [void Function(PublicOperatorProfileDtoOutputServiceTermsBuilder)?
              updates]) =>
      (PublicOperatorProfileDtoOutputServiceTermsBuilder()..update(updates))
          ._build();

  _$PublicOperatorProfileDtoOutputServiceTerms._(
      {required this.title, required this.contentMarkdown})
      : super._();
  @override
  PublicOperatorProfileDtoOutputServiceTerms rebuild(
          void Function(PublicOperatorProfileDtoOutputServiceTermsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicOperatorProfileDtoOutputServiceTermsBuilder toBuilder() =>
      PublicOperatorProfileDtoOutputServiceTermsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicOperatorProfileDtoOutputServiceTerms &&
        title == other.title &&
        contentMarkdown == other.contentMarkdown;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, contentMarkdown.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicOperatorProfileDtoOutputServiceTerms')
          ..add('title', title)
          ..add('contentMarkdown', contentMarkdown))
        .toString();
  }
}

class PublicOperatorProfileDtoOutputServiceTermsBuilder
    implements
        Builder<PublicOperatorProfileDtoOutputServiceTerms,
            PublicOperatorProfileDtoOutputServiceTermsBuilder> {
  _$PublicOperatorProfileDtoOutputServiceTerms? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _contentMarkdown;
  String? get contentMarkdown => _$this._contentMarkdown;
  set contentMarkdown(String? contentMarkdown) =>
      _$this._contentMarkdown = contentMarkdown;

  PublicOperatorProfileDtoOutputServiceTermsBuilder() {
    PublicOperatorProfileDtoOutputServiceTerms._defaults(this);
  }

  PublicOperatorProfileDtoOutputServiceTermsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _contentMarkdown = $v.contentMarkdown;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicOperatorProfileDtoOutputServiceTerms other) {
    _$v = other as _$PublicOperatorProfileDtoOutputServiceTerms;
  }

  @override
  void update(
      void Function(PublicOperatorProfileDtoOutputServiceTermsBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicOperatorProfileDtoOutputServiceTerms build() => _build();

  _$PublicOperatorProfileDtoOutputServiceTerms _build() {
    final _$result = _$v ??
        _$PublicOperatorProfileDtoOutputServiceTerms._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'PublicOperatorProfileDtoOutputServiceTerms', 'title'),
          contentMarkdown: BuiltValueNullFieldError.checkNotNull(
              contentMarkdown,
              r'PublicOperatorProfileDtoOutputServiceTerms',
              'contentMarkdown'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
