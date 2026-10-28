// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion_list_response_dto_output_items_inner_target.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_province =
    const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum._(
        'province');
const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_ward =
    const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum._(
        'ward');
const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_stopPoint =
    const PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum._(
        'stopPoint');

PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'province':
      return _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_province;
    case 'ward':
      return _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_ward;
    case 'stopPoint':
      return _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_stopPoint;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum>
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumValues =
    BuiltSet<
        PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum>(const <PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum>[
  _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_province,
  _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_ward,
  _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum_stopPoint,
]);

Serializer<PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum>
    _$placeSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumSerializer =
    _$PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumSerializer();

class _$PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnumSerializer
    implements
        PrimitiveSerializer<
            PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'province': 'province',
    'ward': 'ward',
    'stopPoint': 'stopPoint',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'province': 'province',
    'ward': 'ward',
    'stopPoint': 'stopPoint',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum
  ];
  @override
  final String wireName =
      'PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum';

  @override
  Object serialize(Serializers serializers,
          PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget
    extends PlaceSuggestionListResponseDtoOutputItemsInnerTarget {
  @override
  final PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum type;
  @override
  final String id;

  factory _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget(
          [void Function(
                  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder)?
              updates]) =>
      (PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder()
            ..update(updates))
          ._build();

  _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget._(
      {required this.type, required this.id})
      : super._();
  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerTarget rebuild(
          void Function(
                  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder toBuilder() =>
      PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlaceSuggestionListResponseDtoOutputItemsInnerTarget &&
        type == other.type &&
        id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PlaceSuggestionListResponseDtoOutputItemsInnerTarget')
          ..add('type', type)
          ..add('id', id))
        .toString();
  }
}

class PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder
    implements
        Builder<PlaceSuggestionListResponseDtoOutputItemsInnerTarget,
            PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder> {
  _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget? _$v;

  PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum? _type;
  PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum? get type =>
      _$this._type;
  set type(
          PlaceSuggestionListResponseDtoOutputItemsInnerTargetTypeEnum? type) =>
      _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder() {
    PlaceSuggestionListResponseDtoOutputItemsInnerTarget._defaults(this);
  }

  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlaceSuggestionListResponseDtoOutputItemsInnerTarget other) {
    _$v = other as _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget;
  }

  @override
  void update(
      void Function(
              PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerTarget build() => _build();

  _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget _build() {
    final _$result = _$v ??
        _$PlaceSuggestionListResponseDtoOutputItemsInnerTarget._(
          type: BuiltValueNullFieldError.checkNotNull(type,
              r'PlaceSuggestionListResponseDtoOutputItemsInnerTarget', 'type'),
          id: BuiltValueNullFieldError.checkNotNull(id,
              r'PlaceSuggestionListResponseDtoOutputItemsInnerTarget', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
