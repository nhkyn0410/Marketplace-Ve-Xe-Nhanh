// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_by_operator_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutputByOperatorInner
    extends AdminReportDtoOutputByOperatorInner {
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final int trips;
  @override
  final int ticketsSold;
  @override
  final int seats;
  @override
  final int gmv;
  @override
  final int refunded;
  @override
  final num? averageRating;
  @override
  final int reviewCount;

  factory _$AdminReportDtoOutputByOperatorInner(
          [void Function(AdminReportDtoOutputByOperatorInnerBuilder)?
              updates]) =>
      (AdminReportDtoOutputByOperatorInnerBuilder()..update(updates))._build();

  _$AdminReportDtoOutputByOperatorInner._(
      {required this.operatorId,
      required this.operatorName,
      required this.trips,
      required this.ticketsSold,
      required this.seats,
      required this.gmv,
      required this.refunded,
      this.averageRating,
      required this.reviewCount})
      : super._();
  @override
  AdminReportDtoOutputByOperatorInner rebuild(
          void Function(AdminReportDtoOutputByOperatorInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputByOperatorInnerBuilder toBuilder() =>
      AdminReportDtoOutputByOperatorInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputByOperatorInner &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        trips == other.trips &&
        ticketsSold == other.ticketsSold &&
        seats == other.seats &&
        gmv == other.gmv &&
        refunded == other.refunded &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jc(_$hash, refunded.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutputByOperatorInner')
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('trips', trips)
          ..add('ticketsSold', ticketsSold)
          ..add('seats', seats)
          ..add('gmv', gmv)
          ..add('refunded', refunded)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount))
        .toString();
  }
}

class AdminReportDtoOutputByOperatorInnerBuilder
    implements
        Builder<AdminReportDtoOutputByOperatorInner,
            AdminReportDtoOutputByOperatorInnerBuilder> {
  _$AdminReportDtoOutputByOperatorInner? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _gmv;
  int? get gmv => _$this._gmv;
  set gmv(int? gmv) => _$this._gmv = gmv;

  int? _refunded;
  int? get refunded => _$this._refunded;
  set refunded(int? refunded) => _$this._refunded = refunded;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  AdminReportDtoOutputByOperatorInnerBuilder() {
    AdminReportDtoOutputByOperatorInner._defaults(this);
  }

  AdminReportDtoOutputByOperatorInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _trips = $v.trips;
      _ticketsSold = $v.ticketsSold;
      _seats = $v.seats;
      _gmv = $v.gmv;
      _refunded = $v.refunded;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputByOperatorInner other) {
    _$v = other as _$AdminReportDtoOutputByOperatorInner;
  }

  @override
  void update(
      void Function(AdminReportDtoOutputByOperatorInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputByOperatorInner build() => _build();

  _$AdminReportDtoOutputByOperatorInner _build() {
    final _$result = _$v ??
        _$AdminReportDtoOutputByOperatorInner._(
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminReportDtoOutputByOperatorInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminReportDtoOutputByOperatorInner', 'operatorName'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'AdminReportDtoOutputByOperatorInner', 'trips'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(ticketsSold,
              r'AdminReportDtoOutputByOperatorInner', 'ticketsSold'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminReportDtoOutputByOperatorInner', 'seats'),
          gmv: BuiltValueNullFieldError.checkNotNull(
              gmv, r'AdminReportDtoOutputByOperatorInner', 'gmv'),
          refunded: BuiltValueNullFieldError.checkNotNull(
              refunded, r'AdminReportDtoOutputByOperatorInner', 'refunded'),
          averageRating: averageRating,
          reviewCount: BuiltValueNullFieldError.checkNotNull(reviewCount,
              r'AdminReportDtoOutputByOperatorInner', 'reviewCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
