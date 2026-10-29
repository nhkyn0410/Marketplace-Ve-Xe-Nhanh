// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response_dto_output_sub_routes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum
    _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_AUTO =
    const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum._('AUTO');
const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum
    _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_MANUAL =
    const RouteResponseDtoOutputSubRoutesInnerNameSourceEnum._('MANUAL');

RouteResponseDtoOutputSubRoutesInnerNameSourceEnum
    _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumValueOf(String name) {
  switch (name) {
    case 'AUTO':
      return _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_AUTO;
    case 'MANUAL':
      return _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteResponseDtoOutputSubRoutesInnerNameSourceEnum>
    _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumValues = BuiltSet<
        RouteResponseDtoOutputSubRoutesInnerNameSourceEnum>(const <RouteResponseDtoOutputSubRoutesInnerNameSourceEnum>[
  _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_AUTO,
  _$routeResponseDtoOutputSubRoutesInnerNameSourceEnum_MANUAL,
]);

const RouteResponseDtoOutputSubRoutesInnerStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerStatusEnum_ACTIVE =
    const RouteResponseDtoOutputSubRoutesInnerStatusEnum._('ACTIVE');
const RouteResponseDtoOutputSubRoutesInnerStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerStatusEnum_INACTIVE =
    const RouteResponseDtoOutputSubRoutesInnerStatusEnum._('INACTIVE');
const RouteResponseDtoOutputSubRoutesInnerStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerStatusEnum_DRAFT =
    const RouteResponseDtoOutputSubRoutesInnerStatusEnum._('DRAFT');

RouteResponseDtoOutputSubRoutesInnerStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$routeResponseDtoOutputSubRoutesInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$routeResponseDtoOutputSubRoutesInnerStatusEnum_INACTIVE;
    case 'DRAFT':
      return _$routeResponseDtoOutputSubRoutesInnerStatusEnum_DRAFT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteResponseDtoOutputSubRoutesInnerStatusEnum>
    _$routeResponseDtoOutputSubRoutesInnerStatusEnumValues = BuiltSet<
        RouteResponseDtoOutputSubRoutesInnerStatusEnum>(const <RouteResponseDtoOutputSubRoutesInnerStatusEnum>[
  _$routeResponseDtoOutputSubRoutesInnerStatusEnum_ACTIVE,
  _$routeResponseDtoOutputSubRoutesInnerStatusEnum_INACTIVE,
  _$routeResponseDtoOutputSubRoutesInnerStatusEnum_DRAFT,
]);

Serializer<RouteResponseDtoOutputSubRoutesInnerNameSourceEnum>
    _$routeResponseDtoOutputSubRoutesInnerNameSourceEnumSerializer =
    _$RouteResponseDtoOutputSubRoutesInnerNameSourceEnumSerializer();
Serializer<RouteResponseDtoOutputSubRoutesInnerStatusEnum>
    _$routeResponseDtoOutputSubRoutesInnerStatusEnumSerializer =
    _$RouteResponseDtoOutputSubRoutesInnerStatusEnumSerializer();

class _$RouteResponseDtoOutputSubRoutesInnerNameSourceEnumSerializer
    implements
        PrimitiveSerializer<
            RouteResponseDtoOutputSubRoutesInnerNameSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RouteResponseDtoOutputSubRoutesInnerNameSourceEnum
  ];
  @override
  final String wireName = 'RouteResponseDtoOutputSubRoutesInnerNameSourceEnum';

  @override
  Object serialize(Serializers serializers,
          RouteResponseDtoOutputSubRoutesInnerNameSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteResponseDtoOutputSubRoutesInnerNameSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteResponseDtoOutputSubRoutesInnerNameSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteResponseDtoOutputSubRoutesInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<RouteResponseDtoOutputSubRoutesInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    RouteResponseDtoOutputSubRoutesInnerStatusEnum
  ];
  @override
  final String wireName = 'RouteResponseDtoOutputSubRoutesInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          RouteResponseDtoOutputSubRoutesInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteResponseDtoOutputSubRoutesInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteResponseDtoOutputSubRoutesInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteResponseDtoOutputSubRoutesInner
    extends RouteResponseDtoOutputSubRoutesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final RouteResponseDtoOutputSubRoutesInnerNameSourceEnum nameSource;
  @override
  final RouteResponseDtoOutputSubRoutesInnerStatusEnum status;
  @override
  final int totalDistanceMeters;
  @override
  final int totalDurationSeconds;
  @override
  final RouteResponseDtoOutputSubRoutesInnerFrom from;
  @override
  final RouteResponseDtoOutputSubRoutesInnerFrom to;
  @override
  final bool needsReview;
  @override
  final RouteResponseDtoOutputSubRoutesInnerFare? fare;

  factory _$RouteResponseDtoOutputSubRoutesInner(
          [void Function(RouteResponseDtoOutputSubRoutesInnerBuilder)?
              updates]) =>
      (RouteResponseDtoOutputSubRoutesInnerBuilder()..update(updates))._build();

  _$RouteResponseDtoOutputSubRoutesInner._(
      {required this.id,
      required this.name,
      required this.nameSource,
      required this.status,
      required this.totalDistanceMeters,
      required this.totalDurationSeconds,
      required this.from,
      required this.to,
      required this.needsReview,
      this.fare})
      : super._();
  @override
  RouteResponseDtoOutputSubRoutesInner rebuild(
          void Function(RouteResponseDtoOutputSubRoutesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteResponseDtoOutputSubRoutesInnerBuilder toBuilder() =>
      RouteResponseDtoOutputSubRoutesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteResponseDtoOutputSubRoutesInner &&
        id == other.id &&
        name == other.name &&
        nameSource == other.nameSource &&
        status == other.status &&
        totalDistanceMeters == other.totalDistanceMeters &&
        totalDurationSeconds == other.totalDurationSeconds &&
        from == other.from &&
        to == other.to &&
        needsReview == other.needsReview &&
        fare == other.fare;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameSource.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, totalDistanceMeters.hashCode);
    _$hash = $jc(_$hash, totalDurationSeconds.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, needsReview.hashCode);
    _$hash = $jc(_$hash, fare.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteResponseDtoOutputSubRoutesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('nameSource', nameSource)
          ..add('status', status)
          ..add('totalDistanceMeters', totalDistanceMeters)
          ..add('totalDurationSeconds', totalDurationSeconds)
          ..add('from', from)
          ..add('to', to)
          ..add('needsReview', needsReview)
          ..add('fare', fare))
        .toString();
  }
}

class RouteResponseDtoOutputSubRoutesInnerBuilder
    implements
        Builder<RouteResponseDtoOutputSubRoutesInner,
            RouteResponseDtoOutputSubRoutesInnerBuilder> {
  _$RouteResponseDtoOutputSubRoutesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RouteResponseDtoOutputSubRoutesInnerNameSourceEnum? _nameSource;
  RouteResponseDtoOutputSubRoutesInnerNameSourceEnum? get nameSource =>
      _$this._nameSource;
  set nameSource(
          RouteResponseDtoOutputSubRoutesInnerNameSourceEnum? nameSource) =>
      _$this._nameSource = nameSource;

  RouteResponseDtoOutputSubRoutesInnerStatusEnum? _status;
  RouteResponseDtoOutputSubRoutesInnerStatusEnum? get status => _$this._status;
  set status(RouteResponseDtoOutputSubRoutesInnerStatusEnum? status) =>
      _$this._status = status;

  int? _totalDistanceMeters;
  int? get totalDistanceMeters => _$this._totalDistanceMeters;
  set totalDistanceMeters(int? totalDistanceMeters) =>
      _$this._totalDistanceMeters = totalDistanceMeters;

  int? _totalDurationSeconds;
  int? get totalDurationSeconds => _$this._totalDurationSeconds;
  set totalDurationSeconds(int? totalDurationSeconds) =>
      _$this._totalDurationSeconds = totalDurationSeconds;

  RouteResponseDtoOutputSubRoutesInnerFromBuilder? _from;
  RouteResponseDtoOutputSubRoutesInnerFromBuilder get from =>
      _$this._from ??= RouteResponseDtoOutputSubRoutesInnerFromBuilder();
  set from(RouteResponseDtoOutputSubRoutesInnerFromBuilder? from) =>
      _$this._from = from;

  RouteResponseDtoOutputSubRoutesInnerFromBuilder? _to;
  RouteResponseDtoOutputSubRoutesInnerFromBuilder get to =>
      _$this._to ??= RouteResponseDtoOutputSubRoutesInnerFromBuilder();
  set to(RouteResponseDtoOutputSubRoutesInnerFromBuilder? to) =>
      _$this._to = to;

  bool? _needsReview;
  bool? get needsReview => _$this._needsReview;
  set needsReview(bool? needsReview) => _$this._needsReview = needsReview;

  RouteResponseDtoOutputSubRoutesInnerFareBuilder? _fare;
  RouteResponseDtoOutputSubRoutesInnerFareBuilder get fare =>
      _$this._fare ??= RouteResponseDtoOutputSubRoutesInnerFareBuilder();
  set fare(RouteResponseDtoOutputSubRoutesInnerFareBuilder? fare) =>
      _$this._fare = fare;

  RouteResponseDtoOutputSubRoutesInnerBuilder() {
    RouteResponseDtoOutputSubRoutesInner._defaults(this);
  }

  RouteResponseDtoOutputSubRoutesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _nameSource = $v.nameSource;
      _status = $v.status;
      _totalDistanceMeters = $v.totalDistanceMeters;
      _totalDurationSeconds = $v.totalDurationSeconds;
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _needsReview = $v.needsReview;
      _fare = $v.fare?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteResponseDtoOutputSubRoutesInner other) {
    _$v = other as _$RouteResponseDtoOutputSubRoutesInner;
  }

  @override
  void update(
      void Function(RouteResponseDtoOutputSubRoutesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteResponseDtoOutputSubRoutesInner build() => _build();

  _$RouteResponseDtoOutputSubRoutesInner _build() {
    _$RouteResponseDtoOutputSubRoutesInner _$result;
    try {
      _$result = _$v ??
          _$RouteResponseDtoOutputSubRoutesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RouteResponseDtoOutputSubRoutesInner', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RouteResponseDtoOutputSubRoutesInner', 'name'),
            nameSource: BuiltValueNullFieldError.checkNotNull(nameSource,
                r'RouteResponseDtoOutputSubRoutesInner', 'nameSource'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'RouteResponseDtoOutputSubRoutesInner', 'status'),
            totalDistanceMeters: BuiltValueNullFieldError.checkNotNull(
                totalDistanceMeters,
                r'RouteResponseDtoOutputSubRoutesInner',
                'totalDistanceMeters'),
            totalDurationSeconds: BuiltValueNullFieldError.checkNotNull(
                totalDurationSeconds,
                r'RouteResponseDtoOutputSubRoutesInner',
                'totalDurationSeconds'),
            from: from.build(),
            to: to.build(),
            needsReview: BuiltValueNullFieldError.checkNotNull(needsReview,
                r'RouteResponseDtoOutputSubRoutesInner', 'needsReview'),
            fare: _fare?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();

        _$failedField = 'fare';
        _fare?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RouteResponseDtoOutputSubRoutesInner',
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
