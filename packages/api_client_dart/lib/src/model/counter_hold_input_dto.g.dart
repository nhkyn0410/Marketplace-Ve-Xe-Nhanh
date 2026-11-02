// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_hold_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterHoldInputDto extends CounterHoldInputDto {
  @override
  final String officeId;
  @override
  final String tripId;
  @override
  final BuiltList<String> seatCodes;
  @override
  final int pickupSequence;
  @override
  final int dropoffSequence;

  factory _$CounterHoldInputDto(
          [void Function(CounterHoldInputDtoBuilder)? updates]) =>
      (CounterHoldInputDtoBuilder()..update(updates))._build();

  _$CounterHoldInputDto._(
      {required this.officeId,
      required this.tripId,
      required this.seatCodes,
      required this.pickupSequence,
      required this.dropoffSequence})
      : super._();
  @override
  CounterHoldInputDto rebuild(
          void Function(CounterHoldInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterHoldInputDtoBuilder toBuilder() =>
      CounterHoldInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterHoldInputDto &&
        officeId == other.officeId &&
        tripId == other.tripId &&
        seatCodes == other.seatCodes &&
        pickupSequence == other.pickupSequence &&
        dropoffSequence == other.dropoffSequence;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, seatCodes.hashCode);
    _$hash = $jc(_$hash, pickupSequence.hashCode);
    _$hash = $jc(_$hash, dropoffSequence.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterHoldInputDto')
          ..add('officeId', officeId)
          ..add('tripId', tripId)
          ..add('seatCodes', seatCodes)
          ..add('pickupSequence', pickupSequence)
          ..add('dropoffSequence', dropoffSequence))
        .toString();
  }
}

class CounterHoldInputDtoBuilder
    implements Builder<CounterHoldInputDto, CounterHoldInputDtoBuilder> {
  _$CounterHoldInputDto? _$v;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

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

  CounterHoldInputDtoBuilder() {
    CounterHoldInputDto._defaults(this);
  }

  CounterHoldInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _officeId = $v.officeId;
      _tripId = $v.tripId;
      _seatCodes = $v.seatCodes.toBuilder();
      _pickupSequence = $v.pickupSequence;
      _dropoffSequence = $v.dropoffSequence;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterHoldInputDto other) {
    _$v = other as _$CounterHoldInputDto;
  }

  @override
  void update(void Function(CounterHoldInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterHoldInputDto build() => _build();

  _$CounterHoldInputDto _build() {
    _$CounterHoldInputDto _$result;
    try {
      _$result = _$v ??
          _$CounterHoldInputDto._(
            officeId: BuiltValueNullFieldError.checkNotNull(
                officeId, r'CounterHoldInputDto', 'officeId'),
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'CounterHoldInputDto', 'tripId'),
            seatCodes: seatCodes.build(),
            pickupSequence: BuiltValueNullFieldError.checkNotNull(
                pickupSequence, r'CounterHoldInputDto', 'pickupSequence'),
            dropoffSequence: BuiltValueNullFieldError.checkNotNull(
                dropoffSequence, r'CounterHoldInputDto', 'dropoffSequence'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'seatCodes';
        seatCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterHoldInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
