// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_name_preview_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteNamePreviewInputDto extends RouteNamePreviewInputDto {
  @override
  final BuiltList<RouteNamePreviewInputDtoStopsInner> stops;
  @override
  final String? routeId;

  factory _$RouteNamePreviewInputDto(
          [void Function(RouteNamePreviewInputDtoBuilder)? updates]) =>
      (RouteNamePreviewInputDtoBuilder()..update(updates))._build();

  _$RouteNamePreviewInputDto._({required this.stops, this.routeId}) : super._();
  @override
  RouteNamePreviewInputDto rebuild(
          void Function(RouteNamePreviewInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteNamePreviewInputDtoBuilder toBuilder() =>
      RouteNamePreviewInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteNamePreviewInputDto &&
        stops == other.stops &&
        routeId == other.routeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteNamePreviewInputDto')
          ..add('stops', stops)
          ..add('routeId', routeId))
        .toString();
  }
}

class RouteNamePreviewInputDtoBuilder
    implements
        Builder<RouteNamePreviewInputDto, RouteNamePreviewInputDtoBuilder> {
  _$RouteNamePreviewInputDto? _$v;

  ListBuilder<RouteNamePreviewInputDtoStopsInner>? _stops;
  ListBuilder<RouteNamePreviewInputDtoStopsInner> get stops =>
      _$this._stops ??= ListBuilder<RouteNamePreviewInputDtoStopsInner>();
  set stops(ListBuilder<RouteNamePreviewInputDtoStopsInner>? stops) =>
      _$this._stops = stops;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  RouteNamePreviewInputDtoBuilder() {
    RouteNamePreviewInputDto._defaults(this);
  }

  RouteNamePreviewInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stops = $v.stops.toBuilder();
      _routeId = $v.routeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteNamePreviewInputDto other) {
    _$v = other as _$RouteNamePreviewInputDto;
  }

  @override
  void update(void Function(RouteNamePreviewInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteNamePreviewInputDto build() => _build();

  _$RouteNamePreviewInputDto _build() {
    _$RouteNamePreviewInputDto _$result;
    try {
      _$result = _$v ??
          _$RouteNamePreviewInputDto._(
            stops: stops.build(),
            routeId: routeId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stops';
        stops.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RouteNamePreviewInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
