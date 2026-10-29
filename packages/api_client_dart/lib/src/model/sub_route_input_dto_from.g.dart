// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_route_input_dto_from.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubRouteInputDtoFrom extends SubRouteInputDtoFrom {
  @override
  final String? catalogStopPointId;
  @override
  final String? stopPointId;

  factory _$SubRouteInputDtoFrom(
          [void Function(SubRouteInputDtoFromBuilder)? updates]) =>
      (SubRouteInputDtoFromBuilder()..update(updates))._build();

  _$SubRouteInputDtoFrom._({this.catalogStopPointId, this.stopPointId})
      : super._();
  @override
  SubRouteInputDtoFrom rebuild(
          void Function(SubRouteInputDtoFromBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubRouteInputDtoFromBuilder toBuilder() =>
      SubRouteInputDtoFromBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubRouteInputDtoFrom &&
        catalogStopPointId == other.catalogStopPointId &&
        stopPointId == other.stopPointId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, stopPointId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubRouteInputDtoFrom')
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('stopPointId', stopPointId))
        .toString();
  }
}

class SubRouteInputDtoFromBuilder
    implements Builder<SubRouteInputDtoFrom, SubRouteInputDtoFromBuilder> {
  _$SubRouteInputDtoFrom? _$v;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _stopPointId;
  String? get stopPointId => _$this._stopPointId;
  set stopPointId(String? stopPointId) => _$this._stopPointId = stopPointId;

  SubRouteInputDtoFromBuilder() {
    SubRouteInputDtoFrom._defaults(this);
  }

  SubRouteInputDtoFromBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _catalogStopPointId = $v.catalogStopPointId;
      _stopPointId = $v.stopPointId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubRouteInputDtoFrom other) {
    _$v = other as _$SubRouteInputDtoFrom;
  }

  @override
  void update(void Function(SubRouteInputDtoFromBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubRouteInputDtoFrom build() => _build();

  _$SubRouteInputDtoFrom _build() {
    final _$result = _$v ??
        _$SubRouteInputDtoFrom._(
          catalogStopPointId: catalogStopPointId,
          stopPointId: stopPointId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
