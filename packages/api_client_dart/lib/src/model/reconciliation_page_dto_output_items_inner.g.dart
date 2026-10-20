// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReconciliationPageDtoOutputItemsInnerSource_Enum
    _$reconciliationPageDtoOutputItemsInnerSourceEnum_MANUAL =
    const ReconciliationPageDtoOutputItemsInnerSource_Enum._('MANUAL');
const ReconciliationPageDtoOutputItemsInnerSource_Enum
    _$reconciliationPageDtoOutputItemsInnerSourceEnum_SCHEDULED =
    const ReconciliationPageDtoOutputItemsInnerSource_Enum._('SCHEDULED');

ReconciliationPageDtoOutputItemsInnerSource_Enum
    _$reconciliationPageDtoOutputItemsInnerSourceEnumValueOf(String name) {
  switch (name) {
    case 'MANUAL':
      return _$reconciliationPageDtoOutputItemsInnerSourceEnum_MANUAL;
    case 'SCHEDULED':
      return _$reconciliationPageDtoOutputItemsInnerSourceEnum_SCHEDULED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReconciliationPageDtoOutputItemsInnerSource_Enum>
    _$reconciliationPageDtoOutputItemsInnerSourceEnumValues = BuiltSet<
        ReconciliationPageDtoOutputItemsInnerSource_Enum>(const <ReconciliationPageDtoOutputItemsInnerSource_Enum>[
  _$reconciliationPageDtoOutputItemsInnerSourceEnum_MANUAL,
  _$reconciliationPageDtoOutputItemsInnerSourceEnum_SCHEDULED,
]);

const ReconciliationPageDtoOutputItemsInnerStatusEnum
    _$reconciliationPageDtoOutputItemsInnerStatusEnum_QUEUED =
    const ReconciliationPageDtoOutputItemsInnerStatusEnum._('QUEUED');
const ReconciliationPageDtoOutputItemsInnerStatusEnum
    _$reconciliationPageDtoOutputItemsInnerStatusEnum_RUNNING =
    const ReconciliationPageDtoOutputItemsInnerStatusEnum._('RUNNING');
const ReconciliationPageDtoOutputItemsInnerStatusEnum
    _$reconciliationPageDtoOutputItemsInnerStatusEnum_COMPLETED =
    const ReconciliationPageDtoOutputItemsInnerStatusEnum._('COMPLETED');
const ReconciliationPageDtoOutputItemsInnerStatusEnum
    _$reconciliationPageDtoOutputItemsInnerStatusEnum_FAILED =
    const ReconciliationPageDtoOutputItemsInnerStatusEnum._('FAILED');

ReconciliationPageDtoOutputItemsInnerStatusEnum
    _$reconciliationPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'QUEUED':
      return _$reconciliationPageDtoOutputItemsInnerStatusEnum_QUEUED;
    case 'RUNNING':
      return _$reconciliationPageDtoOutputItemsInnerStatusEnum_RUNNING;
    case 'COMPLETED':
      return _$reconciliationPageDtoOutputItemsInnerStatusEnum_COMPLETED;
    case 'FAILED':
      return _$reconciliationPageDtoOutputItemsInnerStatusEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReconciliationPageDtoOutputItemsInnerStatusEnum>
    _$reconciliationPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        ReconciliationPageDtoOutputItemsInnerStatusEnum>(const <ReconciliationPageDtoOutputItemsInnerStatusEnum>[
  _$reconciliationPageDtoOutputItemsInnerStatusEnum_QUEUED,
  _$reconciliationPageDtoOutputItemsInnerStatusEnum_RUNNING,
  _$reconciliationPageDtoOutputItemsInnerStatusEnum_COMPLETED,
  _$reconciliationPageDtoOutputItemsInnerStatusEnum_FAILED,
]);

Serializer<ReconciliationPageDtoOutputItemsInnerSource_Enum>
    _$reconciliationPageDtoOutputItemsInnerSourceEnumSerializer =
    _$ReconciliationPageDtoOutputItemsInnerSource_EnumSerializer();
Serializer<ReconciliationPageDtoOutputItemsInnerStatusEnum>
    _$reconciliationPageDtoOutputItemsInnerStatusEnumSerializer =
    _$ReconciliationPageDtoOutputItemsInnerStatusEnumSerializer();

class _$ReconciliationPageDtoOutputItemsInnerSource_EnumSerializer
    implements
        PrimitiveSerializer<ReconciliationPageDtoOutputItemsInnerSource_Enum> {
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
    ReconciliationPageDtoOutputItemsInnerSource_Enum
  ];
  @override
  final String wireName = 'ReconciliationPageDtoOutputItemsInnerSource_Enum';

  @override
  Object serialize(Serializers serializers,
          ReconciliationPageDtoOutputItemsInnerSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReconciliationPageDtoOutputItemsInnerSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReconciliationPageDtoOutputItemsInnerSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReconciliationPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<ReconciliationPageDtoOutputItemsInnerStatusEnum> {
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
    ReconciliationPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'ReconciliationPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ReconciliationPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReconciliationPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReconciliationPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReconciliationPageDtoOutputItemsInner
    extends ReconciliationPageDtoOutputItemsInner {
  @override
  final String runId;
  @override
  final ReconciliationPageDtoOutputItemsInnerSource_Enum source_;
  @override
  final ReconciliationPageDtoOutputItemsInnerStatusEnum status;
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

  factory _$ReconciliationPageDtoOutputItemsInner(
          [void Function(ReconciliationPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (ReconciliationPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$ReconciliationPageDtoOutputItemsInner._(
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
  ReconciliationPageDtoOutputItemsInner rebuild(
          void Function(ReconciliationPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReconciliationPageDtoOutputItemsInnerBuilder toBuilder() =>
      ReconciliationPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReconciliationPageDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'ReconciliationPageDtoOutputItemsInner')
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

class ReconciliationPageDtoOutputItemsInnerBuilder
    implements
        Builder<ReconciliationPageDtoOutputItemsInner,
            ReconciliationPageDtoOutputItemsInnerBuilder> {
  _$ReconciliationPageDtoOutputItemsInner? _$v;

  String? _runId;
  String? get runId => _$this._runId;
  set runId(String? runId) => _$this._runId = runId;

  ReconciliationPageDtoOutputItemsInnerSource_Enum? _source_;
  ReconciliationPageDtoOutputItemsInnerSource_Enum? get source_ =>
      _$this._source_;
  set source_(ReconciliationPageDtoOutputItemsInnerSource_Enum? source_) =>
      _$this._source_ = source_;

  ReconciliationPageDtoOutputItemsInnerStatusEnum? _status;
  ReconciliationPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(ReconciliationPageDtoOutputItemsInnerStatusEnum? status) =>
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

  ReconciliationPageDtoOutputItemsInnerBuilder() {
    ReconciliationPageDtoOutputItemsInner._defaults(this);
  }

  ReconciliationPageDtoOutputItemsInnerBuilder get _$this {
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
  void replace(ReconciliationPageDtoOutputItemsInner other) {
    _$v = other as _$ReconciliationPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(ReconciliationPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReconciliationPageDtoOutputItemsInner build() => _build();

  _$ReconciliationPageDtoOutputItemsInner _build() {
    _$ReconciliationPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$ReconciliationPageDtoOutputItemsInner._(
            runId: BuiltValueNullFieldError.checkNotNull(
                runId, r'ReconciliationPageDtoOutputItemsInner', 'runId'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'ReconciliationPageDtoOutputItemsInner', 'source_'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ReconciliationPageDtoOutputItemsInner', 'status'),
            checkpoint: BuiltValueNullFieldError.checkNotNull(checkpoint,
                r'ReconciliationPageDtoOutputItemsInner', 'checkpoint'),
            paymentsChecked: BuiltValueNullFieldError.checkNotNull(
                paymentsChecked,
                r'ReconciliationPageDtoOutputItemsInner',
                'paymentsChecked'),
            paymentErrors: BuiltValueNullFieldError.checkNotNull(paymentErrors,
                r'ReconciliationPageDtoOutputItemsInner', 'paymentErrors'),
            ledgerEntriesChecked: BuiltValueNullFieldError.checkNotNull(
                ledgerEntriesChecked,
                r'ReconciliationPageDtoOutputItemsInner',
                'ledgerEntriesChecked'),
            payoutsChecked: BuiltValueNullFieldError.checkNotNull(
                payoutsChecked,
                r'ReconciliationPageDtoOutputItemsInner',
                'payoutsChecked'),
            issueCount: BuiltValueNullFieldError.checkNotNull(issueCount,
                r'ReconciliationPageDtoOutputItemsInner', 'issueCount'),
            issues: issues.build(),
            error: error,
            startedAt: startedAt,
            finishedAt: finishedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'ReconciliationPageDtoOutputItemsInner', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReconciliationPageDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
