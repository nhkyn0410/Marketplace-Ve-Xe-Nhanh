// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_evidence_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RequestEvidenceInputDtoPartyEnum
    _$requestEvidenceInputDtoPartyEnum_PASSENGER =
    const RequestEvidenceInputDtoPartyEnum._('PASSENGER');
const RequestEvidenceInputDtoPartyEnum
    _$requestEvidenceInputDtoPartyEnum_OPERATOR =
    const RequestEvidenceInputDtoPartyEnum._('OPERATOR');

RequestEvidenceInputDtoPartyEnum _$requestEvidenceInputDtoPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'PASSENGER':
      return _$requestEvidenceInputDtoPartyEnum_PASSENGER;
    case 'OPERATOR':
      return _$requestEvidenceInputDtoPartyEnum_OPERATOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RequestEvidenceInputDtoPartyEnum>
    _$requestEvidenceInputDtoPartyEnumValues = BuiltSet<
        RequestEvidenceInputDtoPartyEnum>(const <RequestEvidenceInputDtoPartyEnum>[
  _$requestEvidenceInputDtoPartyEnum_PASSENGER,
  _$requestEvidenceInputDtoPartyEnum_OPERATOR,
]);

Serializer<RequestEvidenceInputDtoPartyEnum>
    _$requestEvidenceInputDtoPartyEnumSerializer =
    _$RequestEvidenceInputDtoPartyEnumSerializer();

class _$RequestEvidenceInputDtoPartyEnumSerializer
    implements PrimitiveSerializer<RequestEvidenceInputDtoPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PASSENGER': 'PASSENGER',
    'OPERATOR': 'OPERATOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PASSENGER': 'PASSENGER',
    'OPERATOR': 'OPERATOR',
  };

  @override
  final Iterable<Type> types = const <Type>[RequestEvidenceInputDtoPartyEnum];
  @override
  final String wireName = 'RequestEvidenceInputDtoPartyEnum';

  @override
  Object serialize(
          Serializers serializers, RequestEvidenceInputDtoPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RequestEvidenceInputDtoPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RequestEvidenceInputDtoPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RequestEvidenceInputDto extends RequestEvidenceInputDto {
  @override
  final RequestEvidenceInputDtoPartyEnum party;
  @override
  final String message;
  @override
  final DateTime dueAt;

  factory _$RequestEvidenceInputDto(
          [void Function(RequestEvidenceInputDtoBuilder)? updates]) =>
      (RequestEvidenceInputDtoBuilder()..update(updates))._build();

  _$RequestEvidenceInputDto._(
      {required this.party, required this.message, required this.dueAt})
      : super._();
  @override
  RequestEvidenceInputDto rebuild(
          void Function(RequestEvidenceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestEvidenceInputDtoBuilder toBuilder() =>
      RequestEvidenceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestEvidenceInputDto &&
        party == other.party &&
        message == other.message &&
        dueAt == other.dueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RequestEvidenceInputDto')
          ..add('party', party)
          ..add('message', message)
          ..add('dueAt', dueAt))
        .toString();
  }
}

class RequestEvidenceInputDtoBuilder
    implements
        Builder<RequestEvidenceInputDto, RequestEvidenceInputDtoBuilder> {
  _$RequestEvidenceInputDto? _$v;

  RequestEvidenceInputDtoPartyEnum? _party;
  RequestEvidenceInputDtoPartyEnum? get party => _$this._party;
  set party(RequestEvidenceInputDtoPartyEnum? party) => _$this._party = party;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  RequestEvidenceInputDtoBuilder() {
    RequestEvidenceInputDto._defaults(this);
  }

  RequestEvidenceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _party = $v.party;
      _message = $v.message;
      _dueAt = $v.dueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RequestEvidenceInputDto other) {
    _$v = other as _$RequestEvidenceInputDto;
  }

  @override
  void update(void Function(RequestEvidenceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestEvidenceInputDto build() => _build();

  _$RequestEvidenceInputDto _build() {
    final _$result = _$v ??
        _$RequestEvidenceInputDto._(
          party: BuiltValueNullFieldError.checkNotNull(
              party, r'RequestEvidenceInputDto', 'party'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'RequestEvidenceInputDto', 'message'),
          dueAt: BuiltValueNullFieldError.checkNotNull(
              dueAt, r'RequestEvidenceInputDto', 'dueAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
