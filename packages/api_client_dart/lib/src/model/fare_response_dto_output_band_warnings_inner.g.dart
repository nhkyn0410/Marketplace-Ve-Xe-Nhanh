// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_response_dto_output_band_warnings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FareResponseDtoOutputBandWarningsInner
    extends FareResponseDtoOutputBandWarningsInner {
  @override
  final int ruleIndex;
  @override
  final int price;
  @override
  final String bandId;
  @override
  final String bandName;
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

  factory _$FareResponseDtoOutputBandWarningsInner(
          [void Function(FareResponseDtoOutputBandWarningsInnerBuilder)?
              updates]) =>
      (FareResponseDtoOutputBandWarningsInnerBuilder()..update(updates))
          ._build();

  _$FareResponseDtoOutputBandWarningsInner._(
      {required this.ruleIndex,
      required this.price,
      required this.bandId,
      required this.bandName,
      this.minPrice,
      this.maxPrice,
      required this.effectiveFrom,
      required this.effectiveTo,
      required this.message})
      : super._();
  @override
  FareResponseDtoOutputBandWarningsInner rebuild(
          void Function(FareResponseDtoOutputBandWarningsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FareResponseDtoOutputBandWarningsInnerBuilder toBuilder() =>
      FareResponseDtoOutputBandWarningsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FareResponseDtoOutputBandWarningsInner &&
        ruleIndex == other.ruleIndex &&
        price == other.price &&
        bandId == other.bandId &&
        bandName == other.bandName &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ruleIndex.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, bandId.hashCode);
    _$hash = $jc(_$hash, bandName.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, maxPrice.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'FareResponseDtoOutputBandWarningsInner')
          ..add('ruleIndex', ruleIndex)
          ..add('price', price)
          ..add('bandId', bandId)
          ..add('bandName', bandName)
          ..add('minPrice', minPrice)
          ..add('maxPrice', maxPrice)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('message', message))
        .toString();
  }
}

class FareResponseDtoOutputBandWarningsInnerBuilder
    implements
        Builder<FareResponseDtoOutputBandWarningsInner,
            FareResponseDtoOutputBandWarningsInnerBuilder> {
  _$FareResponseDtoOutputBandWarningsInner? _$v;

  int? _ruleIndex;
  int? get ruleIndex => _$this._ruleIndex;
  set ruleIndex(int? ruleIndex) => _$this._ruleIndex = ruleIndex;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  String? _bandId;
  String? get bandId => _$this._bandId;
  set bandId(String? bandId) => _$this._bandId = bandId;

  String? _bandName;
  String? get bandName => _$this._bandName;
  set bandName(String? bandName) => _$this._bandName = bandName;

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

  FareResponseDtoOutputBandWarningsInnerBuilder() {
    FareResponseDtoOutputBandWarningsInner._defaults(this);
  }

  FareResponseDtoOutputBandWarningsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ruleIndex = $v.ruleIndex;
      _price = $v.price;
      _bandId = $v.bandId;
      _bandName = $v.bandName;
      _minPrice = $v.minPrice;
      _maxPrice = $v.maxPrice;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FareResponseDtoOutputBandWarningsInner other) {
    _$v = other as _$FareResponseDtoOutputBandWarningsInner;
  }

  @override
  void update(
      void Function(FareResponseDtoOutputBandWarningsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FareResponseDtoOutputBandWarningsInner build() => _build();

  _$FareResponseDtoOutputBandWarningsInner _build() {
    final _$result = _$v ??
        _$FareResponseDtoOutputBandWarningsInner._(
          ruleIndex: BuiltValueNullFieldError.checkNotNull(ruleIndex,
              r'FareResponseDtoOutputBandWarningsInner', 'ruleIndex'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'FareResponseDtoOutputBandWarningsInner', 'price'),
          bandId: BuiltValueNullFieldError.checkNotNull(
              bandId, r'FareResponseDtoOutputBandWarningsInner', 'bandId'),
          bandName: BuiltValueNullFieldError.checkNotNull(
              bandName, r'FareResponseDtoOutputBandWarningsInner', 'bandName'),
          minPrice: minPrice,
          maxPrice: maxPrice,
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(effectiveFrom,
              r'FareResponseDtoOutputBandWarningsInner', 'effectiveFrom'),
          effectiveTo: BuiltValueNullFieldError.checkNotNull(effectiveTo,
              r'FareResponseDtoOutputBandWarningsInner', 'effectiveTo'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'FareResponseDtoOutputBandWarningsInner', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
