// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion_list_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_PROVINCE =
    const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum._('PROVINCE');
const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_WARD =
    const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum._('WARD');
const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_STOP_POINT =
    const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum._(
        'STOP_POINT');
const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_LEGACY =
    const PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum._('LEGACY');

PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumValueOf(
        String name) {
  switch (name) {
    case 'PROVINCE':
      return _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_PROVINCE;
    case 'WARD':
      return _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_WARD;
    case 'STOP_POINT':
      return _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_STOP_POINT;
    case 'LEGACY':
      return _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_LEGACY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum>
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumValues = BuiltSet<
        PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum>(const <PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum>[
  _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_PROVINCE,
  _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_WARD,
  _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_STOP_POINT,
  _$placeSuggestionListResponseDtoOutputItemsInnerKindEnum_LEGACY,
]);

Serializer<PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum>
    _$placeSuggestionListResponseDtoOutputItemsInnerKindEnumSerializer =
    _$PlaceSuggestionListResponseDtoOutputItemsInnerKindEnumSerializer();

class _$PlaceSuggestionListResponseDtoOutputItemsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
            PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROVINCE': 'PROVINCE',
    'WARD': 'WARD',
    'STOP_POINT': 'STOP_POINT',
    'LEGACY': 'LEGACY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROVINCE': 'PROVINCE',
    'WARD': 'WARD',
    'STOP_POINT': 'STOP_POINT',
    'LEGACY': 'LEGACY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum
  ];
  @override
  final String wireName =
      'PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum';

  @override
  Object serialize(Serializers serializers,
          PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlaceSuggestionListResponseDtoOutputItemsInner
    extends PlaceSuggestionListResponseDtoOutputItemsInner {
  @override
  final PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum kind;
  @override
  final String label;
  @override
  final String? detail;
  @override
  final PlaceSuggestionListResponseDtoOutputItemsInnerTarget target;

  factory _$PlaceSuggestionListResponseDtoOutputItemsInner(
          [void Function(PlaceSuggestionListResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PlaceSuggestionListResponseDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PlaceSuggestionListResponseDtoOutputItemsInner._(
      {required this.kind,
      required this.label,
      this.detail,
      required this.target})
      : super._();
  @override
  PlaceSuggestionListResponseDtoOutputItemsInner rebuild(
          void Function(PlaceSuggestionListResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaceSuggestionListResponseDtoOutputItemsInnerBuilder toBuilder() =>
      PlaceSuggestionListResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlaceSuggestionListResponseDtoOutputItemsInner &&
        kind == other.kind &&
        label == other.label &&
        detail == other.detail &&
        target == other.target;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PlaceSuggestionListResponseDtoOutputItemsInner')
          ..add('kind', kind)
          ..add('label', label)
          ..add('detail', detail)
          ..add('target', target))
        .toString();
  }
}

class PlaceSuggestionListResponseDtoOutputItemsInnerBuilder
    implements
        Builder<PlaceSuggestionListResponseDtoOutputItemsInner,
            PlaceSuggestionListResponseDtoOutputItemsInnerBuilder> {
  _$PlaceSuggestionListResponseDtoOutputItemsInner? _$v;

  PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum? _kind;
  PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(PlaceSuggestionListResponseDtoOutputItemsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder? _target;
  PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder get target =>
      _$this._target ??=
          PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder();
  set target(
          PlaceSuggestionListResponseDtoOutputItemsInnerTargetBuilder?
              target) =>
      _$this._target = target;

  PlaceSuggestionListResponseDtoOutputItemsInnerBuilder() {
    PlaceSuggestionListResponseDtoOutputItemsInner._defaults(this);
  }

  PlaceSuggestionListResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _label = $v.label;
      _detail = $v.detail;
      _target = $v.target.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlaceSuggestionListResponseDtoOutputItemsInner other) {
    _$v = other as _$PlaceSuggestionListResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PlaceSuggestionListResponseDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PlaceSuggestionListResponseDtoOutputItemsInner build() => _build();

  _$PlaceSuggestionListResponseDtoOutputItemsInner _build() {
    _$PlaceSuggestionListResponseDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$PlaceSuggestionListResponseDtoOutputItemsInner._(
            kind: BuiltValueNullFieldError.checkNotNull(kind,
                r'PlaceSuggestionListResponseDtoOutputItemsInner', 'kind'),
            label: BuiltValueNullFieldError.checkNotNull(label,
                r'PlaceSuggestionListResponseDtoOutputItemsInner', 'label'),
            detail: detail,
            target: target.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'target';
        target.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlaceSuggestionListResponseDtoOutputItemsInner',
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
