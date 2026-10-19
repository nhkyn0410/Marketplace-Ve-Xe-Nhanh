// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_OPEN =
    const DisputePageDtoOutputItemsInnerStatusEnum._('OPEN');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_USER_EVIDENCE =
    const DisputePageDtoOutputItemsInnerStatusEnum._('WAITING_USER_EVIDENCE');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_OPERATOR_RESPONSE =
    const DisputePageDtoOutputItemsInnerStatusEnum._(
        'WAITING_OPERATOR_RESPONSE');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_UNDER_REVIEW =
    const DisputePageDtoOutputItemsInnerStatusEnum._('UNDER_REVIEW');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_ESCALATED =
    const DisputePageDtoOutputItemsInnerStatusEnum._('ESCALATED');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_REFUND =
    const DisputePageDtoOutputItemsInnerStatusEnum._('RESOLVED_REFUND');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_NO_REFUND =
    const DisputePageDtoOutputItemsInnerStatusEnum._('RESOLVED_NO_REFUND');
const DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnum_CLOSED =
    const DisputePageDtoOutputItemsInnerStatusEnum._('CLOSED');

DisputePageDtoOutputItemsInnerStatusEnum
    _$disputePageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$disputePageDtoOutputItemsInnerStatusEnum_OPEN;
    case 'WAITING_USER_EVIDENCE':
      return _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_USER_EVIDENCE;
    case 'WAITING_OPERATOR_RESPONSE':
      return _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_OPERATOR_RESPONSE;
    case 'UNDER_REVIEW':
      return _$disputePageDtoOutputItemsInnerStatusEnum_UNDER_REVIEW;
    case 'ESCALATED':
      return _$disputePageDtoOutputItemsInnerStatusEnum_ESCALATED;
    case 'RESOLVED_REFUND':
      return _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_REFUND;
    case 'RESOLVED_NO_REFUND':
      return _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_NO_REFUND;
    case 'CLOSED':
      return _$disputePageDtoOutputItemsInnerStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputePageDtoOutputItemsInnerStatusEnum>
    _$disputePageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        DisputePageDtoOutputItemsInnerStatusEnum>(const <DisputePageDtoOutputItemsInnerStatusEnum>[
  _$disputePageDtoOutputItemsInnerStatusEnum_OPEN,
  _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_USER_EVIDENCE,
  _$disputePageDtoOutputItemsInnerStatusEnum_WAITING_OPERATOR_RESPONSE,
  _$disputePageDtoOutputItemsInnerStatusEnum_UNDER_REVIEW,
  _$disputePageDtoOutputItemsInnerStatusEnum_ESCALATED,
  _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_REFUND,
  _$disputePageDtoOutputItemsInnerStatusEnum_RESOLVED_NO_REFUND,
  _$disputePageDtoOutputItemsInnerStatusEnum_CLOSED,
]);

Serializer<DisputePageDtoOutputItemsInnerStatusEnum>
    _$disputePageDtoOutputItemsInnerStatusEnumSerializer =
    _$DisputePageDtoOutputItemsInnerStatusEnumSerializer();

class _$DisputePageDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<DisputePageDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'WAITING_USER_EVIDENCE': 'WAITING_USER_EVIDENCE',
    'WAITING_OPERATOR_RESPONSE': 'WAITING_OPERATOR_RESPONSE',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'RESOLVED_REFUND': 'RESOLVED_REFUND',
    'RESOLVED_NO_REFUND': 'RESOLVED_NO_REFUND',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'WAITING_USER_EVIDENCE': 'WAITING_USER_EVIDENCE',
    'WAITING_OPERATOR_RESPONSE': 'WAITING_OPERATOR_RESPONSE',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'ESCALATED': 'ESCALATED',
    'RESOLVED_REFUND': 'RESOLVED_REFUND',
    'RESOLVED_NO_REFUND': 'RESOLVED_NO_REFUND',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DisputePageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'DisputePageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          DisputePageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputePageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputePageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputePageDtoOutputItemsInner extends DisputePageDtoOutputItemsInner {
  @override
  final String disputeId;
  @override
  final String disputeCode;
  @override
  final String title;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final int paidAmount;
  @override
  final DisputePageDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime? responseDueAt;
  @override
  final bool overdue;
  @override
  final CustomerTicketListDtoOutputItemsInnerAssignee? assignee;
  @override
  final String? supportTicketId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$DisputePageDtoOutputItemsInner(
          [void Function(DisputePageDtoOutputItemsInnerBuilder)? updates]) =>
      (DisputePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$DisputePageDtoOutputItemsInner._(
      {required this.disputeId,
      required this.disputeCode,
      required this.title,
      required this.bookingId,
      required this.bookingCode,
      required this.operatorId,
      required this.operatorName,
      required this.paidAmount,
      required this.status,
      this.responseDueAt,
      required this.overdue,
      this.assignee,
      this.supportTicketId,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  DisputePageDtoOutputItemsInner rebuild(
          void Function(DisputePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputePageDtoOutputItemsInnerBuilder toBuilder() =>
      DisputePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputePageDtoOutputItemsInner &&
        disputeId == other.disputeId &&
        disputeCode == other.disputeCode &&
        title == other.title &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        paidAmount == other.paidAmount &&
        status == other.status &&
        responseDueAt == other.responseDueAt &&
        overdue == other.overdue &&
        assignee == other.assignee &&
        supportTicketId == other.supportTicketId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, disputeId.hashCode);
    _$hash = $jc(_$hash, disputeCode.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, paidAmount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, responseDueAt.hashCode);
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jc(_$hash, assignee.hashCode);
    _$hash = $jc(_$hash, supportTicketId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputePageDtoOutputItemsInner')
          ..add('disputeId', disputeId)
          ..add('disputeCode', disputeCode)
          ..add('title', title)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('paidAmount', paidAmount)
          ..add('status', status)
          ..add('responseDueAt', responseDueAt)
          ..add('overdue', overdue)
          ..add('assignee', assignee)
          ..add('supportTicketId', supportTicketId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DisputePageDtoOutputItemsInnerBuilder
    implements
        Builder<DisputePageDtoOutputItemsInner,
            DisputePageDtoOutputItemsInnerBuilder> {
  _$DisputePageDtoOutputItemsInner? _$v;

  String? _disputeId;
  String? get disputeId => _$this._disputeId;
  set disputeId(String? disputeId) => _$this._disputeId = disputeId;

  String? _disputeCode;
  String? get disputeCode => _$this._disputeCode;
  set disputeCode(String? disputeCode) => _$this._disputeCode = disputeCode;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  int? _paidAmount;
  int? get paidAmount => _$this._paidAmount;
  set paidAmount(int? paidAmount) => _$this._paidAmount = paidAmount;

  DisputePageDtoOutputItemsInnerStatusEnum? _status;
  DisputePageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(DisputePageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _responseDueAt;
  DateTime? get responseDueAt => _$this._responseDueAt;
  set responseDueAt(DateTime? responseDueAt) =>
      _$this._responseDueAt = responseDueAt;

  bool? _overdue;
  bool? get overdue => _$this._overdue;
  set overdue(bool? overdue) => _$this._overdue = overdue;

  CustomerTicketListDtoOutputItemsInnerAssigneeBuilder? _assignee;
  CustomerTicketListDtoOutputItemsInnerAssigneeBuilder get assignee =>
      _$this._assignee ??=
          CustomerTicketListDtoOutputItemsInnerAssigneeBuilder();
  set assignee(
          CustomerTicketListDtoOutputItemsInnerAssigneeBuilder? assignee) =>
      _$this._assignee = assignee;

  String? _supportTicketId;
  String? get supportTicketId => _$this._supportTicketId;
  set supportTicketId(String? supportTicketId) =>
      _$this._supportTicketId = supportTicketId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DisputePageDtoOutputItemsInnerBuilder() {
    DisputePageDtoOutputItemsInner._defaults(this);
  }

  DisputePageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _disputeId = $v.disputeId;
      _disputeCode = $v.disputeCode;
      _title = $v.title;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _paidAmount = $v.paidAmount;
      _status = $v.status;
      _responseDueAt = $v.responseDueAt;
      _overdue = $v.overdue;
      _assignee = $v.assignee?.toBuilder();
      _supportTicketId = $v.supportTicketId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputePageDtoOutputItemsInner other) {
    _$v = other as _$DisputePageDtoOutputItemsInner;
  }

  @override
  void update(void Function(DisputePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputePageDtoOutputItemsInner build() => _build();

  _$DisputePageDtoOutputItemsInner _build() {
    _$DisputePageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$DisputePageDtoOutputItemsInner._(
            disputeId: BuiltValueNullFieldError.checkNotNull(
                disputeId, r'DisputePageDtoOutputItemsInner', 'disputeId'),
            disputeCode: BuiltValueNullFieldError.checkNotNull(
                disputeCode, r'DisputePageDtoOutputItemsInner', 'disputeCode'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'DisputePageDtoOutputItemsInner', 'title'),
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'DisputePageDtoOutputItemsInner', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'DisputePageDtoOutputItemsInner', 'bookingCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'DisputePageDtoOutputItemsInner', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
                r'DisputePageDtoOutputItemsInner', 'operatorName'),
            paidAmount: BuiltValueNullFieldError.checkNotNull(
                paidAmount, r'DisputePageDtoOutputItemsInner', 'paidAmount'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DisputePageDtoOutputItemsInner', 'status'),
            responseDueAt: responseDueAt,
            overdue: BuiltValueNullFieldError.checkNotNull(
                overdue, r'DisputePageDtoOutputItemsInner', 'overdue'),
            assignee: _assignee?.build(),
            supportTicketId: supportTicketId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'DisputePageDtoOutputItemsInner', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'DisputePageDtoOutputItemsInner', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'assignee';
        _assignee?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputePageDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
