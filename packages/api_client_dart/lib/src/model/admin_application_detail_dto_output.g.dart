// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnum_DRAFT =
    const AdminApplicationDetailDtoOutputStatusEnum._('DRAFT');
const AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnum_SUBMITTED =
    const AdminApplicationDetailDtoOutputStatusEnum._('SUBMITTED');
const AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnum_NEEDS_INFO =
    const AdminApplicationDetailDtoOutputStatusEnum._('NEEDS_INFO');
const AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnum_APPROVED =
    const AdminApplicationDetailDtoOutputStatusEnum._('APPROVED');
const AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnum_REJECTED =
    const AdminApplicationDetailDtoOutputStatusEnum._('REJECTED');

AdminApplicationDetailDtoOutputStatusEnum
    _$adminApplicationDetailDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminApplicationDetailDtoOutputStatusEnum_DRAFT;
    case 'SUBMITTED':
      return _$adminApplicationDetailDtoOutputStatusEnum_SUBMITTED;
    case 'NEEDS_INFO':
      return _$adminApplicationDetailDtoOutputStatusEnum_NEEDS_INFO;
    case 'APPROVED':
      return _$adminApplicationDetailDtoOutputStatusEnum_APPROVED;
    case 'REJECTED':
      return _$adminApplicationDetailDtoOutputStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApplicationDetailDtoOutputStatusEnum>
    _$adminApplicationDetailDtoOutputStatusEnumValues = BuiltSet<
        AdminApplicationDetailDtoOutputStatusEnum>(const <AdminApplicationDetailDtoOutputStatusEnum>[
  _$adminApplicationDetailDtoOutputStatusEnum_DRAFT,
  _$adminApplicationDetailDtoOutputStatusEnum_SUBMITTED,
  _$adminApplicationDetailDtoOutputStatusEnum_NEEDS_INFO,
  _$adminApplicationDetailDtoOutputStatusEnum_APPROVED,
  _$adminApplicationDetailDtoOutputStatusEnum_REJECTED,
]);

Serializer<AdminApplicationDetailDtoOutputStatusEnum>
    _$adminApplicationDetailDtoOutputStatusEnumSerializer =
    _$AdminApplicationDetailDtoOutputStatusEnumSerializer();

class _$AdminApplicationDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminApplicationDetailDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'SUBMITTED': 'SUBMITTED',
    'NEEDS_INFO': 'NEEDS_INFO',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'SUBMITTED': 'SUBMITTED',
    'NEEDS_INFO': 'NEEDS_INFO',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminApplicationDetailDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminApplicationDetailDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminApplicationDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminApplicationDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminApplicationDetailDtoOutput
    extends AdminApplicationDetailDtoOutput {
  @override
  final String id;
  @override
  final String applicationCode;
  @override
  final AdminApplicationDetailDtoOutputStatusEnum status;
  @override
  final String operatorName;
  @override
  final String contactName;
  @override
  final String contactEmail;
  @override
  final DateTime? contactEmailVerifiedAt;
  @override
  final String? legalName;
  @override
  final String? taxCode;
  @override
  final String? hotline;
  @override
  final String? address;
  @override
  final String? displayName;
  @override
  final String? description;
  @override
  final String? bankName;
  @override
  final String? bankAccountNumberMasked;
  @override
  final String? bankAccountHolder;
  @override
  final BuiltList<AdminApplicationDetailDtoOutputDocumentsInner> documents;
  @override
  final String? reviewNote;
  @override
  final DateTime createdAt;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  final AdminApplicationDetailDtoOutputDuplicates duplicates;
  @override
  final AdminApplicationDetailDtoOutputOperator? operator_;
  @override
  final BuiltList<AdminApplicationDetailDtoOutputHistoryInner>? history;

  factory _$AdminApplicationDetailDtoOutput(
          [void Function(AdminApplicationDetailDtoOutputBuilder)? updates]) =>
      (AdminApplicationDetailDtoOutputBuilder()..update(updates))._build();

  _$AdminApplicationDetailDtoOutput._(
      {required this.id,
      required this.applicationCode,
      required this.status,
      required this.operatorName,
      required this.contactName,
      required this.contactEmail,
      this.contactEmailVerifiedAt,
      this.legalName,
      this.taxCode,
      this.hotline,
      this.address,
      this.displayName,
      this.description,
      this.bankName,
      this.bankAccountNumberMasked,
      this.bankAccountHolder,
      required this.documents,
      this.reviewNote,
      required this.createdAt,
      this.submittedAt,
      this.reviewedAt,
      required this.duplicates,
      this.operator_,
      this.history})
      : super._();
  @override
  AdminApplicationDetailDtoOutput rebuild(
          void Function(AdminApplicationDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputBuilder toBuilder() =>
      AdminApplicationDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationDetailDtoOutput &&
        id == other.id &&
        applicationCode == other.applicationCode &&
        status == other.status &&
        operatorName == other.operatorName &&
        contactName == other.contactName &&
        contactEmail == other.contactEmail &&
        contactEmailVerifiedAt == other.contactEmailVerifiedAt &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        hotline == other.hotline &&
        address == other.address &&
        displayName == other.displayName &&
        description == other.description &&
        bankName == other.bankName &&
        bankAccountNumberMasked == other.bankAccountNumberMasked &&
        bankAccountHolder == other.bankAccountHolder &&
        documents == other.documents &&
        reviewNote == other.reviewNote &&
        createdAt == other.createdAt &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        duplicates == other.duplicates &&
        operator_ == other.operator_ &&
        history == other.history;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, contactEmailVerifiedAt.hashCode);
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, bankAccountNumberMasked.hashCode);
    _$hash = $jc(_$hash, bankAccountHolder.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jc(_$hash, reviewNote.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, duplicates.hashCode);
    _$hash = $jc(_$hash, operator_.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminApplicationDetailDtoOutput')
          ..add('id', id)
          ..add('applicationCode', applicationCode)
          ..add('status', status)
          ..add('operatorName', operatorName)
          ..add('contactName', contactName)
          ..add('contactEmail', contactEmail)
          ..add('contactEmailVerifiedAt', contactEmailVerifiedAt)
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('hotline', hotline)
          ..add('address', address)
          ..add('displayName', displayName)
          ..add('description', description)
          ..add('bankName', bankName)
          ..add('bankAccountNumberMasked', bankAccountNumberMasked)
          ..add('bankAccountHolder', bankAccountHolder)
          ..add('documents', documents)
          ..add('reviewNote', reviewNote)
          ..add('createdAt', createdAt)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('duplicates', duplicates)
          ..add('operator_', operator_)
          ..add('history', history))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputBuilder
    implements
        Builder<AdminApplicationDetailDtoOutput,
            AdminApplicationDetailDtoOutputBuilder> {
  _$AdminApplicationDetailDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  AdminApplicationDetailDtoOutputStatusEnum? _status;
  AdminApplicationDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminApplicationDetailDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  DateTime? _contactEmailVerifiedAt;
  DateTime? get contactEmailVerifiedAt => _$this._contactEmailVerifiedAt;
  set contactEmailVerifiedAt(DateTime? contactEmailVerifiedAt) =>
      _$this._contactEmailVerifiedAt = contactEmailVerifiedAt;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _taxCode;
  String? get taxCode => _$this._taxCode;
  set taxCode(String? taxCode) => _$this._taxCode = taxCode;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _bankName;
  String? get bankName => _$this._bankName;
  set bankName(String? bankName) => _$this._bankName = bankName;

  String? _bankAccountNumberMasked;
  String? get bankAccountNumberMasked => _$this._bankAccountNumberMasked;
  set bankAccountNumberMasked(String? bankAccountNumberMasked) =>
      _$this._bankAccountNumberMasked = bankAccountNumberMasked;

  String? _bankAccountHolder;
  String? get bankAccountHolder => _$this._bankAccountHolder;
  set bankAccountHolder(String? bankAccountHolder) =>
      _$this._bankAccountHolder = bankAccountHolder;

  ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>? _documents;
  ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>();
  set documents(
          ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  String? _reviewNote;
  String? get reviewNote => _$this._reviewNote;
  set reviewNote(String? reviewNote) => _$this._reviewNote = reviewNote;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  AdminApplicationDetailDtoOutputDuplicatesBuilder? _duplicates;
  AdminApplicationDetailDtoOutputDuplicatesBuilder get duplicates =>
      _$this._duplicates ??= AdminApplicationDetailDtoOutputDuplicatesBuilder();
  set duplicates(
          AdminApplicationDetailDtoOutputDuplicatesBuilder? duplicates) =>
      _$this._duplicates = duplicates;

  AdminApplicationDetailDtoOutputOperatorBuilder? _operator_;
  AdminApplicationDetailDtoOutputOperatorBuilder get operator_ =>
      _$this._operator_ ??= AdminApplicationDetailDtoOutputOperatorBuilder();
  set operator_(AdminApplicationDetailDtoOutputOperatorBuilder? operator_) =>
      _$this._operator_ = operator_;

  ListBuilder<AdminApplicationDetailDtoOutputHistoryInner>? _history;
  ListBuilder<AdminApplicationDetailDtoOutputHistoryInner> get history =>
      _$this._history ??=
          ListBuilder<AdminApplicationDetailDtoOutputHistoryInner>();
  set history(
          ListBuilder<AdminApplicationDetailDtoOutputHistoryInner>? history) =>
      _$this._history = history;

  AdminApplicationDetailDtoOutputBuilder() {
    AdminApplicationDetailDtoOutput._defaults(this);
  }

  AdminApplicationDetailDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _applicationCode = $v.applicationCode;
      _status = $v.status;
      _operatorName = $v.operatorName;
      _contactName = $v.contactName;
      _contactEmail = $v.contactEmail;
      _contactEmailVerifiedAt = $v.contactEmailVerifiedAt;
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _hotline = $v.hotline;
      _address = $v.address;
      _displayName = $v.displayName;
      _description = $v.description;
      _bankName = $v.bankName;
      _bankAccountNumberMasked = $v.bankAccountNumberMasked;
      _bankAccountHolder = $v.bankAccountHolder;
      _documents = $v.documents.toBuilder();
      _reviewNote = $v.reviewNote;
      _createdAt = $v.createdAt;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _duplicates = $v.duplicates.toBuilder();
      _operator_ = $v.operator_?.toBuilder();
      _history = $v.history?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationDetailDtoOutput other) {
    _$v = other as _$AdminApplicationDetailDtoOutput;
  }

  @override
  void update(void Function(AdminApplicationDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutput build() => _build();

  _$AdminApplicationDetailDtoOutput _build() {
    _$AdminApplicationDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminApplicationDetailDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminApplicationDetailDtoOutput', 'id'),
            applicationCode: BuiltValueNullFieldError.checkNotNull(
                applicationCode,
                r'AdminApplicationDetailDtoOutput',
                'applicationCode'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminApplicationDetailDtoOutput', 'status'),
            operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
                r'AdminApplicationDetailDtoOutput', 'operatorName'),
            contactName: BuiltValueNullFieldError.checkNotNull(
                contactName, r'AdminApplicationDetailDtoOutput', 'contactName'),
            contactEmail: BuiltValueNullFieldError.checkNotNull(contactEmail,
                r'AdminApplicationDetailDtoOutput', 'contactEmail'),
            contactEmailVerifiedAt: contactEmailVerifiedAt,
            legalName: legalName,
            taxCode: taxCode,
            hotline: hotline,
            address: address,
            displayName: displayName,
            description: description,
            bankName: bankName,
            bankAccountNumberMasked: bankAccountNumberMasked,
            bankAccountHolder: bankAccountHolder,
            documents: documents.build(),
            reviewNote: reviewNote,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminApplicationDetailDtoOutput', 'createdAt'),
            submittedAt: submittedAt,
            reviewedAt: reviewedAt,
            duplicates: duplicates.build(),
            operator_: _operator_?.build(),
            history: _history?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();

        _$failedField = 'duplicates';
        duplicates.build();
        _$failedField = 'operator_';
        _operator_?.build();
        _$failedField = 'history';
        _history?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminApplicationDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
