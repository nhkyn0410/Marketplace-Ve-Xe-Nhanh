// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_suspend_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorSuspendDto extends AdminOperatorSuspendDto {
  @override
  final String reason;

  factory _$AdminOperatorSuspendDto(
          [void Function(AdminOperatorSuspendDtoBuilder)? updates]) =>
      (AdminOperatorSuspendDtoBuilder()..update(updates))._build();

  _$AdminOperatorSuspendDto._({required this.reason}) : super._();
  @override
  AdminOperatorSuspendDto rebuild(
          void Function(AdminOperatorSuspendDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorSuspendDtoBuilder toBuilder() =>
      AdminOperatorSuspendDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorSuspendDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'AdminOperatorSuspendDto')
          ..add('reason', reason))
        .toString();
  }
}

class AdminOperatorSuspendDtoBuilder
    implements
        Builder<AdminOperatorSuspendDto, AdminOperatorSuspendDtoBuilder> {
  _$AdminOperatorSuspendDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminOperatorSuspendDtoBuilder() {
    AdminOperatorSuspendDto._defaults(this);
  }

  AdminOperatorSuspendDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorSuspendDto other) {
    _$v = other as _$AdminOperatorSuspendDto;
  }

  @override
  void update(void Function(AdminOperatorSuspendDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorSuspendDto build() => _build();

  _$AdminOperatorSuspendDto _build() {
    final _$result = _$v ??
        _$AdminOperatorSuspendDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminOperatorSuspendDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
