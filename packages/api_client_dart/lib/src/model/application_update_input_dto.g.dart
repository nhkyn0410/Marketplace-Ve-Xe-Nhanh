// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_update_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApplicationUpdateInputDto extends ApplicationUpdateInputDto {
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
  final String? bankAccountNumber;
  @override
  final String? bankAccountHolder;
  @override
  final BuiltList<ApplicationUpdateInputDtoDocumentsInner> documents;

  factory _$ApplicationUpdateInputDto(
          [void Function(ApplicationUpdateInputDtoBuilder)? updates]) =>
      (ApplicationUpdateInputDtoBuilder()..update(updates))._build();

  _$ApplicationUpdateInputDto._(
      {this.legalName,
      this.taxCode,
      this.hotline,
      this.address,
      this.displayName,
      this.description,
      this.bankName,
      this.bankAccountNumber,
      this.bankAccountHolder,
      required this.documents})
      : super._();
  @override
  ApplicationUpdateInputDto rebuild(
          void Function(ApplicationUpdateInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationUpdateInputDtoBuilder toBuilder() =>
      ApplicationUpdateInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationUpdateInputDto &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        hotline == other.hotline &&
        address == other.address &&
        displayName == other.displayName &&
        description == other.description &&
        bankName == other.bankName &&
        bankAccountNumber == other.bankAccountNumber &&
        bankAccountHolder == other.bankAccountHolder &&
        documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, hotline.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, bankAccountNumber.hashCode);
    _$hash = $jc(_$hash, bankAccountHolder.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApplicationUpdateInputDto')
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('hotline', hotline)
          ..add('address', address)
          ..add('displayName', displayName)
          ..add('description', description)
          ..add('bankName', bankName)
          ..add('bankAccountNumber', bankAccountNumber)
          ..add('bankAccountHolder', bankAccountHolder)
          ..add('documents', documents))
        .toString();
  }
}

class ApplicationUpdateInputDtoBuilder
    implements
        Builder<ApplicationUpdateInputDto, ApplicationUpdateInputDtoBuilder> {
  _$ApplicationUpdateInputDto? _$v;

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

  String? _bankAccountNumber;
  String? get bankAccountNumber => _$this._bankAccountNumber;
  set bankAccountNumber(String? bankAccountNumber) =>
      _$this._bankAccountNumber = bankAccountNumber;

  String? _bankAccountHolder;
  String? get bankAccountHolder => _$this._bankAccountHolder;
  set bankAccountHolder(String? bankAccountHolder) =>
      _$this._bankAccountHolder = bankAccountHolder;

  ListBuilder<ApplicationUpdateInputDtoDocumentsInner>? _documents;
  ListBuilder<ApplicationUpdateInputDtoDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<ApplicationUpdateInputDtoDocumentsInner>();
  set documents(
          ListBuilder<ApplicationUpdateInputDtoDocumentsInner>? documents) =>
      _$this._documents = documents;

  ApplicationUpdateInputDtoBuilder() {
    ApplicationUpdateInputDto._defaults(this);
  }

  ApplicationUpdateInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _hotline = $v.hotline;
      _address = $v.address;
      _displayName = $v.displayName;
      _description = $v.description;
      _bankName = $v.bankName;
      _bankAccountNumber = $v.bankAccountNumber;
      _bankAccountHolder = $v.bankAccountHolder;
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationUpdateInputDto other) {
    _$v = other as _$ApplicationUpdateInputDto;
  }

  @override
  void update(void Function(ApplicationUpdateInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationUpdateInputDto build() => _build();

  _$ApplicationUpdateInputDto _build() {
    _$ApplicationUpdateInputDto _$result;
    try {
      _$result = _$v ??
          _$ApplicationUpdateInputDto._(
            legalName: legalName,
            taxCode: taxCode,
            hotline: hotline,
            address: address,
            displayName: displayName,
            description: description,
            bankName: bankName,
            bankAccountNumber: bankAccountNumber,
            bankAccountHolder: bankAccountHolder,
            documents: documents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApplicationUpdateInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
