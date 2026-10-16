// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_publish_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminArticlePublishDto extends AdminArticlePublishDto {
  @override
  final DateTime? publishedAt;

  factory _$AdminArticlePublishDto(
          [void Function(AdminArticlePublishDtoBuilder)? updates]) =>
      (AdminArticlePublishDtoBuilder()..update(updates))._build();

  _$AdminArticlePublishDto._({this.publishedAt}) : super._();
  @override
  AdminArticlePublishDto rebuild(
          void Function(AdminArticlePublishDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticlePublishDtoBuilder toBuilder() =>
      AdminArticlePublishDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticlePublishDto && publishedAt == other.publishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticlePublishDto')
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class AdminArticlePublishDtoBuilder
    implements Builder<AdminArticlePublishDto, AdminArticlePublishDtoBuilder> {
  _$AdminArticlePublishDto? _$v;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  AdminArticlePublishDtoBuilder() {
    AdminArticlePublishDto._defaults(this);
  }

  AdminArticlePublishDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _publishedAt = $v.publishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticlePublishDto other) {
    _$v = other as _$AdminArticlePublishDto;
  }

  @override
  void update(void Function(AdminArticlePublishDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticlePublishDto build() => _build();

  _$AdminArticlePublishDto _build() {
    final _$result = _$v ??
        _$AdminArticlePublishDto._(
          publishedAt: publishedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
