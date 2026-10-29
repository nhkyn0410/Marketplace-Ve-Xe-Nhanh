// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_response_dto_output_sub_routes_inner_fare.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_ACTIVE =
    const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum._('ACTIVE');
const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_INACTIVE =
    const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum._('INACTIVE');

RouteResponseDtoOutputSubRoutesInnerFareStatusEnum
    _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteResponseDtoOutputSubRoutesInnerFareStatusEnum>
    _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumValues = BuiltSet<
        RouteResponseDtoOutputSubRoutesInnerFareStatusEnum>(const <RouteResponseDtoOutputSubRoutesInnerFareStatusEnum>[
  _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_ACTIVE,
  _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_INACTIVE,
]);

Serializer<RouteResponseDtoOutputSubRoutesInnerFareStatusEnum>
    _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumSerializer =
    _$RouteResponseDtoOutputSubRoutesInnerFareStatusEnumSerializer();

class _$RouteResponseDtoOutputSubRoutesInnerFareStatusEnumSerializer
    implements
        PrimitiveSerializer<
            RouteResponseDtoOutputSubRoutesInnerFareStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RouteResponseDtoOutputSubRoutesInnerFareStatusEnum
  ];
  @override
  final String wireName = 'RouteResponseDtoOutputSubRoutesInnerFareStatusEnum';

  @override
  Object serialize(Serializers serializers,
          RouteResponseDtoOutputSubRoutesInnerFareStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteResponseDtoOutputSubRoutesInnerFareStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteResponseDtoOutputSubRoutesInnerFareStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteResponseDtoOutputSubRoutesInnerFare
    extends RouteResponseDtoOutputSubRoutesInnerFare {
  @override
  final String id;
  @override
  final RouteResponseDtoOutputSubRoutesInnerFareStatusEnum status;
  @override
  final int? minPrice;
  @override
  final int? maxPrice;

  factory _$RouteResponseDtoOutputSubRoutesInnerFare(
          [void Function(RouteResponseDtoOutputSubRoutesInnerFareBuilder)?
              updates]) =>
      (RouteResponseDtoOutputSubRoutesInnerFareBuilder()..update(updates))
          ._build();

  _$RouteResponseDtoOutputSubRoutesInnerFare._(
      {required this.id, required this.status, this.minPrice, this.maxPrice})
      : super._();
  @override
  RouteResponseDtoOutputSubRoutesInnerFare rebuild(
          void Function(RouteResponseDtoOutputSubRoutesInnerFareBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteResponseDtoOutputSubRoutesInnerFareBuilder toBuilder() =>
      RouteResponseDtoOutputSubRoutesInnerFareBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteResponseDtoOutputSubRoutesInnerFare &&
        id == other.id &&
        status == other.status &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, maxPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'RouteResponseDtoOutputSubRoutesInnerFare')
          ..add('id', id)
          ..add('status', status)
          ..add('minPrice', minPrice)
          ..add('maxPrice', maxPrice))
        .toString();
  }
}

class RouteResponseDtoOutputSubRoutesInnerFareBuilder
    implements
        Builder<RouteResponseDtoOutputSubRoutesInnerFare,
            RouteResponseDtoOutputSubRoutesInnerFareBuilder> {
  _$RouteResponseDtoOutputSubRoutesInnerFare? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  RouteResponseDtoOutputSubRoutesInnerFareStatusEnum? _status;
  RouteResponseDtoOutputSubRoutesInnerFareStatusEnum? get status =>
      _$this._status;
  set status(RouteResponseDtoOutputSubRoutesInnerFareStatusEnum? status) =>
      _$this._status = status;

  int? _minPrice;
  int? get minPrice => _$this._minPrice;
  set minPrice(int? minPrice) => _$this._minPrice = minPrice;

  int? _maxPrice;
  int? get maxPrice => _$this._maxPrice;
  set maxPrice(int? maxPrice) => _$this._maxPrice = maxPrice;

  RouteResponseDtoOutputSubRoutesInnerFareBuilder() {
    RouteResponseDtoOutputSubRoutesInnerFare._defaults(this);
  }

  RouteResponseDtoOutputSubRoutesInnerFareBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _minPrice = $v.minPrice;
      _maxPrice = $v.maxPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteResponseDtoOutputSubRoutesInnerFare other) {
    _$v = other as _$RouteResponseDtoOutputSubRoutesInnerFare;
  }

  @override
  void update(
      void Function(RouteResponseDtoOutputSubRoutesInnerFareBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteResponseDtoOutputSubRoutesInnerFare build() => _build();

  _$RouteResponseDtoOutputSubRoutesInnerFare _build() {
    final _$result = _$v ??
        _$RouteResponseDtoOutputSubRoutesInnerFare._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'RouteResponseDtoOutputSubRoutesInnerFare', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'RouteResponseDtoOutputSubRoutesInnerFare', 'status'),
          minPrice: minPrice,
          maxPrice: maxPrice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
