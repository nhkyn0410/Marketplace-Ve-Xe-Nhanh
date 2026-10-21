// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_verify_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketVerifyInputDto extends TicketVerifyInputDto {
  @override
  final String tripId;
  @override
  final String code;

  factory _$TicketVerifyInputDto(
          [void Function(TicketVerifyInputDtoBuilder)? updates]) =>
      (TicketVerifyInputDtoBuilder()..update(updates))._build();

  _$TicketVerifyInputDto._({required this.tripId, required this.code})
      : super._();
  @override
  TicketVerifyInputDto rebuild(
          void Function(TicketVerifyInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketVerifyInputDtoBuilder toBuilder() =>
      TicketVerifyInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketVerifyInputDto &&
        tripId == other.tripId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketVerifyInputDto')
          ..add('tripId', tripId)
          ..add('code', code))
        .toString();
  }
}

class TicketVerifyInputDtoBuilder
    implements Builder<TicketVerifyInputDto, TicketVerifyInputDtoBuilder> {
  _$TicketVerifyInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  TicketVerifyInputDtoBuilder() {
    TicketVerifyInputDto._defaults(this);
  }

  TicketVerifyInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketVerifyInputDto other) {
    _$v = other as _$TicketVerifyInputDto;
  }

  @override
  void update(void Function(TicketVerifyInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketVerifyInputDto build() => _build();

  _$TicketVerifyInputDto _build() {
    final _$result = _$v ??
        _$TicketVerifyInputDto._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'TicketVerifyInputDto', 'tripId'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'TicketVerifyInputDto', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
