// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_assignments_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeAssignmentsInputDto extends SalesOfficeAssignmentsInputDto {
  @override
  final int version;
  @override
  final BuiltList<String> employeeIds;

  factory _$SalesOfficeAssignmentsInputDto(
          [void Function(SalesOfficeAssignmentsInputDtoBuilder)? updates]) =>
      (SalesOfficeAssignmentsInputDtoBuilder()..update(updates))._build();

  _$SalesOfficeAssignmentsInputDto._(
      {required this.version, required this.employeeIds})
      : super._();
  @override
  SalesOfficeAssignmentsInputDto rebuild(
          void Function(SalesOfficeAssignmentsInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeAssignmentsInputDtoBuilder toBuilder() =>
      SalesOfficeAssignmentsInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeAssignmentsInputDto &&
        version == other.version &&
        employeeIds == other.employeeIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, employeeIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesOfficeAssignmentsInputDto')
          ..add('version', version)
          ..add('employeeIds', employeeIds))
        .toString();
  }
}

class SalesOfficeAssignmentsInputDtoBuilder
    implements
        Builder<SalesOfficeAssignmentsInputDto,
            SalesOfficeAssignmentsInputDtoBuilder> {
  _$SalesOfficeAssignmentsInputDto? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ListBuilder<String>? _employeeIds;
  ListBuilder<String> get employeeIds =>
      _$this._employeeIds ??= ListBuilder<String>();
  set employeeIds(ListBuilder<String>? employeeIds) =>
      _$this._employeeIds = employeeIds;

  SalesOfficeAssignmentsInputDtoBuilder() {
    SalesOfficeAssignmentsInputDto._defaults(this);
  }

  SalesOfficeAssignmentsInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _employeeIds = $v.employeeIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeAssignmentsInputDto other) {
    _$v = other as _$SalesOfficeAssignmentsInputDto;
  }

  @override
  void update(void Function(SalesOfficeAssignmentsInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeAssignmentsInputDto build() => _build();

  _$SalesOfficeAssignmentsInputDto _build() {
    _$SalesOfficeAssignmentsInputDto _$result;
    try {
      _$result = _$v ??
          _$SalesOfficeAssignmentsInputDto._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'SalesOfficeAssignmentsInputDto', 'version'),
            employeeIds: employeeIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'employeeIds';
        employeeIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalesOfficeAssignmentsInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
