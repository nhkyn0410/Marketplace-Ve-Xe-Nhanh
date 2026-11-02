// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_operator_list_response_dto_output_items_inner_routes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner
    extends FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner {
  @override
  final String originProvinceId;
  @override
  final String originName;
  @override
  final String destinationProvinceId;
  @override
  final String destinationName;

  factory _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner(
          [void Function(
                  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder)?
              updates]) =>
      (FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder()
            ..update(updates))
          ._build();

  _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner._(
      {required this.originProvinceId,
      required this.originName,
      required this.destinationProvinceId,
      required this.destinationName})
      : super._();
  @override
  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner rebuild(
          void Function(
                  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder
      toBuilder() =>
          FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner &&
        originProvinceId == other.originProvinceId &&
        originName == other.originName &&
        destinationProvinceId == other.destinationProvinceId &&
        destinationName == other.destinationName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, originProvinceId.hashCode);
    _$hash = $jc(_$hash, originName.hashCode);
    _$hash = $jc(_$hash, destinationProvinceId.hashCode);
    _$hash = $jc(_$hash, destinationName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner')
          ..add('originProvinceId', originProvinceId)
          ..add('originName', originName)
          ..add('destinationProvinceId', destinationProvinceId)
          ..add('destinationName', destinationName))
        .toString();
  }
}

class FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder
    implements
        Builder<FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner,
            FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder> {
  _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner? _$v;

  String? _originProvinceId;
  String? get originProvinceId => _$this._originProvinceId;
  set originProvinceId(String? originProvinceId) =>
      _$this._originProvinceId = originProvinceId;

  String? _originName;
  String? get originName => _$this._originName;
  set originName(String? originName) => _$this._originName = originName;

  String? _destinationProvinceId;
  String? get destinationProvinceId => _$this._destinationProvinceId;
  set destinationProvinceId(String? destinationProvinceId) =>
      _$this._destinationProvinceId = destinationProvinceId;

  String? _destinationName;
  String? get destinationName => _$this._destinationName;
  set destinationName(String? destinationName) =>
      _$this._destinationName = destinationName;

  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder() {
    FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner._defaults(this);
  }

  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _originProvinceId = $v.originProvinceId;
      _originName = $v.originName;
      _destinationProvinceId = $v.destinationProvinceId;
      _destinationName = $v.destinationName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner other) {
    _$v = other as _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner;
  }

  @override
  void update(
      void Function(
              FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner build() =>
      _build();

  _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner _build() {
    final _$result = _$v ??
        _$FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner._(
          originProvinceId: BuiltValueNullFieldError.checkNotNull(
              originProvinceId,
              r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner',
              'originProvinceId'),
          originName: BuiltValueNullFieldError.checkNotNull(
              originName,
              r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner',
              'originName'),
          destinationProvinceId: BuiltValueNullFieldError.checkNotNull(
              destinationProvinceId,
              r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner',
              'destinationProvinceId'),
          destinationName: BuiltValueNullFieldError.checkNotNull(
              destinationName,
              r'FeaturedOperatorListResponseDtoOutputItemsInnerRoutesInner',
              'destinationName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
