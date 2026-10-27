// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_check_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionCheckInputDto extends PromotionCheckInputDto {
  @override
  final String tripId;
  @override
  final String? code;
  @override
  final String? userVoucherId;
  @override
  final int subtotal;

  factory _$PromotionCheckInputDto(
          [void Function(PromotionCheckInputDtoBuilder)? updates]) =>
      (PromotionCheckInputDtoBuilder()..update(updates))._build();

  _$PromotionCheckInputDto._(
      {required this.tripId,
      this.code,
      this.userVoucherId,
      required this.subtotal})
      : super._();
  @override
  PromotionCheckInputDto rebuild(
          void Function(PromotionCheckInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionCheckInputDtoBuilder toBuilder() =>
      PromotionCheckInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionCheckInputDto &&
        tripId == other.tripId &&
        code == other.code &&
        userVoucherId == other.userVoucherId &&
        subtotal == other.subtotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, userVoucherId.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionCheckInputDto')
          ..add('tripId', tripId)
          ..add('code', code)
          ..add('userVoucherId', userVoucherId)
          ..add('subtotal', subtotal))
        .toString();
  }
}

class PromotionCheckInputDtoBuilder
    implements Builder<PromotionCheckInputDto, PromotionCheckInputDtoBuilder> {
  _$PromotionCheckInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _userVoucherId;
  String? get userVoucherId => _$this._userVoucherId;
  set userVoucherId(String? userVoucherId) =>
      _$this._userVoucherId = userVoucherId;

  int? _subtotal;
  int? get subtotal => _$this._subtotal;
  set subtotal(int? subtotal) => _$this._subtotal = subtotal;

  PromotionCheckInputDtoBuilder() {
    PromotionCheckInputDto._defaults(this);
  }

  PromotionCheckInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _code = $v.code;
      _userVoucherId = $v.userVoucherId;
      _subtotal = $v.subtotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionCheckInputDto other) {
    _$v = other as _$PromotionCheckInputDto;
  }

  @override
  void update(void Function(PromotionCheckInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionCheckInputDto build() => _build();

  _$PromotionCheckInputDto _build() {
    final _$result = _$v ??
        _$PromotionCheckInputDto._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'PromotionCheckInputDto', 'tripId'),
          code: code,
          userVoucherId: userVoucherId,
          subtotal: BuiltValueNullFieldError.checkNotNull(
              subtotal, r'PromotionCheckInputDto', 'subtotal'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
