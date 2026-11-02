// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_dispute_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectDisputeInputDto extends DirectDisputeInputDto {
  @override
  final String bookingId;
  @override
  final String? title;
  @override
  final String? customerRequest;
  @override
  final String reason;

  factory _$DirectDisputeInputDto(
          [void Function(DirectDisputeInputDtoBuilder)? updates]) =>
      (DirectDisputeInputDtoBuilder()..update(updates))._build();

  _$DirectDisputeInputDto._(
      {required this.bookingId,
      this.title,
      this.customerRequest,
      required this.reason})
      : super._();
  @override
  DirectDisputeInputDto rebuild(
          void Function(DirectDisputeInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectDisputeInputDtoBuilder toBuilder() =>
      DirectDisputeInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectDisputeInputDto &&
        bookingId == other.bookingId &&
        title == other.title &&
        customerRequest == other.customerRequest &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, customerRequest.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectDisputeInputDto')
          ..add('bookingId', bookingId)
          ..add('title', title)
          ..add('customerRequest', customerRequest)
          ..add('reason', reason))
        .toString();
  }
}

class DirectDisputeInputDtoBuilder
    implements Builder<DirectDisputeInputDto, DirectDisputeInputDtoBuilder> {
  _$DirectDisputeInputDto? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _customerRequest;
  String? get customerRequest => _$this._customerRequest;
  set customerRequest(String? customerRequest) =>
      _$this._customerRequest = customerRequest;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DirectDisputeInputDtoBuilder() {
    DirectDisputeInputDto._defaults(this);
  }

  DirectDisputeInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _title = $v.title;
      _customerRequest = $v.customerRequest;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectDisputeInputDto other) {
    _$v = other as _$DirectDisputeInputDto;
  }

  @override
  void update(void Function(DirectDisputeInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectDisputeInputDto build() => _build();

  _$DirectDisputeInputDto _build() {
    final _$result = _$v ??
        _$DirectDisputeInputDto._(
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'DirectDisputeInputDto', 'bookingId'),
          title: title,
          customerRequest: customerRequest,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DirectDisputeInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
