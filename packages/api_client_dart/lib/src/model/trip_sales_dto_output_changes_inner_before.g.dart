// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_sales_dto_output_changes_inner_before.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSalesDtoOutputChangesInnerBefore
    extends TripSalesDtoOutputChangesInnerBefore {
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final String? vehiclePlateNumber;
  @override
  final BuiltList<TripSalesDtoOutputChangesInnerBeforeStopsInner> stops;

  factory _$TripSalesDtoOutputChangesInnerBefore(
          [void Function(TripSalesDtoOutputChangesInnerBeforeBuilder)?
              updates]) =>
      (TripSalesDtoOutputChangesInnerBeforeBuilder()..update(updates))._build();

  _$TripSalesDtoOutputChangesInnerBefore._(
      {required this.departureAt,
      required this.arrivalAt,
      this.vehiclePlateNumber,
      required this.stops})
      : super._();
  @override
  TripSalesDtoOutputChangesInnerBefore rebuild(
          void Function(TripSalesDtoOutputChangesInnerBeforeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSalesDtoOutputChangesInnerBeforeBuilder toBuilder() =>
      TripSalesDtoOutputChangesInnerBeforeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSalesDtoOutputChangesInnerBefore &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        stops == other.stops;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripSalesDtoOutputChangesInnerBefore')
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('stops', stops))
        .toString();
  }
}

class TripSalesDtoOutputChangesInnerBeforeBuilder
    implements
        Builder<TripSalesDtoOutputChangesInnerBefore,
            TripSalesDtoOutputChangesInnerBeforeBuilder> {
  _$TripSalesDtoOutputChangesInnerBefore? _$v;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  ListBuilder<TripSalesDtoOutputChangesInnerBeforeStopsInner>? _stops;
  ListBuilder<TripSalesDtoOutputChangesInnerBeforeStopsInner> get stops =>
      _$this._stops ??=
          ListBuilder<TripSalesDtoOutputChangesInnerBeforeStopsInner>();
  set stops(
          ListBuilder<TripSalesDtoOutputChangesInnerBeforeStopsInner>? stops) =>
      _$this._stops = stops;

  TripSalesDtoOutputChangesInnerBeforeBuilder() {
    TripSalesDtoOutputChangesInnerBefore._defaults(this);
  }

  TripSalesDtoOutputChangesInnerBeforeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _stops = $v.stops.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSalesDtoOutputChangesInnerBefore other) {
    _$v = other as _$TripSalesDtoOutputChangesInnerBefore;
  }

  @override
  void update(
      void Function(TripSalesDtoOutputChangesInnerBeforeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSalesDtoOutputChangesInnerBefore build() => _build();

  _$TripSalesDtoOutputChangesInnerBefore _build() {
    _$TripSalesDtoOutputChangesInnerBefore _$result;
    try {
      _$result = _$v ??
          _$TripSalesDtoOutputChangesInnerBefore._(
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'TripSalesDtoOutputChangesInnerBefore', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(arrivalAt,
                r'TripSalesDtoOutputChangesInnerBefore', 'arrivalAt'),
            vehiclePlateNumber: vehiclePlateNumber,
            stops: stops.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stops';
        stops.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripSalesDtoOutputChangesInnerBefore',
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
