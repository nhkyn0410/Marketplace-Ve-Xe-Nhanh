// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CampaignDtoOutputTypeEnum _$campaignDtoOutputTypeEnum_SERVICE =
    const CampaignDtoOutputTypeEnum._('SERVICE');
const CampaignDtoOutputTypeEnum _$campaignDtoOutputTypeEnum_PROMOTION =
    const CampaignDtoOutputTypeEnum._('PROMOTION');
const CampaignDtoOutputTypeEnum _$campaignDtoOutputTypeEnum_NEWS =
    const CampaignDtoOutputTypeEnum._('NEWS');

CampaignDtoOutputTypeEnum _$campaignDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'SERVICE':
      return _$campaignDtoOutputTypeEnum_SERVICE;
    case 'PROMOTION':
      return _$campaignDtoOutputTypeEnum_PROMOTION;
    case 'NEWS':
      return _$campaignDtoOutputTypeEnum_NEWS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignDtoOutputTypeEnum> _$campaignDtoOutputTypeEnumValues =
    BuiltSet<CampaignDtoOutputTypeEnum>(const <CampaignDtoOutputTypeEnum>[
  _$campaignDtoOutputTypeEnum_SERVICE,
  _$campaignDtoOutputTypeEnum_PROMOTION,
  _$campaignDtoOutputTypeEnum_NEWS,
]);

const CampaignDtoOutputAudienceEnum _$campaignDtoOutputAudienceEnum_ALL =
    const CampaignDtoOutputAudienceEnum._('ALL');
const CampaignDtoOutputAudienceEnum
    _$campaignDtoOutputAudienceEnum_LOYALTY_TIER =
    const CampaignDtoOutputAudienceEnum._('LOYALTY_TIER');

CampaignDtoOutputAudienceEnum _$campaignDtoOutputAudienceEnumValueOf(
    String name) {
  switch (name) {
    case 'ALL':
      return _$campaignDtoOutputAudienceEnum_ALL;
    case 'LOYALTY_TIER':
      return _$campaignDtoOutputAudienceEnum_LOYALTY_TIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignDtoOutputAudienceEnum>
    _$campaignDtoOutputAudienceEnumValues = BuiltSet<
        CampaignDtoOutputAudienceEnum>(const <CampaignDtoOutputAudienceEnum>[
  _$campaignDtoOutputAudienceEnum_ALL,
  _$campaignDtoOutputAudienceEnum_LOYALTY_TIER,
]);

const CampaignDtoOutputTiersEnum _$campaignDtoOutputTiersEnum_BRONZE =
    const CampaignDtoOutputTiersEnum._('BRONZE');
const CampaignDtoOutputTiersEnum _$campaignDtoOutputTiersEnum_SILVER =
    const CampaignDtoOutputTiersEnum._('SILVER');
const CampaignDtoOutputTiersEnum _$campaignDtoOutputTiersEnum_GOLD =
    const CampaignDtoOutputTiersEnum._('GOLD');
const CampaignDtoOutputTiersEnum _$campaignDtoOutputTiersEnum_PLATINUM =
    const CampaignDtoOutputTiersEnum._('PLATINUM');

CampaignDtoOutputTiersEnum _$campaignDtoOutputTiersEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$campaignDtoOutputTiersEnum_BRONZE;
    case 'SILVER':
      return _$campaignDtoOutputTiersEnum_SILVER;
    case 'GOLD':
      return _$campaignDtoOutputTiersEnum_GOLD;
    case 'PLATINUM':
      return _$campaignDtoOutputTiersEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignDtoOutputTiersEnum> _$campaignDtoOutputTiersEnumValues =
    BuiltSet<CampaignDtoOutputTiersEnum>(const <CampaignDtoOutputTiersEnum>[
  _$campaignDtoOutputTiersEnum_BRONZE,
  _$campaignDtoOutputTiersEnum_SILVER,
  _$campaignDtoOutputTiersEnum_GOLD,
  _$campaignDtoOutputTiersEnum_PLATINUM,
]);

const CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnum_DRAFT =
    const CampaignDtoOutputStatusEnum._('DRAFT');
const CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnum_SCHEDULED =
    const CampaignDtoOutputStatusEnum._('SCHEDULED');
const CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnum_SENDING =
    const CampaignDtoOutputStatusEnum._('SENDING');
const CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnum_COMPLETED =
    const CampaignDtoOutputStatusEnum._('COMPLETED');
const CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnum_CANCELLED =
    const CampaignDtoOutputStatusEnum._('CANCELLED');

CampaignDtoOutputStatusEnum _$campaignDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$campaignDtoOutputStatusEnum_DRAFT;
    case 'SCHEDULED':
      return _$campaignDtoOutputStatusEnum_SCHEDULED;
    case 'SENDING':
      return _$campaignDtoOutputStatusEnum_SENDING;
    case 'COMPLETED':
      return _$campaignDtoOutputStatusEnum_COMPLETED;
    case 'CANCELLED':
      return _$campaignDtoOutputStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignDtoOutputStatusEnum>
    _$campaignDtoOutputStatusEnumValues =
    BuiltSet<CampaignDtoOutputStatusEnum>(const <CampaignDtoOutputStatusEnum>[
  _$campaignDtoOutputStatusEnum_DRAFT,
  _$campaignDtoOutputStatusEnum_SCHEDULED,
  _$campaignDtoOutputStatusEnum_SENDING,
  _$campaignDtoOutputStatusEnum_COMPLETED,
  _$campaignDtoOutputStatusEnum_CANCELLED,
]);

Serializer<CampaignDtoOutputTypeEnum> _$campaignDtoOutputTypeEnumSerializer =
    _$CampaignDtoOutputTypeEnumSerializer();
Serializer<CampaignDtoOutputAudienceEnum>
    _$campaignDtoOutputAudienceEnumSerializer =
    _$CampaignDtoOutputAudienceEnumSerializer();
Serializer<CampaignDtoOutputTiersEnum> _$campaignDtoOutputTiersEnumSerializer =
    _$CampaignDtoOutputTiersEnumSerializer();
Serializer<CampaignDtoOutputStatusEnum>
    _$campaignDtoOutputStatusEnumSerializer =
    _$CampaignDtoOutputStatusEnumSerializer();

class _$CampaignDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<CampaignDtoOutputTypeEnum> {
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
  final Iterable<Type> types = const <Type>[CampaignDtoOutputTypeEnum];
  @override
  final String wireName = 'CampaignDtoOutputTypeEnum';

  @override
  Object serialize(Serializers serializers, CampaignDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignDtoOutputAudienceEnumSerializer
    implements PrimitiveSerializer<CampaignDtoOutputAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignDtoOutputAudienceEnum];
  @override
  final String wireName = 'CampaignDtoOutputAudienceEnum';

  @override
  Object serialize(
          Serializers serializers, CampaignDtoOutputAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignDtoOutputAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignDtoOutputAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignDtoOutputTiersEnumSerializer
    implements PrimitiveSerializer<CampaignDtoOutputTiersEnum> {
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
  final Iterable<Type> types = const <Type>[CampaignDtoOutputTiersEnum];
  @override
  final String wireName = 'CampaignDtoOutputTiersEnum';

  @override
  Object serialize(Serializers serializers, CampaignDtoOutputTiersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignDtoOutputTiersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignDtoOutputTiersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CampaignDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'SENDING': 'SENDING',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'SENDING': 'SENDING',
    'COMPLETED': 'COMPLETED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignDtoOutputStatusEnum];
  @override
  final String wireName = 'CampaignDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers, CampaignDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignDtoOutput extends CampaignDtoOutput {
  @override
  final String id;
  @override
  final CampaignDtoOutputTypeEnum type;
  @override
  final String title;
  @override
  final String body;
  @override
  final CampaignDtoOutputAudienceEnum audience;
  @override
  final BuiltList<CampaignDtoOutputTiersEnum> tiers;
  @override
  final String? promotionId;
  @override
  final String? promotionLabel;
  @override
  final String? articleId;
  @override
  final String? articleLabel;
  @override
  final CampaignDtoOutputStatusEnum status;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? cancelledAt;
  @override
  final String? note;
  @override
  final int recipientCount;
  @override
  final int cappedCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$CampaignDtoOutput(
          [void Function(CampaignDtoOutputBuilder)? updates]) =>
      (CampaignDtoOutputBuilder()..update(updates))._build();

  _$CampaignDtoOutput._(
      {required this.id,
      required this.type,
      required this.title,
      required this.body,
      required this.audience,
      required this.tiers,
      this.promotionId,
      this.promotionLabel,
      this.articleId,
      this.articleLabel,
      required this.status,
      this.scheduledAt,
      this.startedAt,
      this.completedAt,
      this.cancelledAt,
      this.note,
      required this.recipientCount,
      required this.cappedCount,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  CampaignDtoOutput rebuild(void Function(CampaignDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignDtoOutputBuilder toBuilder() =>
      CampaignDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignDtoOutput &&
        id == other.id &&
        type == other.type &&
        title == other.title &&
        body == other.body &&
        audience == other.audience &&
        tiers == other.tiers &&
        promotionId == other.promotionId &&
        promotionLabel == other.promotionLabel &&
        articleId == other.articleId &&
        articleLabel == other.articleLabel &&
        status == other.status &&
        scheduledAt == other.scheduledAt &&
        startedAt == other.startedAt &&
        completedAt == other.completedAt &&
        cancelledAt == other.cancelledAt &&
        note == other.note &&
        recipientCount == other.recipientCount &&
        cappedCount == other.cappedCount &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jc(_$hash, promotionId.hashCode);
    _$hash = $jc(_$hash, promotionLabel.hashCode);
    _$hash = $jc(_$hash, articleId.hashCode);
    _$hash = $jc(_$hash, articleLabel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, scheduledAt.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, cancelledAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, recipientCount.hashCode);
    _$hash = $jc(_$hash, cappedCount.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignDtoOutput')
          ..add('id', id)
          ..add('type', type)
          ..add('title', title)
          ..add('body', body)
          ..add('audience', audience)
          ..add('tiers', tiers)
          ..add('promotionId', promotionId)
          ..add('promotionLabel', promotionLabel)
          ..add('articleId', articleId)
          ..add('articleLabel', articleLabel)
          ..add('status', status)
          ..add('scheduledAt', scheduledAt)
          ..add('startedAt', startedAt)
          ..add('completedAt', completedAt)
          ..add('cancelledAt', cancelledAt)
          ..add('note', note)
          ..add('recipientCount', recipientCount)
          ..add('cappedCount', cappedCount)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class CampaignDtoOutputBuilder
    implements Builder<CampaignDtoOutput, CampaignDtoOutputBuilder> {
  _$CampaignDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CampaignDtoOutputTypeEnum? _type;
  CampaignDtoOutputTypeEnum? get type => _$this._type;
  set type(CampaignDtoOutputTypeEnum? type) => _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  CampaignDtoOutputAudienceEnum? _audience;
  CampaignDtoOutputAudienceEnum? get audience => _$this._audience;
  set audience(CampaignDtoOutputAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<CampaignDtoOutputTiersEnum>? _tiers;
  ListBuilder<CampaignDtoOutputTiersEnum> get tiers =>
      _$this._tiers ??= ListBuilder<CampaignDtoOutputTiersEnum>();
  set tiers(ListBuilder<CampaignDtoOutputTiersEnum>? tiers) =>
      _$this._tiers = tiers;

  String? _promotionId;
  String? get promotionId => _$this._promotionId;
  set promotionId(String? promotionId) => _$this._promotionId = promotionId;

  String? _promotionLabel;
  String? get promotionLabel => _$this._promotionLabel;
  set promotionLabel(String? promotionLabel) =>
      _$this._promotionLabel = promotionLabel;

  String? _articleId;
  String? get articleId => _$this._articleId;
  set articleId(String? articleId) => _$this._articleId = articleId;

  String? _articleLabel;
  String? get articleLabel => _$this._articleLabel;
  set articleLabel(String? articleLabel) => _$this._articleLabel = articleLabel;

  CampaignDtoOutputStatusEnum? _status;
  CampaignDtoOutputStatusEnum? get status => _$this._status;
  set status(CampaignDtoOutputStatusEnum? status) => _$this._status = status;

  DateTime? _scheduledAt;
  DateTime? get scheduledAt => _$this._scheduledAt;
  set scheduledAt(DateTime? scheduledAt) => _$this._scheduledAt = scheduledAt;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _cancelledAt;
  DateTime? get cancelledAt => _$this._cancelledAt;
  set cancelledAt(DateTime? cancelledAt) => _$this._cancelledAt = cancelledAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _recipientCount;
  int? get recipientCount => _$this._recipientCount;
  set recipientCount(int? recipientCount) =>
      _$this._recipientCount = recipientCount;

  int? _cappedCount;
  int? get cappedCount => _$this._cappedCount;
  set cappedCount(int? cappedCount) => _$this._cappedCount = cappedCount;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  CampaignDtoOutputBuilder() {
    CampaignDtoOutput._defaults(this);
  }

  CampaignDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _title = $v.title;
      _body = $v.body;
      _audience = $v.audience;
      _tiers = $v.tiers.toBuilder();
      _promotionId = $v.promotionId;
      _promotionLabel = $v.promotionLabel;
      _articleId = $v.articleId;
      _articleLabel = $v.articleLabel;
      _status = $v.status;
      _scheduledAt = $v.scheduledAt;
      _startedAt = $v.startedAt;
      _completedAt = $v.completedAt;
      _cancelledAt = $v.cancelledAt;
      _note = $v.note;
      _recipientCount = $v.recipientCount;
      _cappedCount = $v.cappedCount;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignDtoOutput other) {
    _$v = other as _$CampaignDtoOutput;
  }

  @override
  void update(void Function(CampaignDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignDtoOutput build() => _build();

  _$CampaignDtoOutput _build() {
    _$CampaignDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CampaignDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CampaignDtoOutput', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CampaignDtoOutput', 'type'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'CampaignDtoOutput', 'title'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'CampaignDtoOutput', 'body'),
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'CampaignDtoOutput', 'audience'),
            tiers: tiers.build(),
            promotionId: promotionId,
            promotionLabel: promotionLabel,
            articleId: articleId,
            articleLabel: articleLabel,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CampaignDtoOutput', 'status'),
            scheduledAt: scheduledAt,
            startedAt: startedAt,
            completedAt: completedAt,
            cancelledAt: cancelledAt,
            note: note,
            recipientCount: BuiltValueNullFieldError.checkNotNull(
                recipientCount, r'CampaignDtoOutput', 'recipientCount'),
            cappedCount: BuiltValueNullFieldError.checkNotNull(
                cappedCount, r'CampaignDtoOutput', 'cappedCount'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CampaignDtoOutput', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'CampaignDtoOutput', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CampaignDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
