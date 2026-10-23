// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bank_change_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBankChangeDtoOutput extends AdminBankChangeDtoOutput {
  @override
  final String changeId;
  @override
  final String operatorName;
  @override
  final String? legalName;
  @override
  final String? taxCode;
  @override
  final AdminBankChangeDtoOutputCurrent? current;
  @override
  final AdminBankChangeDtoOutputRequested requested;

  factory _$AdminBankChangeDtoOutput(
          [void Function(AdminBankChangeDtoOutputBuilder)? updates]) =>
      (AdminBankChangeDtoOutputBuilder()..update(updates))._build();

  _$AdminBankChangeDtoOutput._(
      {required this.changeId,
      required this.operatorName,
      this.legalName,
      this.taxCode,
      this.current,
      required this.requested})
      : super._();
  @override
  AdminBankChangeDtoOutput rebuild(
          void Function(AdminBankChangeDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminBankChangeDtoOutputBuilder toBuilder() =>
      AdminBankChangeDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBankChangeDtoOutput &&
        changeId == other.changeId &&
        operatorName == other.operatorName &&
        legalName == other.legalName &&
        taxCode == other.taxCode &&
        current == other.current &&
        requested == other.requested;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changeId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, taxCode.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, requested.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBankChangeDtoOutput')
          ..add('changeId', changeId)
          ..add('operatorName', operatorName)
          ..add('legalName', legalName)
          ..add('taxCode', taxCode)
          ..add('current', current)
          ..add('requested', requested))
        .toString();
  }
}

class AdminBankChangeDtoOutputBuilder
    implements
        Builder<AdminBankChangeDtoOutput, AdminBankChangeDtoOutputBuilder> {
  _$AdminBankChangeDtoOutput? _$v;

  String? _changeId;
  String? get changeId => _$this._changeId;
  set changeId(String? changeId) => _$this._changeId = changeId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _taxCode;
  String? get taxCode => _$this._taxCode;
  set taxCode(String? taxCode) => _$this._taxCode = taxCode;

  AdminBankChangeDtoOutputCurrentBuilder? _current;
  AdminBankChangeDtoOutputCurrentBuilder get current =>
      _$this._current ??= AdminBankChangeDtoOutputCurrentBuilder();
  set current(AdminBankChangeDtoOutputCurrentBuilder? current) =>
      _$this._current = current;

  AdminBankChangeDtoOutputRequestedBuilder? _requested;
  AdminBankChangeDtoOutputRequestedBuilder get requested =>
      _$this._requested ??= AdminBankChangeDtoOutputRequestedBuilder();
  set requested(AdminBankChangeDtoOutputRequestedBuilder? requested) =>
      _$this._requested = requested;

  AdminBankChangeDtoOutputBuilder() {
    AdminBankChangeDtoOutput._defaults(this);
  }

  AdminBankChangeDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changeId = $v.changeId;
      _operatorName = $v.operatorName;
      _legalName = $v.legalName;
      _taxCode = $v.taxCode;
      _current = $v.current?.toBuilder();
      _requested = $v.requested.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBankChangeDtoOutput other) {
    _$v = other as _$AdminBankChangeDtoOutput;
  }

  @override
  void update(void Function(AdminBankChangeDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBankChangeDtoOutput build() => _build();

  _$AdminBankChangeDtoOutput _build() {
    _$AdminBankChangeDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminBankChangeDtoOutput._(
            changeId: BuiltValueNullFieldError.checkNotNull(
                changeId, r'AdminBankChangeDtoOutput', 'changeId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'AdminBankChangeDtoOutput', 'operatorName'),
            legalName: legalName,
            taxCode: taxCode,
            current: _current?.build(),
            requested: requested.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'requested';
        requested.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminBankChangeDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
