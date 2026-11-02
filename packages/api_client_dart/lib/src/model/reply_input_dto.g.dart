// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReplyInputDto extends ReplyInputDto {
  @override
  final String reply;

  factory _$ReplyInputDto([void Function(ReplyInputDtoBuilder)? updates]) =>
      (ReplyInputDtoBuilder()..update(updates))._build();

  _$ReplyInputDto._({required this.reply}) : super._();
  @override
  ReplyInputDto rebuild(void Function(ReplyInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReplyInputDtoBuilder toBuilder() => ReplyInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReplyInputDto && reply == other.reply;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reply.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReplyInputDto')..add('reply', reply))
        .toString();
  }
}

class ReplyInputDtoBuilder
    implements Builder<ReplyInputDto, ReplyInputDtoBuilder> {
  _$ReplyInputDto? _$v;

  String? _reply;
  String? get reply => _$this._reply;
  set reply(String? reply) => _$this._reply = reply;

  ReplyInputDtoBuilder() {
    ReplyInputDto._defaults(this);
  }

  ReplyInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reply = $v.reply;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReplyInputDto other) {
    _$v = other as _$ReplyInputDto;
  }

  @override
  void update(void Function(ReplyInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReplyInputDto build() => _build();

  _$ReplyInputDto _build() {
    final _$result = _$v ??
        _$ReplyInputDto._(
          reply: BuiltValueNullFieldError.checkNotNull(
              reply, r'ReplyInputDto', 'reply'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
