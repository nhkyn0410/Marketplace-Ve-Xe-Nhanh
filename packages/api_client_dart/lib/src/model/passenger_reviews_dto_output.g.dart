// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_reviews_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerReviewsDtoOutput extends PassengerReviewsDtoOutput {
  @override
  final PassengerReviewsDtoOutputPending pending;
  @override
  final PassengerReviewsDtoOutputReviewed reviewed;

  factory _$PassengerReviewsDtoOutput(
          [void Function(PassengerReviewsDtoOutputBuilder)? updates]) =>
      (PassengerReviewsDtoOutputBuilder()..update(updates))._build();

  _$PassengerReviewsDtoOutput._({required this.pending, required this.reviewed})
      : super._();
  @override
  PassengerReviewsDtoOutput rebuild(
          void Function(PassengerReviewsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerReviewsDtoOutputBuilder toBuilder() =>
      PassengerReviewsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerReviewsDtoOutput &&
        pending == other.pending &&
        reviewed == other.reviewed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jc(_$hash, reviewed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PassengerReviewsDtoOutput')
          ..add('pending', pending)
          ..add('reviewed', reviewed))
        .toString();
  }
}

class PassengerReviewsDtoOutputBuilder
    implements
        Builder<PassengerReviewsDtoOutput, PassengerReviewsDtoOutputBuilder> {
  _$PassengerReviewsDtoOutput? _$v;

  PassengerReviewsDtoOutputPendingBuilder? _pending;
  PassengerReviewsDtoOutputPendingBuilder get pending =>
      _$this._pending ??= PassengerReviewsDtoOutputPendingBuilder();
  set pending(PassengerReviewsDtoOutputPendingBuilder? pending) =>
      _$this._pending = pending;

  PassengerReviewsDtoOutputReviewedBuilder? _reviewed;
  PassengerReviewsDtoOutputReviewedBuilder get reviewed =>
      _$this._reviewed ??= PassengerReviewsDtoOutputReviewedBuilder();
  set reviewed(PassengerReviewsDtoOutputReviewedBuilder? reviewed) =>
      _$this._reviewed = reviewed;

  PassengerReviewsDtoOutputBuilder() {
    PassengerReviewsDtoOutput._defaults(this);
  }

  PassengerReviewsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pending = $v.pending.toBuilder();
      _reviewed = $v.reviewed.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerReviewsDtoOutput other) {
    _$v = other as _$PassengerReviewsDtoOutput;
  }

  @override
  void update(void Function(PassengerReviewsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerReviewsDtoOutput build() => _build();

  _$PassengerReviewsDtoOutput _build() {
    _$PassengerReviewsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerReviewsDtoOutput._(
            pending: pending.build(),
            reviewed: reviewed.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pending';
        pending.build();
        _$failedField = 'reviewed';
        reviewed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerReviewsDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
