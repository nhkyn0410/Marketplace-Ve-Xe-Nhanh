// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_record_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReconciliationRecordDtoOutputSource_Enum
    _$reconciliationRecordDtoOutputSourceEnum_MANUAL =
    const ReconciliationRecordDtoOutputSource_Enum._('MANUAL');
const ReconciliationRecordDtoOutputSource_Enum
    _$reconciliationRecordDtoOutputSourceEnum_SCHEDULED =
    const ReconciliationRecordDtoOutputSource_Enum._('SCHEDULED');

ReconciliationRecordDtoOutputSource_Enum
    _$reconciliationRecordDtoOutputSourceEnumValueOf(String name) {
  switch (name) {
    case 'MANUAL':
      return _$reconciliationRecordDtoOutputSourceEnum_MANUAL;
    case 'SCHEDULED':
      return _$reconciliationRecordDtoOutputSourceEnum_SCHEDULED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReconciliationRecordDtoOutputSource_Enum>
    _$reconciliationRecordDtoOutputSourceEnumValues = BuiltSet<
        ReconciliationRecordDtoOutputSource_Enum>(const <ReconciliationRecordDtoOutputSource_Enum>[
  _$reconciliationRecordDtoOutputSourceEnum_MANUAL,
  _$reconciliationRecordDtoOutputSourceEnum_SCHEDULED,
]);

const ReconciliationRecordDtoOutputStatusEnum
    _$reconciliationRecordDtoOutputStatusEnum_QUEUED =
    const ReconciliationRecordDtoOutputStatusEnum._('QUEUED');
const ReconciliationRecordDtoOutputStatusEnum
    _$reconciliationRecordDtoOutputStatusEnum_RUNNING =
    const ReconciliationRecordDtoOutputStatusEnum._('RUNNING');
const ReconciliationRecordDtoOutputStatusEnum
    _$reconciliationRecordDtoOutputStatusEnum_COMPLETED =
    const ReconciliationRecordDtoOutputStatusEnum._('COMPLETED');
const ReconciliationRecordDtoOutputStatusEnum
    _$reconciliationRecordDtoOutputStatusEnum_FAILED =
    const ReconciliationRecordDtoOutputStatusEnum._('FAILED');

ReconciliationRecordDtoOutputStatusEnum
    _$reconciliationRecordDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'QUEUED':
      return _$reconciliationRecordDtoOutputStatusEnum_QUEUED;
    case 'RUNNING':
      return _$reconciliationRecordDtoOutputStatusEnum_RUNNING;
    case 'COMPLETED':
      return _$reconciliationRecordDtoOutputStatusEnum_COMPLETED;
    case 'FAILED':
      return _$reconciliationRecordDtoOutputStatusEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReconciliationRecordDtoOutputStatusEnum>
    _$reconciliationRecordDtoOutputStatusEnumValues = BuiltSet<
        ReconciliationRecordDtoOutputStatusEnum>(const <ReconciliationRecordDtoOutputStatusEnum>[
  _$reconciliationRecordDtoOutputStatusEnum_QUEUED,
  _$reconciliationRecordDtoOutputStatusEnum_RUNNING,
  _$reconciliationRecordDtoOutputStatusEnum_COMPLETED,
  _$reconciliationRecordDtoOutputStatusEnum_FAILED,
]);

Serializer<ReconciliationRecordDtoOutputSource_Enum>
    _$reconciliationRecordDtoOutputSourceEnumSerializer =
    _$ReconciliationRecordDtoOutputSource_EnumSerializer();
Serializer<ReconciliationRecordDtoOutputStatusEnum>
    _$reconciliationRecordDtoOutputStatusEnumSerializer =
    _$ReconciliationRecordDtoOutputStatusEnumSerializer();

class _$ReconciliationRecordDtoOutputSource_EnumSerializer
    implements PrimitiveSerializer<ReconciliationRecordDtoOutputSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL': 'MANUAL',
    'SCHEDULED': 'SCHEDULED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL': 'MANUAL',
    'SCHEDULED': 'SCHEDULED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ReconciliationRecordDtoOutputSource_Enum
  ];
  @override
  final String wireName = 'ReconciliationRecordDtoOutputSource_Enum';

  @override
  Object serialize(Serializers serializers,
          ReconciliationRecordDtoOutputSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReconciliationRecordDtoOutputSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReconciliationRecordDtoOutputSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReconciliationRecordDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ReconciliationRecordDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUEUED': 'QUEUED',
    'RUNNING': 'RUNNING',
    'COMPLETED': 'COMPLETED',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUEUED': 'QUEUED',
    'RUNNING': 'RUNNING',
    'COMPLETED': 'COMPLETED',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ReconciliationRecordDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'ReconciliationRecordDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ReconciliationRecordDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReconciliationRecordDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReconciliationRecordDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReconciliationRecordDtoOutput extends ReconciliationRecordDtoOutput {
  @override
  final String runId;
  @override
  final ReconciliationRecordDtoOutputSource_Enum source_;
  @override
  final ReconciliationRecordDtoOutputStatusEnum status;
  @override
  final String checkpoint;
  @override
  final int paymentsChecked;
  @override
  final int paymentErrors;
  @override
  final int ledgerEntriesChecked;
  @override
  final int payoutsChecked;
  @override
  final int issueCount;
  @override
  final BuiltList<ReconciliationPageDtoOutputItemsInnerIssuesInner> issues;
  @override
  final String? error;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final DateTime createdAt;

  factory _$ReconciliationRecordDtoOutput(
          [void Function(ReconciliationRecordDtoOutputBuilder)? updates]) =>
      (ReconciliationRecordDtoOutputBuilder()..update(updates))._build();

  _$ReconciliationRecordDtoOutput._(
      {required this.runId,
      required this.source_,
      required this.status,
      required this.checkpoint,
      required this.paymentsChecked,
      required this.paymentErrors,
      required this.ledgerEntriesChecked,
      required this.payoutsChecked,
      required this.issueCount,
      required this.issues,
      this.error,
      this.startedAt,
      this.finishedAt,
      required this.createdAt})
      : super._();
  @override
  ReconciliationRecordDtoOutput rebuild(
          void Function(ReconciliationRecordDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReconciliationRecordDtoOutputBuilder toBuilder() =>
      ReconciliationRecordDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReconciliationRecordDtoOutput &&
        runId == other.runId &&
        source_ == other.source_ &&
        status == other.status &&
        checkpoint == other.checkpoint &&
        paymentsChecked == other.paymentsChecked &&
        paymentErrors == other.paymentErrors &&
        ledgerEntriesChecked == other.ledgerEntriesChecked &&
        payoutsChecked == other.payoutsChecked &&
        issueCount == other.issueCount &&
        issues == other.issues &&
        error == other.error &&
        startedAt == other.startedAt &&
        finishedAt == other.finishedAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, runId.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, checkpoint.hashCode);
    _$hash = $jc(_$hash, paymentsChecked.hashCode);
    _$hash = $jc(_$hash, paymentErrors.hashCode);
    _$hash = $jc(_$hash, ledgerEntriesChecked.hashCode);
    _$hash = $jc(_$hash, payoutsChecked.hashCode);
    _$hash = $jc(_$hash, issueCount.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, finishedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReconciliationRecordDtoOutput')
          ..add('runId', runId)
          ..add('source_', source_)
          ..add('status', status)
          ..add('checkpoint', checkpoint)
          ..add('paymentsChecked', paymentsChecked)
          ..add('paymentErrors', paymentErrors)
          ..add('ledgerEntriesChecked', ledgerEntriesChecked)
          ..add('payoutsChecked', payoutsChecked)
          ..add('issueCount', issueCount)
          ..add('issues', issues)
          ..add('error', error)
          ..add('startedAt', startedAt)
          ..add('finishedAt', finishedAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ReconciliationRecordDtoOutputBuilder
    implements
        Builder<ReconciliationRecordDtoOutput,
            ReconciliationRecordDtoOutputBuilder> {
  _$ReconciliationRecordDtoOutput? _$v;

  String? _runId;
  String? get runId => _$this._runId;
  set runId(String? runId) => _$this._runId = runId;

  ReconciliationRecordDtoOutputSource_Enum? _source_;
  ReconciliationRecordDtoOutputSource_Enum? get source_ => _$this._source_;
  set source_(ReconciliationRecordDtoOutputSource_Enum? source_) =>
      _$this._source_ = source_;

  ReconciliationRecordDtoOutputStatusEnum? _status;
  ReconciliationRecordDtoOutputStatusEnum? get status => _$this._status;
  set status(ReconciliationRecordDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _checkpoint;
  String? get checkpoint => _$this._checkpoint;
  set checkpoint(String? checkpoint) => _$this._checkpoint = checkpoint;

  int? _paymentsChecked;
  int? get paymentsChecked => _$this._paymentsChecked;
  set paymentsChecked(int? paymentsChecked) =>
      _$this._paymentsChecked = paymentsChecked;

  int? _paymentErrors;
  int? get paymentErrors => _$this._paymentErrors;
  set paymentErrors(int? paymentErrors) =>
      _$this._paymentErrors = paymentErrors;

  int? _ledgerEntriesChecked;
  int? get ledgerEntriesChecked => _$this._ledgerEntriesChecked;
  set ledgerEntriesChecked(int? ledgerEntriesChecked) =>
      _$this._ledgerEntriesChecked = ledgerEntriesChecked;

  int? _payoutsChecked;
  int? get payoutsChecked => _$this._payoutsChecked;
  set payoutsChecked(int? payoutsChecked) =>
      _$this._payoutsChecked = payoutsChecked;

  int? _issueCount;
  int? get issueCount => _$this._issueCount;
  set issueCount(int? issueCount) => _$this._issueCount = issueCount;

  ListBuilder<ReconciliationPageDtoOutputItemsInnerIssuesInner>? _issues;
  ListBuilder<ReconciliationPageDtoOutputItemsInnerIssuesInner> get issues =>
      _$this._issues ??=
          ListBuilder<ReconciliationPageDtoOutputItemsInnerIssuesInner>();
  set issues(
          ListBuilder<ReconciliationPageDtoOutputItemsInnerIssuesInner>?
              issues) =>
      _$this._issues = issues;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _finishedAt;
  DateTime? get finishedAt => _$this._finishedAt;
  set finishedAt(DateTime? finishedAt) => _$this._finishedAt = finishedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ReconciliationRecordDtoOutputBuilder() {
    ReconciliationRecordDtoOutput._defaults(this);
  }

  ReconciliationRecordDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _runId = $v.runId;
      _source_ = $v.source_;
      _status = $v.status;
      _checkpoint = $v.checkpoint;
      _paymentsChecked = $v.paymentsChecked;
      _paymentErrors = $v.paymentErrors;
      _ledgerEntriesChecked = $v.ledgerEntriesChecked;
      _payoutsChecked = $v.payoutsChecked;
      _issueCount = $v.issueCount;
      _issues = $v.issues.toBuilder();
      _error = $v.error;
      _startedAt = $v.startedAt;
      _finishedAt = $v.finishedAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReconciliationRecordDtoOutput other) {
    _$v = other as _$ReconciliationRecordDtoOutput;
  }

  @override
  void update(void Function(ReconciliationRecordDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReconciliationRecordDtoOutput build() => _build();

  _$ReconciliationRecordDtoOutput _build() {
    _$ReconciliationRecordDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ReconciliationRecordDtoOutput._(
            runId: BuiltValueNullFieldError.checkNotNull(
                runId, r'ReconciliationRecordDtoOutput', 'runId'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'ReconciliationRecordDtoOutput', 'source_'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ReconciliationRecordDtoOutput', 'status'),
            checkpoint: BuiltValueNullFieldError.checkNotNull(
                checkpoint, r'ReconciliationRecordDtoOutput', 'checkpoint'),
            paymentsChecked: BuiltValueNullFieldError.checkNotNull(
                paymentsChecked,
                r'ReconciliationRecordDtoOutput',
                'paymentsChecked'),
            paymentErrors: BuiltValueNullFieldError.checkNotNull(paymentErrors,
                r'ReconciliationRecordDtoOutput', 'paymentErrors'),
            ledgerEntriesChecked: BuiltValueNullFieldError.checkNotNull(
                ledgerEntriesChecked,
                r'ReconciliationRecordDtoOutput',
                'ledgerEntriesChecked'),
            payoutsChecked: BuiltValueNullFieldError.checkNotNull(
                payoutsChecked,
                r'ReconciliationRecordDtoOutput',
                'payoutsChecked'),
            issueCount: BuiltValueNullFieldError.checkNotNull(
                issueCount, r'ReconciliationRecordDtoOutput', 'issueCount'),
            issues: issues.build(),
            error: error,
            startedAt: startedAt,
            finishedAt: finishedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ReconciliationRecordDtoOutput', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReconciliationRecordDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
