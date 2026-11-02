// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audience_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AudienceInputDtoTypeEnum _$audienceInputDtoTypeEnum_SERVICE =
    const AudienceInputDtoTypeEnum._('SERVICE');
const AudienceInputDtoTypeEnum _$audienceInputDtoTypeEnum_PROMOTION =
    const AudienceInputDtoTypeEnum._('PROMOTION');
const AudienceInputDtoTypeEnum _$audienceInputDtoTypeEnum_NEWS =
    const AudienceInputDtoTypeEnum._('NEWS');

AudienceInputDtoTypeEnum _$audienceInputDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'SERVICE':
      return _$audienceInputDtoTypeEnum_SERVICE;
    case 'PROMOTION':
      return _$audienceInputDtoTypeEnum_PROMOTION;
    case 'NEWS':
      return _$audienceInputDtoTypeEnum_NEWS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AudienceInputDtoTypeEnum> _$audienceInputDtoTypeEnumValues =
    BuiltSet<AudienceInputDtoTypeEnum>(const <AudienceInputDtoTypeEnum>[
  _$audienceInputDtoTypeEnum_SERVICE,
  _$audienceInputDtoTypeEnum_PROMOTION,
  _$audienceInputDtoTypeEnum_NEWS,
]);

const AudienceInputDtoAudienceEnum _$audienceInputDtoAudienceEnum_ALL =
    const AudienceInputDtoAudienceEnum._('ALL');
const AudienceInputDtoAudienceEnum _$audienceInputDtoAudienceEnum_LOYALTY_TIER =
    const AudienceInputDtoAudienceEnum._('LOYALTY_TIER');

AudienceInputDtoAudienceEnum _$audienceInputDtoAudienceEnumValueOf(
    String name) {
  switch (name) {
    case 'ALL':
      return _$audienceInputDtoAudienceEnum_ALL;
    case 'LOYALTY_TIER':
      return _$audienceInputDtoAudienceEnum_LOYALTY_TIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AudienceInputDtoAudienceEnum>
    _$audienceInputDtoAudienceEnumValues =
    BuiltSet<AudienceInputDtoAudienceEnum>(const <AudienceInputDtoAudienceEnum>[
  _$audienceInputDtoAudienceEnum_ALL,
  _$audienceInputDtoAudienceEnum_LOYALTY_TIER,
]);

const AudienceInputDtoTiersEnum _$audienceInputDtoTiersEnum_BRONZE =
    const AudienceInputDtoTiersEnum._('BRONZE');
const AudienceInputDtoTiersEnum _$audienceInputDtoTiersEnum_SILVER =
    const AudienceInputDtoTiersEnum._('SILVER');
const AudienceInputDtoTiersEnum _$audienceInputDtoTiersEnum_GOLD =
    const AudienceInputDtoTiersEnum._('GOLD');
const AudienceInputDtoTiersEnum _$audienceInputDtoTiersEnum_PLATINUM =
    const AudienceInputDtoTiersEnum._('PLATINUM');

AudienceInputDtoTiersEnum _$audienceInputDtoTiersEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$audienceInputDtoTiersEnum_BRONZE;
    case 'SILVER':
      return _$audienceInputDtoTiersEnum_SILVER;
    case 'GOLD':
      return _$audienceInputDtoTiersEnum_GOLD;
    case 'PLATINUM':
      return _$audienceInputDtoTiersEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AudienceInputDtoTiersEnum> _$audienceInputDtoTiersEnumValues =
    BuiltSet<AudienceInputDtoTiersEnum>(const <AudienceInputDtoTiersEnum>[
  _$audienceInputDtoTiersEnum_BRONZE,
  _$audienceInputDtoTiersEnum_SILVER,
  _$audienceInputDtoTiersEnum_GOLD,
  _$audienceInputDtoTiersEnum_PLATINUM,
]);

Serializer<AudienceInputDtoTypeEnum> _$audienceInputDtoTypeEnumSerializer =
    _$AudienceInputDtoTypeEnumSerializer();
Serializer<AudienceInputDtoAudienceEnum>
    _$audienceInputDtoAudienceEnumSerializer =
    _$AudienceInputDtoAudienceEnumSerializer();
Serializer<AudienceInputDtoTiersEnum> _$audienceInputDtoTiersEnumSerializer =
    _$AudienceInputDtoTiersEnumSerializer();

class _$AudienceInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<AudienceInputDtoTypeEnum> {
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
  final Iterable<Type> types = const <Type>[AudienceInputDtoTypeEnum];
  @override
  final String wireName = 'AudienceInputDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, AudienceInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudienceInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudienceInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AudienceInputDtoAudienceEnumSerializer
    implements PrimitiveSerializer<AudienceInputDtoAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALL': 'ALL',
    'LOYALTY_TIER': 'LOYALTY_TIER',
  };

  @override
  final Iterable<Type> types = const <Type>[AudienceInputDtoAudienceEnum];
  @override
  final String wireName = 'AudienceInputDtoAudienceEnum';

  @override
  Object serialize(Serializers serializers, AudienceInputDtoAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudienceInputDtoAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudienceInputDtoAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AudienceInputDtoTiersEnumSerializer
    implements PrimitiveSerializer<AudienceInputDtoTiersEnum> {
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
  final Iterable<Type> types = const <Type>[AudienceInputDtoTiersEnum];
  @override
  final String wireName = 'AudienceInputDtoTiersEnum';

  @override
  Object serialize(Serializers serializers, AudienceInputDtoTiersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudienceInputDtoTiersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudienceInputDtoTiersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AudienceInputDto extends AudienceInputDto {
  @override
  final AudienceInputDtoTypeEnum type;
  @override
  final AudienceInputDtoAudienceEnum? audience;
  @override
  final BuiltList<AudienceInputDtoTiersEnum> tiers;

  factory _$AudienceInputDto(
          [void Function(AudienceInputDtoBuilder)? updates]) =>
      (AudienceInputDtoBuilder()..update(updates))._build();

  _$AudienceInputDto._({required this.type, this.audience, required this.tiers})
      : super._();
  @override
  AudienceInputDto rebuild(void Function(AudienceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudienceInputDtoBuilder toBuilder() =>
      AudienceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudienceInputDto &&
        type == other.type &&
        audience == other.audience &&
        tiers == other.tiers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AudienceInputDto')
          ..add('type', type)
          ..add('audience', audience)
          ..add('tiers', tiers))
        .toString();
  }
}

class AudienceInputDtoBuilder
    implements Builder<AudienceInputDto, AudienceInputDtoBuilder> {
  _$AudienceInputDto? _$v;

  AudienceInputDtoTypeEnum? _type;
  AudienceInputDtoTypeEnum? get type => _$this._type;
  set type(AudienceInputDtoTypeEnum? type) => _$this._type = type;

  AudienceInputDtoAudienceEnum? _audience;
  AudienceInputDtoAudienceEnum? get audience => _$this._audience;
  set audience(AudienceInputDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<AudienceInputDtoTiersEnum>? _tiers;
  ListBuilder<AudienceInputDtoTiersEnum> get tiers =>
      _$this._tiers ??= ListBuilder<AudienceInputDtoTiersEnum>();
  set tiers(ListBuilder<AudienceInputDtoTiersEnum>? tiers) =>
      _$this._tiers = tiers;

  AudienceInputDtoBuilder() {
    AudienceInputDto._defaults(this);
  }

  AudienceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _audience = $v.audience;
      _tiers = $v.tiers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AudienceInputDto other) {
    _$v = other as _$AudienceInputDto;
  }

  @override
  void update(void Function(AudienceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AudienceInputDto build() => _build();

  _$AudienceInputDto _build() {
    _$AudienceInputDto _$result;
    try {
      _$result = _$v ??
          _$AudienceInputDto._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'AudienceInputDto', 'type'),
            audience: audience,
            tiers: tiers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AudienceInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
