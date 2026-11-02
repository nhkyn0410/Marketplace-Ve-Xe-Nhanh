// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_status_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PromotionStatusInputDtoStatusEnum
    _$promotionStatusInputDtoStatusEnum_ACTIVE =
    const PromotionStatusInputDtoStatusEnum._('ACTIVE');
const PromotionStatusInputDtoStatusEnum
    _$promotionStatusInputDtoStatusEnum_PAUSED =
    const PromotionStatusInputDtoStatusEnum._('PAUSED');
const PromotionStatusInputDtoStatusEnum
    _$promotionStatusInputDtoStatusEnum_ENDED =
    const PromotionStatusInputDtoStatusEnum._('ENDED');

PromotionStatusInputDtoStatusEnum _$promotionStatusInputDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$promotionStatusInputDtoStatusEnum_ACTIVE;
    case 'PAUSED':
      return _$promotionStatusInputDtoStatusEnum_PAUSED;
    case 'ENDED':
      return _$promotionStatusInputDtoStatusEnum_ENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionStatusInputDtoStatusEnum>
    _$promotionStatusInputDtoStatusEnumValues = BuiltSet<
        PromotionStatusInputDtoStatusEnum>(const <PromotionStatusInputDtoStatusEnum>[
  _$promotionStatusInputDtoStatusEnum_ACTIVE,
  _$promotionStatusInputDtoStatusEnum_PAUSED,
  _$promotionStatusInputDtoStatusEnum_ENDED,
]);

Serializer<PromotionStatusInputDtoStatusEnum>
    _$promotionStatusInputDtoStatusEnumSerializer =
    _$PromotionStatusInputDtoStatusEnumSerializer();

class _$PromotionStatusInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<PromotionStatusInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionStatusInputDtoStatusEnum];
  @override
  final String wireName = 'PromotionStatusInputDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PromotionStatusInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionStatusInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionStatusInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionStatusInputDto extends PromotionStatusInputDto {
  @override
  final PromotionStatusInputDtoStatusEnum status;

  factory _$PromotionStatusInputDto(
          [void Function(PromotionStatusInputDtoBuilder)? updates]) =>
      (PromotionStatusInputDtoBuilder()..update(updates))._build();

  _$PromotionStatusInputDto._({required this.status}) : super._();
  @override
  PromotionStatusInputDto rebuild(
          void Function(PromotionStatusInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionStatusInputDtoBuilder toBuilder() =>
      PromotionStatusInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionStatusInputDto && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionStatusInputDto')
          ..add('status', status))
        .toString();
  }
}

class PromotionStatusInputDtoBuilder
    implements
        Builder<PromotionStatusInputDto, PromotionStatusInputDtoBuilder> {
  _$PromotionStatusInputDto? _$v;

  PromotionStatusInputDtoStatusEnum? _status;
  PromotionStatusInputDtoStatusEnum? get status => _$this._status;
  set status(PromotionStatusInputDtoStatusEnum? status) =>
      _$this._status = status;

  PromotionStatusInputDtoBuilder() {
    PromotionStatusInputDto._defaults(this);
  }

  PromotionStatusInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionStatusInputDto other) {
    _$v = other as _$PromotionStatusInputDto;
  }

  @override
  void update(void Function(PromotionStatusInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionStatusInputDto build() => _build();

  _$PromotionStatusInputDto _build() {
    final _$result = _$v ??
        _$PromotionStatusInputDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PromotionStatusInputDto', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
