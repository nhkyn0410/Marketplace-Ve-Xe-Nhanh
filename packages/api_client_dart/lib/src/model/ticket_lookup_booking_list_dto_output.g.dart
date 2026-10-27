// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_lookup_booking_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketLookupBookingListDtoOutputScopeEnum
    _$ticketLookupBookingListDtoOutputScopeEnum_BOOKING =
    const TicketLookupBookingListDtoOutputScopeEnum._('BOOKING');
const TicketLookupBookingListDtoOutputScopeEnum
    _$ticketLookupBookingListDtoOutputScopeEnum_EMAIL =
    const TicketLookupBookingListDtoOutputScopeEnum._('EMAIL');

TicketLookupBookingListDtoOutputScopeEnum
    _$ticketLookupBookingListDtoOutputScopeEnumValueOf(String name) {
  switch (name) {
    case 'BOOKING':
      return _$ticketLookupBookingListDtoOutputScopeEnum_BOOKING;
    case 'EMAIL':
      return _$ticketLookupBookingListDtoOutputScopeEnum_EMAIL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketLookupBookingListDtoOutputScopeEnum>
    _$ticketLookupBookingListDtoOutputScopeEnumValues = BuiltSet<
        TicketLookupBookingListDtoOutputScopeEnum>(const <TicketLookupBookingListDtoOutputScopeEnum>[
  _$ticketLookupBookingListDtoOutputScopeEnum_BOOKING,
  _$ticketLookupBookingListDtoOutputScopeEnum_EMAIL,
]);

Serializer<TicketLookupBookingListDtoOutputScopeEnum>
    _$ticketLookupBookingListDtoOutputScopeEnumSerializer =
    _$TicketLookupBookingListDtoOutputScopeEnumSerializer();

class _$TicketLookupBookingListDtoOutputScopeEnumSerializer
    implements PrimitiveSerializer<TicketLookupBookingListDtoOutputScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOOKING': 'BOOKING',
    'EMAIL': 'EMAIL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOOKING': 'BOOKING',
    'EMAIL': 'EMAIL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TicketLookupBookingListDtoOutputScopeEnum
  ];
  @override
  final String wireName = 'TicketLookupBookingListDtoOutputScopeEnum';

  @override
  Object serialize(Serializers serializers,
          TicketLookupBookingListDtoOutputScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketLookupBookingListDtoOutputScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketLookupBookingListDtoOutputScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketLookupBookingListDtoOutput
    extends TicketLookupBookingListDtoOutput {
  @override
  final String maskedEmail;
  @override
  final TicketLookupBookingListDtoOutputScopeEnum scope;
  @override
  final bool hasAccount;
  @override
  final BuiltList<TicketLookupBookingListDtoOutputItemsInner> items;

  factory _$TicketLookupBookingListDtoOutput(
          [void Function(TicketLookupBookingListDtoOutputBuilder)? updates]) =>
      (TicketLookupBookingListDtoOutputBuilder()..update(updates))._build();

  _$TicketLookupBookingListDtoOutput._(
      {required this.maskedEmail,
      required this.scope,
      required this.hasAccount,
      required this.items})
      : super._();
  @override
  TicketLookupBookingListDtoOutput rebuild(
          void Function(TicketLookupBookingListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketLookupBookingListDtoOutputBuilder toBuilder() =>
      TicketLookupBookingListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketLookupBookingListDtoOutput &&
        maskedEmail == other.maskedEmail &&
        scope == other.scope &&
        hasAccount == other.hasAccount &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maskedEmail.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, hasAccount.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketLookupBookingListDtoOutput')
          ..add('maskedEmail', maskedEmail)
          ..add('scope', scope)
          ..add('hasAccount', hasAccount)
          ..add('items', items))
        .toString();
  }
}

class TicketLookupBookingListDtoOutputBuilder
    implements
        Builder<TicketLookupBookingListDtoOutput,
            TicketLookupBookingListDtoOutputBuilder> {
  _$TicketLookupBookingListDtoOutput? _$v;

  String? _maskedEmail;
  String? get maskedEmail => _$this._maskedEmail;
  set maskedEmail(String? maskedEmail) => _$this._maskedEmail = maskedEmail;

  TicketLookupBookingListDtoOutputScopeEnum? _scope;
  TicketLookupBookingListDtoOutputScopeEnum? get scope => _$this._scope;
  set scope(TicketLookupBookingListDtoOutputScopeEnum? scope) =>
      _$this._scope = scope;

  bool? _hasAccount;
  bool? get hasAccount => _$this._hasAccount;
  set hasAccount(bool? hasAccount) => _$this._hasAccount = hasAccount;

  ListBuilder<TicketLookupBookingListDtoOutputItemsInner>? _items;
  ListBuilder<TicketLookupBookingListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<TicketLookupBookingListDtoOutputItemsInner>();
  set items(ListBuilder<TicketLookupBookingListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  TicketLookupBookingListDtoOutputBuilder() {
    TicketLookupBookingListDtoOutput._defaults(this);
  }

  TicketLookupBookingListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maskedEmail = $v.maskedEmail;
      _scope = $v.scope;
      _hasAccount = $v.hasAccount;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketLookupBookingListDtoOutput other) {
    _$v = other as _$TicketLookupBookingListDtoOutput;
  }

  @override
  void update(void Function(TicketLookupBookingListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketLookupBookingListDtoOutput build() => _build();

  _$TicketLookupBookingListDtoOutput _build() {
    _$TicketLookupBookingListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TicketLookupBookingListDtoOutput._(
            maskedEmail: BuiltValueNullFieldError.checkNotNull(maskedEmail,
                r'TicketLookupBookingListDtoOutput', 'maskedEmail'),
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'TicketLookupBookingListDtoOutput', 'scope'),
            hasAccount: BuiltValueNullFieldError.checkNotNull(
                hasAccount, r'TicketLookupBookingListDtoOutput', 'hasAccount'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TicketLookupBookingListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
