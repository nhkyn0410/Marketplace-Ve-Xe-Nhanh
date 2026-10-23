// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancellationResultDtoOutput extends CancellationResultDtoOutput {
  @override
  final CancellationResultDtoOutputBooking booking;
  @override
  final CancellationResultDtoOutputRefund? refund;

  factory _$CancellationResultDtoOutput(
          [void Function(CancellationResultDtoOutputBuilder)? updates]) =>
      (CancellationResultDtoOutputBuilder()..update(updates))._build();

  _$CancellationResultDtoOutput._({required this.booking, this.refund})
      : super._();
  @override
  CancellationResultDtoOutput rebuild(
          void Function(CancellationResultDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationResultDtoOutputBuilder toBuilder() =>
      CancellationResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationResultDtoOutput &&
        booking == other.booking &&
        refund == other.refund;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, booking.hashCode);
    _$hash = $jc(_$hash, refund.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationResultDtoOutput')
          ..add('booking', booking)
          ..add('refund', refund))
        .toString();
  }
}

class CancellationResultDtoOutputBuilder
    implements
        Builder<CancellationResultDtoOutput,
            CancellationResultDtoOutputBuilder> {
  _$CancellationResultDtoOutput? _$v;

  CancellationResultDtoOutputBookingBuilder? _booking;
  CancellationResultDtoOutputBookingBuilder get booking =>
      _$this._booking ??= CancellationResultDtoOutputBookingBuilder();
  set booking(CancellationResultDtoOutputBookingBuilder? booking) =>
      _$this._booking = booking;

  CancellationResultDtoOutputRefundBuilder? _refund;
  CancellationResultDtoOutputRefundBuilder get refund =>
      _$this._refund ??= CancellationResultDtoOutputRefundBuilder();
  set refund(CancellationResultDtoOutputRefundBuilder? refund) =>
      _$this._refund = refund;

  CancellationResultDtoOutputBuilder() {
    CancellationResultDtoOutput._defaults(this);
  }

  CancellationResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _booking = $v.booking.toBuilder();
      _refund = $v.refund?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationResultDtoOutput other) {
    _$v = other as _$CancellationResultDtoOutput;
  }

  @override
  void update(void Function(CancellationResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationResultDtoOutput build() => _build();

  _$CancellationResultDtoOutput _build() {
    _$CancellationResultDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CancellationResultDtoOutput._(
            booking: booking.build(),
            refund: _refund?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'booking';
        booking.build();
        _$failedField = 'refund';
        _refund?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CancellationResultDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
