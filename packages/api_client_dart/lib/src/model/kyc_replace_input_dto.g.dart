// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_replace_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycReplaceInputDto extends KycReplaceInputDto {
  @override
  final String objectKey;
  @override
  final String fileName;

  factory _$KycReplaceInputDto(
          [void Function(KycReplaceInputDtoBuilder)? updates]) =>
      (KycReplaceInputDtoBuilder()..update(updates))._build();

  _$KycReplaceInputDto._({required this.objectKey, required this.fileName})
      : super._();
  @override
  KycReplaceInputDto rebuild(
          void Function(KycReplaceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycReplaceInputDtoBuilder toBuilder() =>
      KycReplaceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycReplaceInputDto &&
        objectKey == other.objectKey &&
        fileName == other.fileName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycReplaceInputDto')
          ..add('objectKey', objectKey)
          ..add('fileName', fileName))
        .toString();
  }
}

class KycReplaceInputDtoBuilder
    implements Builder<KycReplaceInputDto, KycReplaceInputDtoBuilder> {
  _$KycReplaceInputDto? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  KycReplaceInputDtoBuilder() {
    KycReplaceInputDto._defaults(this);
  }

  KycReplaceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycReplaceInputDto other) {
    _$v = other as _$KycReplaceInputDto;
  }

  @override
  void update(void Function(KycReplaceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycReplaceInputDto build() => _build();

  _$KycReplaceInputDto _build() {
    final _$result = _$v ??
        _$KycReplaceInputDto._(
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'KycReplaceInputDto', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'KycReplaceInputDto', 'fileName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
