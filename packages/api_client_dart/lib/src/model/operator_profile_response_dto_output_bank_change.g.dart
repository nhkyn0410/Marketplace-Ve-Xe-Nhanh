// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_profile_response_dto_output_bank_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorProfileResponseDtoOutputBankChangeStatusEnum
    _$operatorProfileResponseDtoOutputBankChangeStatusEnum_PENDING =
    const OperatorProfileResponseDtoOutputBankChangeStatusEnum._('PENDING');
const OperatorProfileResponseDtoOutputBankChangeStatusEnum
    _$operatorProfileResponseDtoOutputBankChangeStatusEnum_REJECTED =
    const OperatorProfileResponseDtoOutputBankChangeStatusEnum._('REJECTED');

OperatorProfileResponseDtoOutputBankChangeStatusEnum
    _$operatorProfileResponseDtoOutputBankChangeStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$operatorProfileResponseDtoOutputBankChangeStatusEnum_PENDING;
    case 'REJECTED':
      return _$operatorProfileResponseDtoOutputBankChangeStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorProfileResponseDtoOutputBankChangeStatusEnum>
    _$operatorProfileResponseDtoOutputBankChangeStatusEnumValues = BuiltSet<
        OperatorProfileResponseDtoOutputBankChangeStatusEnum>(const <OperatorProfileResponseDtoOutputBankChangeStatusEnum>[
  _$operatorProfileResponseDtoOutputBankChangeStatusEnum_PENDING,
  _$operatorProfileResponseDtoOutputBankChangeStatusEnum_REJECTED,
]);

Serializer<OperatorProfileResponseDtoOutputBankChangeStatusEnum>
    _$operatorProfileResponseDtoOutputBankChangeStatusEnumSerializer =
    _$OperatorProfileResponseDtoOutputBankChangeStatusEnumSerializer();

class _$OperatorProfileResponseDtoOutputBankChangeStatusEnumSerializer
    implements
        PrimitiveSerializer<
            OperatorProfileResponseDtoOutputBankChangeStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OperatorProfileResponseDtoOutputBankChangeStatusEnum
  ];
  @override
  final String wireName =
      'OperatorProfileResponseDtoOutputBankChangeStatusEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorProfileResponseDtoOutputBankChangeStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorProfileResponseDtoOutputBankChangeStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorProfileResponseDtoOutputBankChangeStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorProfileResponseDtoOutputBankChange
    extends OperatorProfileResponseDtoOutputBankChange {
  @override
  final OperatorProfileResponseDtoOutputBankChangeStatusEnum status;
  @override
  final String bankName;
  @override
  final String accountNumberMasked;
  @override
  final String accountHolder;
  @override
  final String? reason;
  @override
  final String? reviewNote;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? reviewedAt;

  factory _$OperatorProfileResponseDtoOutputBankChange(
          [void Function(OperatorProfileResponseDtoOutputBankChangeBuilder)?
              updates]) =>
      (OperatorProfileResponseDtoOutputBankChangeBuilder()..update(updates))
          ._build();

  _$OperatorProfileResponseDtoOutputBankChange._(
      {required this.status,
      required this.bankName,
      required this.accountNumberMasked,
      required this.accountHolder,
      this.reason,
      this.reviewNote,
      required this.requestedAt,
      this.reviewedAt})
      : super._();
  @override
  OperatorProfileResponseDtoOutputBankChange rebuild(
          void Function(OperatorProfileResponseDtoOutputBankChangeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorProfileResponseDtoOutputBankChangeBuilder toBuilder() =>
      OperatorProfileResponseDtoOutputBankChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorProfileResponseDtoOutputBankChange &&
        status == other.status &&
        bankName == other.bankName &&
        accountNumberMasked == other.accountNumberMasked &&
        accountHolder == other.accountHolder &&
        reason == other.reason &&
        reviewNote == other.reviewNote &&
        requestedAt == other.requestedAt &&
        reviewedAt == other.reviewedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, bankName.hashCode);
    _$hash = $jc(_$hash, accountNumberMasked.hashCode);
    _$hash = $jc(_$hash, accountHolder.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reviewNote.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorProfileResponseDtoOutputBankChange')
          ..add('status', status)
          ..add('bankName', bankName)
          ..add('accountNumberMasked', accountNumberMasked)
          ..add('accountHolder', accountHolder)
          ..add('reason', reason)
          ..add('reviewNote', reviewNote)
          ..add('requestedAt', requestedAt)
          ..add('reviewedAt', reviewedAt))
        .toString();
  }
}

class OperatorProfileResponseDtoOutputBankChangeBuilder
    implements
        Builder<OperatorProfileResponseDtoOutputBankChange,
            OperatorProfileResponseDtoOutputBankChangeBuilder> {
  _$OperatorProfileResponseDtoOutputBankChange? _$v;

  OperatorProfileResponseDtoOutputBankChangeStatusEnum? _status;
  OperatorProfileResponseDtoOutputBankChangeStatusEnum? get status =>
      _$this._status;
  set status(OperatorProfileResponseDtoOutputBankChangeStatusEnum? status) =>
      _$this._status = status;

  String? _bankName;
  String? get bankName => _$this._bankName;
  set bankName(String? bankName) => _$this._bankName = bankName;

  String? _accountNumberMasked;
  String? get accountNumberMasked => _$this._accountNumberMasked;
  set accountNumberMasked(String? accountNumberMasked) =>
      _$this._accountNumberMasked = accountNumberMasked;

  String? _accountHolder;
  String? get accountHolder => _$this._accountHolder;
  set accountHolder(String? accountHolder) =>
      _$this._accountHolder = accountHolder;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _reviewNote;
  String? get reviewNote => _$this._reviewNote;
  set reviewNote(String? reviewNote) => _$this._reviewNote = reviewNote;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  OperatorProfileResponseDtoOutputBankChangeBuilder() {
    OperatorProfileResponseDtoOutputBankChange._defaults(this);
  }

  OperatorProfileResponseDtoOutputBankChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _bankName = $v.bankName;
      _accountNumberMasked = $v.accountNumberMasked;
      _accountHolder = $v.accountHolder;
      _reason = $v.reason;
      _reviewNote = $v.reviewNote;
      _requestedAt = $v.requestedAt;
      _reviewedAt = $v.reviewedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorProfileResponseDtoOutputBankChange other) {
    _$v = other as _$OperatorProfileResponseDtoOutputBankChange;
  }

  @override
  void update(
      void Function(OperatorProfileResponseDtoOutputBankChangeBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorProfileResponseDtoOutputBankChange build() => _build();

  _$OperatorProfileResponseDtoOutputBankChange _build() {
    final _$result = _$v ??
        _$OperatorProfileResponseDtoOutputBankChange._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OperatorProfileResponseDtoOutputBankChange', 'status'),
          bankName: BuiltValueNullFieldError.checkNotNull(bankName,
              r'OperatorProfileResponseDtoOutputBankChange', 'bankName'),
          accountNumberMasked: BuiltValueNullFieldError.checkNotNull(
              accountNumberMasked,
              r'OperatorProfileResponseDtoOutputBankChange',
              'accountNumberMasked'),
          accountHolder: BuiltValueNullFieldError.checkNotNull(accountHolder,
              r'OperatorProfileResponseDtoOutputBankChange', 'accountHolder'),
          reason: reason,
          reviewNote: reviewNote,
          requestedAt: BuiltValueNullFieldError.checkNotNull(requestedAt,
              r'OperatorProfileResponseDtoOutputBankChange', 'requestedAt'),
          reviewedAt: reviewedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
