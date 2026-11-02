// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_demo_start_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JourneyDemoStartDto extends JourneyDemoStartDto {
  @override
  final String bookingId;
  @override
  final String deviceId;

  factory _$JourneyDemoStartDto(
          [void Function(JourneyDemoStartDtoBuilder)? updates]) =>
      (JourneyDemoStartDtoBuilder()..update(updates))._build();

  _$JourneyDemoStartDto._({required this.bookingId, required this.deviceId})
      : super._();
  @override
  JourneyDemoStartDto rebuild(
          void Function(JourneyDemoStartDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyDemoStartDtoBuilder toBuilder() =>
      JourneyDemoStartDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyDemoStartDto &&
        bookingId == other.bookingId &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JourneyDemoStartDto')
          ..add('bookingId', bookingId)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class JourneyDemoStartDtoBuilder
    implements Builder<JourneyDemoStartDto, JourneyDemoStartDtoBuilder> {
  _$JourneyDemoStartDto? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  JourneyDemoStartDtoBuilder() {
    JourneyDemoStartDto._defaults(this);
  }

  JourneyDemoStartDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JourneyDemoStartDto other) {
    _$v = other as _$JourneyDemoStartDto;
  }

  @override
  void update(void Function(JourneyDemoStartDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyDemoStartDto build() => _build();

  _$JourneyDemoStartDto _build() {
    final _$result = _$v ??
        _$JourneyDemoStartDto._(
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'JourneyDemoStartDto', 'bookingId'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'JourneyDemoStartDto', 'deviceId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
