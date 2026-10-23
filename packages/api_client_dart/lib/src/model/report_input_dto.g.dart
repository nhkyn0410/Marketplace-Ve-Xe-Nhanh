// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportInputDto extends ReportInputDto {
  @override
  final String reason;

  factory _$ReportInputDto([void Function(ReportInputDtoBuilder)? updates]) =>
      (ReportInputDtoBuilder()..update(updates))._build();

  _$ReportInputDto._({required this.reason}) : super._();
  @override
  ReportInputDto rebuild(void Function(ReportInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportInputDtoBuilder toBuilder() => ReportInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportInputDto && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class ReportInputDtoBuilder
    implements Builder<ReportInputDto, ReportInputDtoBuilder> {
  _$ReportInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ReportInputDtoBuilder() {
    ReportInputDto._defaults(this);
  }

  ReportInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportInputDto other) {
    _$v = other as _$ReportInputDto;
  }

  @override
  void update(void Function(ReportInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportInputDto build() => _build();

  _$ReportInputDto _build() {
    final _$result = _$v ??
        _$ReportInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReportInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
