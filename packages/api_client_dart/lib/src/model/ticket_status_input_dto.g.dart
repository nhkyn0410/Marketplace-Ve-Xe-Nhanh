// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_status_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketStatusInputDtoStatusEnum _$ticketStatusInputDtoStatusEnum_RESOLVED =
    const TicketStatusInputDtoStatusEnum._('RESOLVED');
const TicketStatusInputDtoStatusEnum _$ticketStatusInputDtoStatusEnum_CLOSED =
    const TicketStatusInputDtoStatusEnum._('CLOSED');

TicketStatusInputDtoStatusEnum _$ticketStatusInputDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'RESOLVED':
      return _$ticketStatusInputDtoStatusEnum_RESOLVED;
    case 'CLOSED':
      return _$ticketStatusInputDtoStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketStatusInputDtoStatusEnum>
    _$ticketStatusInputDtoStatusEnumValues = BuiltSet<
        TicketStatusInputDtoStatusEnum>(const <TicketStatusInputDtoStatusEnum>[
  _$ticketStatusInputDtoStatusEnum_RESOLVED,
  _$ticketStatusInputDtoStatusEnum_CLOSED,
]);

Serializer<TicketStatusInputDtoStatusEnum>
    _$ticketStatusInputDtoStatusEnumSerializer =
    _$TicketStatusInputDtoStatusEnumSerializer();

class _$TicketStatusInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<TicketStatusInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[TicketStatusInputDtoStatusEnum];
  @override
  final String wireName = 'TicketStatusInputDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, TicketStatusInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketStatusInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketStatusInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketStatusInputDto extends TicketStatusInputDto {
  @override
  final TicketStatusInputDtoStatusEnum status;
  @override
  final String? note;

  factory _$TicketStatusInputDto(
          [void Function(TicketStatusInputDtoBuilder)? updates]) =>
      (TicketStatusInputDtoBuilder()..update(updates))._build();

  _$TicketStatusInputDto._({required this.status, this.note}) : super._();
  @override
  TicketStatusInputDto rebuild(
          void Function(TicketStatusInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketStatusInputDtoBuilder toBuilder() =>
      TicketStatusInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketStatusInputDto &&
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
    return (newBuiltValueToStringHelper(r'TicketStatusInputDto')
          ..add('status', status)
          ..add('note', note))
        .toString();
  }
}

class TicketStatusInputDtoBuilder
    implements Builder<TicketStatusInputDto, TicketStatusInputDtoBuilder> {
  _$TicketStatusInputDto? _$v;

  TicketStatusInputDtoStatusEnum? _status;
  TicketStatusInputDtoStatusEnum? get status => _$this._status;
  set status(TicketStatusInputDtoStatusEnum? status) => _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TicketStatusInputDtoBuilder() {
    TicketStatusInputDto._defaults(this);
  }

  TicketStatusInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketStatusInputDto other) {
    _$v = other as _$TicketStatusInputDto;
  }

  @override
  void update(void Function(TicketStatusInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketStatusInputDto build() => _build();

  _$TicketStatusInputDto _build() {
    final _$result = _$v ??
        _$TicketStatusInputDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TicketStatusInputDto', 'status'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
