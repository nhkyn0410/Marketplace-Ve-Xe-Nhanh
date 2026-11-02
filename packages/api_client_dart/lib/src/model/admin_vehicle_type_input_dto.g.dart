// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_type_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminVehicleTypeInputDtoFormEnum
    _$adminVehicleTypeInputDtoFormEnum_SEATER =
    const AdminVehicleTypeInputDtoFormEnum._('SEATER');
const AdminVehicleTypeInputDtoFormEnum
    _$adminVehicleTypeInputDtoFormEnum_SLEEPER =
    const AdminVehicleTypeInputDtoFormEnum._('SLEEPER');
const AdminVehicleTypeInputDtoFormEnum
    _$adminVehicleTypeInputDtoFormEnum_CABIN =
    const AdminVehicleTypeInputDtoFormEnum._('CABIN');

AdminVehicleTypeInputDtoFormEnum _$adminVehicleTypeInputDtoFormEnumValueOf(
    String name) {
  switch (name) {
    case 'SEATER':
      return _$adminVehicleTypeInputDtoFormEnum_SEATER;
    case 'SLEEPER':
      return _$adminVehicleTypeInputDtoFormEnum_SLEEPER;
    case 'CABIN':
      return _$adminVehicleTypeInputDtoFormEnum_CABIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeInputDtoFormEnum>
    _$adminVehicleTypeInputDtoFormEnumValues = BuiltSet<
        AdminVehicleTypeInputDtoFormEnum>(const <AdminVehicleTypeInputDtoFormEnum>[
  _$adminVehicleTypeInputDtoFormEnum_SEATER,
  _$adminVehicleTypeInputDtoFormEnum_SLEEPER,
  _$adminVehicleTypeInputDtoFormEnum_CABIN,
]);

const AdminVehicleTypeInputDtoClass_Enum
    _$adminVehicleTypeInputDtoClassEnum_STANDARD =
    const AdminVehicleTypeInputDtoClass_Enum._('STANDARD');
const AdminVehicleTypeInputDtoClass_Enum
    _$adminVehicleTypeInputDtoClassEnum_LIMOUSINE =
    const AdminVehicleTypeInputDtoClass_Enum._('LIMOUSINE');

AdminVehicleTypeInputDtoClass_Enum _$adminVehicleTypeInputDtoClassEnumValueOf(
    String name) {
  switch (name) {
    case 'STANDARD':
      return _$adminVehicleTypeInputDtoClassEnum_STANDARD;
    case 'LIMOUSINE':
      return _$adminVehicleTypeInputDtoClassEnum_LIMOUSINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeInputDtoClass_Enum>
    _$adminVehicleTypeInputDtoClassEnumValues = BuiltSet<
        AdminVehicleTypeInputDtoClass_Enum>(const <AdminVehicleTypeInputDtoClass_Enum>[
  _$adminVehicleTypeInputDtoClassEnum_STANDARD,
  _$adminVehicleTypeInputDtoClassEnum_LIMOUSINE,
]);

Serializer<AdminVehicleTypeInputDtoFormEnum>
    _$adminVehicleTypeInputDtoFormEnumSerializer =
    _$AdminVehicleTypeInputDtoFormEnumSerializer();
Serializer<AdminVehicleTypeInputDtoClass_Enum>
    _$adminVehicleTypeInputDtoClassEnumSerializer =
    _$AdminVehicleTypeInputDtoClass_EnumSerializer();

class _$AdminVehicleTypeInputDtoFormEnumSerializer
    implements PrimitiveSerializer<AdminVehicleTypeInputDtoFormEnum> {
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
  final Iterable<Type> types = const <Type>[AdminVehicleTypeInputDtoFormEnum];
  @override
  final String wireName = 'AdminVehicleTypeInputDtoFormEnum';

  @override
  Object serialize(
          Serializers serializers, AdminVehicleTypeInputDtoFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeInputDtoFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeInputDtoFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeInputDtoClass_EnumSerializer
    implements PrimitiveSerializer<AdminVehicleTypeInputDtoClass_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminVehicleTypeInputDtoClass_Enum];
  @override
  final String wireName = 'AdminVehicleTypeInputDtoClass_Enum';

  @override
  Object serialize(
          Serializers serializers, AdminVehicleTypeInputDtoClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeInputDtoClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeInputDtoClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeInputDto extends AdminVehicleTypeInputDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final AdminVehicleTypeInputDtoFormEnum form;
  @override
  final AdminVehicleTypeInputDtoClass_Enum class_;

  factory _$AdminVehicleTypeInputDto(
          [void Function(AdminVehicleTypeInputDtoBuilder)? updates]) =>
      (AdminVehicleTypeInputDtoBuilder()..update(updates))._build();

  _$AdminVehicleTypeInputDto._(
      {required this.code,
      required this.name,
      this.description,
      required this.form,
      required this.class_})
      : super._();
  @override
  AdminVehicleTypeInputDto rebuild(
          void Function(AdminVehicleTypeInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleTypeInputDtoBuilder toBuilder() =>
      AdminVehicleTypeInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleTypeInputDto &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        form == other.form &&
        class_ == other.class_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(r'AdminVehicleTypeInputDto')
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('form', form)
          ..add('class_', class_))
        .toString();
  }
}

class AdminVehicleTypeInputDtoBuilder
    implements
        Builder<AdminVehicleTypeInputDto, AdminVehicleTypeInputDtoBuilder> {
  _$AdminVehicleTypeInputDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminVehicleTypeInputDtoFormEnum? _form;
  AdminVehicleTypeInputDtoFormEnum? get form => _$this._form;
  set form(AdminVehicleTypeInputDtoFormEnum? form) => _$this._form = form;

  AdminVehicleTypeInputDtoClass_Enum? _class_;
  AdminVehicleTypeInputDtoClass_Enum? get class_ => _$this._class_;
  set class_(AdminVehicleTypeInputDtoClass_Enum? class_) =>
      _$this._class_ = class_;

  AdminVehicleTypeInputDtoBuilder() {
    AdminVehicleTypeInputDto._defaults(this);
  }

  AdminVehicleTypeInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(AdminVehicleTypeInputDto other) {
    _$v = other as _$AdminVehicleTypeInputDto;
  }

  @override
  void update(void Function(AdminVehicleTypeInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleTypeInputDto build() => _build();

  _$AdminVehicleTypeInputDto _build() {
    final _$result = _$v ??
        _$AdminVehicleTypeInputDto._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminVehicleTypeInputDto', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminVehicleTypeInputDto', 'name'),
          description: description,
          form: BuiltValueNullFieldError.checkNotNull(
              form, r'AdminVehicleTypeInputDto', 'form'),
          class_: BuiltValueNullFieldError.checkNotNull(
              class_, r'AdminVehicleTypeInputDto', 'class_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
