// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteInputDtoNameSourceEnum _$routeInputDtoNameSourceEnum_AUTO =
    const RouteInputDtoNameSourceEnum._('AUTO');
const RouteInputDtoNameSourceEnum _$routeInputDtoNameSourceEnum_MANUAL =
    const RouteInputDtoNameSourceEnum._('MANUAL');

RouteInputDtoNameSourceEnum _$routeInputDtoNameSourceEnumValueOf(String name) {
  switch (name) {
    case 'AUTO':
      return _$routeInputDtoNameSourceEnum_AUTO;
    case 'MANUAL':
      return _$routeInputDtoNameSourceEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteInputDtoNameSourceEnum>
    _$routeInputDtoNameSourceEnumValues =
    BuiltSet<RouteInputDtoNameSourceEnum>(const <RouteInputDtoNameSourceEnum>[
  _$routeInputDtoNameSourceEnum_AUTO,
  _$routeInputDtoNameSourceEnum_MANUAL,
]);

const RouteInputDtoStatusEnum _$routeInputDtoStatusEnum_ACTIVE =
    const RouteInputDtoStatusEnum._('ACTIVE');
const RouteInputDtoStatusEnum _$routeInputDtoStatusEnum_INACTIVE =
    const RouteInputDtoStatusEnum._('INACTIVE');
const RouteInputDtoStatusEnum _$routeInputDtoStatusEnum_DRAFT =
    const RouteInputDtoStatusEnum._('DRAFT');

RouteInputDtoStatusEnum _$routeInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$routeInputDtoStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$routeInputDtoStatusEnum_INACTIVE;
    case 'DRAFT':
      return _$routeInputDtoStatusEnum_DRAFT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteInputDtoStatusEnum> _$routeInputDtoStatusEnumValues =
    BuiltSet<RouteInputDtoStatusEnum>(const <RouteInputDtoStatusEnum>[
  _$routeInputDtoStatusEnum_ACTIVE,
  _$routeInputDtoStatusEnum_INACTIVE,
  _$routeInputDtoStatusEnum_DRAFT,
]);

Serializer<RouteInputDtoNameSourceEnum>
    _$routeInputDtoNameSourceEnumSerializer =
    _$RouteInputDtoNameSourceEnumSerializer();
Serializer<RouteInputDtoStatusEnum> _$routeInputDtoStatusEnumSerializer =
    _$RouteInputDtoStatusEnumSerializer();

class _$RouteInputDtoNameSourceEnumSerializer
    implements PrimitiveSerializer<RouteInputDtoNameSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteInputDtoNameSourceEnum];
  @override
  final String wireName = 'RouteInputDtoNameSourceEnum';

  @override
  Object serialize(Serializers serializers, RouteInputDtoNameSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteInputDtoNameSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteInputDtoNameSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<RouteInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'DRAFT': 'DRAFT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'DRAFT': 'DRAFT',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteInputDtoStatusEnum];
  @override
  final String wireName = 'RouteInputDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, RouteInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteInputDto extends RouteInputDto {
  @override
  final String name;
  @override
  final RouteInputDtoNameSourceEnum? nameSource;
  @override
  final RouteInputDtoStatusEnum status;
  @override
  final String? note;
  @override
  final BuiltList<RouteNamePreviewInputDtoStopsInner> stops;

  factory _$RouteInputDto([void Function(RouteInputDtoBuilder)? updates]) =>
      (RouteInputDtoBuilder()..update(updates))._build();

  _$RouteInputDto._(
      {required this.name,
      this.nameSource,
      required this.status,
      this.note,
      required this.stops})
      : super._();
  @override
  RouteInputDto rebuild(void Function(RouteInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteInputDtoBuilder toBuilder() => RouteInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteInputDto &&
        name == other.name &&
        nameSource == other.nameSource &&
        status == other.status &&
        note == other.note &&
        stops == other.stops;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameSource.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteInputDto')
          ..add('name', name)
          ..add('nameSource', nameSource)
          ..add('status', status)
          ..add('note', note)
          ..add('stops', stops))
        .toString();
  }
}

class RouteInputDtoBuilder
    implements Builder<RouteInputDto, RouteInputDtoBuilder> {
  _$RouteInputDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RouteInputDtoNameSourceEnum? _nameSource;
  RouteInputDtoNameSourceEnum? get nameSource => _$this._nameSource;
  set nameSource(RouteInputDtoNameSourceEnum? nameSource) =>
      _$this._nameSource = nameSource;

  RouteInputDtoStatusEnum? _status;
  RouteInputDtoStatusEnum? get status => _$this._status;
  set status(RouteInputDtoStatusEnum? status) => _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<RouteNamePreviewInputDtoStopsInner>? _stops;
  ListBuilder<RouteNamePreviewInputDtoStopsInner> get stops =>
      _$this._stops ??= ListBuilder<RouteNamePreviewInputDtoStopsInner>();
  set stops(ListBuilder<RouteNamePreviewInputDtoStopsInner>? stops) =>
      _$this._stops = stops;

  RouteInputDtoBuilder() {
    RouteInputDto._defaults(this);
  }

  RouteInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _nameSource = $v.nameSource;
      _status = $v.status;
      _note = $v.note;
      _stops = $v.stops.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteInputDto other) {
    _$v = other as _$RouteInputDto;
  }

  @override
  void update(void Function(RouteInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteInputDto build() => _build();

  _$RouteInputDto _build() {
    _$RouteInputDto _$result;
    try {
      _$result = _$v ??
          _$RouteInputDto._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RouteInputDto', 'name'),
            nameSource: nameSource,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'RouteInputDto', 'status'),
            note: note,
            stops: stops.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stops';
        stops.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RouteInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
