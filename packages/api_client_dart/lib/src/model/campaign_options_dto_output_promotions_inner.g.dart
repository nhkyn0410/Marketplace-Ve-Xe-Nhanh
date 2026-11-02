// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_options_dto_output_promotions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignOptionsDtoOutputPromotionsInner
    extends CampaignOptionsDtoOutputPromotionsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final DateTime endsAt;

  factory _$CampaignOptionsDtoOutputPromotionsInner(
          [void Function(CampaignOptionsDtoOutputPromotionsInnerBuilder)?
              updates]) =>
      (CampaignOptionsDtoOutputPromotionsInnerBuilder()..update(updates))
          ._build();

  _$CampaignOptionsDtoOutputPromotionsInner._(
      {required this.id,
      required this.code,
      required this.name,
      required this.endsAt})
      : super._();
  @override
  CampaignOptionsDtoOutputPromotionsInner rebuild(
          void Function(CampaignOptionsDtoOutputPromotionsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignOptionsDtoOutputPromotionsInnerBuilder toBuilder() =>
      CampaignOptionsDtoOutputPromotionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignOptionsDtoOutputPromotionsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        endsAt == other.endsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CampaignOptionsDtoOutputPromotionsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class CampaignOptionsDtoOutputPromotionsInnerBuilder
    implements
        Builder<CampaignOptionsDtoOutputPromotionsInner,
            CampaignOptionsDtoOutputPromotionsInnerBuilder> {
  _$CampaignOptionsDtoOutputPromotionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  CampaignOptionsDtoOutputPromotionsInnerBuilder() {
    CampaignOptionsDtoOutputPromotionsInner._defaults(this);
  }

  CampaignOptionsDtoOutputPromotionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignOptionsDtoOutputPromotionsInner other) {
    _$v = other as _$CampaignOptionsDtoOutputPromotionsInner;
  }

  @override
  void update(
      void Function(CampaignOptionsDtoOutputPromotionsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignOptionsDtoOutputPromotionsInner build() => _build();

  _$CampaignOptionsDtoOutputPromotionsInner _build() {
    final _$result = _$v ??
        _$CampaignOptionsDtoOutputPromotionsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CampaignOptionsDtoOutputPromotionsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CampaignOptionsDtoOutputPromotionsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CampaignOptionsDtoOutputPromotionsInner', 'name'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'CampaignOptionsDtoOutputPromotionsInner', 'endsAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
