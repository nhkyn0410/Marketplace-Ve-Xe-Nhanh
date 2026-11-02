// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_assignment_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DriverAssignmentInputDto extends DriverAssignmentInputDto {
  @override
  final String? employeeId;
  @override
  final String? reason;

  factory _$DriverAssignmentInputDto(
          [void Function(DriverAssignmentInputDtoBuilder)? updates]) =>
      (DriverAssignmentInputDtoBuilder()..update(updates))._build();

  _$DriverAssignmentInputDto._({this.employeeId, this.reason}) : super._();
  @override
  DriverAssignmentInputDto rebuild(
          void Function(DriverAssignmentInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DriverAssignmentInputDtoBuilder toBuilder() =>
      DriverAssignmentInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DriverAssignmentInputDto &&
        employeeId == other.employeeId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DriverAssignmentInputDto')
          ..add('employeeId', employeeId)
          ..add('reason', reason))
        .toString();
  }
}

class DriverAssignmentInputDtoBuilder
    implements
        Builder<DriverAssignmentInputDto, DriverAssignmentInputDtoBuilder> {
  _$DriverAssignmentInputDto? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DriverAssignmentInputDtoBuilder() {
    DriverAssignmentInputDto._defaults(this);
  }

  DriverAssignmentInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DriverAssignmentInputDto other) {
    _$v = other as _$DriverAssignmentInputDto;
  }

  @override
  void update(void Function(DriverAssignmentInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DriverAssignmentInputDto build() => _build();

  _$DriverAssignmentInputDto _build() {
    final _$result = _$v ??
        _$DriverAssignmentInputDto._(
          employeeId: employeeId,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
