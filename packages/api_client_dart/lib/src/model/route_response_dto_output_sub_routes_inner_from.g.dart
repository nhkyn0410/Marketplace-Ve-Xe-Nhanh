// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response_dto_output_sub_routes_inner_from.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteResponseDtoOutputSubRoutesInnerFrom
    extends RouteResponseDtoOutputSubRoutesInnerFrom {
  @override
  final String? catalogStopPointId;
  @override
  final String? stopPointId;
  @override
  final String name;

  factory _$RouteResponseDtoOutputSubRoutesInnerFrom(
          [void Function(RouteResponseDtoOutputSubRoutesInnerFromBuilder)?
              updates]) =>
      (RouteResponseDtoOutputSubRoutesInnerFromBuilder()..update(updates))
          ._build();

  _$RouteResponseDtoOutputSubRoutesInnerFrom._(
      {this.catalogStopPointId, this.stopPointId, required this.name})
      : super._();
  @override
  RouteResponseDtoOutputSubRoutesInnerFrom rebuild(
          void Function(RouteResponseDtoOutputSubRoutesInnerFromBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteResponseDtoOutputSubRoutesInnerFromBuilder toBuilder() =>
      RouteResponseDtoOutputSubRoutesInnerFromBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteResponseDtoOutputSubRoutesInnerFrom &&
        catalogStopPointId == other.catalogStopPointId &&
        stopPointId == other.stopPointId &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, stopPointId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'RouteResponseDtoOutputSubRoutesInnerFrom')
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('stopPointId', stopPointId)
          ..add('name', name))
        .toString();
  }
}

class RouteResponseDtoOutputSubRoutesInnerFromBuilder
    implements
        Builder<RouteResponseDtoOutputSubRoutesInnerFrom,
            RouteResponseDtoOutputSubRoutesInnerFromBuilder> {
  _$RouteResponseDtoOutputSubRoutesInnerFrom? _$v;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _stopPointId;
  String? get stopPointId => _$this._stopPointId;
  set stopPointId(String? stopPointId) => _$this._stopPointId = stopPointId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RouteResponseDtoOutputSubRoutesInnerFromBuilder() {
    RouteResponseDtoOutputSubRoutesInnerFrom._defaults(this);
  }

  RouteResponseDtoOutputSubRoutesInnerFromBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _catalogStopPointId = $v.catalogStopPointId;
      _stopPointId = $v.stopPointId;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteResponseDtoOutputSubRoutesInnerFrom other) {
    _$v = other as _$RouteResponseDtoOutputSubRoutesInnerFrom;
  }

  @override
  void update(
      void Function(RouteResponseDtoOutputSubRoutesInnerFromBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteResponseDtoOutputSubRoutesInnerFrom build() => _build();

  _$RouteResponseDtoOutputSubRoutesInnerFrom _build() {
    final _$result = _$v ??
        _$RouteResponseDtoOutputSubRoutesInnerFrom._(
          catalogStopPointId: catalogStopPointId,
          stopPointId: stopPointId,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RouteResponseDtoOutputSubRoutesInnerFrom', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
