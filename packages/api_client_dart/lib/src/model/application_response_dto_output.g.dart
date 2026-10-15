// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnum_DRAFT =
    const ApplicationResponseDtoOutputStatusEnum._('DRAFT');
const ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnum_SUBMITTED =
    const ApplicationResponseDtoOutputStatusEnum._('SUBMITTED');
const ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnum_NEEDS_INFO =
    const ApplicationResponseDtoOutputStatusEnum._('NEEDS_INFO');
const ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnum_APPROVED =
    const ApplicationResponseDtoOutputStatusEnum._('APPROVED');
const ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnum_REJECTED =
    const ApplicationResponseDtoOutputStatusEnum._('REJECTED');

ApplicationResponseDtoOutputStatusEnum
    _$applicationResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$applicationResponseDtoOutputStatusEnum_DRAFT;
    case 'SUBMITTED':
      return _$applicationResponseDtoOutputStatusEnum_SUBMITTED;
    case 'NEEDS_INFO':
      return _$applicationResponseDtoOutputStatusEnum_NEEDS_INFO;
    case 'APPROVED':
      return _$applicationResponseDtoOutputStatusEnum_APPROVED;
    case 'REJECTED':
      return _$applicationResponseDtoOutputStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApplicationResponseDtoOutputStatusEnum>
    _$applicationResponseDtoOutputStatusEnumValues = BuiltSet<
        ApplicationResponseDtoOutputStatusEnum>(const <ApplicationResponseDtoOutputStatusEnum>[
  _$applicationResponseDtoOutputStatusEnum_DRAFT,
  _$applicationResponseDtoOutputStatusEnum_SUBMITTED,
  _$applicationResponseDtoOutputStatusEnum_NEEDS_INFO,
  _$applicationResponseDtoOutputStatusEnum_APPROVED,
  _$applicationResponseDtoOutputStatusEnum_REJECTED,
]);

Serializer<ApplicationResponseDtoOutputStatusEnum>
    _$applicationResponseDtoOutputStatusEnumSerializer =
    _$ApplicationResponseDtoOutputStatusEnumSerializer();

class _$ApplicationResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ApplicationResponseDtoOutputStatusEnum> {
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
    ApplicationResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'ApplicationResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApplicationResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplicationResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplicationResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApplicationResponseDtoOutput extends ApplicationResponseDtoOutput {
  @override
  final String applicationCode;
  @override
  final ApplicationResponseDtoOutputStatusEnum status;
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
  final BuiltList<ApplicationResponseDtoOutputDocumentsInner> documents;
  @override
  final BuiltList<String> missing;
  @override
  final String? reviewNote;
  @override
  final DateTime createdAt;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime linkExpiresAt;

  factory _$ApplicationResponseDtoOutput(
          [void Function(ApplicationResponseDtoOutputBuilder)? updates]) =>
      (ApplicationResponseDtoOutputBuilder()..update(updates))._build();

  _$ApplicationResponseDtoOutput._(
      {required this.applicationCode,
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
      required this.missing,
      this.reviewNote,
      required this.createdAt,
      this.submittedAt,
      required this.updatedAt,
      required this.linkExpiresAt})
      : super._();
  @override
  ApplicationResponseDtoOutput rebuild(
          void Function(ApplicationResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationResponseDtoOutputBuilder toBuilder() =>
      ApplicationResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationResponseDtoOutput &&
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
        missing == other.missing &&
        reviewNote == other.reviewNote &&
        createdAt == other.createdAt &&
        submittedAt == other.submittedAt &&
        updatedAt == other.updatedAt &&
        linkExpiresAt == other.linkExpiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jc(_$hash, reviewNote.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, linkExpiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApplicationResponseDtoOutput')
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
          ..add('missing', missing)
          ..add('reviewNote', reviewNote)
          ..add('createdAt', createdAt)
          ..add('submittedAt', submittedAt)
          ..add('updatedAt', updatedAt)
          ..add('linkExpiresAt', linkExpiresAt))
        .toString();
  }
}

class ApplicationResponseDtoOutputBuilder
    implements
        Builder<ApplicationResponseDtoOutput,
            ApplicationResponseDtoOutputBuilder> {
  _$ApplicationResponseDtoOutput? _$v;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  ApplicationResponseDtoOutputStatusEnum? _status;
  ApplicationResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(ApplicationResponseDtoOutputStatusEnum? status) =>
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

  ListBuilder<ApplicationResponseDtoOutputDocumentsInner>? _documents;
  ListBuilder<ApplicationResponseDtoOutputDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<ApplicationResponseDtoOutputDocumentsInner>();
  set documents(
          ListBuilder<ApplicationResponseDtoOutputDocumentsInner>? documents) =>
      _$this._documents = documents;

  ListBuilder<String>? _missing;
  ListBuilder<String> get missing => _$this._missing ??= ListBuilder<String>();
  set missing(ListBuilder<String>? missing) => _$this._missing = missing;

  String? _reviewNote;
  String? get reviewNote => _$this._reviewNote;
  set reviewNote(String? reviewNote) => _$this._reviewNote = reviewNote;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DateTime? _linkExpiresAt;
  DateTime? get linkExpiresAt => _$this._linkExpiresAt;
  set linkExpiresAt(DateTime? linkExpiresAt) =>
      _$this._linkExpiresAt = linkExpiresAt;

  ApplicationResponseDtoOutputBuilder() {
    ApplicationResponseDtoOutput._defaults(this);
  }

  ApplicationResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
      _missing = $v.missing.toBuilder();
      _reviewNote = $v.reviewNote;
      _createdAt = $v.createdAt;
      _submittedAt = $v.submittedAt;
      _updatedAt = $v.updatedAt;
      _linkExpiresAt = $v.linkExpiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationResponseDtoOutput other) {
    _$v = other as _$ApplicationResponseDtoOutput;
  }

  @override
  void update(void Function(ApplicationResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationResponseDtoOutput build() => _build();

  _$ApplicationResponseDtoOutput _build() {
    _$ApplicationResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ApplicationResponseDtoOutput._(
            applicationCode: BuiltValueNullFieldError.checkNotNull(
                applicationCode,
                r'ApplicationResponseDtoOutput',
                'applicationCode'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ApplicationResponseDtoOutput', 'status'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'ApplicationResponseDtoOutput', 'operatorName'),
            contactName: BuiltValueNullFieldError.checkNotNull(
                contactName, r'ApplicationResponseDtoOutput', 'contactName'),
            contactEmail: BuiltValueNullFieldError.checkNotNull(
                contactEmail, r'ApplicationResponseDtoOutput', 'contactEmail'),
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
            missing: missing.build(),
            reviewNote: reviewNote,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ApplicationResponseDtoOutput', 'createdAt'),
            submittedAt: submittedAt,
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ApplicationResponseDtoOutput', 'updatedAt'),
            linkExpiresAt: BuiltValueNullFieldError.checkNotNull(linkExpiresAt,
                r'ApplicationResponseDtoOutput', 'linkExpiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
        _$failedField = 'missing';
        missing.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApplicationResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
