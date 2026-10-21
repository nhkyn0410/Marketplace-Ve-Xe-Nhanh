// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_generate_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripScheduleGenerateResponseDtoOutput
    extends TripScheduleGenerateResponseDtoOutput {
  @override
  final BuiltList<TripScheduleGenerateResponseDtoOutputCreatedInner> created;
  @override
  final BuiltList<TripScheduleGenerateResponseDtoOutputSkippedInner> skipped;

  factory _$TripScheduleGenerateResponseDtoOutput(
          [void Function(TripScheduleGenerateResponseDtoOutputBuilder)?
              updates]) =>
      (TripScheduleGenerateResponseDtoOutputBuilder()..update(updates))
          ._build();

  _$TripScheduleGenerateResponseDtoOutput._(
      {required this.created, required this.skipped})
      : super._();
  @override
  TripScheduleGenerateResponseDtoOutput rebuild(
          void Function(TripScheduleGenerateResponseDtoOutputBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleGenerateResponseDtoOutputBuilder toBuilder() =>
      TripScheduleGenerateResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleGenerateResponseDtoOutput &&
        created == other.created &&
        skipped == other.skipped;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, skipped.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripScheduleGenerateResponseDtoOutput')
          ..add('created', created)
          ..add('skipped', skipped))
        .toString();
  }
}

class TripScheduleGenerateResponseDtoOutputBuilder
    implements
        Builder<TripScheduleGenerateResponseDtoOutput,
            TripScheduleGenerateResponseDtoOutputBuilder> {
  _$TripScheduleGenerateResponseDtoOutput? _$v;

  ListBuilder<TripScheduleGenerateResponseDtoOutputCreatedInner>? _created;
  ListBuilder<TripScheduleGenerateResponseDtoOutputCreatedInner> get created =>
      _$this._created ??=
          ListBuilder<TripScheduleGenerateResponseDtoOutputCreatedInner>();
  set created(
          ListBuilder<TripScheduleGenerateResponseDtoOutputCreatedInner>?
              created) =>
      _$this._created = created;

  ListBuilder<TripScheduleGenerateResponseDtoOutputSkippedInner>? _skipped;
  ListBuilder<TripScheduleGenerateResponseDtoOutputSkippedInner> get skipped =>
      _$this._skipped ??=
          ListBuilder<TripScheduleGenerateResponseDtoOutputSkippedInner>();
  set skipped(
          ListBuilder<TripScheduleGenerateResponseDtoOutputSkippedInner>?
              skipped) =>
      _$this._skipped = skipped;

  TripScheduleGenerateResponseDtoOutputBuilder() {
    TripScheduleGenerateResponseDtoOutput._defaults(this);
  }

  TripScheduleGenerateResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _created = $v.created.toBuilder();
      _skipped = $v.skipped.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleGenerateResponseDtoOutput other) {
    _$v = other as _$TripScheduleGenerateResponseDtoOutput;
  }

  @override
  void update(
      void Function(TripScheduleGenerateResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleGenerateResponseDtoOutput build() => _build();

  _$TripScheduleGenerateResponseDtoOutput _build() {
    _$TripScheduleGenerateResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripScheduleGenerateResponseDtoOutput._(
            created: created.build(),
            skipped: skipped.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'created';
        created.build();
        _$failedField = 'skipped';
        skipped.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripScheduleGenerateResponseDtoOutput',
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
