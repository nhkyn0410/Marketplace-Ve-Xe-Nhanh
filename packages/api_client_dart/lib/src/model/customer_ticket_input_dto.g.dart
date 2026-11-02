// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ticket_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerTicketInputDtoCategoryEnum
    _$customerTicketInputDtoCategoryEnum_PAYMENT_REFUND =
    const CustomerTicketInputDtoCategoryEnum._('PAYMENT_REFUND');
const CustomerTicketInputDtoCategoryEnum
    _$customerTicketInputDtoCategoryEnum_SCHEDULE =
    const CustomerTicketInputDtoCategoryEnum._('SCHEDULE');
const CustomerTicketInputDtoCategoryEnum
    _$customerTicketInputDtoCategoryEnum_SERVICE_QUALITY =
    const CustomerTicketInputDtoCategoryEnum._('SERVICE_QUALITY');
const CustomerTicketInputDtoCategoryEnum
    _$customerTicketInputDtoCategoryEnum_TICKET_CHANGE =
    const CustomerTicketInputDtoCategoryEnum._('TICKET_CHANGE');
const CustomerTicketInputDtoCategoryEnum
    _$customerTicketInputDtoCategoryEnum_OTHER =
    const CustomerTicketInputDtoCategoryEnum._('OTHER');

CustomerTicketInputDtoCategoryEnum _$customerTicketInputDtoCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'PAYMENT_REFUND':
      return _$customerTicketInputDtoCategoryEnum_PAYMENT_REFUND;
    case 'SCHEDULE':
      return _$customerTicketInputDtoCategoryEnum_SCHEDULE;
    case 'SERVICE_QUALITY':
      return _$customerTicketInputDtoCategoryEnum_SERVICE_QUALITY;
    case 'TICKET_CHANGE':
      return _$customerTicketInputDtoCategoryEnum_TICKET_CHANGE;
    case 'OTHER':
      return _$customerTicketInputDtoCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerTicketInputDtoCategoryEnum>
    _$customerTicketInputDtoCategoryEnumValues = BuiltSet<
        CustomerTicketInputDtoCategoryEnum>(const <CustomerTicketInputDtoCategoryEnum>[
  _$customerTicketInputDtoCategoryEnum_PAYMENT_REFUND,
  _$customerTicketInputDtoCategoryEnum_SCHEDULE,
  _$customerTicketInputDtoCategoryEnum_SERVICE_QUALITY,
  _$customerTicketInputDtoCategoryEnum_TICKET_CHANGE,
  _$customerTicketInputDtoCategoryEnum_OTHER,
]);

const CustomerTicketInputDtoPriorityEnum
    _$customerTicketInputDtoPriorityEnum_LOW =
    const CustomerTicketInputDtoPriorityEnum._('LOW');
const CustomerTicketInputDtoPriorityEnum
    _$customerTicketInputDtoPriorityEnum_MEDIUM =
    const CustomerTicketInputDtoPriorityEnum._('MEDIUM');
const CustomerTicketInputDtoPriorityEnum
    _$customerTicketInputDtoPriorityEnum_HIGH =
    const CustomerTicketInputDtoPriorityEnum._('HIGH');
const CustomerTicketInputDtoPriorityEnum
    _$customerTicketInputDtoPriorityEnum_URGENT =
    const CustomerTicketInputDtoPriorityEnum._('URGENT');

CustomerTicketInputDtoPriorityEnum _$customerTicketInputDtoPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'LOW':
      return _$customerTicketInputDtoPriorityEnum_LOW;
    case 'MEDIUM':
      return _$customerTicketInputDtoPriorityEnum_MEDIUM;
    case 'HIGH':
      return _$customerTicketInputDtoPriorityEnum_HIGH;
    case 'URGENT':
      return _$customerTicketInputDtoPriorityEnum_URGENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerTicketInputDtoPriorityEnum>
    _$customerTicketInputDtoPriorityEnumValues = BuiltSet<
        CustomerTicketInputDtoPriorityEnum>(const <CustomerTicketInputDtoPriorityEnum>[
  _$customerTicketInputDtoPriorityEnum_LOW,
  _$customerTicketInputDtoPriorityEnum_MEDIUM,
  _$customerTicketInputDtoPriorityEnum_HIGH,
  _$customerTicketInputDtoPriorityEnum_URGENT,
]);

Serializer<CustomerTicketInputDtoCategoryEnum>
    _$customerTicketInputDtoCategoryEnumSerializer =
    _$CustomerTicketInputDtoCategoryEnumSerializer();
Serializer<CustomerTicketInputDtoPriorityEnum>
    _$customerTicketInputDtoPriorityEnumSerializer =
    _$CustomerTicketInputDtoPriorityEnumSerializer();

class _$CustomerTicketInputDtoCategoryEnumSerializer
    implements PrimitiveSerializer<CustomerTicketInputDtoCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[CustomerTicketInputDtoCategoryEnum];
  @override
  final String wireName = 'CustomerTicketInputDtoCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, CustomerTicketInputDtoCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CustomerTicketInputDtoCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CustomerTicketInputDtoCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CustomerTicketInputDtoPriorityEnumSerializer
    implements PrimitiveSerializer<CustomerTicketInputDtoPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[CustomerTicketInputDtoPriorityEnum];
  @override
  final String wireName = 'CustomerTicketInputDtoPriorityEnum';

  @override
  Object serialize(
          Serializers serializers, CustomerTicketInputDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CustomerTicketInputDtoPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CustomerTicketInputDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CustomerTicketInputDto extends CustomerTicketInputDto {
  @override
  final CustomerTicketInputDtoCategoryEnum category;
  @override
  final CustomerTicketInputDtoPriorityEnum? priority;
  @override
  final String subject;
  @override
  final String body;
  @override
  final BuiltList<CustomerTicketInputDtoAttachmentsInner>? attachments;

  factory _$CustomerTicketInputDto(
          [void Function(CustomerTicketInputDtoBuilder)? updates]) =>
      (CustomerTicketInputDtoBuilder()..update(updates))._build();

  _$CustomerTicketInputDto._(
      {required this.category,
      this.priority,
      required this.subject,
      required this.body,
      this.attachments})
      : super._();
  @override
  CustomerTicketInputDto rebuild(
          void Function(CustomerTicketInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerTicketInputDtoBuilder toBuilder() =>
      CustomerTicketInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerTicketInputDto &&
        category == other.category &&
        priority == other.priority &&
        subject == other.subject &&
        body == other.body &&
        attachments == other.attachments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerTicketInputDto')
          ..add('category', category)
          ..add('priority', priority)
          ..add('subject', subject)
          ..add('body', body)
          ..add('attachments', attachments))
        .toString();
  }
}

class CustomerTicketInputDtoBuilder
    implements Builder<CustomerTicketInputDto, CustomerTicketInputDtoBuilder> {
  _$CustomerTicketInputDto? _$v;

  CustomerTicketInputDtoCategoryEnum? _category;
  CustomerTicketInputDtoCategoryEnum? get category => _$this._category;
  set category(CustomerTicketInputDtoCategoryEnum? category) =>
      _$this._category = category;

  CustomerTicketInputDtoPriorityEnum? _priority;
  CustomerTicketInputDtoPriorityEnum? get priority => _$this._priority;
  set priority(CustomerTicketInputDtoPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  ListBuilder<CustomerTicketInputDtoAttachmentsInner>? _attachments;
  ListBuilder<CustomerTicketInputDtoAttachmentsInner> get attachments =>
      _$this._attachments ??=
          ListBuilder<CustomerTicketInputDtoAttachmentsInner>();
  set attachments(
          ListBuilder<CustomerTicketInputDtoAttachmentsInner>? attachments) =>
      _$this._attachments = attachments;

  CustomerTicketInputDtoBuilder() {
    CustomerTicketInputDto._defaults(this);
  }

  CustomerTicketInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _priority = $v.priority;
      _subject = $v.subject;
      _body = $v.body;
      _attachments = $v.attachments?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerTicketInputDto other) {
    _$v = other as _$CustomerTicketInputDto;
  }

  @override
  void update(void Function(CustomerTicketInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerTicketInputDto build() => _build();

  _$CustomerTicketInputDto _build() {
    _$CustomerTicketInputDto _$result;
    try {
      _$result = _$v ??
          _$CustomerTicketInputDto._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'CustomerTicketInputDto', 'category'),
            priority: priority,
            subject: BuiltValueNullFieldError.checkNotNull(
                subject, r'CustomerTicketInputDto', 'subject'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'CustomerTicketInputDto', 'body'),
            attachments: _attachments?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CustomerTicketInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
