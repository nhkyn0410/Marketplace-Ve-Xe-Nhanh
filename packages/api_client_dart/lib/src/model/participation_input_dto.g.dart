// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ParticipationInputDto extends ParticipationInputDto {
  @override
  final bool joined;

  factory _$ParticipationInputDto(
          [void Function(ParticipationInputDtoBuilder)? updates]) =>
      (ParticipationInputDtoBuilder()..update(updates))._build();

  _$ParticipationInputDto._({required this.joined}) : super._();
  @override
  ParticipationInputDto rebuild(
          void Function(ParticipationInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipationInputDtoBuilder toBuilder() =>
      ParticipationInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipationInputDto && joined == other.joined;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, joined.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParticipationInputDto')
          ..add('joined', joined))
        .toString();
  }
}

class ParticipationInputDtoBuilder
    implements Builder<ParticipationInputDto, ParticipationInputDtoBuilder> {
  _$ParticipationInputDto? _$v;

  bool? _joined;
  bool? get joined => _$this._joined;
  set joined(bool? joined) => _$this._joined = joined;

  ParticipationInputDtoBuilder() {
    ParticipationInputDto._defaults(this);
  }

  ParticipationInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _joined = $v.joined;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParticipationInputDto other) {
    _$v = other as _$ParticipationInputDto;
  }

  @override
  void update(void Function(ParticipationInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParticipationInputDto build() => _build();

  _$ParticipationInputDto _build() {
    final _$result = _$v ??
        _$ParticipationInputDto._(
          joined: BuiltValueNullFieldError.checkNotNull(
              joined, r'ParticipationInputDto', 'joined'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
