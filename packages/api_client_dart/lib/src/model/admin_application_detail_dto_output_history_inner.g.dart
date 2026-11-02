// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output_history_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_CREATED =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._('CREATED');
const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_EMAIL_VERIFIED =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._(
        'EMAIL_VERIFIED');
const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_SUBMITTED =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._('SUBMITTED');
const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_NEEDS_INFO =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._('NEEDS_INFO');
const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_REJECTED =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._('REJECTED');
const AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_APPROVED =
    const AdminApplicationDetailDtoOutputHistoryInnerEventEnum._('APPROVED');

AdminApplicationDetailDtoOutputHistoryInnerEventEnum
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnumValueOf(String name) {
  switch (name) {
    case 'CREATED':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_CREATED;
    case 'EMAIL_VERIFIED':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_EMAIL_VERIFIED;
    case 'SUBMITTED':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_SUBMITTED;
    case 'NEEDS_INFO':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_NEEDS_INFO;
    case 'REJECTED':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_REJECTED;
    case 'APPROVED':
      return _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_APPROVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApplicationDetailDtoOutputHistoryInnerEventEnum>
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnumValues = BuiltSet<
        AdminApplicationDetailDtoOutputHistoryInnerEventEnum>(const <AdminApplicationDetailDtoOutputHistoryInnerEventEnum>[
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_CREATED,
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_EMAIL_VERIFIED,
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_SUBMITTED,
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_NEEDS_INFO,
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_REJECTED,
  _$adminApplicationDetailDtoOutputHistoryInnerEventEnum_APPROVED,
]);

Serializer<AdminApplicationDetailDtoOutputHistoryInnerEventEnum>
    _$adminApplicationDetailDtoOutputHistoryInnerEventEnumSerializer =
    _$AdminApplicationDetailDtoOutputHistoryInnerEventEnumSerializer();

class _$AdminApplicationDetailDtoOutputHistoryInnerEventEnumSerializer
    implements
        PrimitiveSerializer<
            AdminApplicationDetailDtoOutputHistoryInnerEventEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CREATED': 'CREATED',
    'EMAIL_VERIFIED': 'EMAIL_VERIFIED',
    'SUBMITTED': 'SUBMITTED',
    'NEEDS_INFO': 'NEEDS_INFO',
    'REJECTED': 'REJECTED',
    'APPROVED': 'APPROVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CREATED': 'CREATED',
    'EMAIL_VERIFIED': 'EMAIL_VERIFIED',
    'SUBMITTED': 'SUBMITTED',
    'NEEDS_INFO': 'NEEDS_INFO',
    'REJECTED': 'REJECTED',
    'APPROVED': 'APPROVED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminApplicationDetailDtoOutputHistoryInnerEventEnum
  ];
  @override
  final String wireName =
      'AdminApplicationDetailDtoOutputHistoryInnerEventEnum';

  @override
  Object serialize(Serializers serializers,
          AdminApplicationDetailDtoOutputHistoryInnerEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationDetailDtoOutputHistoryInnerEventEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminApplicationDetailDtoOutputHistoryInnerEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminApplicationDetailDtoOutputHistoryInner
    extends AdminApplicationDetailDtoOutputHistoryInner {
  @override
  final AdminApplicationDetailDtoOutputHistoryInnerEventEnum event;
  @override
  final DateTime at;
  @override
  final String? note;

  factory _$AdminApplicationDetailDtoOutputHistoryInner(
          [void Function(AdminApplicationDetailDtoOutputHistoryInnerBuilder)?
              updates]) =>
      (AdminApplicationDetailDtoOutputHistoryInnerBuilder()..update(updates))
          ._build();

  _$AdminApplicationDetailDtoOutputHistoryInner._(
      {required this.event, required this.at, this.note})
      : super._();
  @override
  AdminApplicationDetailDtoOutputHistoryInner rebuild(
          void Function(AdminApplicationDetailDtoOutputHistoryInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputHistoryInnerBuilder toBuilder() =>
      AdminApplicationDetailDtoOutputHistoryInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationDetailDtoOutputHistoryInner &&
        event == other.event &&
        at == other.at &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminApplicationDetailDtoOutputHistoryInner')
          ..add('event', event)
          ..add('at', at)
          ..add('note', note))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputHistoryInnerBuilder
    implements
        Builder<AdminApplicationDetailDtoOutputHistoryInner,
            AdminApplicationDetailDtoOutputHistoryInnerBuilder> {
  _$AdminApplicationDetailDtoOutputHistoryInner? _$v;

  AdminApplicationDetailDtoOutputHistoryInnerEventEnum? _event;
  AdminApplicationDetailDtoOutputHistoryInnerEventEnum? get event =>
      _$this._event;
  set event(AdminApplicationDetailDtoOutputHistoryInnerEventEnum? event) =>
      _$this._event = event;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminApplicationDetailDtoOutputHistoryInnerBuilder() {
    AdminApplicationDetailDtoOutputHistoryInner._defaults(this);
  }

  AdminApplicationDetailDtoOutputHistoryInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _at = $v.at;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationDetailDtoOutputHistoryInner other) {
    _$v = other as _$AdminApplicationDetailDtoOutputHistoryInner;
  }

  @override
  void update(
      void Function(AdminApplicationDetailDtoOutputHistoryInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutputHistoryInner build() => _build();

  _$AdminApplicationDetailDtoOutputHistoryInner _build() {
    final _$result = _$v ??
        _$AdminApplicationDetailDtoOutputHistoryInner._(
          event: BuiltValueNullFieldError.checkNotNull(
              event, r'AdminApplicationDetailDtoOutputHistoryInner', 'event'),
          at: BuiltValueNullFieldError.checkNotNull(
              at, r'AdminApplicationDetailDtoOutputHistoryInner', 'at'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
