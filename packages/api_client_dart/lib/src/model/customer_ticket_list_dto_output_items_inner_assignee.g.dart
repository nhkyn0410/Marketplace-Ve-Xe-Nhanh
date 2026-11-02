// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ticket_list_dto_output_items_inner_assignee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerTicketListDtoOutputItemsInnerAssignee
    extends CustomerTicketListDtoOutputItemsInnerAssignee {
  @override
  final String id;
  @override
  final String username;

  factory _$CustomerTicketListDtoOutputItemsInnerAssignee(
          [void Function(CustomerTicketListDtoOutputItemsInnerAssigneeBuilder)?
              updates]) =>
      (CustomerTicketListDtoOutputItemsInnerAssigneeBuilder()..update(updates))
          ._build();

  _$CustomerTicketListDtoOutputItemsInnerAssignee._(
      {required this.id, required this.username})
      : super._();
  @override
  CustomerTicketListDtoOutputItemsInnerAssignee rebuild(
          void Function(CustomerTicketListDtoOutputItemsInnerAssigneeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerTicketListDtoOutputItemsInnerAssigneeBuilder toBuilder() =>
      CustomerTicketListDtoOutputItemsInnerAssigneeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerTicketListDtoOutputItemsInnerAssignee &&
        id == other.id &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerTicketListDtoOutputItemsInnerAssignee')
          ..add('id', id)
          ..add('username', username))
        .toString();
  }
}

class CustomerTicketListDtoOutputItemsInnerAssigneeBuilder
    implements
        Builder<CustomerTicketListDtoOutputItemsInnerAssignee,
            CustomerTicketListDtoOutputItemsInnerAssigneeBuilder> {
  _$CustomerTicketListDtoOutputItemsInnerAssignee? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  CustomerTicketListDtoOutputItemsInnerAssigneeBuilder() {
    CustomerTicketListDtoOutputItemsInnerAssignee._defaults(this);
  }

  CustomerTicketListDtoOutputItemsInnerAssigneeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerTicketListDtoOutputItemsInnerAssignee other) {
    _$v = other as _$CustomerTicketListDtoOutputItemsInnerAssignee;
  }

  @override
  void update(
      void Function(CustomerTicketListDtoOutputItemsInnerAssigneeBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerTicketListDtoOutputItemsInnerAssignee build() => _build();

  _$CustomerTicketListDtoOutputItemsInnerAssignee _build() {
    final _$result = _$v ??
        _$CustomerTicketListDtoOutputItemsInnerAssignee._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CustomerTicketListDtoOutputItemsInnerAssignee', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'CustomerTicketListDtoOutputItemsInnerAssignee', 'username'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
