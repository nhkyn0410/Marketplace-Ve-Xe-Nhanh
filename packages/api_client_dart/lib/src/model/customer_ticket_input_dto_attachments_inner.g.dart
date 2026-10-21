// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ticket_input_dto_attachments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerTicketInputDtoAttachmentsInner
    extends CustomerTicketInputDtoAttachmentsInner {
  @override
  final String objectKey;
  @override
  final String fileName;

  factory _$CustomerTicketInputDtoAttachmentsInner(
          [void Function(CustomerTicketInputDtoAttachmentsInnerBuilder)?
              updates]) =>
      (CustomerTicketInputDtoAttachmentsInnerBuilder()..update(updates))
          ._build();

  _$CustomerTicketInputDtoAttachmentsInner._(
      {required this.objectKey, required this.fileName})
      : super._();
  @override
  CustomerTicketInputDtoAttachmentsInner rebuild(
          void Function(CustomerTicketInputDtoAttachmentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerTicketInputDtoAttachmentsInnerBuilder toBuilder() =>
      CustomerTicketInputDtoAttachmentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerTicketInputDtoAttachmentsInner &&
        objectKey == other.objectKey &&
        fileName == other.fileName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerTicketInputDtoAttachmentsInner')
          ..add('objectKey', objectKey)
          ..add('fileName', fileName))
        .toString();
  }
}

class CustomerTicketInputDtoAttachmentsInnerBuilder
    implements
        Builder<CustomerTicketInputDtoAttachmentsInner,
            CustomerTicketInputDtoAttachmentsInnerBuilder> {
  _$CustomerTicketInputDtoAttachmentsInner? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  CustomerTicketInputDtoAttachmentsInnerBuilder() {
    CustomerTicketInputDtoAttachmentsInner._defaults(this);
  }

  CustomerTicketInputDtoAttachmentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerTicketInputDtoAttachmentsInner other) {
    _$v = other as _$CustomerTicketInputDtoAttachmentsInner;
  }

  @override
  void update(
      void Function(CustomerTicketInputDtoAttachmentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerTicketInputDtoAttachmentsInner build() => _build();

  _$CustomerTicketInputDtoAttachmentsInner _build() {
    final _$result = _$v ??
        _$CustomerTicketInputDtoAttachmentsInner._(
          objectKey: BuiltValueNullFieldError.checkNotNull(objectKey,
              r'CustomerTicketInputDtoAttachmentsInner', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'CustomerTicketInputDtoAttachmentsInner', 'fileName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
