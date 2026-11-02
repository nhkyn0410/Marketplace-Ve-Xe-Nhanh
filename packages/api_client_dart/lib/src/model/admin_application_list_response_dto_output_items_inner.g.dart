// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_list_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_DRAFT =
    const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._('DRAFT');
const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_SUBMITTED =
    const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._(
        'SUBMITTED');
const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_NEEDS_INFO =
    const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._(
        'NEEDS_INFO');
const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_APPROVED =
    const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._(
        'APPROVED');
const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_REJECTED =
    const AdminApplicationListResponseDtoOutputItemsInnerStatusEnum._(
        'REJECTED');

AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_DRAFT;
    case 'SUBMITTED':
      return _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_SUBMITTED;
    case 'NEEDS_INFO':
      return _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_NEEDS_INFO;
    case 'APPROVED':
      return _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_APPROVED;
    case 'REJECTED':
      return _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApplicationListResponseDtoOutputItemsInnerStatusEnum>
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumValues =
    BuiltSet<
        AdminApplicationListResponseDtoOutputItemsInnerStatusEnum>(const <AdminApplicationListResponseDtoOutputItemsInnerStatusEnum>[
  _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_DRAFT,
  _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_SUBMITTED,
  _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_NEEDS_INFO,
  _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_APPROVED,
  _$adminApplicationListResponseDtoOutputItemsInnerStatusEnum_REJECTED,
]);

const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_CONTACT_EMAIL =
    const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum._(
        'CONTACT_EMAIL');
const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_TAX_CODE =
    const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum._(
        'TAX_CODE');
const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_BANK_ACCOUNT =
    const AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum._(
        'BANK_ACCOUNT');

AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumValueOf(
        String name) {
  switch (name) {
    case 'CONTACT_EMAIL':
      return _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_CONTACT_EMAIL;
    case 'TAX_CODE':
      return _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_TAX_CODE;
    case 'BANK_ACCOUNT':
      return _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_BANK_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumValues =
    BuiltSet<
        AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>(const <AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>[
  _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_CONTACT_EMAIL,
  _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_TAX_CODE,
  _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum_BANK_ACCOUNT,
]);

Serializer<AdminApplicationListResponseDtoOutputItemsInnerStatusEnum>
    _$adminApplicationListResponseDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminApplicationListResponseDtoOutputItemsInnerStatusEnumSerializer();
Serializer<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>
    _$adminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumSerializer =
    _$AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumSerializer();

class _$AdminApplicationListResponseDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminApplicationListResponseDtoOutputItemsInnerStatusEnum> {
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
    AdminApplicationListResponseDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminApplicationListResponseDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminApplicationListResponseDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationListResponseDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminApplicationListResponseDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnumSerializer
    implements
        PrimitiveSerializer<
            AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONTACT_EMAIL': 'CONTACT_EMAIL',
    'TAX_CODE': 'TAX_CODE',
    'BANK_ACCOUNT': 'BANK_ACCOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONTACT_EMAIL': 'CONTACT_EMAIL',
    'TAX_CODE': 'TAX_CODE',
    'BANK_ACCOUNT': 'BANK_ACCOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum
  ];
  @override
  final String wireName =
      'AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum';

  @override
  Object serialize(Serializers serializers,
          AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminApplicationListResponseDtoOutputItemsInner
    extends AdminApplicationListResponseDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String applicationCode;
  @override
  final AdminApplicationListResponseDtoOutputItemsInnerStatusEnum status;
  @override
  final String operatorName;
  @override
  final String? legalName;
  @override
  final String? taxCode;
  @override
  final String contactName;
  @override
  final String contactEmail;
  @override
  final DateTime submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  final BuiltList<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>
      duplicates;

  factory _$AdminApplicationListResponseDtoOutputItemsInner(
          [void Function(
                  AdminApplicationListResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminApplicationListResponseDtoOutputItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminApplicationListResponseDtoOutputItemsInner._(
      {required this.id,
      required this.applicationCode,
      required this.status,
      required this.operatorName,
      this.legalName,
      this.taxCode,
      required this.contactName,
      required this.contactEmail,
      required this.submittedAt,
      this.reviewedAt,
      required this.duplicates})
      : super._();
  @override
  AdminApplicationListResponseDtoOutputItemsInner rebuild(
          void Function(AdminApplicationListResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationListResponseDtoOutputItemsInnerBuilder toBuilder() =>
      AdminApplicationListResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationListResponseDtoOutputItemsInner &&
        id == other.id &&
        applicationCode == other.applicationCode &&
        status == other.status &&
        operatorName == other.operatorName &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        contactName == other.contactName &&
        contactEmail == other.contactEmail &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        duplicates == other.duplicates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, duplicates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationListResponseDtoOutputItemsInner')
          ..add('id', id)
          ..add('applicationCode', applicationCode)
          ..add('status', status)
          ..add('operatorName', operatorName)
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('contactName', contactName)
          ..add('contactEmail', contactEmail)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('duplicates', duplicates))
        .toString();
  }
}

class AdminApplicationListResponseDtoOutputItemsInnerBuilder
    implements
        Builder<AdminApplicationListResponseDtoOutputItemsInner,
            AdminApplicationListResponseDtoOutputItemsInnerBuilder> {
  _$AdminApplicationListResponseDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  AdminApplicationListResponseDtoOutputItemsInnerStatusEnum? _status;
  AdminApplicationListResponseDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(
          AdminApplicationListResponseDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _taxCode;
  String? get taxCode => _$this._taxCode;
  set taxCode(String? taxCode) => _$this._taxCode = taxCode;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  ListBuilder<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>?
      _duplicates;
  ListBuilder<AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>
      get duplicates => _$this._duplicates ??= ListBuilder<
          AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>();
  set duplicates(
          ListBuilder<
                  AdminApplicationListResponseDtoOutputItemsInnerDuplicatesEnum>?
              duplicates) =>
      _$this._duplicates = duplicates;

  AdminApplicationListResponseDtoOutputItemsInnerBuilder() {
    AdminApplicationListResponseDtoOutputItemsInner._defaults(this);
  }

  AdminApplicationListResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _applicationCode = $v.applicationCode;
      _status = $v.status;
      _operatorName = $v.operatorName;
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _contactName = $v.contactName;
      _contactEmail = $v.contactEmail;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _duplicates = $v.duplicates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationListResponseDtoOutputItemsInner other) {
    _$v = other as _$AdminApplicationListResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminApplicationListResponseDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationListResponseDtoOutputItemsInner build() => _build();

  _$AdminApplicationListResponseDtoOutputItemsInner _build() {
    _$AdminApplicationListResponseDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminApplicationListResponseDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminApplicationListResponseDtoOutputItemsInner', 'id'),
            applicationCode: BuiltValueNullFieldError.checkNotNull(
                applicationCode,
                r'AdminApplicationListResponseDtoOutputItemsInner',
                'applicationCode'),
            status: BuiltValueNullFieldError.checkNotNull(status,
                r'AdminApplicationListResponseDtoOutputItemsInner', 'status'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName,
                r'AdminApplicationListResponseDtoOutputItemsInner',
                'operatorName'),
            legalName: legalName,
            taxCode: taxCode,
            contactName: BuiltValueNullFieldError.checkNotNull(
                contactName,
                r'AdminApplicationListResponseDtoOutputItemsInner',
                'contactName'),
            contactEmail: BuiltValueNullFieldError.checkNotNull(
                contactEmail,
                r'AdminApplicationListResponseDtoOutputItemsInner',
                'contactEmail'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt,
                r'AdminApplicationListResponseDtoOutputItemsInner',
                'submittedAt'),
            reviewedAt: reviewedAt,
            duplicates: duplicates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'duplicates';
        duplicates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminApplicationListResponseDtoOutputItemsInner',
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
