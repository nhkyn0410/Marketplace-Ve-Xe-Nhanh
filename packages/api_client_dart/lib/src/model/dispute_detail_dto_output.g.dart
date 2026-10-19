// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDetailDtoOutputStatusEnum _$disputeDetailDtoOutputStatusEnum_OPEN =
    const DisputeDetailDtoOutputStatusEnum._('OPEN');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_WAITING_USER_EVIDENCE =
    const DisputeDetailDtoOutputStatusEnum._('WAITING_USER_EVIDENCE');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_WAITING_OPERATOR_RESPONSE =
    const DisputeDetailDtoOutputStatusEnum._('WAITING_OPERATOR_RESPONSE');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_UNDER_REVIEW =
    const DisputeDetailDtoOutputStatusEnum._('UNDER_REVIEW');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_ESCALATED =
    const DisputeDetailDtoOutputStatusEnum._('ESCALATED');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_RESOLVED_REFUND =
    const DisputeDetailDtoOutputStatusEnum._('RESOLVED_REFUND');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_RESOLVED_NO_REFUND =
    const DisputeDetailDtoOutputStatusEnum._('RESOLVED_NO_REFUND');
const DisputeDetailDtoOutputStatusEnum
    _$disputeDetailDtoOutputStatusEnum_CLOSED =
    const DisputeDetailDtoOutputStatusEnum._('CLOSED');

DisputeDetailDtoOutputStatusEnum _$disputeDetailDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'OPEN':
      return _$disputeDetailDtoOutputStatusEnum_OPEN;
    case 'WAITING_USER_EVIDENCE':
      return _$disputeDetailDtoOutputStatusEnum_WAITING_USER_EVIDENCE;
    case 'WAITING_OPERATOR_RESPONSE':
      return _$disputeDetailDtoOutputStatusEnum_WAITING_OPERATOR_RESPONSE;
    case 'UNDER_REVIEW':
      return _$disputeDetailDtoOutputStatusEnum_UNDER_REVIEW;
    case 'ESCALATED':
      return _$disputeDetailDtoOutputStatusEnum_ESCALATED;
    case 'RESOLVED_REFUND':
      return _$disputeDetailDtoOutputStatusEnum_RESOLVED_REFUND;
    case 'RESOLVED_NO_REFUND':
      return _$disputeDetailDtoOutputStatusEnum_RESOLVED_NO_REFUND;
    case 'CLOSED':
      return _$disputeDetailDtoOutputStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDetailDtoOutputStatusEnum>
    _$disputeDetailDtoOutputStatusEnumValues = BuiltSet<
        DisputeDetailDtoOutputStatusEnum>(const <DisputeDetailDtoOutputStatusEnum>[
  _$disputeDetailDtoOutputStatusEnum_OPEN,
  _$disputeDetailDtoOutputStatusEnum_WAITING_USER_EVIDENCE,
  _$disputeDetailDtoOutputStatusEnum_WAITING_OPERATOR_RESPONSE,
  _$disputeDetailDtoOutputStatusEnum_UNDER_REVIEW,
  _$disputeDetailDtoOutputStatusEnum_ESCALATED,
  _$disputeDetailDtoOutputStatusEnum_RESOLVED_REFUND,
  _$disputeDetailDtoOutputStatusEnum_RESOLVED_NO_REFUND,
  _$disputeDetailDtoOutputStatusEnum_CLOSED,
]);

Serializer<DisputeDetailDtoOutputStatusEnum>
    _$disputeDetailDtoOutputStatusEnumSerializer =
    _$DisputeDetailDtoOutputStatusEnumSerializer();

class _$DisputeDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<DisputeDetailDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[DisputeDetailDtoOutputStatusEnum];
  @override
  final String wireName = 'DisputeDetailDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDetailDtoOutput extends DisputeDetailDtoOutput {
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
  final DisputeDetailDtoOutputStatusEnum status;
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
  @override
  final String? customerRequest;
  @override
  final String? supportTicketCode;
  @override
  final int bookingTotal;
  @override
  final int refundableAmount;
  @override
  final String customerName;
  @override
  final DisputeDetailDtoOutputTrip trip;
  @override
  final DateTime? firstCheckInAt;
  @override
  final bool tripChangeNotified;
  @override
  final BuiltList<DisputeDetailDtoOutputCancellationTiersInner>
      cancellationTiers;
  @override
  final BuiltList<DisputeDetailDtoOutputEventsInner> events;
  @override
  final DisputeDetailDtoOutputDecision? decision;

  factory _$DisputeDetailDtoOutput(
          [void Function(DisputeDetailDtoOutputBuilder)? updates]) =>
      (DisputeDetailDtoOutputBuilder()..update(updates))._build();

  _$DisputeDetailDtoOutput._(
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
      required this.updatedAt,
      this.customerRequest,
      this.supportTicketCode,
      required this.bookingTotal,
      required this.refundableAmount,
      required this.customerName,
      required this.trip,
      this.firstCheckInAt,
      required this.tripChangeNotified,
      required this.cancellationTiers,
      required this.events,
      this.decision})
      : super._();
  @override
  DisputeDetailDtoOutput rebuild(
          void Function(DisputeDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailDtoOutputBuilder toBuilder() =>
      DisputeDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailDtoOutput &&
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
        updatedAt == other.updatedAt &&
        customerRequest == other.customerRequest &&
        supportTicketCode == other.supportTicketCode &&
        bookingTotal == other.bookingTotal &&
        refundableAmount == other.refundableAmount &&
        customerName == other.customerName &&
        trip == other.trip &&
        firstCheckInAt == other.firstCheckInAt &&
        tripChangeNotified == other.tripChangeNotified &&
        cancellationTiers == other.cancellationTiers &&
        events == other.events &&
        decision == other.decision;
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
    _$hash = $jc(_$hash, customerRequest.hashCode);
    _$hash = $jc(_$hash, supportTicketCode.hashCode);
    _$hash = $jc(_$hash, bookingTotal.hashCode);
    _$hash = $jc(_$hash, refundableAmount.hashCode);
    _$hash = $jc(_$hash, customerName.hashCode);
    _$hash = $jc(_$hash, trip.hashCode);
    _$hash = $jc(_$hash, firstCheckInAt.hashCode);
    _$hash = $jc(_$hash, tripChangeNotified.hashCode);
    _$hash = $jc(_$hash, cancellationTiers.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDetailDtoOutput')
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
          ..add('updatedAt', updatedAt)
          ..add('customerRequest', customerRequest)
          ..add('supportTicketCode', supportTicketCode)
          ..add('bookingTotal', bookingTotal)
          ..add('refundableAmount', refundableAmount)
          ..add('customerName', customerName)
          ..add('trip', trip)
          ..add('firstCheckInAt', firstCheckInAt)
          ..add('tripChangeNotified', tripChangeNotified)
          ..add('cancellationTiers', cancellationTiers)
          ..add('events', events)
          ..add('decision', decision))
        .toString();
  }
}

class DisputeDetailDtoOutputBuilder
    implements Builder<DisputeDetailDtoOutput, DisputeDetailDtoOutputBuilder> {
  _$DisputeDetailDtoOutput? _$v;

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

  DisputeDetailDtoOutputStatusEnum? _status;
  DisputeDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(DisputeDetailDtoOutputStatusEnum? status) =>
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

  String? _customerRequest;
  String? get customerRequest => _$this._customerRequest;
  set customerRequest(String? customerRequest) =>
      _$this._customerRequest = customerRequest;

  String? _supportTicketCode;
  String? get supportTicketCode => _$this._supportTicketCode;
  set supportTicketCode(String? supportTicketCode) =>
      _$this._supportTicketCode = supportTicketCode;

  int? _bookingTotal;
  int? get bookingTotal => _$this._bookingTotal;
  set bookingTotal(int? bookingTotal) => _$this._bookingTotal = bookingTotal;

  int? _refundableAmount;
  int? get refundableAmount => _$this._refundableAmount;
  set refundableAmount(int? refundableAmount) =>
      _$this._refundableAmount = refundableAmount;

  String? _customerName;
  String? get customerName => _$this._customerName;
  set customerName(String? customerName) => _$this._customerName = customerName;

  DisputeDetailDtoOutputTripBuilder? _trip;
  DisputeDetailDtoOutputTripBuilder get trip =>
      _$this._trip ??= DisputeDetailDtoOutputTripBuilder();
  set trip(DisputeDetailDtoOutputTripBuilder? trip) => _$this._trip = trip;

  DateTime? _firstCheckInAt;
  DateTime? get firstCheckInAt => _$this._firstCheckInAt;
  set firstCheckInAt(DateTime? firstCheckInAt) =>
      _$this._firstCheckInAt = firstCheckInAt;

  bool? _tripChangeNotified;
  bool? get tripChangeNotified => _$this._tripChangeNotified;
  set tripChangeNotified(bool? tripChangeNotified) =>
      _$this._tripChangeNotified = tripChangeNotified;

  ListBuilder<DisputeDetailDtoOutputCancellationTiersInner>? _cancellationTiers;
  ListBuilder<DisputeDetailDtoOutputCancellationTiersInner>
      get cancellationTiers => _$this._cancellationTiers ??=
          ListBuilder<DisputeDetailDtoOutputCancellationTiersInner>();
  set cancellationTiers(
          ListBuilder<DisputeDetailDtoOutputCancellationTiersInner>?
              cancellationTiers) =>
      _$this._cancellationTiers = cancellationTiers;

  ListBuilder<DisputeDetailDtoOutputEventsInner>? _events;
  ListBuilder<DisputeDetailDtoOutputEventsInner> get events =>
      _$this._events ??= ListBuilder<DisputeDetailDtoOutputEventsInner>();
  set events(ListBuilder<DisputeDetailDtoOutputEventsInner>? events) =>
      _$this._events = events;

  DisputeDetailDtoOutputDecisionBuilder? _decision;
  DisputeDetailDtoOutputDecisionBuilder get decision =>
      _$this._decision ??= DisputeDetailDtoOutputDecisionBuilder();
  set decision(DisputeDetailDtoOutputDecisionBuilder? decision) =>
      _$this._decision = decision;

  DisputeDetailDtoOutputBuilder() {
    DisputeDetailDtoOutput._defaults(this);
  }

  DisputeDetailDtoOutputBuilder get _$this {
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
      _customerRequest = $v.customerRequest;
      _supportTicketCode = $v.supportTicketCode;
      _bookingTotal = $v.bookingTotal;
      _refundableAmount = $v.refundableAmount;
      _customerName = $v.customerName;
      _trip = $v.trip.toBuilder();
      _firstCheckInAt = $v.firstCheckInAt;
      _tripChangeNotified = $v.tripChangeNotified;
      _cancellationTiers = $v.cancellationTiers.toBuilder();
      _events = $v.events.toBuilder();
      _decision = $v.decision?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDetailDtoOutput other) {
    _$v = other as _$DisputeDetailDtoOutput;
  }

  @override
  void update(void Function(DisputeDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailDtoOutput build() => _build();

  _$DisputeDetailDtoOutput _build() {
    _$DisputeDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$DisputeDetailDtoOutput._(
            disputeId: BuiltValueNullFieldError.checkNotNull(
                disputeId, r'DisputeDetailDtoOutput', 'disputeId'),
            disputeCode: BuiltValueNullFieldError.checkNotNull(
                disputeCode, r'DisputeDetailDtoOutput', 'disputeCode'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'DisputeDetailDtoOutput', 'title'),
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'DisputeDetailDtoOutput', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'DisputeDetailDtoOutput', 'bookingCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'DisputeDetailDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'DisputeDetailDtoOutput', 'operatorName'),
            paidAmount: BuiltValueNullFieldError.checkNotNull(
                paidAmount, r'DisputeDetailDtoOutput', 'paidAmount'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DisputeDetailDtoOutput', 'status'),
            responseDueAt: responseDueAt,
            overdue: BuiltValueNullFieldError.checkNotNull(
                overdue, r'DisputeDetailDtoOutput', 'overdue'),
            assignee: _assignee?.build(),
            supportTicketId: supportTicketId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'DisputeDetailDtoOutput', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'DisputeDetailDtoOutput', 'updatedAt'),
            customerRequest: customerRequest,
            supportTicketCode: supportTicketCode,
            bookingTotal: BuiltValueNullFieldError.checkNotNull(
                bookingTotal, r'DisputeDetailDtoOutput', 'bookingTotal'),
            refundableAmount: BuiltValueNullFieldError.checkNotNull(
                refundableAmount,
                r'DisputeDetailDtoOutput',
                'refundableAmount'),
            customerName: BuiltValueNullFieldError.checkNotNull(
                customerName, r'DisputeDetailDtoOutput', 'customerName'),
            trip: trip.build(),
            firstCheckInAt: firstCheckInAt,
            tripChangeNotified: BuiltValueNullFieldError.checkNotNull(
                tripChangeNotified,
                r'DisputeDetailDtoOutput',
                'tripChangeNotified'),
            cancellationTiers: cancellationTiers.build(),
            events: events.build(),
            decision: _decision?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'assignee';
        _assignee?.build();

        _$failedField = 'trip';
        trip.build();

        _$failedField = 'cancellationTiers';
        cancellationTiers.build();
        _$failedField = 'events';
        events.build();
        _$failedField = 'decision';
        _decision?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
