// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output_duplicates_contact_email_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_DRAFT =
    const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
        ._('DRAFT');
const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_SUBMITTED =
    const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
        ._('SUBMITTED');
const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_NEEDS_INFO =
    const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
        ._('NEEDS_INFO');
const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_APPROVED =
    const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
        ._('APPROVED');
const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_REJECTED =
    const AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
        ._('REJECTED');

AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_DRAFT;
    case 'SUBMITTED':
      return _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_SUBMITTED;
    case 'NEEDS_INFO':
      return _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_NEEDS_INFO;
    case 'APPROVED':
      return _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_APPROVED;
    case 'REJECTED':
      return _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum>
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumValues =
    BuiltSet<
        AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum>(const <AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum>[
  _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_DRAFT,
  _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_SUBMITTED,
  _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_NEEDS_INFO,
  _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_APPROVED,
  _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum_REJECTED,
]);

Serializer<AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum>
    _$adminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumSerializer =
    _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumSerializer();

class _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum> {
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
    AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum';

  @override
  Object serialize(
          Serializers serializers,
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner
    extends AdminApplicationDetailDtoOutputDuplicatesContactEmailInner {
  @override
  final String id;
  @override
  final String applicationCode;
  @override
  final String operatorName;
  @override
  final AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum
      status;

  factory _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner(
          [void Function(
                  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder)?
              updates]) =>
      (AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner._(
      {required this.id,
      required this.applicationCode,
      required this.operatorName,
      required this.status})
      : super._();
  @override
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner rebuild(
          void Function(
                  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder
      toBuilder() =>
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminApplicationDetailDtoOutputDuplicatesContactEmailInner &&
        id == other.id &&
        applicationCode == other.applicationCode &&
        operatorName == other.operatorName &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, applicationCode.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner')
          ..add('id', id)
          ..add('applicationCode', applicationCode)
          ..add('operatorName', operatorName)
          ..add('status', status))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder
    implements
        Builder<AdminApplicationDetailDtoOutputDuplicatesContactEmailInner,
            AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder> {
  _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _applicationCode;
  String? get applicationCode => _$this._applicationCode;
  set applicationCode(String? applicationCode) =>
      _$this._applicationCode = applicationCode;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum? _status;
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum?
      get status => _$this._status;
  set status(
          AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerStatusEnum?
              status) =>
      _$this._status = status;

  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder() {
    AdminApplicationDetailDtoOutputDuplicatesContactEmailInner._defaults(this);
  }

  AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _applicationCode = $v.applicationCode;
      _operatorName = $v.operatorName;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      AdminApplicationDetailDtoOutputDuplicatesContactEmailInner other) {
    _$v = other as _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner;
  }

  @override
  void update(
      void Function(
              AdminApplicationDetailDtoOutputDuplicatesContactEmailInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutputDuplicatesContactEmailInner build() =>
      _build();

  _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner _build() {
    final _$result = _$v ??
        _$AdminApplicationDetailDtoOutputDuplicatesContactEmailInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner',
              'id'),
          applicationCode: BuiltValueNullFieldError.checkNotNull(
              applicationCode,
              r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner',
              'applicationCode'),
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName,
              r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner',
              'operatorName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminApplicationDetailDtoOutputDuplicatesContactEmailInner',
              'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
