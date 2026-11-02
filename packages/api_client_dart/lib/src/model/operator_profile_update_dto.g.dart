// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_profile_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorProfileUpdateDto extends OperatorProfileUpdateDto {
  @override
  final String displayName;
  @override
  final String hotline;
  @override
  final String publicEmail;
  @override
  final String address;
  @override
  final String? description;

  factory _$OperatorProfileUpdateDto(
          [void Function(OperatorProfileUpdateDtoBuilder)? updates]) =>
      (OperatorProfileUpdateDtoBuilder()..update(updates))._build();

  _$OperatorProfileUpdateDto._(
      {required this.displayName,
      required this.hotline,
      required this.publicEmail,
      required this.address,
      this.description})
      : super._();
  @override
  OperatorProfileUpdateDto rebuild(
          void Function(OperatorProfileUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorProfileUpdateDtoBuilder toBuilder() =>
      OperatorProfileUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorProfileUpdateDto &&
        displayName == other.displayName &&
        hotline == other.hotline &&
        publicEmail == other.publicEmail &&
        address == other.address &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorProfileUpdateDto')
          ..add('displayName', displayName)
          ..add('hotline', hotline)
          ..add('publicEmail', publicEmail)
          ..add('address', address)
          ..add('description', description))
        .toString();
  }
}

class OperatorProfileUpdateDtoBuilder
    implements
        Builder<OperatorProfileUpdateDto, OperatorProfileUpdateDtoBuilder> {
  _$OperatorProfileUpdateDto? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  OperatorProfileUpdateDtoBuilder() {
    OperatorProfileUpdateDto._defaults(this);
  }

  OperatorProfileUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _hotline = $v.hotline;
      _publicEmail = $v.publicEmail;
      _address = $v.address;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorProfileUpdateDto other) {
    _$v = other as _$OperatorProfileUpdateDto;
  }

  @override
  void update(void Function(OperatorProfileUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorProfileUpdateDto build() => _build();

  _$OperatorProfileUpdateDto _build() {
    final _$result = _$v ??
        _$OperatorProfileUpdateDto._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'OperatorProfileUpdateDto', 'displayName'),
          hotline: BuiltValueNullFieldError.checkNotNull(
              hotline, r'OperatorProfileUpdateDto', 'hotline'),
          publicEmail: BuiltValueNullFieldError.checkNotNull(
              publicEmail, r'OperatorProfileUpdateDto', 'publicEmail'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'OperatorProfileUpdateDto', 'address'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
