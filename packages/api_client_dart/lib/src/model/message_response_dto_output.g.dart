// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MessageResponseDtoOutputStatusEnum
    _$messageResponseDtoOutputStatusEnum_ok =
    const MessageResponseDtoOutputStatusEnum._('ok');

MessageResponseDtoOutputStatusEnum _$messageResponseDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ok':
      return _$messageResponseDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MessageResponseDtoOutputStatusEnum>
    _$messageResponseDtoOutputStatusEnumValues = BuiltSet<
        MessageResponseDtoOutputStatusEnum>(const <MessageResponseDtoOutputStatusEnum>[
  _$messageResponseDtoOutputStatusEnum_ok,
]);

Serializer<MessageResponseDtoOutputStatusEnum>
    _$messageResponseDtoOutputStatusEnumSerializer =
    _$MessageResponseDtoOutputStatusEnumSerializer();

class _$MessageResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MessageResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[MessageResponseDtoOutputStatusEnum];
  @override
  final String wireName = 'MessageResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, MessageResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MessageResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MessageResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MessageResponseDtoOutput extends MessageResponseDtoOutput {
  @override
  final MessageResponseDtoOutputStatusEnum status;

  factory _$MessageResponseDtoOutput(
          [void Function(MessageResponseDtoOutputBuilder)? updates]) =>
      (MessageResponseDtoOutputBuilder()..update(updates))._build();

  _$MessageResponseDtoOutput._({required this.status}) : super._();
  @override
  MessageResponseDtoOutput rebuild(
          void Function(MessageResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageResponseDtoOutputBuilder toBuilder() =>
      MessageResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageResponseDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageResponseDtoOutput')
          ..add('status', status))
        .toString();
  }
}

class MessageResponseDtoOutputBuilder
    implements
        Builder<MessageResponseDtoOutput, MessageResponseDtoOutputBuilder> {
  _$MessageResponseDtoOutput? _$v;

  MessageResponseDtoOutputStatusEnum? _status;
  MessageResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(MessageResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MessageResponseDtoOutputBuilder() {
    MessageResponseDtoOutput._defaults(this);
  }

  MessageResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageResponseDtoOutput other) {
    _$v = other as _$MessageResponseDtoOutput;
  }

  @override
  void update(void Function(MessageResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageResponseDtoOutput build() => _build();

  _$MessageResponseDtoOutput _build() {
    final _$result = _$v ??
        _$MessageResponseDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MessageResponseDtoOutput', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
