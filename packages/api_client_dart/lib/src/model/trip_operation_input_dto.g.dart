// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_operation_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripOperationInputDtoStatusEnum
    _$tripOperationInputDtoStatusEnum_BOARDING =
    const TripOperationInputDtoStatusEnum._('BOARDING');
const TripOperationInputDtoStatusEnum
    _$tripOperationInputDtoStatusEnum_DEPARTED =
    const TripOperationInputDtoStatusEnum._('DEPARTED');
const TripOperationInputDtoStatusEnum
    _$tripOperationInputDtoStatusEnum_IN_PROGRESS =
    const TripOperationInputDtoStatusEnum._('IN_PROGRESS');
const TripOperationInputDtoStatusEnum
    _$tripOperationInputDtoStatusEnum_COMPLETED =
    const TripOperationInputDtoStatusEnum._('COMPLETED');

TripOperationInputDtoStatusEnum _$tripOperationInputDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'BOARDING':
      return _$tripOperationInputDtoStatusEnum_BOARDING;
    case 'DEPARTED':
      return _$tripOperationInputDtoStatusEnum_DEPARTED;
    case 'IN_PROGRESS':
      return _$tripOperationInputDtoStatusEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$tripOperationInputDtoStatusEnum_COMPLETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripOperationInputDtoStatusEnum>
    _$tripOperationInputDtoStatusEnumValues = BuiltSet<
        TripOperationInputDtoStatusEnum>(const <TripOperationInputDtoStatusEnum>[
  _$tripOperationInputDtoStatusEnum_BOARDING,
  _$tripOperationInputDtoStatusEnum_DEPARTED,
  _$tripOperationInputDtoStatusEnum_IN_PROGRESS,
  _$tripOperationInputDtoStatusEnum_COMPLETED,
]);

Serializer<TripOperationInputDtoStatusEnum>
    _$tripOperationInputDtoStatusEnumSerializer =
    _$TripOperationInputDtoStatusEnumSerializer();

class _$TripOperationInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<TripOperationInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOARDING': 'BOARDING',
    'DEPARTED': 'DEPARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOARDING': 'BOARDING',
    'DEPARTED': 'DEPARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
  };

  @override
  final Iterable<Type> types = const <Type>[TripOperationInputDtoStatusEnum];
  @override
  final String wireName = 'TripOperationInputDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, TripOperationInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripOperationInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripOperationInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripOperationInputDto extends TripOperationInputDto {
  @override
  final TripOperationInputDtoStatusEnum status;
  @override
  final String? note;

  factory _$TripOperationInputDto(
          [void Function(TripOperationInputDtoBuilder)? updates]) =>
      (TripOperationInputDtoBuilder()..update(updates))._build();

  _$TripOperationInputDto._({required this.status, this.note}) : super._();
  @override
  TripOperationInputDto rebuild(
          void Function(TripOperationInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripOperationInputDtoBuilder toBuilder() =>
      TripOperationInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripOperationInputDto &&
        status == other.status &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripOperationInputDto')
          ..add('status', status)
          ..add('note', note))
        .toString();
  }
}

class TripOperationInputDtoBuilder
    implements Builder<TripOperationInputDto, TripOperationInputDtoBuilder> {
  _$TripOperationInputDto? _$v;

  TripOperationInputDtoStatusEnum? _status;
  TripOperationInputDtoStatusEnum? get status => _$this._status;
  set status(TripOperationInputDtoStatusEnum? status) =>
      _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TripOperationInputDtoBuilder() {
    TripOperationInputDto._defaults(this);
  }

  TripOperationInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripOperationInputDto other) {
    _$v = other as _$TripOperationInputDto;
  }

  @override
  void update(void Function(TripOperationInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripOperationInputDto build() => _build();

  _$TripOperationInputDto _build() {
    final _$result = _$v ??
        _$TripOperationInputDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TripOperationInputDto', 'status'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
