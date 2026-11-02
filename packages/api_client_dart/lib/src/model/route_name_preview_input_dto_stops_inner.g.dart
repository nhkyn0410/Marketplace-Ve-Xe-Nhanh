// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_name_preview_input_dto_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteNamePreviewInputDtoStopsInner
    extends RouteNamePreviewInputDtoStopsInner {
  @override
  final String? catalogStopPointId;
  @override
  final String? stopPointId;
  @override
  final String? note;
  @override
  final bool allowPickup;
  @override
  final bool allowDropoff;
  @override
  final int? durationMinutesFromPrevious;

  factory _$RouteNamePreviewInputDtoStopsInner(
          [void Function(RouteNamePreviewInputDtoStopsInnerBuilder)?
              updates]) =>
      (RouteNamePreviewInputDtoStopsInnerBuilder()..update(updates))._build();

  _$RouteNamePreviewInputDtoStopsInner._(
      {this.catalogStopPointId,
      this.stopPointId,
      this.note,
      required this.allowPickup,
      required this.allowDropoff,
      this.durationMinutesFromPrevious})
      : super._();
  @override
  RouteNamePreviewInputDtoStopsInner rebuild(
          void Function(RouteNamePreviewInputDtoStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteNamePreviewInputDtoStopsInnerBuilder toBuilder() =>
      RouteNamePreviewInputDtoStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteNamePreviewInputDtoStopsInner &&
        catalogStopPointId == other.catalogStopPointId &&
        stopPointId == other.stopPointId &&
        note == other.note &&
        allowPickup == other.allowPickup &&
        allowDropoff == other.allowDropoff &&
        durationMinutesFromPrevious == other.durationMinutesFromPrevious;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, stopPointId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, allowPickup.hashCode);
    _$hash = $jc(_$hash, allowDropoff.hashCode);
    _$hash = $jc(_$hash, durationMinutesFromPrevious.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteNamePreviewInputDtoStopsInner')
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('stopPointId', stopPointId)
          ..add('note', note)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff)
          ..add('durationMinutesFromPrevious', durationMinutesFromPrevious))
        .toString();
  }
}

class RouteNamePreviewInputDtoStopsInnerBuilder
    implements
        Builder<RouteNamePreviewInputDtoStopsInner,
            RouteNamePreviewInputDtoStopsInnerBuilder> {
  _$RouteNamePreviewInputDtoStopsInner? _$v;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _stopPointId;
  String? get stopPointId => _$this._stopPointId;
  set stopPointId(String? stopPointId) => _$this._stopPointId = stopPointId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  bool? _allowPickup;
  bool? get allowPickup => _$this._allowPickup;
  set allowPickup(bool? allowPickup) => _$this._allowPickup = allowPickup;

  bool? _allowDropoff;
  bool? get allowDropoff => _$this._allowDropoff;
  set allowDropoff(bool? allowDropoff) => _$this._allowDropoff = allowDropoff;

  int? _durationMinutesFromPrevious;
  int? get durationMinutesFromPrevious => _$this._durationMinutesFromPrevious;
  set durationMinutesFromPrevious(int? durationMinutesFromPrevious) =>
      _$this._durationMinutesFromPrevious = durationMinutesFromPrevious;

  RouteNamePreviewInputDtoStopsInnerBuilder() {
    RouteNamePreviewInputDtoStopsInner._defaults(this);
  }

  RouteNamePreviewInputDtoStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _catalogStopPointId = $v.catalogStopPointId;
      _stopPointId = $v.stopPointId;
      _note = $v.note;
      _allowPickup = $v.allowPickup;
      _allowDropoff = $v.allowDropoff;
      _durationMinutesFromPrevious = $v.durationMinutesFromPrevious;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteNamePreviewInputDtoStopsInner other) {
    _$v = other as _$RouteNamePreviewInputDtoStopsInner;
  }

  @override
  void update(
      void Function(RouteNamePreviewInputDtoStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteNamePreviewInputDtoStopsInner build() => _build();

  _$RouteNamePreviewInputDtoStopsInner _build() {
    final _$result = _$v ??
        _$RouteNamePreviewInputDtoStopsInner._(
          catalogStopPointId: catalogStopPointId,
          stopPointId: stopPointId,
          note: note,
          allowPickup: BuiltValueNullFieldError.checkNotNull(allowPickup,
              r'RouteNamePreviewInputDtoStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(allowDropoff,
              r'RouteNamePreviewInputDtoStopsInner', 'allowDropoff'),
          durationMinutesFromPrevious: durationMinutesFromPrevious,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
