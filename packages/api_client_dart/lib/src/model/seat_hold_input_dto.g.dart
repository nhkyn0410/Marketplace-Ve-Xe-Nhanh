// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_hold_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeatHoldInputDto extends SeatHoldInputDto {
  @override
  final String tripId;
  @override
  final BuiltList<String> seatCodes;
  @override
  final int pickupSequence;
  @override
  final int dropoffSequence;

  factory _$SeatHoldInputDto(
          [void Function(SeatHoldInputDtoBuilder)? updates]) =>
      (SeatHoldInputDtoBuilder()..update(updates))._build();

  _$SeatHoldInputDto._(
      {required this.tripId,
      required this.seatCodes,
      required this.pickupSequence,
      required this.dropoffSequence})
      : super._();
  @override
  SeatHoldInputDto rebuild(void Function(SeatHoldInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatHoldInputDtoBuilder toBuilder() =>
      SeatHoldInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeatHoldInputDto &&
        tripId == other.tripId &&
        seatCodes == other.seatCodes &&
        pickupSequence == other.pickupSequence &&
        dropoffSequence == other.dropoffSequence;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, seatCodes.hashCode);
    _$hash = $jc(_$hash, pickupSequence.hashCode);
    _$hash = $jc(_$hash, dropoffSequence.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SeatHoldInputDto')
          ..add('tripId', tripId)
          ..add('seatCodes', seatCodes)
          ..add('pickupSequence', pickupSequence)
          ..add('dropoffSequence', dropoffSequence))
        .toString();
  }
}

class SeatHoldInputDtoBuilder
    implements Builder<SeatHoldInputDto, SeatHoldInputDtoBuilder> {
  _$SeatHoldInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  ListBuilder<String>? _seatCodes;
  ListBuilder<String> get seatCodes =>
      _$this._seatCodes ??= ListBuilder<String>();
  set seatCodes(ListBuilder<String>? seatCodes) =>
      _$this._seatCodes = seatCodes;

  int? _pickupSequence;
  int? get pickupSequence => _$this._pickupSequence;
  set pickupSequence(int? pickupSequence) =>
      _$this._pickupSequence = pickupSequence;

  int? _dropoffSequence;
  int? get dropoffSequence => _$this._dropoffSequence;
  set dropoffSequence(int? dropoffSequence) =>
      _$this._dropoffSequence = dropoffSequence;

  SeatHoldInputDtoBuilder() {
    SeatHoldInputDto._defaults(this);
  }

  SeatHoldInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _seatCodes = $v.seatCodes.toBuilder();
      _pickupSequence = $v.pickupSequence;
      _dropoffSequence = $v.dropoffSequence;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeatHoldInputDto other) {
    _$v = other as _$SeatHoldInputDto;
  }

  @override
  void update(void Function(SeatHoldInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeatHoldInputDto build() => _build();

  _$SeatHoldInputDto _build() {
    _$SeatHoldInputDto _$result;
    try {
      _$result = _$v ??
          _$SeatHoldInputDto._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'SeatHoldInputDto', 'tripId'),
            seatCodes: seatCodes.build(),
            pickupSequence: BuiltValueNullFieldError.checkNotNull(
                pickupSequence, r'SeatHoldInputDto', 'pickupSequence'),
            dropoffSequence: BuiltValueNullFieldError.checkNotNull(
                dropoffSequence, r'SeatHoldInputDto', 'dropoffSequence'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'seatCodes';
        seatCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SeatHoldInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
