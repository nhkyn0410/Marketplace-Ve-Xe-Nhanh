// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingInputDto extends CounterBookingInputDto {
  @override
  final String holdId;
  @override
  final CounterBookingInputDtoContact contact;
  @override
  final BuiltList<CounterBookingInputDtoPassengersInner> passengers;
  @override
  final String? note;
  @override
  final String expectedTotal;

  factory _$CounterBookingInputDto(
          [void Function(CounterBookingInputDtoBuilder)? updates]) =>
      (CounterBookingInputDtoBuilder()..update(updates))._build();

  _$CounterBookingInputDto._(
      {required this.holdId,
      required this.contact,
      required this.passengers,
      this.note,
      required this.expectedTotal})
      : super._();
  @override
  CounterBookingInputDto rebuild(
          void Function(CounterBookingInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingInputDtoBuilder toBuilder() =>
      CounterBookingInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingInputDto &&
        holdId == other.holdId &&
        contact == other.contact &&
        passengers == other.passengers &&
        note == other.note &&
        expectedTotal == other.expectedTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, holdId.hashCode);
    _$hash = $jc(_$hash, contact.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, expectedTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterBookingInputDto')
          ..add('holdId', holdId)
          ..add('contact', contact)
          ..add('passengers', passengers)
          ..add('note', note)
          ..add('expectedTotal', expectedTotal))
        .toString();
  }
}

class CounterBookingInputDtoBuilder
    implements Builder<CounterBookingInputDto, CounterBookingInputDtoBuilder> {
  _$CounterBookingInputDto? _$v;

  String? _holdId;
  String? get holdId => _$this._holdId;
  set holdId(String? holdId) => _$this._holdId = holdId;

  CounterBookingInputDtoContactBuilder? _contact;
  CounterBookingInputDtoContactBuilder get contact =>
      _$this._contact ??= CounterBookingInputDtoContactBuilder();
  set contact(CounterBookingInputDtoContactBuilder? contact) =>
      _$this._contact = contact;

  ListBuilder<CounterBookingInputDtoPassengersInner>? _passengers;
  ListBuilder<CounterBookingInputDtoPassengersInner> get passengers =>
      _$this._passengers ??=
          ListBuilder<CounterBookingInputDtoPassengersInner>();
  set passengers(
          ListBuilder<CounterBookingInputDtoPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _expectedTotal;
  String? get expectedTotal => _$this._expectedTotal;
  set expectedTotal(String? expectedTotal) =>
      _$this._expectedTotal = expectedTotal;

  CounterBookingInputDtoBuilder() {
    CounterBookingInputDto._defaults(this);
  }

  CounterBookingInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _holdId = $v.holdId;
      _contact = $v.contact.toBuilder();
      _passengers = $v.passengers.toBuilder();
      _note = $v.note;
      _expectedTotal = $v.expectedTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingInputDto other) {
    _$v = other as _$CounterBookingInputDto;
  }

  @override
  void update(void Function(CounterBookingInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingInputDto build() => _build();

  _$CounterBookingInputDto _build() {
    _$CounterBookingInputDto _$result;
    try {
      _$result = _$v ??
          _$CounterBookingInputDto._(
            holdId: BuiltValueNullFieldError.checkNotNull(
                holdId, r'CounterBookingInputDto', 'holdId'),
            contact: contact.build(),
            passengers: passengers.build(),
            note: note,
            expectedTotal: BuiltValueNullFieldError.checkNotNull(
                expectedTotal, r'CounterBookingInputDto', 'expectedTotal'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contact';
        contact.build();
        _$failedField = 'passengers';
        passengers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterBookingInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
