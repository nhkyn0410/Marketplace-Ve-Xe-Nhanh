// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_resolve_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefundResolveInputDto extends RefundResolveInputDto {
  @override
  final String reference;
  @override
  final String reason;

  factory _$RefundResolveInputDto(
          [void Function(RefundResolveInputDtoBuilder)? updates]) =>
      (RefundResolveInputDtoBuilder()..update(updates))._build();

  _$RefundResolveInputDto._({required this.reference, required this.reason})
      : super._();
  @override
  RefundResolveInputDto rebuild(
          void Function(RefundResolveInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefundResolveInputDtoBuilder toBuilder() =>
      RefundResolveInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefundResolveInputDto &&
        reference == other.reference &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefundResolveInputDto')
          ..add('reference', reference)
          ..add('reason', reason))
        .toString();
  }
}

class RefundResolveInputDtoBuilder
    implements Builder<RefundResolveInputDto, RefundResolveInputDtoBuilder> {
  _$RefundResolveInputDto? _$v;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RefundResolveInputDtoBuilder() {
    RefundResolveInputDto._defaults(this);
  }

  RefundResolveInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reference = $v.reference;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefundResolveInputDto other) {
    _$v = other as _$RefundResolveInputDto;
  }

  @override
  void update(void Function(RefundResolveInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefundResolveInputDto build() => _build();

  _$RefundResolveInputDto _build() {
    final _$result = _$v ??
        _$RefundResolveInputDto._(
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'RefundResolveInputDto', 'reference'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'RefundResolveInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
