// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_route_suggestion_list_dto_output_items_inner_suggested_rules_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_SEAT =
    const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
        ._('SEAT');
const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED =
    const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
        ._('BED');
const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED_DOUBLE =
    const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
        ._('BED_DOUBLE');
const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN =
    const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
        ._('CABIN');
const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN_DOUBLE =
    const SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
        ._('CABIN_DOUBLE');

SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'SEAT':
      return _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_SEAT;
    case 'BED':
      return _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum>
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumValues =
    BuiltSet<
        SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum>(const <SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum>[
  _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_SEAT,
  _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED,
  _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_BED_DOUBLE,
  _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN,
  _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum_CABIN_DOUBLE,
]);

Serializer<
        SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum>
    _$subRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumSerializer =
    _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumSerializer();

class _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnumSerializer
    implements
        PrimitiveSerializer<
            SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum> {
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
    SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
  ];
  @override
  final String wireName =
      'SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum';

  @override
  Object serialize(
          Serializers serializers,
          SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner
    extends SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner {
  @override
  final String? vehicleTypeId;
  @override
  final SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum?
      seatType;
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validTo;
  @override
  final int price;

  factory _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner(
          [void Function(
                  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder)?
              updates]) =>
      (SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder()
            ..update(updates))
          ._build();

  _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner._(
      {this.vehicleTypeId,
      this.seatType,
      this.validFrom,
      this.validTo,
      required this.price})
      : super._();
  @override
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner rebuild(
          void Function(
                  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder
      toBuilder() =>
          SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner &&
        vehicleTypeId == other.vehicleTypeId &&
        seatType == other.seatType &&
        validFrom == other.validFrom &&
        validTo == other.validTo &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleTypeId.hashCode);
    _$hash = $jc(_$hash, seatType.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner')
          ..add('vehicleTypeId', vehicleTypeId)
          ..add('seatType', seatType)
          ..add('validFrom', validFrom)
          ..add('validTo', validTo)
          ..add('price', price))
        .toString();
  }
}

class SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder
    implements
        Builder<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner,
            SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder> {
  _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner? _$v;

  String? _vehicleTypeId;
  String? get vehicleTypeId => _$this._vehicleTypeId;
  set vehicleTypeId(String? vehicleTypeId) =>
      _$this._vehicleTypeId = vehicleTypeId;

  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum?
      _seatType;
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum?
      get seatType => _$this._seatType;
  set seatType(
          SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerSeatTypeEnum?
              seatType) =>
      _$this._seatType = seatType;

  DateTime? _validFrom;
  DateTime? get validFrom => _$this._validFrom;
  set validFrom(DateTime? validFrom) => _$this._validFrom = validFrom;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder() {
    SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner._defaults(
        this);
  }

  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder
      get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleTypeId = $v.vehicleTypeId;
      _seatType = $v.seatType;
      _validFrom = $v.validFrom;
      _validTo = $v.validTo;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner other) {
    _$v =
        other as _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner;
  }

  @override
  void update(
      void Function(
              SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner build() =>
      _build();

  _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner _build() {
    final _$result = _$v ??
        _$SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner._(
          vehicleTypeId: vehicleTypeId,
          seatType: seatType,
          validFrom: validFrom,
          validTo: validTo,
          price: BuiltValueNullFieldError.checkNotNull(
              price,
              r'SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner',
              'price'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
