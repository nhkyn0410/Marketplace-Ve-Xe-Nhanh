// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_redemption_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoyaltyRedemptionInputDto extends LoyaltyRedemptionInputDto {
  @override
  final int points;

  factory _$LoyaltyRedemptionInputDto(
          [void Function(LoyaltyRedemptionInputDtoBuilder)? updates]) =>
      (LoyaltyRedemptionInputDtoBuilder()..update(updates))._build();

  _$LoyaltyRedemptionInputDto._({required this.points}) : super._();
  @override
  LoyaltyRedemptionInputDto rebuild(
          void Function(LoyaltyRedemptionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyRedemptionInputDtoBuilder toBuilder() =>
      LoyaltyRedemptionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyRedemptionInputDto && points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyRedemptionInputDto')
          ..add('points', points))
        .toString();
  }
}

class LoyaltyRedemptionInputDtoBuilder
    implements
        Builder<LoyaltyRedemptionInputDto, LoyaltyRedemptionInputDtoBuilder> {
  _$LoyaltyRedemptionInputDto? _$v;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  LoyaltyRedemptionInputDtoBuilder() {
    LoyaltyRedemptionInputDto._defaults(this);
  }

  LoyaltyRedemptionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _points = $v.points;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyRedemptionInputDto other) {
    _$v = other as _$LoyaltyRedemptionInputDto;
  }

  @override
  void update(void Function(LoyaltyRedemptionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyRedemptionInputDto build() => _build();

  _$LoyaltyRedemptionInputDto _build() {
    final _$result = _$v ??
        _$LoyaltyRedemptionInputDto._(
          points: BuiltValueNullFieldError.checkNotNull(
              points, r'LoyaltyRedemptionInputDto', 'points'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
