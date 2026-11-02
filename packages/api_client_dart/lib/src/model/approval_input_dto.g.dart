// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApprovalInputDto extends ApprovalInputDto {
  @override
  final String operatorSlug;
  @override
  final String ownerUsername;

  factory _$ApprovalInputDto(
          [void Function(ApprovalInputDtoBuilder)? updates]) =>
      (ApprovalInputDtoBuilder()..update(updates))._build();

  _$ApprovalInputDto._(
      {required this.operatorSlug, required this.ownerUsername})
      : super._();
  @override
  ApprovalInputDto rebuild(void Function(ApprovalInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApprovalInputDtoBuilder toBuilder() =>
      ApprovalInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalInputDto &&
        operatorSlug == other.operatorSlug &&
        ownerUsername == other.ownerUsername;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, ownerUsername.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApprovalInputDto')
          ..add('operatorSlug', operatorSlug)
          ..add('ownerUsername', ownerUsername))
        .toString();
  }
}

class ApprovalInputDtoBuilder
    implements Builder<ApprovalInputDto, ApprovalInputDtoBuilder> {
  _$ApprovalInputDto? _$v;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  String? _ownerUsername;
  String? get ownerUsername => _$this._ownerUsername;
  set ownerUsername(String? ownerUsername) =>
      _$this._ownerUsername = ownerUsername;

  ApprovalInputDtoBuilder() {
    ApprovalInputDto._defaults(this);
  }

  ApprovalInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorSlug = $v.operatorSlug;
      _ownerUsername = $v.ownerUsername;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalInputDto other) {
    _$v = other as _$ApprovalInputDto;
  }

  @override
  void update(void Function(ApprovalInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalInputDto build() => _build();

  _$ApprovalInputDto _build() {
    final _$result = _$v ??
        _$ApprovalInputDto._(
          operatorSlug: BuiltValueNullFieldError.checkNotNull(
              operatorSlug, r'ApprovalInputDto', 'operatorSlug'),
          ownerUsername: BuiltValueNullFieldError.checkNotNull(
              ownerUsername, r'ApprovalInputDto', 'ownerUsername'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
