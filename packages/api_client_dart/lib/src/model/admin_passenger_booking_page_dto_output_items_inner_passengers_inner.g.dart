// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_booking_page_dto_output_items_inner_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner
    extends AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner {
  @override
  final String fullName;
  @override
  final String? companionName;
  @override
  final String seatCode;
  @override
  final String? ticketStatus;

  factory _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner(
          [void Function(
                  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder)?
              updates]) =>
      (AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner._(
      {required this.fullName,
      this.companionName,
      required this.seatCode,
      this.ticketStatus})
      : super._();
  @override
  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner rebuild(
          void Function(
                  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder
      toBuilder() =>
          AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner &&
        fullName == other.fullName &&
        companionName == other.companionName &&
        seatCode == other.seatCode &&
        ticketStatus == other.ticketStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, companionName.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, ticketStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner')
          ..add('fullName', fullName)
          ..add('companionName', companionName)
          ..add('seatCode', seatCode)
          ..add('ticketStatus', ticketStatus))
        .toString();
  }
}

class AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder
    implements
        Builder<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner,
            AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder> {
  _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _companionName;
  String? get companionName => _$this._companionName;
  set companionName(String? companionName) =>
      _$this._companionName = companionName;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _ticketStatus;
  String? get ticketStatus => _$this._ticketStatus;
  set ticketStatus(String? ticketStatus) => _$this._ticketStatus = ticketStatus;

  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder() {
    AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner._defaults(this);
  }

  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder
      get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _companionName = $v.companionName;
      _seatCode = $v.seatCode;
      _ticketStatus = $v.ticketStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner other) {
    _$v =
        other as _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner;
  }

  @override
  void update(
      void Function(
              AdminPassengerBookingPageDtoOutputItemsInnerPassengersInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner build() =>
      _build();

  _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner _build() {
    final _$result = _$v ??
        _$AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName,
              r'AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner',
              'fullName'),
          companionName: companionName,
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode,
              r'AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner',
              'seatCode'),
          ticketStatus: ticketStatus,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
