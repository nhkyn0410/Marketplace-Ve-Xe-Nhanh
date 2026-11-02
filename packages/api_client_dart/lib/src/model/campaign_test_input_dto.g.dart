// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_test_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignTestInputDto extends CampaignTestInputDto {
  @override
  final String email;

  factory _$CampaignTestInputDto(
          [void Function(CampaignTestInputDtoBuilder)? updates]) =>
      (CampaignTestInputDtoBuilder()..update(updates))._build();

  _$CampaignTestInputDto._({required this.email}) : super._();
  @override
  CampaignTestInputDto rebuild(
          void Function(CampaignTestInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignTestInputDtoBuilder toBuilder() =>
      CampaignTestInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignTestInputDto && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignTestInputDto')
          ..add('email', email))
        .toString();
  }
}

class CampaignTestInputDtoBuilder
    implements Builder<CampaignTestInputDto, CampaignTestInputDtoBuilder> {
  _$CampaignTestInputDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CampaignTestInputDtoBuilder() {
    CampaignTestInputDto._defaults(this);
  }

  CampaignTestInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignTestInputDto other) {
    _$v = other as _$CampaignTestInputDto;
  }

  @override
  void update(void Function(CampaignTestInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignTestInputDto build() => _build();

  _$CampaignTestInputDto _build() {
    final _$result = _$v ??
        _$CampaignTestInputDto._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CampaignTestInputDto', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
