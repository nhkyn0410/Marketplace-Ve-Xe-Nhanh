// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_resolution_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IncidentResolutionDto extends IncidentResolutionDto {
  @override
  final String resolution;

  factory _$IncidentResolutionDto(
          [void Function(IncidentResolutionDtoBuilder)? updates]) =>
      (IncidentResolutionDtoBuilder()..update(updates))._build();

  _$IncidentResolutionDto._({required this.resolution}) : super._();
  @override
  IncidentResolutionDto rebuild(
          void Function(IncidentResolutionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncidentResolutionDtoBuilder toBuilder() =>
      IncidentResolutionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncidentResolutionDto && resolution == other.resolution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IncidentResolutionDto')
          ..add('resolution', resolution))
        .toString();
  }
}

class IncidentResolutionDtoBuilder
    implements Builder<IncidentResolutionDto, IncidentResolutionDtoBuilder> {
  _$IncidentResolutionDto? _$v;

  String? _resolution;
  String? get resolution => _$this._resolution;
  set resolution(String? resolution) => _$this._resolution = resolution;

  IncidentResolutionDtoBuilder() {
    IncidentResolutionDto._defaults(this);
  }

  IncidentResolutionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resolution = $v.resolution;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncidentResolutionDto other) {
    _$v = other as _$IncidentResolutionDto;
  }

  @override
  void update(void Function(IncidentResolutionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncidentResolutionDto build() => _build();

  _$IncidentResolutionDto _build() {
    final _$result = _$v ??
        _$IncidentResolutionDto._(
          resolution: BuiltValueNullFieldError.checkNotNull(
              resolution, r'IncidentResolutionDto', 'resolution'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
