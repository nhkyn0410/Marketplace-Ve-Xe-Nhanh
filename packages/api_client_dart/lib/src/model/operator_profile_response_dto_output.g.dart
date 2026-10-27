// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_profile_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorProfileResponseDtoOutputStatusEnum
    _$operatorProfileResponseDtoOutputStatusEnum_ACTIVE =
    const OperatorProfileResponseDtoOutputStatusEnum._('ACTIVE');
const OperatorProfileResponseDtoOutputStatusEnum
    _$operatorProfileResponseDtoOutputStatusEnum_SUSPENDED =
    const OperatorProfileResponseDtoOutputStatusEnum._('SUSPENDED');

OperatorProfileResponseDtoOutputStatusEnum
    _$operatorProfileResponseDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$operatorProfileResponseDtoOutputStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$operatorProfileResponseDtoOutputStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorProfileResponseDtoOutputStatusEnum>
    _$operatorProfileResponseDtoOutputStatusEnumValues = BuiltSet<
        OperatorProfileResponseDtoOutputStatusEnum>(const <OperatorProfileResponseDtoOutputStatusEnum>[
  _$operatorProfileResponseDtoOutputStatusEnum_ACTIVE,
  _$operatorProfileResponseDtoOutputStatusEnum_SUSPENDED,
]);

Serializer<OperatorProfileResponseDtoOutputStatusEnum>
    _$operatorProfileResponseDtoOutputStatusEnumSerializer =
    _$OperatorProfileResponseDtoOutputStatusEnumSerializer();

class _$OperatorProfileResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<OperatorProfileResponseDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OperatorProfileResponseDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'OperatorProfileResponseDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorProfileResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorProfileResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorProfileResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorProfileResponseDtoOutput
    extends OperatorProfileResponseDtoOutput {
  @override
  final String id;
  @override
  final String slug;
  @override
  final String displayName;
  @override
  final String? legalName;
  @override
  final String? taxCode;
  @override
  final String? hotline;
  @override
  final String? publicEmail;
  @override
  final String? address;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final OperatorProfileResponseDtoOutputStatusEnum status;
  @override
  final String? suspendedReason;
  @override
  final DateTime? approvedAt;
  @override
  final BuiltList<AdminApplicationDetailDtoOutputDocumentsInner> documents;
  @override
  final OperatorProfileResponseDtoOutputBankAccount? bankAccount;
  @override
  final OperatorProfileResponseDtoOutputBankChange? bankChange;

  factory _$OperatorProfileResponseDtoOutput(
          [void Function(OperatorProfileResponseDtoOutputBuilder)? updates]) =>
      (OperatorProfileResponseDtoOutputBuilder()..update(updates))._build();

  _$OperatorProfileResponseDtoOutput._(
      {required this.id,
      required this.slug,
      required this.displayName,
      this.legalName,
      this.taxCode,
      this.hotline,
      this.publicEmail,
      this.address,
      this.description,
      this.logoUrl,
      required this.status,
      this.suspendedReason,
      this.approvedAt,
      required this.documents,
      this.bankAccount,
      this.bankChange})
      : super._();
  @override
  OperatorProfileResponseDtoOutput rebuild(
          void Function(OperatorProfileResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorProfileResponseDtoOutputBuilder toBuilder() =>
      OperatorProfileResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorProfileResponseDtoOutput &&
        id == other.id &&
        slug == other.slug &&
        displayName == other.displayName &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        hotline == other.hotline &&
        publicEmail == other.publicEmail &&
        address == other.address &&
        description == other.description &&
        logoUrl == other.logoUrl &&
        status == other.status &&
        suspendedReason == other.suspendedReason &&
        approvedAt == other.approvedAt &&
        documents == other.documents &&
        bankAccount == other.bankAccount &&
        bankChange == other.bankChange;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, suspendedReason.hashCode);
    _$hash = $jc(_$hash, approvedAt.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jc(_$hash, bankAccount.hashCode);
    _$hash = $jc(_$hash, bankChange.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorProfileResponseDtoOutput')
          ..add('id', id)
          ..add('slug', slug)
          ..add('displayName', displayName)
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('hotline', hotline)
          ..add('publicEmail', publicEmail)
          ..add('address', address)
          ..add('description', description)
          ..add('logoUrl', logoUrl)
          ..add('status', status)
          ..add('suspendedReason', suspendedReason)
          ..add('approvedAt', approvedAt)
          ..add('documents', documents)
          ..add('bankAccount', bankAccount)
          ..add('bankChange', bankChange))
        .toString();
  }
}

class OperatorProfileResponseDtoOutputBuilder
    implements
        Builder<OperatorProfileResponseDtoOutput,
            OperatorProfileResponseDtoOutputBuilder> {
  _$OperatorProfileResponseDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _taxCode;
  String? get taxCode => _$this._taxCode;
  set taxCode(String? taxCode) => _$this._taxCode = taxCode;

  String? _hotline;
  String? get hotline => _$this._hotline;
  set hotline(String? hotline) => _$this._hotline = hotline;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  OperatorProfileResponseDtoOutputStatusEnum? _status;
  OperatorProfileResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(OperatorProfileResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _suspendedReason;
  String? get suspendedReason => _$this._suspendedReason;
  set suspendedReason(String? suspendedReason) =>
      _$this._suspendedReason = suspendedReason;

  DateTime? _approvedAt;
  DateTime? get approvedAt => _$this._approvedAt;
  set approvedAt(DateTime? approvedAt) => _$this._approvedAt = approvedAt;

  ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>? _documents;
  ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>();
  set documents(
          ListBuilder<AdminApplicationDetailDtoOutputDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  OperatorProfileResponseDtoOutputBankAccountBuilder? _bankAccount;
  OperatorProfileResponseDtoOutputBankAccountBuilder get bankAccount =>
      _$this._bankAccount ??=
          OperatorProfileResponseDtoOutputBankAccountBuilder();
  set bankAccount(
          OperatorProfileResponseDtoOutputBankAccountBuilder? bankAccount) =>
      _$this._bankAccount = bankAccount;

  OperatorProfileResponseDtoOutputBankChangeBuilder? _bankChange;
  OperatorProfileResponseDtoOutputBankChangeBuilder get bankChange =>
      _$this._bankChange ??=
          OperatorProfileResponseDtoOutputBankChangeBuilder();
  set bankChange(
          OperatorProfileResponseDtoOutputBankChangeBuilder? bankChange) =>
      _$this._bankChange = bankChange;

  OperatorProfileResponseDtoOutputBuilder() {
    OperatorProfileResponseDtoOutput._defaults(this);
  }

  OperatorProfileResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _displayName = $v.displayName;
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _hotline = $v.hotline;
      _publicEmail = $v.publicEmail;
      _address = $v.address;
      _description = $v.description;
      _logoUrl = $v.logoUrl;
      _status = $v.status;
      _suspendedReason = $v.suspendedReason;
      _approvedAt = $v.approvedAt;
      _documents = $v.documents.toBuilder();
      _bankAccount = $v.bankAccount?.toBuilder();
      _bankChange = $v.bankChange?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorProfileResponseDtoOutput other) {
    _$v = other as _$OperatorProfileResponseDtoOutput;
  }

  @override
  void update(void Function(OperatorProfileResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorProfileResponseDtoOutput build() => _build();

  _$OperatorProfileResponseDtoOutput _build() {
    _$OperatorProfileResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$OperatorProfileResponseDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'OperatorProfileResponseDtoOutput', 'id'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'OperatorProfileResponseDtoOutput', 'slug'),
            displayName: BuiltValueNullFieldError.checkNotNull(displayName,
                r'OperatorProfileResponseDtoOutput', 'displayName'),
            legalName: legalName,
            taxCode: taxCode,
            hotline: hotline,
            publicEmail: publicEmail,
            address: address,
            description: description,
            logoUrl: logoUrl,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'OperatorProfileResponseDtoOutput', 'status'),
            suspendedReason: suspendedReason,
            approvedAt: approvedAt,
            documents: documents.build(),
            bankAccount: _bankAccount?.build(),
            bankChange: _bankChange?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
        _$failedField = 'bankAccount';
        _bankAccount?.build();
        _$failedField = 'bankChange';
        _bankChange?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OperatorProfileResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
