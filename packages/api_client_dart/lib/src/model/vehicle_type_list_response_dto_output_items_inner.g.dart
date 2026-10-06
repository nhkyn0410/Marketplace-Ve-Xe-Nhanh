// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_list_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VehicleTypeListResponseDtoOutputItemsInnerFormEnum
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SEATER =
    const VehicleTypeListResponseDtoOutputItemsInnerFormEnum._('SEATER');
const VehicleTypeListResponseDtoOutputItemsInnerFormEnum
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SLEEPER =
    const VehicleTypeListResponseDtoOutputItemsInnerFormEnum._('SLEEPER');
const VehicleTypeListResponseDtoOutputItemsInnerFormEnum
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_CABIN =
    const VehicleTypeListResponseDtoOutputItemsInnerFormEnum._('CABIN');

VehicleTypeListResponseDtoOutputItemsInnerFormEnum
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumValueOf(String name) {
  switch (name) {
    case 'SEATER':
      return _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SEATER;
    case 'SLEEPER':
      return _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SLEEPER;
    case 'CABIN':
      return _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_CABIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VehicleTypeListResponseDtoOutputItemsInnerFormEnum>
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumValues = BuiltSet<
        VehicleTypeListResponseDtoOutputItemsInnerFormEnum>(const <VehicleTypeListResponseDtoOutputItemsInnerFormEnum>[
  _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SEATER,
  _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_SLEEPER,
  _$vehicleTypeListResponseDtoOutputItemsInnerFormEnum_CABIN,
]);

const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum
    _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_STANDARD =
    const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum._('STANDARD');
const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum
    _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_LIMOUSINE =
    const VehicleTypeListResponseDtoOutputItemsInnerClass_Enum._('LIMOUSINE');

VehicleTypeListResponseDtoOutputItemsInnerClass_Enum
    _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumValueOf(String name) {
  switch (name) {
    case 'STANDARD':
      return _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_STANDARD;
    case 'LIMOUSINE':
      return _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_LIMOUSINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VehicleTypeListResponseDtoOutputItemsInnerClass_Enum>
    _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumValues = BuiltSet<
        VehicleTypeListResponseDtoOutputItemsInnerClass_Enum>(const <VehicleTypeListResponseDtoOutputItemsInnerClass_Enum>[
  _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_STANDARD,
  _$vehicleTypeListResponseDtoOutputItemsInnerClassEnum_LIMOUSINE,
]);

Serializer<VehicleTypeListResponseDtoOutputItemsInnerFormEnum>
    _$vehicleTypeListResponseDtoOutputItemsInnerFormEnumSerializer =
    _$VehicleTypeListResponseDtoOutputItemsInnerFormEnumSerializer();
Serializer<VehicleTypeListResponseDtoOutputItemsInnerClass_Enum>
    _$vehicleTypeListResponseDtoOutputItemsInnerClassEnumSerializer =
    _$VehicleTypeListResponseDtoOutputItemsInnerClass_EnumSerializer();

class _$VehicleTypeListResponseDtoOutputItemsInnerFormEnumSerializer
    implements
        PrimitiveSerializer<
            VehicleTypeListResponseDtoOutputItemsInnerFormEnum> {
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
    VehicleTypeListResponseDtoOutputItemsInnerFormEnum
  ];
  @override
  final String wireName = 'VehicleTypeListResponseDtoOutputItemsInnerFormEnum';

  @override
  Object serialize(Serializers serializers,
          VehicleTypeListResponseDtoOutputItemsInnerFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VehicleTypeListResponseDtoOutputItemsInnerFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VehicleTypeListResponseDtoOutputItemsInnerFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VehicleTypeListResponseDtoOutputItemsInnerClass_EnumSerializer
    implements
        PrimitiveSerializer<
            VehicleTypeListResponseDtoOutputItemsInnerClass_Enum> {
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
    VehicleTypeListResponseDtoOutputItemsInnerClass_Enum
  ];
  @override
  final String wireName =
      'VehicleTypeListResponseDtoOutputItemsInnerClass_Enum';

  @override
  Object serialize(Serializers serializers,
          VehicleTypeListResponseDtoOutputItemsInnerClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VehicleTypeListResponseDtoOutputItemsInnerClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VehicleTypeListResponseDtoOutputItemsInnerClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VehicleTypeListResponseDtoOutputItemsInner
    extends VehicleTypeListResponseDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final VehicleTypeListResponseDtoOutputItemsInnerFormEnum form;
  @override
  final VehicleTypeListResponseDtoOutputItemsInnerClass_Enum class_;

  factory _$VehicleTypeListResponseDtoOutputItemsInner(
          [void Function(VehicleTypeListResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (VehicleTypeListResponseDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$VehicleTypeListResponseDtoOutputItemsInner._(
      {required this.id,
      required this.code,
      required this.name,
      this.description,
      required this.form,
      required this.class_})
      : super._();
  @override
  VehicleTypeListResponseDtoOutputItemsInner rebuild(
          void Function(VehicleTypeListResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleTypeListResponseDtoOutputItemsInnerBuilder toBuilder() =>
      VehicleTypeListResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleTypeListResponseDtoOutputItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        form == other.form &&
        class_ == other.class_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, form.hashCode);
    _$hash = $jc(_$hash, class_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VehicleTypeListResponseDtoOutputItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('form', form)
          ..add('class_', class_))
        .toString();
  }
}

class VehicleTypeListResponseDtoOutputItemsInnerBuilder
    implements
        Builder<VehicleTypeListResponseDtoOutputItemsInner,
            VehicleTypeListResponseDtoOutputItemsInnerBuilder> {
  _$VehicleTypeListResponseDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  VehicleTypeListResponseDtoOutputItemsInnerFormEnum? _form;
  VehicleTypeListResponseDtoOutputItemsInnerFormEnum? get form => _$this._form;
  set form(VehicleTypeListResponseDtoOutputItemsInnerFormEnum? form) =>
      _$this._form = form;

  VehicleTypeListResponseDtoOutputItemsInnerClass_Enum? _class_;
  VehicleTypeListResponseDtoOutputItemsInnerClass_Enum? get class_ =>
      _$this._class_;
  set class_(VehicleTypeListResponseDtoOutputItemsInnerClass_Enum? class_) =>
      _$this._class_ = class_;

  VehicleTypeListResponseDtoOutputItemsInnerBuilder() {
    VehicleTypeListResponseDtoOutputItemsInner._defaults(this);
  }

  VehicleTypeListResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _description = $v.description;
      _form = $v.form;
      _class_ = $v.class_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleTypeListResponseDtoOutputItemsInner other) {
    _$v = other as _$VehicleTypeListResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(VehicleTypeListResponseDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleTypeListResponseDtoOutputItemsInner build() => _build();

  _$VehicleTypeListResponseDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$VehicleTypeListResponseDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VehicleTypeListResponseDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'VehicleTypeListResponseDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VehicleTypeListResponseDtoOutputItemsInner', 'name'),
          description: description,
          form: BuiltValueNullFieldError.checkNotNull(
              form, r'VehicleTypeListResponseDtoOutputItemsInner', 'form'),
          class_: BuiltValueNullFieldError.checkNotNull(
              class_, r'VehicleTypeListResponseDtoOutputItemsInner', 'class_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
