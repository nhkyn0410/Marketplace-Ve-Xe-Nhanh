// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRoutePageDtoOutputItemsInnerStatusEnum
    _$adminRoutePageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminRoutePageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminRoutePageDtoOutputItemsInnerStatusEnum
    _$adminRoutePageDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminRoutePageDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminRoutePageDtoOutputItemsInnerStatusEnum
    _$adminRoutePageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminRoutePageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminRoutePageDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRoutePageDtoOutputItemsInnerStatusEnum>
    _$adminRoutePageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminRoutePageDtoOutputItemsInnerStatusEnum>(const <AdminRoutePageDtoOutputItemsInnerStatusEnum>[
  _$adminRoutePageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminRoutePageDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminRoutePageDtoOutputItemsInnerStatusEnum>
    _$adminRoutePageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminRoutePageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminRoutePageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminRoutePageDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRoutePageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminRoutePageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminRoutePageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRoutePageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRoutePageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRoutePageDtoOutputItemsInner
    extends AdminRoutePageDtoOutputItemsInner {
  @override
  final int trips;
  @override
  final int completedTrips;
  @override
  final int cancelledTrips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int? ticketRevenue;
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminRoutePageDtoOutputItemsInnerStatusEnum status;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final AdminRoutePageDtoOutputItemsInnerOrigin? origin;
  @override
  final AdminRoutePageDtoOutputItemsInnerOrigin? destination;
  @override
  final int stopCount;
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final int upcomingTrips;
  @override
  final num? averageRating;
  @override
  final int reviewCount;

  factory _$AdminRoutePageDtoOutputItemsInner(
          [void Function(AdminRoutePageDtoOutputItemsInnerBuilder)? updates]) =>
      (AdminRoutePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminRoutePageDtoOutputItemsInner._(
      {required this.trips,
      required this.completedTrips,
      required this.cancelledTrips,
      required this.seats,
      required this.ticketsSold,
      this.ticketRevenue,
      required this.id,
      required this.name,
      required this.status,
      required this.operatorId,
      required this.operatorName,
      this.origin,
      this.destination,
      required this.stopCount,
      required this.distanceMeters,
      required this.durationSeconds,
      required this.upcomingTrips,
      this.averageRating,
      required this.reviewCount})
      : super._();
  @override
  AdminRoutePageDtoOutputItemsInner rebuild(
          void Function(AdminRoutePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRoutePageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminRoutePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRoutePageDtoOutputItemsInner &&
        trips == other.trips &&
        completedTrips == other.completedTrips &&
        cancelledTrips == other.cancelledTrips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        ticketRevenue == other.ticketRevenue &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        origin == other.origin &&
        destination == other.destination &&
        stopCount == other.stopCount &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        upcomingTrips == other.upcomingTrips &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, cancelledTrips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, ticketRevenue.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, stopCount.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, upcomingTrips.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRoutePageDtoOutputItemsInner')
          ..add('trips', trips)
          ..add('completedTrips', completedTrips)
          ..add('cancelledTrips', cancelledTrips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('ticketRevenue', ticketRevenue)
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('origin', origin)
          ..add('destination', destination)
          ..add('stopCount', stopCount)
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('upcomingTrips', upcomingTrips)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount))
        .toString();
  }
}

class AdminRoutePageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminRoutePageDtoOutputItemsInner,
            AdminRoutePageDtoOutputItemsInnerBuilder> {
  _$AdminRoutePageDtoOutputItemsInner? _$v;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  int? _cancelledTrips;
  int? get cancelledTrips => _$this._cancelledTrips;
  set cancelledTrips(int? cancelledTrips) =>
      _$this._cancelledTrips = cancelledTrips;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _ticketRevenue;
  int? get ticketRevenue => _$this._ticketRevenue;
  set ticketRevenue(int? ticketRevenue) =>
      _$this._ticketRevenue = ticketRevenue;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRoutePageDtoOutputItemsInnerStatusEnum? _status;
  AdminRoutePageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminRoutePageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  AdminRoutePageDtoOutputItemsInnerOriginBuilder? _origin;
  AdminRoutePageDtoOutputItemsInnerOriginBuilder get origin =>
      _$this._origin ??= AdminRoutePageDtoOutputItemsInnerOriginBuilder();
  set origin(AdminRoutePageDtoOutputItemsInnerOriginBuilder? origin) =>
      _$this._origin = origin;

  AdminRoutePageDtoOutputItemsInnerOriginBuilder? _destination;
  AdminRoutePageDtoOutputItemsInnerOriginBuilder get destination =>
      _$this._destination ??= AdminRoutePageDtoOutputItemsInnerOriginBuilder();
  set destination(
          AdminRoutePageDtoOutputItemsInnerOriginBuilder? destination) =>
      _$this._destination = destination;

  int? _stopCount;
  int? get stopCount => _$this._stopCount;
  set stopCount(int? stopCount) => _$this._stopCount = stopCount;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  int? _upcomingTrips;
  int? get upcomingTrips => _$this._upcomingTrips;
  set upcomingTrips(int? upcomingTrips) =>
      _$this._upcomingTrips = upcomingTrips;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  AdminRoutePageDtoOutputItemsInnerBuilder() {
    AdminRoutePageDtoOutputItemsInner._defaults(this);
  }

  AdminRoutePageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trips = $v.trips;
      _completedTrips = $v.completedTrips;
      _cancelledTrips = $v.cancelledTrips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _ticketRevenue = $v.ticketRevenue;
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _origin = $v.origin?.toBuilder();
      _destination = $v.destination?.toBuilder();
      _stopCount = $v.stopCount;
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _upcomingTrips = $v.upcomingTrips;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRoutePageDtoOutputItemsInner other) {
    _$v = other as _$AdminRoutePageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminRoutePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRoutePageDtoOutputItemsInner build() => _build();

  _$AdminRoutePageDtoOutputItemsInner _build() {
    _$AdminRoutePageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminRoutePageDtoOutputItemsInner._(
            trips: BuiltValueNullFieldError.checkNotNull(
                trips, r'AdminRoutePageDtoOutputItemsInner', 'trips'),
            completedTrips: BuiltValueNullFieldError.checkNotNull(
                completedTrips,
                r'AdminRoutePageDtoOutputItemsInner',
                'completedTrips'),
            cancelledTrips: BuiltValueNullFieldError.checkNotNull(
                cancelledTrips,
                r'AdminRoutePageDtoOutputItemsInner',
                'cancelledTrips'),
            seats: BuiltValueNullFieldError.checkNotNull(
                seats, r'AdminRoutePageDtoOutputItemsInner', 'seats'),
            ticketsSold: BuiltValueNullFieldError.checkNotNull(ticketsSold,
                r'AdminRoutePageDtoOutputItemsInner', 'ticketsSold'),
            ticketRevenue: ticketRevenue,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminRoutePageDtoOutputItemsInner', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminRoutePageDtoOutputItemsInner', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminRoutePageDtoOutputItemsInner', 'status'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'AdminRoutePageDtoOutputItemsInner', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
                r'AdminRoutePageDtoOutputItemsInner', 'operatorName'),
            origin: _origin?.build(),
            destination: _destination?.build(),
            stopCount: BuiltValueNullFieldError.checkNotNull(
                stopCount, r'AdminRoutePageDtoOutputItemsInner', 'stopCount'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters,
                r'AdminRoutePageDtoOutputItemsInner',
                'distanceMeters'),
            durationSeconds: BuiltValueNullFieldError.checkNotNull(
                durationSeconds,
                r'AdminRoutePageDtoOutputItemsInner',
                'durationSeconds'),
            upcomingTrips: BuiltValueNullFieldError.checkNotNull(upcomingTrips,
                r'AdminRoutePageDtoOutputItemsInner', 'upcomingTrips'),
            averageRating: averageRating,
            reviewCount: BuiltValueNullFieldError.checkNotNull(reviewCount,
                r'AdminRoutePageDtoOutputItemsInner', 'reviewCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'origin';
        _origin?.build();
        _$failedField = 'destination';
        _destination?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminRoutePageDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
