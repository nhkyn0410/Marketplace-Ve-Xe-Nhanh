// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_voucher_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveVoucherInputDto extends SaveVoucherInputDto {
  @override
  final String promotionCode;

  factory _$SaveVoucherInputDto(
          [void Function(SaveVoucherInputDtoBuilder)? updates]) =>
      (SaveVoucherInputDtoBuilder()..update(updates))._build();

  _$SaveVoucherInputDto._({required this.promotionCode}) : super._();
  @override
  SaveVoucherInputDto rebuild(
          void Function(SaveVoucherInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveVoucherInputDtoBuilder toBuilder() =>
      SaveVoucherInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveVoucherInputDto && promotionCode == other.promotionCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, promotionCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveVoucherInputDto')
          ..add('promotionCode', promotionCode))
        .toString();
  }
}

class SaveVoucherInputDtoBuilder
    implements Builder<SaveVoucherInputDto, SaveVoucherInputDtoBuilder> {
  _$SaveVoucherInputDto? _$v;

  String? _promotionCode;
  String? get promotionCode => _$this._promotionCode;
  set promotionCode(String? promotionCode) =>
      _$this._promotionCode = promotionCode;

  SaveVoucherInputDtoBuilder() {
    SaveVoucherInputDto._defaults(this);
  }

  SaveVoucherInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _promotionCode = $v.promotionCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveVoucherInputDto other) {
    _$v = other as _$SaveVoucherInputDto;
  }

  @override
  void update(void Function(SaveVoucherInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveVoucherInputDto build() => _build();

  _$SaveVoucherInputDto _build() {
    final _$result = _$v ??
        _$SaveVoucherInputDto._(
          promotionCode: BuiltValueNullFieldError.checkNotNull(
              promotionCode, r'SaveVoucherInputDto', 'promotionCode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
