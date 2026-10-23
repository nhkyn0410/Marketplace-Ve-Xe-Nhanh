// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeviceInputDtoProviderEnum _$deviceInputDtoProviderEnum_FCM =
    const DeviceInputDtoProviderEnum._('FCM');
const DeviceInputDtoProviderEnum _$deviceInputDtoProviderEnum_APNS =
    const DeviceInputDtoProviderEnum._('APNS');

DeviceInputDtoProviderEnum _$deviceInputDtoProviderEnumValueOf(String name) {
  switch (name) {
    case 'FCM':
      return _$deviceInputDtoProviderEnum_FCM;
    case 'APNS':
      return _$deviceInputDtoProviderEnum_APNS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeviceInputDtoProviderEnum> _$deviceInputDtoProviderEnumValues =
    BuiltSet<DeviceInputDtoProviderEnum>(const <DeviceInputDtoProviderEnum>[
  _$deviceInputDtoProviderEnum_FCM,
  _$deviceInputDtoProviderEnum_APNS,
]);

Serializer<DeviceInputDtoProviderEnum> _$deviceInputDtoProviderEnumSerializer =
    _$DeviceInputDtoProviderEnumSerializer();

class _$DeviceInputDtoProviderEnumSerializer
    implements PrimitiveSerializer<DeviceInputDtoProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FCM': 'FCM',
    'APNS': 'APNS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FCM': 'FCM',
    'APNS': 'APNS',
  };

  @override
  final Iterable<Type> types = const <Type>[DeviceInputDtoProviderEnum];
  @override
  final String wireName = 'DeviceInputDtoProviderEnum';

  @override
  Object serialize(Serializers serializers, DeviceInputDtoProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeviceInputDtoProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeviceInputDtoProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeviceInputDto extends DeviceInputDto {
  @override
  final DeviceInputDtoProviderEnum provider;
  @override
  final String token;

  factory _$DeviceInputDto([void Function(DeviceInputDtoBuilder)? updates]) =>
      (DeviceInputDtoBuilder()..update(updates))._build();

  _$DeviceInputDto._({required this.provider, required this.token}) : super._();
  @override
  DeviceInputDto rebuild(void Function(DeviceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceInputDtoBuilder toBuilder() => DeviceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceInputDto &&
        provider == other.provider &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceInputDto')
          ..add('provider', provider)
          ..add('token', token))
        .toString();
  }
}

class DeviceInputDtoBuilder
    implements Builder<DeviceInputDto, DeviceInputDtoBuilder> {
  _$DeviceInputDto? _$v;

  DeviceInputDtoProviderEnum? _provider;
  DeviceInputDtoProviderEnum? get provider => _$this._provider;
  set provider(DeviceInputDtoProviderEnum? provider) =>
      _$this._provider = provider;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  DeviceInputDtoBuilder() {
    DeviceInputDto._defaults(this);
  }

  DeviceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceInputDto other) {
    _$v = other as _$DeviceInputDto;
  }

  @override
  void update(void Function(DeviceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceInputDto build() => _build();

  _$DeviceInputDto _build() {
    final _$result = _$v ??
        _$DeviceInputDto._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'DeviceInputDto', 'provider'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'DeviceInputDto', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
