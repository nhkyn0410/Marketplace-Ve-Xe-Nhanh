// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classify_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClassifyInputDtoCategoryEnum
    _$classifyInputDtoCategoryEnum_PAYMENT_REFUND =
    const ClassifyInputDtoCategoryEnum._('PAYMENT_REFUND');
const ClassifyInputDtoCategoryEnum _$classifyInputDtoCategoryEnum_SCHEDULE =
    const ClassifyInputDtoCategoryEnum._('SCHEDULE');
const ClassifyInputDtoCategoryEnum
    _$classifyInputDtoCategoryEnum_SERVICE_QUALITY =
    const ClassifyInputDtoCategoryEnum._('SERVICE_QUALITY');
const ClassifyInputDtoCategoryEnum
    _$classifyInputDtoCategoryEnum_TICKET_CHANGE =
    const ClassifyInputDtoCategoryEnum._('TICKET_CHANGE');
const ClassifyInputDtoCategoryEnum _$classifyInputDtoCategoryEnum_OTHER =
    const ClassifyInputDtoCategoryEnum._('OTHER');

ClassifyInputDtoCategoryEnum _$classifyInputDtoCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'PAYMENT_REFUND':
      return _$classifyInputDtoCategoryEnum_PAYMENT_REFUND;
    case 'SCHEDULE':
      return _$classifyInputDtoCategoryEnum_SCHEDULE;
    case 'SERVICE_QUALITY':
      return _$classifyInputDtoCategoryEnum_SERVICE_QUALITY;
    case 'TICKET_CHANGE':
      return _$classifyInputDtoCategoryEnum_TICKET_CHANGE;
    case 'OTHER':
      return _$classifyInputDtoCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClassifyInputDtoCategoryEnum>
    _$classifyInputDtoCategoryEnumValues =
    BuiltSet<ClassifyInputDtoCategoryEnum>(const <ClassifyInputDtoCategoryEnum>[
  _$classifyInputDtoCategoryEnum_PAYMENT_REFUND,
  _$classifyInputDtoCategoryEnum_SCHEDULE,
  _$classifyInputDtoCategoryEnum_SERVICE_QUALITY,
  _$classifyInputDtoCategoryEnum_TICKET_CHANGE,
  _$classifyInputDtoCategoryEnum_OTHER,
]);

const ClassifyInputDtoPriorityEnum _$classifyInputDtoPriorityEnum_LOW =
    const ClassifyInputDtoPriorityEnum._('LOW');
const ClassifyInputDtoPriorityEnum _$classifyInputDtoPriorityEnum_MEDIUM =
    const ClassifyInputDtoPriorityEnum._('MEDIUM');
const ClassifyInputDtoPriorityEnum _$classifyInputDtoPriorityEnum_HIGH =
    const ClassifyInputDtoPriorityEnum._('HIGH');
const ClassifyInputDtoPriorityEnum _$classifyInputDtoPriorityEnum_URGENT =
    const ClassifyInputDtoPriorityEnum._('URGENT');

ClassifyInputDtoPriorityEnum _$classifyInputDtoPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'LOW':
      return _$classifyInputDtoPriorityEnum_LOW;
    case 'MEDIUM':
      return _$classifyInputDtoPriorityEnum_MEDIUM;
    case 'HIGH':
      return _$classifyInputDtoPriorityEnum_HIGH;
    case 'URGENT':
      return _$classifyInputDtoPriorityEnum_URGENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClassifyInputDtoPriorityEnum>
    _$classifyInputDtoPriorityEnumValues =
    BuiltSet<ClassifyInputDtoPriorityEnum>(const <ClassifyInputDtoPriorityEnum>[
  _$classifyInputDtoPriorityEnum_LOW,
  _$classifyInputDtoPriorityEnum_MEDIUM,
  _$classifyInputDtoPriorityEnum_HIGH,
  _$classifyInputDtoPriorityEnum_URGENT,
]);

const ClassifyInputDtoHandlerEnum _$classifyInputDtoHandlerEnum_PLATFORM =
    const ClassifyInputDtoHandlerEnum._('PLATFORM');
const ClassifyInputDtoHandlerEnum _$classifyInputDtoHandlerEnum_OPERATOR =
    const ClassifyInputDtoHandlerEnum._('OPERATOR');

ClassifyInputDtoHandlerEnum _$classifyInputDtoHandlerEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM':
      return _$classifyInputDtoHandlerEnum_PLATFORM;
    case 'OPERATOR':
      return _$classifyInputDtoHandlerEnum_OPERATOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClassifyInputDtoHandlerEnum>
    _$classifyInputDtoHandlerEnumValues =
    BuiltSet<ClassifyInputDtoHandlerEnum>(const <ClassifyInputDtoHandlerEnum>[
  _$classifyInputDtoHandlerEnum_PLATFORM,
  _$classifyInputDtoHandlerEnum_OPERATOR,
]);

Serializer<ClassifyInputDtoCategoryEnum>
    _$classifyInputDtoCategoryEnumSerializer =
    _$ClassifyInputDtoCategoryEnumSerializer();
Serializer<ClassifyInputDtoPriorityEnum>
    _$classifyInputDtoPriorityEnumSerializer =
    _$ClassifyInputDtoPriorityEnumSerializer();
Serializer<ClassifyInputDtoHandlerEnum>
    _$classifyInputDtoHandlerEnumSerializer =
    _$ClassifyInputDtoHandlerEnumSerializer();

class _$ClassifyInputDtoCategoryEnumSerializer
    implements PrimitiveSerializer<ClassifyInputDtoCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PAYMENT_REFUND': 'PAYMENT_REFUND',
    'SCHEDULE': 'SCHEDULE',
    'SERVICE_QUALITY': 'SERVICE_QUALITY',
    'TICKET_CHANGE': 'TICKET_CHANGE',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PAYMENT_REFUND': 'PAYMENT_REFUND',
    'SCHEDULE': 'SCHEDULE',
    'SERVICE_QUALITY': 'SERVICE_QUALITY',
    'TICKET_CHANGE': 'TICKET_CHANGE',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[ClassifyInputDtoCategoryEnum];
  @override
  final String wireName = 'ClassifyInputDtoCategoryEnum';

  @override
  Object serialize(Serializers serializers, ClassifyInputDtoCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClassifyInputDtoCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClassifyInputDtoCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClassifyInputDtoPriorityEnumSerializer
    implements PrimitiveSerializer<ClassifyInputDtoPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
    'URGENT': 'URGENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
    'URGENT': 'URGENT',
  };

  @override
  final Iterable<Type> types = const <Type>[ClassifyInputDtoPriorityEnum];
  @override
  final String wireName = 'ClassifyInputDtoPriorityEnum';

  @override
  Object serialize(Serializers serializers, ClassifyInputDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClassifyInputDtoPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClassifyInputDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClassifyInputDtoHandlerEnumSerializer
    implements PrimitiveSerializer<ClassifyInputDtoHandlerEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };

  @override
  final Iterable<Type> types = const <Type>[ClassifyInputDtoHandlerEnum];
  @override
  final String wireName = 'ClassifyInputDtoHandlerEnum';

  @override
  Object serialize(Serializers serializers, ClassifyInputDtoHandlerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClassifyInputDtoHandlerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClassifyInputDtoHandlerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClassifyInputDto extends ClassifyInputDto {
  @override
  final ClassifyInputDtoCategoryEnum category;
  @override
  final ClassifyInputDtoPriorityEnum priority;
  @override
  final ClassifyInputDtoHandlerEnum handler;
  @override
  final String? assigneeId;

  factory _$ClassifyInputDto(
          [void Function(ClassifyInputDtoBuilder)? updates]) =>
      (ClassifyInputDtoBuilder()..update(updates))._build();

  _$ClassifyInputDto._(
      {required this.category,
      required this.priority,
      required this.handler,
      this.assigneeId})
      : super._();
  @override
  ClassifyInputDto rebuild(void Function(ClassifyInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassifyInputDtoBuilder toBuilder() =>
      ClassifyInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassifyInputDto &&
        category == other.category &&
        priority == other.priority &&
        handler == other.handler &&
        assigneeId == other.assigneeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, handler.hashCode);
    _$hash = $jc(_$hash, assigneeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClassifyInputDto')
          ..add('category', category)
          ..add('priority', priority)
          ..add('handler', handler)
          ..add('assigneeId', assigneeId))
        .toString();
  }
}

class ClassifyInputDtoBuilder
    implements Builder<ClassifyInputDto, ClassifyInputDtoBuilder> {
  _$ClassifyInputDto? _$v;

  ClassifyInputDtoCategoryEnum? _category;
  ClassifyInputDtoCategoryEnum? get category => _$this._category;
  set category(ClassifyInputDtoCategoryEnum? category) =>
      _$this._category = category;

  ClassifyInputDtoPriorityEnum? _priority;
  ClassifyInputDtoPriorityEnum? get priority => _$this._priority;
  set priority(ClassifyInputDtoPriorityEnum? priority) =>
      _$this._priority = priority;

  ClassifyInputDtoHandlerEnum? _handler;
  ClassifyInputDtoHandlerEnum? get handler => _$this._handler;
  set handler(ClassifyInputDtoHandlerEnum? handler) =>
      _$this._handler = handler;

  String? _assigneeId;
  String? get assigneeId => _$this._assigneeId;
  set assigneeId(String? assigneeId) => _$this._assigneeId = assigneeId;

  ClassifyInputDtoBuilder() {
    ClassifyInputDto._defaults(this);
  }

  ClassifyInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _priority = $v.priority;
      _handler = $v.handler;
      _assigneeId = $v.assigneeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassifyInputDto other) {
    _$v = other as _$ClassifyInputDto;
  }

  @override
  void update(void Function(ClassifyInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClassifyInputDto build() => _build();

  _$ClassifyInputDto _build() {
    final _$result = _$v ??
        _$ClassifyInputDto._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'ClassifyInputDto', 'category'),
          priority: BuiltValueNullFieldError.checkNotNull(
              priority, r'ClassifyInputDto', 'priority'),
          handler: BuiltValueNullFieldError.checkNotNull(
              handler, r'ClassifyInputDto', 'handler'),
          assigneeId: assigneeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
