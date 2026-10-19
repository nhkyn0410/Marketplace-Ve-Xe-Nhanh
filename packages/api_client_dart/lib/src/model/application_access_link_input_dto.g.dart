// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_access_link_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApplicationAccessLinkInputDto extends ApplicationAccessLinkInputDto {
  @override
  final String contactEmail;
  @override
  final String applicationCode;

  factory _$ApplicationAccessLinkInputDto(
          [void Function(ApplicationAccessLinkInputDtoBuilder)? updates]) =>
      (ApplicationAccessLinkInputDtoBuilder()..update(updates))._build();

  _$ApplicationAccessLinkInputDto._(
      {required this.contactEmail, required this.applicationCode})
      : super._();
  @override
  ApplicationAccessLinkInputDto rebuild(
          void Function(ApplicationAccessLinkInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationAccessLinkInputDtoBuilder toBuilder() =>
      ApplicationAccessLinkInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationAccessLinkInputDto &&
        contactEmail == other.contactEmail &&
        applicationCode == other.applicationCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApplicationAccessLinkInputDto')
          ..add('contactEmail', contactEmail)
          ..add('applicationCode', applicationCode))
        .toString();
  }
}

class ApplicationAccessLinkInputDtoBuilder
    implements
        Builder<ApplicationAccessLinkInputDto,
            ApplicationAccessLinkInputDtoBuilder> {
  _$ApplicationAccessLinkInputDto? _$v;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  ApplicationAccessLinkInputDtoBuilder() {
    ApplicationAccessLinkInputDto._defaults(this);
  }

  ApplicationAccessLinkInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEmail = $v.contactEmail;
      _applicationCode = $v.applicationCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationAccessLinkInputDto other) {
    _$v = other as _$ApplicationAccessLinkInputDto;
  }

  @override
  void update(void Function(ApplicationAccessLinkInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationAccessLinkInputDto build() => _build();

  _$ApplicationAccessLinkInputDto _build() {
    final _$result = _$v ??
        _$ApplicationAccessLinkInputDto._(
          contactEmail: BuiltValueNullFieldError.checkNotNull(
              contactEmail, r'ApplicationAccessLinkInputDto', 'contactEmail'),
          applicationCode: BuiltValueNullFieldError.checkNotNull(
              applicationCode,
              r'ApplicationAccessLinkInputDto',
              'applicationCode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
