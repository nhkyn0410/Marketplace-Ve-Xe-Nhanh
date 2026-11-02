// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_input_dto_evidence_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IncidentInputDtoEvidenceInner extends IncidentInputDtoEvidenceInner {
  @override
  final String objectKey;
  @override
  final String fileName;

  factory _$IncidentInputDtoEvidenceInner(
          [void Function(IncidentInputDtoEvidenceInnerBuilder)? updates]) =>
      (IncidentInputDtoEvidenceInnerBuilder()..update(updates))._build();

  _$IncidentInputDtoEvidenceInner._(
      {required this.objectKey, required this.fileName})
      : super._();
  @override
  IncidentInputDtoEvidenceInner rebuild(
          void Function(IncidentInputDtoEvidenceInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentInputDtoEvidenceInnerBuilder toBuilder() =>
      IncidentInputDtoEvidenceInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentInputDtoEvidenceInner &&
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
    return (newBuiltValueToStringHelper(r'IncidentInputDtoEvidenceInner')
          ..add('objectKey', objectKey)
          ..add('fileName', fileName))
        .toString();
  }
}

class IncidentInputDtoEvidenceInnerBuilder
    implements
        Builder<IncidentInputDtoEvidenceInner,
            IncidentInputDtoEvidenceInnerBuilder> {
  _$IncidentInputDtoEvidenceInner? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  IncidentInputDtoEvidenceInnerBuilder() {
    IncidentInputDtoEvidenceInner._defaults(this);
  }

  IncidentInputDtoEvidenceInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentInputDtoEvidenceInner other) {
    _$v = other as _$IncidentInputDtoEvidenceInner;
  }

  @override
  void update(void Function(IncidentInputDtoEvidenceInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentInputDtoEvidenceInner build() => _build();

  _$IncidentInputDtoEvidenceInner _build() {
    final _$result = _$v ??
        _$IncidentInputDtoEvidenceInner._(
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'IncidentInputDtoEvidenceInner', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'IncidentInputDtoEvidenceInner', 'fileName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
