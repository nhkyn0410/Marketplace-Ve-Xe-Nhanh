// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_attach_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoAttachInputDto extends LogoAttachInputDto {
  @override
  final String objectKey;

  factory _$LogoAttachInputDto(
          [void Function(LogoAttachInputDtoBuilder)? updates]) =>
      (LogoAttachInputDtoBuilder()..update(updates))._build();

  _$LogoAttachInputDto._({required this.objectKey}) : super._();
  @override
  LogoAttachInputDto rebuild(
          void Function(LogoAttachInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoAttachInputDtoBuilder toBuilder() =>
      LogoAttachInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoAttachInputDto && objectKey == other.objectKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogoAttachInputDto')
          ..add('objectKey', objectKey))
        .toString();
  }
}

class LogoAttachInputDtoBuilder
    implements Builder<LogoAttachInputDto, LogoAttachInputDtoBuilder> {
  _$LogoAttachInputDto? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  LogoAttachInputDtoBuilder() {
    LogoAttachInputDto._defaults(this);
  }

  LogoAttachInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoAttachInputDto other) {
    _$v = other as _$LogoAttachInputDto;
  }

  @override
  void update(void Function(LogoAttachInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoAttachInputDto build() => _build();

  _$LogoAttachInputDto _build() {
    final _$result = _$v ??
        _$LogoAttachInputDto._(
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'LogoAttachInputDto', 'objectKey'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
