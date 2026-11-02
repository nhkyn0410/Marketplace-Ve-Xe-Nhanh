// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ModerationInputDtoActionEnum _$moderationInputDtoActionEnum_HOLD =
    const ModerationInputDtoActionEnum._('HOLD');
const ModerationInputDtoActionEnum _$moderationInputDtoActionEnum_HIDE =
    const ModerationInputDtoActionEnum._('HIDE');
const ModerationInputDtoActionEnum _$moderationInputDtoActionEnum_SHOW =
    const ModerationInputDtoActionEnum._('SHOW');

ModerationInputDtoActionEnum _$moderationInputDtoActionEnumValueOf(
    String name) {
  switch (name) {
    case 'HOLD':
      return _$moderationInputDtoActionEnum_HOLD;
    case 'HIDE':
      return _$moderationInputDtoActionEnum_HIDE;
    case 'SHOW':
      return _$moderationInputDtoActionEnum_SHOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationInputDtoActionEnum>
    _$moderationInputDtoActionEnumValues =
    BuiltSet<ModerationInputDtoActionEnum>(const <ModerationInputDtoActionEnum>[
  _$moderationInputDtoActionEnum_HOLD,
  _$moderationInputDtoActionEnum_HIDE,
  _$moderationInputDtoActionEnum_SHOW,
]);

Serializer<ModerationInputDtoActionEnum>
    _$moderationInputDtoActionEnumSerializer =
    _$ModerationInputDtoActionEnumSerializer();

class _$ModerationInputDtoActionEnumSerializer
    implements PrimitiveSerializer<ModerationInputDtoActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HOLD': 'HOLD',
    'HIDE': 'HIDE',
    'SHOW': 'SHOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HOLD': 'HOLD',
    'HIDE': 'HIDE',
    'SHOW': 'SHOW',
  };

  @override
  final Iterable<Type> types = const <Type>[ModerationInputDtoActionEnum];
  @override
  final String wireName = 'ModerationInputDtoActionEnum';

  @override
  Object serialize(Serializers serializers, ModerationInputDtoActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationInputDtoActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationInputDtoActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationInputDto extends ModerationInputDto {
  @override
  final ModerationInputDtoActionEnum action;
  @override
  final String? reason;

  factory _$ModerationInputDto(
          [void Function(ModerationInputDtoBuilder)? updates]) =>
      (ModerationInputDtoBuilder()..update(updates))._build();

  _$ModerationInputDto._({required this.action, this.reason}) : super._();
  @override
  ModerationInputDto rebuild(
          void Function(ModerationInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModerationInputDtoBuilder toBuilder() =>
      ModerationInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModerationInputDto &&
        action == other.action &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModerationInputDto')
          ..add('action', action)
          ..add('reason', reason))
        .toString();
  }
}

class ModerationInputDtoBuilder
    implements Builder<ModerationInputDto, ModerationInputDtoBuilder> {
  _$ModerationInputDto? _$v;

  ModerationInputDtoActionEnum? _action;
  ModerationInputDtoActionEnum? get action => _$this._action;
  set action(ModerationInputDtoActionEnum? action) => _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ModerationInputDtoBuilder() {
    ModerationInputDto._defaults(this);
  }

  ModerationInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModerationInputDto other) {
    _$v = other as _$ModerationInputDto;
  }

  @override
  void update(void Function(ModerationInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModerationInputDto build() => _build();

  _$ModerationInputDto _build() {
    final _$result = _$v ??
        _$ModerationInputDto._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ModerationInputDto', 'action'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
