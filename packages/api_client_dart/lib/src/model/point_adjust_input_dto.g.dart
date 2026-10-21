// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_adjust_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PointAdjustInputDtoDirectionEnum
    _$pointAdjustInputDtoDirectionEnum_CREDIT =
    const PointAdjustInputDtoDirectionEnum._('CREDIT');
const PointAdjustInputDtoDirectionEnum
    _$pointAdjustInputDtoDirectionEnum_DEBIT =
    const PointAdjustInputDtoDirectionEnum._('DEBIT');

PointAdjustInputDtoDirectionEnum _$pointAdjustInputDtoDirectionEnumValueOf(
    String name) {
  switch (name) {
    case 'CREDIT':
      return _$pointAdjustInputDtoDirectionEnum_CREDIT;
    case 'DEBIT':
      return _$pointAdjustInputDtoDirectionEnum_DEBIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PointAdjustInputDtoDirectionEnum>
    _$pointAdjustInputDtoDirectionEnumValues = BuiltSet<
        PointAdjustInputDtoDirectionEnum>(const <PointAdjustInputDtoDirectionEnum>[
  _$pointAdjustInputDtoDirectionEnum_CREDIT,
  _$pointAdjustInputDtoDirectionEnum_DEBIT,
]);

Serializer<PointAdjustInputDtoDirectionEnum>
    _$pointAdjustInputDtoDirectionEnumSerializer =
    _$PointAdjustInputDtoDirectionEnumSerializer();

class _$PointAdjustInputDtoDirectionEnumSerializer
    implements PrimitiveSerializer<PointAdjustInputDtoDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CREDIT': 'CREDIT',
    'DEBIT': 'DEBIT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CREDIT': 'CREDIT',
    'DEBIT': 'DEBIT',
  };

  @override
  final Iterable<Type> types = const <Type>[PointAdjustInputDtoDirectionEnum];
  @override
  final String wireName = 'PointAdjustInputDtoDirectionEnum';

  @override
  Object serialize(
          Serializers serializers, PointAdjustInputDtoDirectionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PointAdjustInputDtoDirectionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PointAdjustInputDtoDirectionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PointAdjustInputDto extends PointAdjustInputDto {
  @override
  final PointAdjustInputDtoDirectionEnum direction;
  @override
  final int points;
  @override
  final String reason;

  factory _$PointAdjustInputDto(
          [void Function(PointAdjustInputDtoBuilder)? updates]) =>
      (PointAdjustInputDtoBuilder()..update(updates))._build();

  _$PointAdjustInputDto._(
      {required this.direction, required this.points, required this.reason})
      : super._();
  @override
  PointAdjustInputDto rebuild(
          void Function(PointAdjustInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PointAdjustInputDtoBuilder toBuilder() =>
      PointAdjustInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PointAdjustInputDto &&
        direction == other.direction &&
        points == other.points &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PointAdjustInputDto')
          ..add('direction', direction)
          ..add('points', points)
          ..add('reason', reason))
        .toString();
  }
}

class PointAdjustInputDtoBuilder
    implements Builder<PointAdjustInputDto, PointAdjustInputDtoBuilder> {
  _$PointAdjustInputDto? _$v;

  PointAdjustInputDtoDirectionEnum? _direction;
  PointAdjustInputDtoDirectionEnum? get direction => _$this._direction;
  set direction(PointAdjustInputDtoDirectionEnum? direction) =>
      _$this._direction = direction;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PointAdjustInputDtoBuilder() {
    PointAdjustInputDto._defaults(this);
  }

  PointAdjustInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _direction = $v.direction;
      _points = $v.points;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PointAdjustInputDto other) {
    _$v = other as _$PointAdjustInputDto;
  }

  @override
  void update(void Function(PointAdjustInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PointAdjustInputDto build() => _build();

  _$PointAdjustInputDto _build() {
    final _$result = _$v ??
        _$PointAdjustInputDto._(
          direction: BuiltValueNullFieldError.checkNotNull(
              direction, r'PointAdjustInputDto', 'direction'),
          points: BuiltValueNullFieldError.checkNotNull(
              points, r'PointAdjustInputDto', 'points'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'PointAdjustInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
