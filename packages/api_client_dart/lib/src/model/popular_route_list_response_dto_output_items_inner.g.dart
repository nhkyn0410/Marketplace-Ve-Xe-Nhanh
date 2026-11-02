// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_route_list_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PopularRouteListResponseDtoOutputItemsInner
    extends PopularRouteListResponseDtoOutputItemsInner {
  @override
  final String originProvinceId;
  @override
  final String originName;
  @override
  final String destinationProvinceId;
  @override
  final String destinationName;
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final int? minPrice;
  @override
  final BuiltList<String> vehicleTypeNames;
  @override
  final DateTime? nextDepartureAt;
  @override
  final int operatorCount;
  @override
  final num? averageRating;
  @override
  final int reviewCount;

  factory _$PopularRouteListResponseDtoOutputItemsInner(
          [void Function(PopularRouteListResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PopularRouteListResponseDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PopularRouteListResponseDtoOutputItemsInner._(
      {required this.originProvinceId,
      required this.originName,
      required this.destinationProvinceId,
      required this.destinationName,
      required this.distanceMeters,
      required this.durationSeconds,
      this.minPrice,
      required this.vehicleTypeNames,
      this.nextDepartureAt,
      required this.operatorCount,
      this.averageRating,
      required this.reviewCount})
      : super._();
  @override
  PopularRouteListResponseDtoOutputItemsInner rebuild(
          void Function(PopularRouteListResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PopularRouteListResponseDtoOutputItemsInnerBuilder toBuilder() =>
      PopularRouteListResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PopularRouteListResponseDtoOutputItemsInner &&
        originProvinceId == other.originProvinceId &&
        originName == other.originName &&
        destinationProvinceId == other.destinationProvinceId &&
        destinationName == other.destinationName &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        minPrice == other.minPrice &&
        vehicleTypeNames == other.vehicleTypeNames &&
        nextDepartureAt == other.nextDepartureAt &&
        operatorCount == other.operatorCount &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, originProvinceId.hashCode);
    _$hash = $jc(_$hash, originName.hashCode);
    _$hash = $jc(_$hash, destinationProvinceId.hashCode);
    _$hash = $jc(_$hash, destinationName.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, vehicleTypeNames.hashCode);
    _$hash = $jc(_$hash, nextDepartureAt.hashCode);
    _$hash = $jc(_$hash, operatorCount.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PopularRouteListResponseDtoOutputItemsInner')
          ..add('originProvinceId', originProvinceId)
          ..add('originName', originName)
          ..add('destinationProvinceId', destinationProvinceId)
          ..add('destinationName', destinationName)
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('minPrice', minPrice)
          ..add('vehicleTypeNames', vehicleTypeNames)
          ..add('nextDepartureAt', nextDepartureAt)
          ..add('operatorCount', operatorCount)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount))
        .toString();
  }
}

class PopularRouteListResponseDtoOutputItemsInnerBuilder
    implements
        Builder<PopularRouteListResponseDtoOutputItemsInner,
            PopularRouteListResponseDtoOutputItemsInnerBuilder> {
  _$PopularRouteListResponseDtoOutputItemsInner? _$v;

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

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  int? _minPrice;
  int? get minPrice => _$this._minPrice;
  set minPrice(int? minPrice) => _$this._minPrice = minPrice;

  ListBuilder<String>? _vehicleTypeNames;
  ListBuilder<String> get vehicleTypeNames =>
      _$this._vehicleTypeNames ??= ListBuilder<String>();
  set vehicleTypeNames(ListBuilder<String>? vehicleTypeNames) =>
      _$this._vehicleTypeNames = vehicleTypeNames;

  DateTime? _nextDepartureAt;
  DateTime? get nextDepartureAt => _$this._nextDepartureAt;
  set nextDepartureAt(DateTime? nextDepartureAt) =>
      _$this._nextDepartureAt = nextDepartureAt;

  int? _operatorCount;
  int? get operatorCount => _$this._operatorCount;
  set operatorCount(int? operatorCount) =>
      _$this._operatorCount = operatorCount;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  PopularRouteListResponseDtoOutputItemsInnerBuilder() {
    PopularRouteListResponseDtoOutputItemsInner._defaults(this);
  }

  PopularRouteListResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _originProvinceId = $v.originProvinceId;
      _originName = $v.originName;
      _destinationProvinceId = $v.destinationProvinceId;
      _destinationName = $v.destinationName;
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _minPrice = $v.minPrice;
      _vehicleTypeNames = $v.vehicleTypeNames.toBuilder();
      _nextDepartureAt = $v.nextDepartureAt;
      _operatorCount = $v.operatorCount;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PopularRouteListResponseDtoOutputItemsInner other) {
    _$v = other as _$PopularRouteListResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PopularRouteListResponseDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PopularRouteListResponseDtoOutputItemsInner build() => _build();

  _$PopularRouteListResponseDtoOutputItemsInner _build() {
    _$PopularRouteListResponseDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$PopularRouteListResponseDtoOutputItemsInner._(
            originProvinceId: BuiltValueNullFieldError.checkNotNull(
                originProvinceId,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'originProvinceId'),
            originName: BuiltValueNullFieldError.checkNotNull(originName,
                r'PopularRouteListResponseDtoOutputItemsInner', 'originName'),
            destinationProvinceId: BuiltValueNullFieldError.checkNotNull(
                destinationProvinceId,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'destinationProvinceId'),
            destinationName: BuiltValueNullFieldError.checkNotNull(
                destinationName,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'destinationName'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'distanceMeters'),
            durationSeconds: BuiltValueNullFieldError.checkNotNull(
                durationSeconds,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'durationSeconds'),
            minPrice: minPrice,
            vehicleTypeNames: vehicleTypeNames.build(),
            nextDepartureAt: nextDepartureAt,
            operatorCount: BuiltValueNullFieldError.checkNotNull(
                operatorCount,
                r'PopularRouteListResponseDtoOutputItemsInner',
                'operatorCount'),
            averageRating: averageRating,
            reviewCount: BuiltValueNullFieldError.checkNotNull(reviewCount,
                r'PopularRouteListResponseDtoOutputItemsInner', 'reviewCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicleTypeNames';
        vehicleTypeNames.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PopularRouteListResponseDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
