// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stop_point_proposal_list_dto_output_items_inner_nearby_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner
    extends AdminStopPointProposalListDtoOutputItemsInnerNearbyInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final int distanceMeters;
  @override
  final int routeCount;

  factory _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner(
          [void Function(
                  AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder)?
              updates]) =>
      (AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner._(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.distanceMeters,
      required this.routeCount})
      : super._();
  @override
  AdminStopPointProposalListDtoOutputItemsInnerNearbyInner rebuild(
          void Function(
                  AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder toBuilder() =>
      AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStopPointProposalListDtoOutputItemsInnerNearbyInner &&
        id == other.id &&
        name == other.name &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        distanceMeters == other.distanceMeters &&
        routeCount == other.routeCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, routeCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner')
          ..add('id', id)
          ..add('name', name)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('distanceMeters', distanceMeters)
          ..add('routeCount', routeCount))
        .toString();
  }
}

class AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder
    implements
        Builder<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner,
            AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder> {
  _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _routeCount;
  int? get routeCount => _$this._routeCount;
  set routeCount(int? routeCount) => _$this._routeCount = routeCount;

  AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder() {
    AdminStopPointProposalListDtoOutputItemsInnerNearbyInner._defaults(this);
  }

  AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _distanceMeters = $v.distanceMeters;
      _routeCount = $v.routeCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStopPointProposalListDtoOutputItemsInnerNearbyInner other) {
    _$v = other as _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner;
  }

  @override
  void update(
      void Function(
              AdminStopPointProposalListDtoOutputItemsInnerNearbyInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStopPointProposalListDtoOutputItemsInnerNearbyInner build() => _build();

  _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner _build() {
    final _$result = _$v ??
        _$AdminStopPointProposalListDtoOutputItemsInnerNearbyInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'name'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'longitude'),
          distanceMeters: BuiltValueNullFieldError.checkNotNull(
              distanceMeters,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'distanceMeters'),
          routeCount: BuiltValueNullFieldError.checkNotNull(
              routeCount,
              r'AdminStopPointProposalListDtoOutputItemsInnerNearbyInner',
              'routeCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
