// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_seats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnum_SEAT =
    const PublicTripDtoOutputSeatsInnerTypeEnum._('SEAT');
const PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnum_BED =
    const PublicTripDtoOutputSeatsInnerTypeEnum._('BED');
const PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnum_BED_DOUBLE =
    const PublicTripDtoOutputSeatsInnerTypeEnum._('BED_DOUBLE');
const PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN =
    const PublicTripDtoOutputSeatsInnerTypeEnum._('CABIN');
const PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE =
    const PublicTripDtoOutputSeatsInnerTypeEnum._('CABIN_DOUBLE');

PublicTripDtoOutputSeatsInnerTypeEnum
    _$publicTripDtoOutputSeatsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'SEAT':
      return _$publicTripDtoOutputSeatsInnerTypeEnum_SEAT;
    case 'BED':
      return _$publicTripDtoOutputSeatsInnerTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$publicTripDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicTripDtoOutputSeatsInnerTypeEnum>
    _$publicTripDtoOutputSeatsInnerTypeEnumValues = BuiltSet<
        PublicTripDtoOutputSeatsInnerTypeEnum>(const <PublicTripDtoOutputSeatsInnerTypeEnum>[
  _$publicTripDtoOutputSeatsInnerTypeEnum_SEAT,
  _$publicTripDtoOutputSeatsInnerTypeEnum_BED,
  _$publicTripDtoOutputSeatsInnerTypeEnum_BED_DOUBLE,
  _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN,
  _$publicTripDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE,
]);

const PublicTripDtoOutputSeatsInnerStatusEnum
    _$publicTripDtoOutputSeatsInnerStatusEnum_AVAILABLE =
    const PublicTripDtoOutputSeatsInnerStatusEnum._('AVAILABLE');
const PublicTripDtoOutputSeatsInnerStatusEnum
    _$publicTripDtoOutputSeatsInnerStatusEnum_UNAVAILABLE =
    const PublicTripDtoOutputSeatsInnerStatusEnum._('UNAVAILABLE');

PublicTripDtoOutputSeatsInnerStatusEnum
    _$publicTripDtoOutputSeatsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$publicTripDtoOutputSeatsInnerStatusEnum_AVAILABLE;
    case 'UNAVAILABLE':
      return _$publicTripDtoOutputSeatsInnerStatusEnum_UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicTripDtoOutputSeatsInnerStatusEnum>
    _$publicTripDtoOutputSeatsInnerStatusEnumValues = BuiltSet<
        PublicTripDtoOutputSeatsInnerStatusEnum>(const <PublicTripDtoOutputSeatsInnerStatusEnum>[
  _$publicTripDtoOutputSeatsInnerStatusEnum_AVAILABLE,
  _$publicTripDtoOutputSeatsInnerStatusEnum_UNAVAILABLE,
]);

Serializer<PublicTripDtoOutputSeatsInnerTypeEnum>
    _$publicTripDtoOutputSeatsInnerTypeEnumSerializer =
    _$PublicTripDtoOutputSeatsInnerTypeEnumSerializer();
Serializer<PublicTripDtoOutputSeatsInnerStatusEnum>
    _$publicTripDtoOutputSeatsInnerStatusEnumSerializer =
    _$PublicTripDtoOutputSeatsInnerStatusEnumSerializer();

class _$PublicTripDtoOutputSeatsInnerTypeEnumSerializer
    implements PrimitiveSerializer<PublicTripDtoOutputSeatsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEAT': 'SEAT',
    'BED': 'BED',
    'BED_DOUBLE': 'BED_DOUBLE',
    'CABIN': 'CABIN',
    'CABIN_DOUBLE': 'CABIN_DOUBLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEAT': 'SEAT',
    'BED': 'BED',
    'BED_DOUBLE': 'BED_DOUBLE',
    'CABIN': 'CABIN',
    'CABIN_DOUBLE': 'CABIN_DOUBLE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicTripDtoOutputSeatsInnerTypeEnum
  ];
  @override
  final String wireName = 'PublicTripDtoOutputSeatsInnerTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PublicTripDtoOutputSeatsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicTripDtoOutputSeatsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicTripDtoOutputSeatsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicTripDtoOutputSeatsInnerStatusEnumSerializer
    implements PrimitiveSerializer<PublicTripDtoOutputSeatsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicTripDtoOutputSeatsInnerStatusEnum
  ];
  @override
  final String wireName = 'PublicTripDtoOutputSeatsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PublicTripDtoOutputSeatsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicTripDtoOutputSeatsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicTripDtoOutputSeatsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicTripDtoOutputSeatsInner extends PublicTripDtoOutputSeatsInner {
  @override
  final String code;
  @override
  final int deck;
  @override
  final int row;
  @override
  final int column;
  @override
  final PublicTripDtoOutputSeatsInnerTypeEnum type;
  @override
  final PublicTripDtoOutputSeatsInnerStatusEnum status;
  @override
  final int? price;

  factory _$PublicTripDtoOutputSeatsInner(
          [void Function(PublicTripDtoOutputSeatsInnerBuilder)? updates]) =>
      (PublicTripDtoOutputSeatsInnerBuilder()..update(updates))._build();

  _$PublicTripDtoOutputSeatsInner._(
      {required this.code,
      required this.deck,
      required this.row,
      required this.column,
      required this.type,
      required this.status,
      this.price})
      : super._();
  @override
  PublicTripDtoOutputSeatsInner rebuild(
          void Function(PublicTripDtoOutputSeatsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputSeatsInnerBuilder toBuilder() =>
      PublicTripDtoOutputSeatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputSeatsInner &&
        code == other.code &&
        deck == other.deck &&
        row == other.row &&
        column == other.column &&
        type == other.type &&
        status == other.status &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, deck.hashCode);
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, column.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicTripDtoOutputSeatsInner')
          ..add('code', code)
          ..add('deck', deck)
          ..add('row', row)
          ..add('column', column)
          ..add('type', type)
          ..add('status', status)
          ..add('price', price))
        .toString();
  }
}

class PublicTripDtoOutputSeatsInnerBuilder
    implements
        Builder<PublicTripDtoOutputSeatsInner,
            PublicTripDtoOutputSeatsInnerBuilder> {
  _$PublicTripDtoOutputSeatsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  int? _deck;
  int? get deck => _$this._deck;
  set deck(int? deck) => _$this._deck = deck;

  int? _row;
  int? get row => _$this._row;
  set row(int? row) => _$this._row = row;

  int? _column;
  int? get column => _$this._column;
  set column(int? column) => _$this._column = column;

  PublicTripDtoOutputSeatsInnerTypeEnum? _type;
  PublicTripDtoOutputSeatsInnerTypeEnum? get type => _$this._type;
  set type(PublicTripDtoOutputSeatsInnerTypeEnum? type) => _$this._type = type;

  PublicTripDtoOutputSeatsInnerStatusEnum? _status;
  PublicTripDtoOutputSeatsInnerStatusEnum? get status => _$this._status;
  set status(PublicTripDtoOutputSeatsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  PublicTripDtoOutputSeatsInnerBuilder() {
    PublicTripDtoOutputSeatsInner._defaults(this);
  }

  PublicTripDtoOutputSeatsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _deck = $v.deck;
      _row = $v.row;
      _column = $v.column;
      _type = $v.type;
      _status = $v.status;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputSeatsInner other) {
    _$v = other as _$PublicTripDtoOutputSeatsInner;
  }

  @override
  void update(void Function(PublicTripDtoOutputSeatsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputSeatsInner build() => _build();

  _$PublicTripDtoOutputSeatsInner _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputSeatsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PublicTripDtoOutputSeatsInner', 'code'),
          deck: BuiltValueNullFieldError.checkNotNull(
              deck, r'PublicTripDtoOutputSeatsInner', 'deck'),
          row: BuiltValueNullFieldError.checkNotNull(
              row, r'PublicTripDtoOutputSeatsInner', 'row'),
          column: BuiltValueNullFieldError.checkNotNull(
              column, r'PublicTripDtoOutputSeatsInner', 'column'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'PublicTripDtoOutputSeatsInner', 'type'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PublicTripDtoOutputSeatsInner', 'status'),
          price: price,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
