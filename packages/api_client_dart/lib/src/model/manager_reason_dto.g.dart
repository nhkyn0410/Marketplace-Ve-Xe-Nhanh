// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_reason_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ManagerReasonDto extends ManagerReasonDto {
  @override
  final String reason;

  factory _$ManagerReasonDto(
          [void Function(ManagerReasonDtoBuilder)? updates]) =>
      (ManagerReasonDtoBuilder()..update(updates))._build();

  _$ManagerReasonDto._({required this.reason}) : super._();
  @override
  ManagerReasonDto rebuild(void Function(ManagerReasonDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerReasonDtoBuilder toBuilder() =>
      ManagerReasonDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerReasonDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'ManagerReasonDto')
          ..add('reason', reason))
        .toString();
  }
}

class ManagerReasonDtoBuilder
    implements Builder<ManagerReasonDto, ManagerReasonDtoBuilder> {
  _$ManagerReasonDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ManagerReasonDtoBuilder() {
    ManagerReasonDto._defaults(this);
  }

  ManagerReasonDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManagerReasonDto other) {
    _$v = other as _$ManagerReasonDto;
  }

  @override
  void update(void Function(ManagerReasonDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerReasonDto build() => _build();

  _$ManagerReasonDto _build() {
    final _$result = _$v ??
        _$ManagerReasonDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ManagerReasonDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
