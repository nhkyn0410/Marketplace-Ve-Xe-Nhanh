// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_session_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketLookupSessionInputDto extends TicketLookupSessionInputDto {
  @override
  final String lookupToken;

  factory _$TicketLookupSessionInputDto(
          [void Function(TicketLookupSessionInputDtoBuilder)? updates]) =>
      (TicketLookupSessionInputDtoBuilder()..update(updates))._build();

  _$TicketLookupSessionInputDto._({required this.lookupToken}) : super._();
  @override
  TicketLookupSessionInputDto rebuild(
          void Function(TicketLookupSessionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupSessionInputDtoBuilder toBuilder() =>
      TicketLookupSessionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupSessionInputDto &&
        lookupToken == other.lookupToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lookupToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupSessionInputDto')
          ..add('lookupToken', lookupToken))
        .toString();
  }
}

class TicketLookupSessionInputDtoBuilder
    implements
        Builder<TicketLookupSessionInputDto,
            TicketLookupSessionInputDtoBuilder> {
  _$TicketLookupSessionInputDto? _$v;

  String? _lookupToken;
  String? get lookupToken => _$this._lookupToken;
  set lookupToken(String? lookupToken) => _$this._lookupToken = lookupToken;

  TicketLookupSessionInputDtoBuilder() {
    TicketLookupSessionInputDto._defaults(this);
  }

  TicketLookupSessionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lookupToken = $v.lookupToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupSessionInputDto other) {
    _$v = other as _$TicketLookupSessionInputDto;
  }

  @override
  void update(void Function(TicketLookupSessionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupSessionInputDto build() => _build();

  _$TicketLookupSessionInputDto _build() {
    final _$result = _$v ??
        _$TicketLookupSessionInputDto._(
          lookupToken: BuiltValueNullFieldError.checkNotNull(
              lookupToken, r'TicketLookupSessionInputDto', 'lookupToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
