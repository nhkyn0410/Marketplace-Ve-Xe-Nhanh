// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_remove_vehicle_image_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRemoveVehicleImageInputDto
    extends AdminRemoveVehicleImageInputDto {
  @override
  final String reason;

  factory _$AdminRemoveVehicleImageInputDto(
          [void Function(AdminRemoveVehicleImageInputDtoBuilder)? updates]) =>
      (AdminRemoveVehicleImageInputDtoBuilder()..update(updates))._build();

  _$AdminRemoveVehicleImageInputDto._({required this.reason}) : super._();
  @override
  AdminRemoveVehicleImageInputDto rebuild(
          void Function(AdminRemoveVehicleImageInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRemoveVehicleImageInputDtoBuilder toBuilder() =>
      AdminRemoveVehicleImageInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRemoveVehicleImageInputDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'AdminRemoveVehicleImageInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class AdminRemoveVehicleImageInputDtoBuilder
    implements
        Builder<AdminRemoveVehicleImageInputDto,
            AdminRemoveVehicleImageInputDtoBuilder> {
  _$AdminRemoveVehicleImageInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRemoveVehicleImageInputDtoBuilder() {
    AdminRemoveVehicleImageInputDto._defaults(this);
  }

  AdminRemoveVehicleImageInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRemoveVehicleImageInputDto other) {
    _$v = other as _$AdminRemoveVehicleImageInputDto;
  }

  @override
  void update(void Function(AdminRemoveVehicleImageInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRemoveVehicleImageInputDto build() => _build();

  _$AdminRemoveVehicleImageInputDto _build() {
    final _$result = _$v ??
        _$AdminRemoveVehicleImageInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminRemoveVehicleImageInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
