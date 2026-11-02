// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_segment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutputSegment extends PublicTripDtoOutputSegment {
  @override
  final int pickupSequence;
  @override
  final int dropoffSequence;
  @override
  final String title;

  factory _$PublicTripDtoOutputSegment(
          [void Function(PublicTripDtoOutputSegmentBuilder)? updates]) =>
      (PublicTripDtoOutputSegmentBuilder()..update(updates))._build();

  _$PublicTripDtoOutputSegment._(
      {required this.pickupSequence,
      required this.dropoffSequence,
      required this.title})
      : super._();
  @override
  PublicTripDtoOutputSegment rebuild(
          void Function(PublicTripDtoOutputSegmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputSegmentBuilder toBuilder() =>
      PublicTripDtoOutputSegmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputSegment &&
        pickupSequence == other.pickupSequence &&
        dropoffSequence == other.dropoffSequence &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupSequence.hashCode);
    _$hash = $jc(_$hash, dropoffSequence.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicTripDtoOutputSegment')
          ..add('pickupSequence', pickupSequence)
          ..add('dropoffSequence', dropoffSequence)
          ..add('title', title))
        .toString();
  }
}

class PublicTripDtoOutputSegmentBuilder
    implements
        Builder<PublicTripDtoOutputSegment, PublicTripDtoOutputSegmentBuilder> {
  _$PublicTripDtoOutputSegment? _$v;

  int? _pickupSequence;
  int? get pickupSequence => _$this._pickupSequence;
  set pickupSequence(int? pickupSequence) =>
      _$this._pickupSequence = pickupSequence;

  int? _dropoffSequence;
  int? get dropoffSequence => _$this._dropoffSequence;
  set dropoffSequence(int? dropoffSequence) =>
      _$this._dropoffSequence = dropoffSequence;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  PublicTripDtoOutputSegmentBuilder() {
    PublicTripDtoOutputSegment._defaults(this);
  }

  PublicTripDtoOutputSegmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupSequence = $v.pickupSequence;
      _dropoffSequence = $v.dropoffSequence;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputSegment other) {
    _$v = other as _$PublicTripDtoOutputSegment;
  }

  @override
  void update(void Function(PublicTripDtoOutputSegmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputSegment build() => _build();

  _$PublicTripDtoOutputSegment _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputSegment._(
          pickupSequence: BuiltValueNullFieldError.checkNotNull(
              pickupSequence, r'PublicTripDtoOutputSegment', 'pickupSequence'),
          dropoffSequence: BuiltValueNullFieldError.checkNotNull(
              dropoffSequence,
              r'PublicTripDtoOutputSegment',
              'dropoffSequence'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'PublicTripDtoOutputSegment', 'title'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
