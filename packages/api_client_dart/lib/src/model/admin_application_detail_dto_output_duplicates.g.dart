// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output_duplicates.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminApplicationDetailDtoOutputDuplicates
    extends AdminApplicationDetailDtoOutputDuplicates {
  @override
  final BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      contactEmail;
  @override
  final BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      taxCode;
  @override
  final BuiltList<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      bankAccount;

  factory _$AdminApplicationDetailDtoOutputDuplicates(
          [void Function(AdminApplicationDetailDtoOutputDuplicatesBuilder)?
              updates]) =>
      (AdminApplicationDetailDtoOutputDuplicatesBuilder()..update(updates))
          ._build();

  _$AdminApplicationDetailDtoOutputDuplicates._(
      {required this.contactEmail,
      required this.taxCode,
      required this.bankAccount})
      : super._();
  @override
  AdminApplicationDetailDtoOutputDuplicates rebuild(
          void Function(AdminApplicationDetailDtoOutputDuplicatesBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputDuplicatesBuilder toBuilder() =>
      AdminApplicationDetailDtoOutputDuplicatesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationDetailDtoOutputDuplicates &&
        contactEmail == other.contactEmail &&
        taxCode == other.taxCode &&
        bankAccount == other.bankAccount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, bankAccount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationDetailDtoOutputDuplicates')
          ..add('contactEmail', contactEmail)
          ..add('taxCode', taxCode)
          ..add('bankAccount', bankAccount))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputDuplicatesBuilder
    implements
        Builder<AdminApplicationDetailDtoOutputDuplicates,
            AdminApplicationDetailDtoOutputDuplicatesBuilder> {
  _$AdminApplicationDetailDtoOutputDuplicates? _$v;

  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
      _contactEmail;
  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      get contactEmail => _$this._contactEmail ??= ListBuilder<
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>();
  set contactEmail(
          ListBuilder<
                  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
              contactEmail) =>
      _$this._contactEmail = contactEmail;

  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
      _taxCode;
  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      get taxCode => _$this._taxCode ??= ListBuilder<
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>();
  set taxCode(
          ListBuilder<
                  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
              taxCode) =>
      _$this._taxCode = taxCode;

  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
      _bankAccount;
  ListBuilder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>
      get bankAccount => _$this._bankAccount ??= ListBuilder<
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>();
  set bankAccount(
          ListBuilder<
                  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner>?
              bankAccount) =>
      _$this._bankAccount = bankAccount;

  AdminApplicationDetailDtoOutputDuplicatesBuilder() {
    AdminApplicationDetailDtoOutputDuplicates._defaults(this);
  }

  AdminApplicationDetailDtoOutputDuplicatesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEmail = $v.contactEmail.toBuilder();
      _taxCode = $v.taxCode.toBuilder();
      _bankAccount = $v.bankAccount.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationDetailDtoOutputDuplicates other) {
    _$v = other as _$AdminApplicationDetailDtoOutputDuplicates;
  }

  @override
  void update(
      void Function(AdminApplicationDetailDtoOutputDuplicatesBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutputDuplicates build() => _build();

  _$AdminApplicationDetailDtoOutputDuplicates _build() {
    _$AdminApplicationDetailDtoOutputDuplicates _$result;
    try {
      _$result = _$v ??
          _$AdminApplicationDetailDtoOutputDuplicates._(
            contactEmail: contactEmail.build(),
            taxCode: taxCode.build(),
            bankAccount: bankAccount.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contactEmail';
        contactEmail.build();
        _$failedField = 'taxCode';
        taxCode.build();
        _$failedField = 'bankAccount';
        bankAccount.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminApplicationDetailDtoOutputDuplicates',
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
