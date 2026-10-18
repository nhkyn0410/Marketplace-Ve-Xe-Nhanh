// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingInputDto extends BookingInputDto {
  @override
  final String holdId;
  @override
  final BookingInputDtoContact contact;
  @override
  final BuiltList<BookingInputDtoPassengersInner> passengers;
  @override
  final String? note;
  @override
  final int expectedTotal;

  factory _$BookingInputDto([void Function(BookingInputDtoBuilder)? updates]) =>
      (BookingInputDtoBuilder()..update(updates))._build();

  _$BookingInputDto._(
      {required this.holdId,
      required this.contact,
      required this.passengers,
      this.note,
      required this.expectedTotal})
      : super._();
  @override
  BookingInputDto rebuild(void Function(BookingInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingInputDtoBuilder toBuilder() => BookingInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingInputDto &&
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
    return (newBuiltValueToStringHelper(r'BookingInputDto')
          ..add('holdId', holdId)
          ..add('contact', contact)
          ..add('passengers', passengers)
          ..add('note', note)
          ..add('expectedTotal', expectedTotal))
        .toString();
  }
}

class BookingInputDtoBuilder
    implements Builder<BookingInputDto, BookingInputDtoBuilder> {
  _$BookingInputDto? _$v;

  String? _holdId;
  String? get holdId => _$this._holdId;
  set holdId(String? holdId) => _$this._holdId = holdId;

  BookingInputDtoContactBuilder? _contact;
  BookingInputDtoContactBuilder get contact =>
      _$this._contact ??= BookingInputDtoContactBuilder();
  set contact(BookingInputDtoContactBuilder? contact) =>
      _$this._contact = contact;

  ListBuilder<BookingInputDtoPassengersInner>? _passengers;
  ListBuilder<BookingInputDtoPassengersInner> get passengers =>
      _$this._passengers ??= ListBuilder<BookingInputDtoPassengersInner>();
  set passengers(ListBuilder<BookingInputDtoPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _expectedTotal;
  int? get expectedTotal => _$this._expectedTotal;
  set expectedTotal(int? expectedTotal) =>
      _$this._expectedTotal = expectedTotal;

  BookingInputDtoBuilder() {
    BookingInputDto._defaults(this);
  }

  BookingInputDtoBuilder get _$this {
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
  void replace(BookingInputDto other) {
    _$v = other as _$BookingInputDto;
  }

  @override
  void update(void Function(BookingInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingInputDto build() => _build();

  _$BookingInputDto _build() {
    _$BookingInputDto _$result;
    try {
      _$result = _$v ??
          _$BookingInputDto._(
            holdId: BuiltValueNullFieldError.checkNotNull(
                holdId, r'BookingInputDto', 'holdId'),
            contact: contact.build(),
            passengers: passengers.build(),
            note: note,
            expectedTotal: BuiltValueNullFieldError.checkNotNull(
                expectedTotal, r'BookingInputDto', 'expectedTotal'),
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
            r'BookingInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
