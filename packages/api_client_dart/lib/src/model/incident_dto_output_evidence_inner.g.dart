// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_dto_output_evidence_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IncidentDtoOutputEvidenceInner extends IncidentDtoOutputEvidenceInner {
  @override
  final String objectKey;
  @override
  final String fileName;
  @override
  final String contentType;
  @override
  final int sizeBytes;

  factory _$IncidentDtoOutputEvidenceInner(
          [void Function(IncidentDtoOutputEvidenceInnerBuilder)? updates]) =>
      (IncidentDtoOutputEvidenceInnerBuilder()..update(updates))._build();

  _$IncidentDtoOutputEvidenceInner._(
      {required this.objectKey,
      required this.fileName,
      required this.contentType,
      required this.sizeBytes})
      : super._();
  @override
  IncidentDtoOutputEvidenceInner rebuild(
          void Function(IncidentDtoOutputEvidenceInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentDtoOutputEvidenceInnerBuilder toBuilder() =>
      IncidentDtoOutputEvidenceInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentDtoOutputEvidenceInner &&
        objectKey == other.objectKey &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IncidentDtoOutputEvidenceInner')
          ..add('objectKey', objectKey)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class IncidentDtoOutputEvidenceInnerBuilder
    implements
        Builder<IncidentDtoOutputEvidenceInner,
            IncidentDtoOutputEvidenceInnerBuilder> {
  _$IncidentDtoOutputEvidenceInner? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  IncidentDtoOutputEvidenceInnerBuilder() {
    IncidentDtoOutputEvidenceInner._defaults(this);
  }

  IncidentDtoOutputEvidenceInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentDtoOutputEvidenceInner other) {
    _$v = other as _$IncidentDtoOutputEvidenceInner;
  }

  @override
  void update(void Function(IncidentDtoOutputEvidenceInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentDtoOutputEvidenceInner build() => _build();

  _$IncidentDtoOutputEvidenceInner _build() {
    final _$result = _$v ??
        _$IncidentDtoOutputEvidenceInner._(
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'IncidentDtoOutputEvidenceInner', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'IncidentDtoOutputEvidenceInner', 'fileName'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'IncidentDtoOutputEvidenceInner', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'IncidentDtoOutputEvidenceInner', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
