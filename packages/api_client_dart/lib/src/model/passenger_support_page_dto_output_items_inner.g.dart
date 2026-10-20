// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_support_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerSupportPageDtoOutputItemsInner
    extends PassengerSupportPageDtoOutputItemsInner {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String subject;
  @override
  final String status;
  @override
  final DateTime updatedAt;

  factory _$PassengerSupportPageDtoOutputItemsInner(
          [void Function(PassengerSupportPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PassengerSupportPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PassengerSupportPageDtoOutputItemsInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.bookingId,
      required this.bookingCode,
      required this.subject,
      required this.status,
      required this.updatedAt})
      : super._();
  @override
  PassengerSupportPageDtoOutputItemsInner rebuild(
          void Function(PassengerSupportPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerSupportPageDtoOutputItemsInnerBuilder toBuilder() =>
      PassengerSupportPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerSupportPageDtoOutputItemsInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        subject == other.subject &&
        status == other.status &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerSupportPageDtoOutputItemsInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('subject', subject)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PassengerSupportPageDtoOutputItemsInnerBuilder
    implements
        Builder<PassengerSupportPageDtoOutputItemsInner,
            PassengerSupportPageDtoOutputItemsInnerBuilder> {
  _$PassengerSupportPageDtoOutputItemsInner? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PassengerSupportPageDtoOutputItemsInnerBuilder() {
    PassengerSupportPageDtoOutputItemsInner._defaults(this);
  }

  PassengerSupportPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _subject = $v.subject;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerSupportPageDtoOutputItemsInner other) {
    _$v = other as _$PassengerSupportPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PassengerSupportPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerSupportPageDtoOutputItemsInner build() => _build();

  _$PassengerSupportPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PassengerSupportPageDtoOutputItemsInner._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'PassengerSupportPageDtoOutputItemsInner', 'ticketId'),
          ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
              r'PassengerSupportPageDtoOutputItemsInner', 'ticketCode'),
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'PassengerSupportPageDtoOutputItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'PassengerSupportPageDtoOutputItemsInner', 'bookingCode'),
          subject: BuiltValueNullFieldError.checkNotNull(
              subject, r'PassengerSupportPageDtoOutputItemsInner', 'subject'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PassengerSupportPageDtoOutputItemsInner', 'status'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'PassengerSupportPageDtoOutputItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
