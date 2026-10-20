// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReconciliationRequestDto extends ReconciliationRequestDto {
  @override
  final String requestId;
  @override
  final String reason;

  factory _$ReconciliationRequestDto(
          [void Function(ReconciliationRequestDtoBuilder)? updates]) =>
      (ReconciliationRequestDtoBuilder()..update(updates))._build();

  _$ReconciliationRequestDto._({required this.requestId, required this.reason})
      : super._();
  @override
  ReconciliationRequestDto rebuild(
          void Function(ReconciliationRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReconciliationRequestDtoBuilder toBuilder() =>
      ReconciliationRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReconciliationRequestDto &&
        requestId == other.requestId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReconciliationRequestDto')
          ..add('requestId', requestId)
          ..add('reason', reason))
        .toString();
  }
}

class ReconciliationRequestDtoBuilder
    implements
        Builder<ReconciliationRequestDto, ReconciliationRequestDtoBuilder> {
  _$ReconciliationRequestDto? _$v;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ReconciliationRequestDtoBuilder() {
    ReconciliationRequestDto._defaults(this);
  }

  ReconciliationRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestId = $v.requestId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReconciliationRequestDto other) {
    _$v = other as _$ReconciliationRequestDto;
  }

  @override
  void update(void Function(ReconciliationRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReconciliationRequestDto build() => _build();

  _$ReconciliationRequestDto _build() {
    final _$result = _$v ??
        _$ReconciliationRequestDto._(
          requestId: BuiltValueNullFieldError.checkNotNull(
              requestId, r'ReconciliationRequestDto', 'requestId'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReconciliationRequestDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
