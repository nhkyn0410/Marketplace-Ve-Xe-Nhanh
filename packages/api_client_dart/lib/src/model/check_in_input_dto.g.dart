// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckInInputDtoStatusEnum _$checkInInputDtoStatusEnum_CHECKED_IN =
    const CheckInInputDtoStatusEnum._('CHECKED_IN');
const CheckInInputDtoStatusEnum _$checkInInputDtoStatusEnum_NO_SHOW =
    const CheckInInputDtoStatusEnum._('NO_SHOW');

CheckInInputDtoStatusEnum _$checkInInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'CHECKED_IN':
      return _$checkInInputDtoStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$checkInInputDtoStatusEnum_NO_SHOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckInInputDtoStatusEnum> _$checkInInputDtoStatusEnumValues =
    BuiltSet<CheckInInputDtoStatusEnum>(const <CheckInInputDtoStatusEnum>[
  _$checkInInputDtoStatusEnum_CHECKED_IN,
  _$checkInInputDtoStatusEnum_NO_SHOW,
]);

Serializer<CheckInInputDtoStatusEnum> _$checkInInputDtoStatusEnumSerializer =
    _$CheckInInputDtoStatusEnumSerializer();

class _$CheckInInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<CheckInInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckInInputDtoStatusEnum];
  @override
  final String wireName = 'CheckInInputDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, CheckInInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckInInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckInInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckInInputDto extends CheckInInputDto {
  @override
  final String tripId;
  @override
  final String code;
  @override
  final CheckInInputDtoStatusEnum status;

  factory _$CheckInInputDto([void Function(CheckInInputDtoBuilder)? updates]) =>
      (CheckInInputDtoBuilder()..update(updates))._build();

  _$CheckInInputDto._(
      {required this.tripId, required this.code, required this.status})
      : super._();
  @override
  CheckInInputDto rebuild(void Function(CheckInInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckInInputDtoBuilder toBuilder() => CheckInInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckInInputDto &&
        tripId == other.tripId &&
        code == other.code &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckInInputDto')
          ..add('tripId', tripId)
          ..add('code', code)
          ..add('status', status))
        .toString();
  }
}

class CheckInInputDtoBuilder
    implements Builder<CheckInInputDto, CheckInInputDtoBuilder> {
  _$CheckInInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CheckInInputDtoStatusEnum? _status;
  CheckInInputDtoStatusEnum? get status => _$this._status;
  set status(CheckInInputDtoStatusEnum? status) => _$this._status = status;

  CheckInInputDtoBuilder() {
    CheckInInputDto._defaults(this);
  }

  CheckInInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _code = $v.code;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckInInputDto other) {
    _$v = other as _$CheckInInputDto;
  }

  @override
  void update(void Function(CheckInInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckInInputDto build() => _build();

  _$CheckInInputDto _build() {
    final _$result = _$v ??
        _$CheckInInputDto._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'CheckInInputDto', 'tripId'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CheckInInputDto', 'code'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CheckInInputDto', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
