// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CampaignInputDtoTypeEnum _$campaignInputDtoTypeEnum_SERVICE =
    const CampaignInputDtoTypeEnum._('SERVICE');
const CampaignInputDtoTypeEnum _$campaignInputDtoTypeEnum_PROMOTION =
    const CampaignInputDtoTypeEnum._('PROMOTION');
const CampaignInputDtoTypeEnum _$campaignInputDtoTypeEnum_NEWS =
    const CampaignInputDtoTypeEnum._('NEWS');

CampaignInputDtoTypeEnum _$campaignInputDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'SERVICE':
      return _$campaignInputDtoTypeEnum_SERVICE;
    case 'PROMOTION':
      return _$campaignInputDtoTypeEnum_PROMOTION;
    case 'NEWS':
      return _$campaignInputDtoTypeEnum_NEWS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignInputDtoTypeEnum> _$campaignInputDtoTypeEnumValues =
    BuiltSet<CampaignInputDtoTypeEnum>(const <CampaignInputDtoTypeEnum>[
  _$campaignInputDtoTypeEnum_SERVICE,
  _$campaignInputDtoTypeEnum_PROMOTION,
  _$campaignInputDtoTypeEnum_NEWS,
]);

const CampaignInputDtoAudienceEnum _$campaignInputDtoAudienceEnum_ALL =
    const CampaignInputDtoAudienceEnum._('ALL');
const CampaignInputDtoAudienceEnum _$campaignInputDtoAudienceEnum_LOYALTY_TIER =
    const CampaignInputDtoAudienceEnum._('LOYALTY_TIER');

CampaignInputDtoAudienceEnum _$campaignInputDtoAudienceEnumValueOf(
    String name) {
  switch (name) {
    case 'ALL':
      return _$campaignInputDtoAudienceEnum_ALL;
    case 'LOYALTY_TIER':
      return _$campaignInputDtoAudienceEnum_LOYALTY_TIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignInputDtoAudienceEnum>
    _$campaignInputDtoAudienceEnumValues =
    BuiltSet<CampaignInputDtoAudienceEnum>(const <CampaignInputDtoAudienceEnum>[
  _$campaignInputDtoAudienceEnum_ALL,
  _$campaignInputDtoAudienceEnum_LOYALTY_TIER,
]);

const CampaignInputDtoTiersEnum _$campaignInputDtoTiersEnum_BRONZE =
    const CampaignInputDtoTiersEnum._('BRONZE');
const CampaignInputDtoTiersEnum _$campaignInputDtoTiersEnum_SILVER =
    const CampaignInputDtoTiersEnum._('SILVER');
const CampaignInputDtoTiersEnum _$campaignInputDtoTiersEnum_GOLD =
    const CampaignInputDtoTiersEnum._('GOLD');
const CampaignInputDtoTiersEnum _$campaignInputDtoTiersEnum_PLATINUM =
    const CampaignInputDtoTiersEnum._('PLATINUM');

CampaignInputDtoTiersEnum _$campaignInputDtoTiersEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$campaignInputDtoTiersEnum_BRONZE;
    case 'SILVER':
      return _$campaignInputDtoTiersEnum_SILVER;
    case 'GOLD':
      return _$campaignInputDtoTiersEnum_GOLD;
    case 'PLATINUM':
      return _$campaignInputDtoTiersEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignInputDtoTiersEnum> _$campaignInputDtoTiersEnumValues =
    BuiltSet<CampaignInputDtoTiersEnum>(const <CampaignInputDtoTiersEnum>[
  _$campaignInputDtoTiersEnum_BRONZE,
  _$campaignInputDtoTiersEnum_SILVER,
  _$campaignInputDtoTiersEnum_GOLD,
  _$campaignInputDtoTiersEnum_PLATINUM,
]);

Serializer<CampaignInputDtoTypeEnum> _$campaignInputDtoTypeEnumSerializer =
    _$CampaignInputDtoTypeEnumSerializer();
Serializer<CampaignInputDtoAudienceEnum>
    _$campaignInputDtoAudienceEnumSerializer =
    _$CampaignInputDtoAudienceEnumSerializer();
Serializer<CampaignInputDtoTiersEnum> _$campaignInputDtoTiersEnumSerializer =
    _$CampaignInputDtoTiersEnumSerializer();

class _$CampaignInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<CampaignInputDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SERVICE': 'SERVICE',
    'PROMOTION': 'PROMOTION',
    'NEWS': 'NEWS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SERVICE': 'SERVICE',
    'PROMOTION': 'PROMOTION',
    'NEWS': 'NEWS',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignInputDtoTypeEnum];
  @override
  final String wireName = 'CampaignInputDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, CampaignInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignInputDtoAudienceEnumSerializer
    implements PrimitiveSerializer<CampaignInputDtoAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignInputDtoAudienceEnum];
  @override
  final String wireName = 'CampaignInputDtoAudienceEnum';

  @override
  Object serialize(Serializers serializers, CampaignInputDtoAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignInputDtoAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignInputDtoAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignInputDtoTiersEnumSerializer
    implements PrimitiveSerializer<CampaignInputDtoTiersEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignInputDtoTiersEnum];
  @override
  final String wireName = 'CampaignInputDtoTiersEnum';

  @override
  Object serialize(Serializers serializers, CampaignInputDtoTiersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignInputDtoTiersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignInputDtoTiersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignInputDto extends CampaignInputDto {
  @override
  final CampaignInputDtoTypeEnum type;
  @override
  final String title;
  @override
  final String body;
  @override
  final CampaignInputDtoAudienceEnum? audience;
  @override
  final BuiltList<CampaignInputDtoTiersEnum> tiers;
  @override
  final String? promotionId;
  @override
  final String? articleId;

  factory _$CampaignInputDto(
          [void Function(CampaignInputDtoBuilder)? updates]) =>
      (CampaignInputDtoBuilder()..update(updates))._build();

  _$CampaignInputDto._(
      {required this.type,
      required this.title,
      required this.body,
      this.audience,
      required this.tiers,
      this.promotionId,
      this.articleId})
      : super._();
  @override
  CampaignInputDto rebuild(void Function(CampaignInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignInputDtoBuilder toBuilder() =>
      CampaignInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignInputDto &&
        type == other.type &&
        title == other.title &&
        body == other.body &&
        audience == other.audience &&
        tiers == other.tiers &&
        promotionId == other.promotionId &&
        articleId == other.articleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jc(_$hash, promotionId.hashCode);
    _$hash = $jc(_$hash, articleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignInputDto')
          ..add('type', type)
          ..add('title', title)
          ..add('body', body)
          ..add('audience', audience)
          ..add('tiers', tiers)
          ..add('promotionId', promotionId)
          ..add('articleId', articleId))
        .toString();
  }
}

class CampaignInputDtoBuilder
    implements Builder<CampaignInputDto, CampaignInputDtoBuilder> {
  _$CampaignInputDto? _$v;

  CampaignInputDtoTypeEnum? _type;
  CampaignInputDtoTypeEnum? get type => _$this._type;
  set type(CampaignInputDtoTypeEnum? type) => _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  CampaignInputDtoAudienceEnum? _audience;
  CampaignInputDtoAudienceEnum? get audience => _$this._audience;
  set audience(CampaignInputDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<CampaignInputDtoTiersEnum>? _tiers;
  ListBuilder<CampaignInputDtoTiersEnum> get tiers =>
      _$this._tiers ??= ListBuilder<CampaignInputDtoTiersEnum>();
  set tiers(ListBuilder<CampaignInputDtoTiersEnum>? tiers) =>
      _$this._tiers = tiers;

  String? _promotionId;
  String? get promotionId => _$this._promotionId;
  set promotionId(String? promotionId) => _$this._promotionId = promotionId;

  String? _articleId;
  String? get articleId => _$this._articleId;
  set articleId(String? articleId) => _$this._articleId = articleId;

  CampaignInputDtoBuilder() {
    CampaignInputDto._defaults(this);
  }

  CampaignInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _title = $v.title;
      _body = $v.body;
      _audience = $v.audience;
      _tiers = $v.tiers.toBuilder();
      _promotionId = $v.promotionId;
      _articleId = $v.articleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignInputDto other) {
    _$v = other as _$CampaignInputDto;
  }

  @override
  void update(void Function(CampaignInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignInputDto build() => _build();

  _$CampaignInputDto _build() {
    _$CampaignInputDto _$result;
    try {
      _$result = _$v ??
          _$CampaignInputDto._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CampaignInputDto', 'type'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'CampaignInputDto', 'title'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'CampaignInputDto', 'body'),
            audience: audience,
            tiers: tiers.build(),
            promotionId: promotionId,
            articleId: articleId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CampaignInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
