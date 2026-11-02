// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_items_inner_vehicle_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SEATER =
    const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum._('SEATER');
const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SLEEPER =
    const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum._('SLEEPER');
const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_CABIN =
    const TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum._('CABIN');

TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumValueOf(
        String name) {
  switch (name) {
    case 'SEATER':
      return _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SEATER;
    case 'SLEEPER':
      return _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SLEEPER;
    case 'CABIN':
      return _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_CABIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum>
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumValues = BuiltSet<
        TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum>(const <TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum>[
  _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SEATER,
  _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_SLEEPER,
  _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum_CABIN,
]);

const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_STANDARD =
    const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum._(
        'STANDARD');
const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_LIMOUSINE =
    const TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum._(
        'LIMOUSINE');

TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumValueOf(
        String name) {
  switch (name) {
    case 'STANDARD':
      return _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_STANDARD;
    case 'LIMOUSINE':
      return _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_LIMOUSINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum>
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumValues =
    BuiltSet<
        TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum>(const <TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum>[
  _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_STANDARD,
  _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnum_LIMOUSINE,
]);

Serializer<TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum>
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumSerializer =
    _$TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumSerializer();
Serializer<TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum>
    _$tripSearchResponseDtoOutputItemsInnerVehicleTypeClassEnumSerializer =
    _$TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_EnumSerializer();

class _$TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnumSerializer
    implements
        PrimitiveSerializer<
            TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEATER': 'SEATER',
    'SLEEPER': 'SLEEPER',
    'CABIN': 'CABIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEATER': 'SEATER',
    'SLEEPER': 'SLEEPER',
    'CABIN': 'CABIN',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum
  ];
  @override
  final String wireName =
      'TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum';

  @override
  Object serialize(Serializers serializers,
          TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_EnumSerializer
    implements
        PrimitiveSerializer<
            TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum
  ];
  @override
  final String wireName =
      'TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum';

  @override
  Object serialize(Serializers serializers,
          TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripSearchResponseDtoOutputItemsInnerVehicleType
    extends TripSearchResponseDtoOutputItemsInnerVehicleType {
  @override
  final String name;
  @override
  final TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum form;
  @override
  final TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum class_;

  factory _$TripSearchResponseDtoOutputItemsInnerVehicleType(
          [void Function(
                  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder()
            ..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputItemsInnerVehicleType._(
      {required this.name, required this.form, required this.class_})
      : super._();
  @override
  TripSearchResponseDtoOutputItemsInnerVehicleType rebuild(
          void Function(TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder toBuilder() =>
      TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputItemsInnerVehicleType &&
        name == other.name &&
        form == other.form &&
        class_ == other.class_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, form.hashCode);
    _$hash = $jc(_$hash, class_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputItemsInnerVehicleType')
          ..add('name', name)
          ..add('form', form)
          ..add('class_', class_))
        .toString();
  }
}

class TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder
    implements
        Builder<TripSearchResponseDtoOutputItemsInnerVehicleType,
            TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder> {
  _$TripSearchResponseDtoOutputItemsInnerVehicleType? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum? _form;
  TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum? get form =>
      _$this._form;
  set form(TripSearchResponseDtoOutputItemsInnerVehicleTypeFormEnum? form) =>
      _$this._form = form;

  TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum? _class_;
  TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum? get class_ =>
      _$this._class_;
  set class_(
          TripSearchResponseDtoOutputItemsInnerVehicleTypeClass_Enum? class_) =>
      _$this._class_ = class_;

  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder() {
    TripSearchResponseDtoOutputItemsInnerVehicleType._defaults(this);
  }

  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _form = $v.form;
      _class_ = $v.class_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputItemsInnerVehicleType other) {
    _$v = other as _$TripSearchResponseDtoOutputItemsInnerVehicleType;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputItemsInnerVehicleType build() => _build();

  _$TripSearchResponseDtoOutputItemsInnerVehicleType _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputItemsInnerVehicleType._(
          name: BuiltValueNullFieldError.checkNotNull(name,
              r'TripSearchResponseDtoOutputItemsInnerVehicleType', 'name'),
          form: BuiltValueNullFieldError.checkNotNull(form,
              r'TripSearchResponseDtoOutputItemsInnerVehicleType', 'form'),
          class_: BuiltValueNullFieldError.checkNotNull(class_,
              r'TripSearchResponseDtoOutputItemsInnerVehicleType', 'class_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
