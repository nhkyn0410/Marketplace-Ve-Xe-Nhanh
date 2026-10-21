// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FareBandCreateDto extends FareBandCreateDto {
  @override
  final String name;
  @override
  final int? minPrice;
  @override
  final int? maxPrice;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime effectiveTo;
  @override
  final String message;
  @override
  final String reason;

  factory _$FareBandCreateDto(
          [void Function(FareBandCreateDtoBuilder)? updates]) =>
      (FareBandCreateDtoBuilder()..update(updates))._build();

  _$FareBandCreateDto._(
      {required this.name,
      this.minPrice,
      this.maxPrice,
      required this.effectiveFrom,
      required this.effectiveTo,
      required this.message,
      required this.reason})
      : super._();
  @override
  FareBandCreateDto rebuild(void Function(FareBandCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FareBandCreateDtoBuilder toBuilder() =>
      FareBandCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FareBandCreateDto &&
        name == other.name &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        message == other.message &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, maxPrice.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FareBandCreateDto')
          ..add('name', name)
          ..add('minPrice', minPrice)
          ..add('maxPrice', maxPrice)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('message', message)
          ..add('reason', reason))
        .toString();
  }
}

class FareBandCreateDtoBuilder
    implements Builder<FareBandCreateDto, FareBandCreateDtoBuilder> {
  _$FareBandCreateDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minPrice;
  int? get minPrice => _$this._minPrice;
  set minPrice(int? minPrice) => _$this._minPrice = minPrice;

  int? _maxPrice;
  int? get maxPrice => _$this._maxPrice;
  set maxPrice(int? maxPrice) => _$this._maxPrice = maxPrice;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  DateTime? _effectiveTo;
  DateTime? get effectiveTo => _$this._effectiveTo;
  set effectiveTo(DateTime? effectiveTo) => _$this._effectiveTo = effectiveTo;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  FareBandCreateDtoBuilder() {
    FareBandCreateDto._defaults(this);
  }

  FareBandCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _minPrice = $v.minPrice;
      _maxPrice = $v.maxPrice;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _message = $v.message;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FareBandCreateDto other) {
    _$v = other as _$FareBandCreateDto;
  }

  @override
  void update(void Function(FareBandCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FareBandCreateDto build() => _build();

  _$FareBandCreateDto _build() {
    final _$result = _$v ??
        _$FareBandCreateDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FareBandCreateDto', 'name'),
          minPrice: minPrice,
          maxPrice: maxPrice,
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'FareBandCreateDto', 'effectiveFrom'),
          effectiveTo: BuiltValueNullFieldError.checkNotNull(
              effectiveTo, r'FareBandCreateDto', 'effectiveTo'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'FareBandCreateDto', 'message'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FareBandCreateDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
