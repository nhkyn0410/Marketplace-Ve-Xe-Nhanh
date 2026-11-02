// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output_operator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminApplicationDetailDtoOutputOperator
    extends AdminApplicationDetailDtoOutputOperator {
  @override
  final String operatorId;
  @override
  final String operatorSlug;
  @override
  final String ownerUsername;
  @override
  final bool credentialDeliveryPending;

  factory _$AdminApplicationDetailDtoOutputOperator(
          [void Function(AdminApplicationDetailDtoOutputOperatorBuilder)?
              updates]) =>
      (AdminApplicationDetailDtoOutputOperatorBuilder()..update(updates))
          ._build();

  _$AdminApplicationDetailDtoOutputOperator._(
      {required this.operatorId,
      required this.operatorSlug,
      required this.ownerUsername,
      required this.credentialDeliveryPending})
      : super._();
  @override
  AdminApplicationDetailDtoOutputOperator rebuild(
          void Function(AdminApplicationDetailDtoOutputOperatorBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputOperatorBuilder toBuilder() =>
      AdminApplicationDetailDtoOutputOperatorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationDetailDtoOutputOperator &&
        operatorId == other.operatorId &&
        operatorSlug == other.operatorSlug &&
        ownerUsername == other.ownerUsername &&
        credentialDeliveryPending == other.credentialDeliveryPending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, ownerUsername.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationDetailDtoOutputOperator')
          ..add('operatorId', operatorId)
          ..add('operatorSlug', operatorSlug)
          ..add('ownerUsername', ownerUsername)
          ..add('credentialDeliveryPending', credentialDeliveryPending))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputOperatorBuilder
    implements
        Builder<AdminApplicationDetailDtoOutputOperator,
            AdminApplicationDetailDtoOutputOperatorBuilder> {
  _$AdminApplicationDetailDtoOutputOperator? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  String? _ownerUsername;
  String? get ownerUsername => _$this._ownerUsername;
  set ownerUsername(String? ownerUsername) =>
      _$this._ownerUsername = ownerUsername;

  bool? _credentialDeliveryPending;
  bool? get credentialDeliveryPending => _$this._credentialDeliveryPending;
  set credentialDeliveryPending(bool? credentialDeliveryPending) =>
      _$this._credentialDeliveryPending = credentialDeliveryPending;

  AdminApplicationDetailDtoOutputOperatorBuilder() {
    AdminApplicationDetailDtoOutputOperator._defaults(this);
  }

  AdminApplicationDetailDtoOutputOperatorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _operatorSlug = $v.operatorSlug;
      _ownerUsername = $v.ownerUsername;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationDetailDtoOutputOperator other) {
    _$v = other as _$AdminApplicationDetailDtoOutputOperator;
  }

  @override
  void update(
      void Function(AdminApplicationDetailDtoOutputOperatorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutputOperator build() => _build();

  _$AdminApplicationDetailDtoOutputOperator _build() {
    final _$result = _$v ??
        _$AdminApplicationDetailDtoOutputOperator._(
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'AdminApplicationDetailDtoOutputOperator', 'operatorId'),
          operatorSlug: BuiltValueNullFieldError.checkNotNull(operatorSlug,
              r'AdminApplicationDetailDtoOutputOperator', 'operatorSlug'),
          ownerUsername: BuiltValueNullFieldError.checkNotNull(ownerUsername,
              r'AdminApplicationDetailDtoOutputOperator', 'ownerUsername'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminApplicationDetailDtoOutputOperator',
              'credentialDeliveryPending'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
