// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_route_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SubRouteInputDtoNameSourceEnum _$subRouteInputDtoNameSourceEnum_AUTO =
    const SubRouteInputDtoNameSourceEnum._('AUTO');
const SubRouteInputDtoNameSourceEnum _$subRouteInputDtoNameSourceEnum_MANUAL =
    const SubRouteInputDtoNameSourceEnum._('MANUAL');

SubRouteInputDtoNameSourceEnum _$subRouteInputDtoNameSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'AUTO':
      return _$subRouteInputDtoNameSourceEnum_AUTO;
    case 'MANUAL':
      return _$subRouteInputDtoNameSourceEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SubRouteInputDtoNameSourceEnum>
    _$subRouteInputDtoNameSourceEnumValues = BuiltSet<
        SubRouteInputDtoNameSourceEnum>(const <SubRouteInputDtoNameSourceEnum>[
  _$subRouteInputDtoNameSourceEnum_AUTO,
  _$subRouteInputDtoNameSourceEnum_MANUAL,
]);

const SubRouteInputDtoStatusEnum _$subRouteInputDtoStatusEnum_ACTIVE =
    const SubRouteInputDtoStatusEnum._('ACTIVE');
const SubRouteInputDtoStatusEnum _$subRouteInputDtoStatusEnum_INACTIVE =
    const SubRouteInputDtoStatusEnum._('INACTIVE');
const SubRouteInputDtoStatusEnum _$subRouteInputDtoStatusEnum_DRAFT =
    const SubRouteInputDtoStatusEnum._('DRAFT');

SubRouteInputDtoStatusEnum _$subRouteInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$subRouteInputDtoStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$subRouteInputDtoStatusEnum_INACTIVE;
    case 'DRAFT':
      return _$subRouteInputDtoStatusEnum_DRAFT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SubRouteInputDtoStatusEnum> _$subRouteInputDtoStatusEnumValues =
    BuiltSet<SubRouteInputDtoStatusEnum>(const <SubRouteInputDtoStatusEnum>[
  _$subRouteInputDtoStatusEnum_ACTIVE,
  _$subRouteInputDtoStatusEnum_INACTIVE,
  _$subRouteInputDtoStatusEnum_DRAFT,
]);

Serializer<SubRouteInputDtoNameSourceEnum>
    _$subRouteInputDtoNameSourceEnumSerializer =
    _$SubRouteInputDtoNameSourceEnumSerializer();
Serializer<SubRouteInputDtoStatusEnum> _$subRouteInputDtoStatusEnumSerializer =
    _$SubRouteInputDtoStatusEnumSerializer();

class _$SubRouteInputDtoNameSourceEnumSerializer
    implements PrimitiveSerializer<SubRouteInputDtoNameSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUTO': 'AUTO',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[SubRouteInputDtoNameSourceEnum];
  @override
  final String wireName = 'SubRouteInputDtoNameSourceEnum';

  @override
  Object serialize(
          Serializers serializers, SubRouteInputDtoNameSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SubRouteInputDtoNameSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SubRouteInputDtoNameSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SubRouteInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<SubRouteInputDtoStatusEnum> {
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
  final Iterable<Type> types = const <Type>[SubRouteInputDtoStatusEnum];
  @override
  final String wireName = 'SubRouteInputDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, SubRouteInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SubRouteInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SubRouteInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SubRouteInputDto extends SubRouteInputDto {
  @override
  final SubRouteInputDtoFrom from;
  @override
  final SubRouteInputDtoFrom to;
  @override
  final String name;
  @override
  final SubRouteInputDtoNameSourceEnum nameSource;
  @override
  final SubRouteInputDtoStatusEnum status;
  @override
  final String? note;

  factory _$SubRouteInputDto(
          [void Function(SubRouteInputDtoBuilder)? updates]) =>
      (SubRouteInputDtoBuilder()..update(updates))._build();

  _$SubRouteInputDto._(
      {required this.from,
      required this.to,
      required this.name,
      required this.nameSource,
      required this.status,
      this.note})
      : super._();
  @override
  SubRouteInputDto rebuild(void Function(SubRouteInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubRouteInputDtoBuilder toBuilder() =>
      SubRouteInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubRouteInputDto &&
        from == other.from &&
        to == other.to &&
        name == other.name &&
        nameSource == other.nameSource &&
        status == other.status &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameSource.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubRouteInputDto')
          ..add('from', from)
          ..add('to', to)
          ..add('name', name)
          ..add('nameSource', nameSource)
          ..add('status', status)
          ..add('note', note))
        .toString();
  }
}

class SubRouteInputDtoBuilder
    implements Builder<SubRouteInputDto, SubRouteInputDtoBuilder> {
  _$SubRouteInputDto? _$v;

  SubRouteInputDtoFromBuilder? _from;
  SubRouteInputDtoFromBuilder get from =>
      _$this._from ??= SubRouteInputDtoFromBuilder();
  set from(SubRouteInputDtoFromBuilder? from) => _$this._from = from;

  SubRouteInputDtoFromBuilder? _to;
  SubRouteInputDtoFromBuilder get to =>
      _$this._to ??= SubRouteInputDtoFromBuilder();
  set to(SubRouteInputDtoFromBuilder? to) => _$this._to = to;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SubRouteInputDtoNameSourceEnum? _nameSource;
  SubRouteInputDtoNameSourceEnum? get nameSource => _$this._nameSource;
  set nameSource(SubRouteInputDtoNameSourceEnum? nameSource) =>
      _$this._nameSource = nameSource;

  SubRouteInputDtoStatusEnum? _status;
  SubRouteInputDtoStatusEnum? get status => _$this._status;
  set status(SubRouteInputDtoStatusEnum? status) => _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  SubRouteInputDtoBuilder() {
    SubRouteInputDto._defaults(this);
  }

  SubRouteInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _name = $v.name;
      _nameSource = $v.nameSource;
      _status = $v.status;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubRouteInputDto other) {
    _$v = other as _$SubRouteInputDto;
  }

  @override
  void update(void Function(SubRouteInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubRouteInputDto build() => _build();

  _$SubRouteInputDto _build() {
    _$SubRouteInputDto _$result;
    try {
      _$result = _$v ??
          _$SubRouteInputDto._(
            from: from.build(),
            to: to.build(),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'SubRouteInputDto', 'name'),
            nameSource: BuiltValueNullFieldError.checkNotNull(
                nameSource, r'SubRouteInputDto', 'nameSource'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'SubRouteInputDto', 'status'),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubRouteInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
