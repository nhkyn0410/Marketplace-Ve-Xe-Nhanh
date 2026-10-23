// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancellationInputDto extends CancellationInputDto {
  @override
  final BuiltList<String> ticketIds;
  @override
  final int expectedRefund;
  @override
  final String? reason;

  factory _$CancellationInputDto(
          [void Function(CancellationInputDtoBuilder)? updates]) =>
      (CancellationInputDtoBuilder()..update(updates))._build();

  _$CancellationInputDto._(
      {required this.ticketIds, required this.expectedRefund, this.reason})
      : super._();
  @override
  CancellationInputDto rebuild(
          void Function(CancellationInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationInputDtoBuilder toBuilder() =>
      CancellationInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationInputDto &&
        ticketIds == other.ticketIds &&
        expectedRefund == other.expectedRefund &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketIds.hashCode);
    _$hash = $jc(_$hash, expectedRefund.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationInputDto')
          ..add('ticketIds', ticketIds)
          ..add('expectedRefund', expectedRefund)
          ..add('reason', reason))
        .toString();
  }
}

class CancellationInputDtoBuilder
    implements Builder<CancellationInputDto, CancellationInputDtoBuilder> {
  _$CancellationInputDto? _$v;

  ListBuilder<String>? _ticketIds;
  ListBuilder<String> get ticketIds =>
      _$this._ticketIds ??= ListBuilder<String>();
  set ticketIds(ListBuilder<String>? ticketIds) =>
      _$this._ticketIds = ticketIds;

  int? _expectedRefund;
  int? get expectedRefund => _$this._expectedRefund;
  set expectedRefund(int? expectedRefund) =>
      _$this._expectedRefund = expectedRefund;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CancellationInputDtoBuilder() {
    CancellationInputDto._defaults(this);
  }

  CancellationInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketIds = $v.ticketIds.toBuilder();
      _expectedRefund = $v.expectedRefund;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationInputDto other) {
    _$v = other as _$CancellationInputDto;
  }

  @override
  void update(void Function(CancellationInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationInputDto build() => _build();

  _$CancellationInputDto _build() {
    _$CancellationInputDto _$result;
    try {
      _$result = _$v ??
          _$CancellationInputDto._(
            ticketIds: ticketIds.build(),
            expectedRefund: BuiltValueNullFieldError.checkNotNull(
                expectedRefund, r'CancellationInputDto', 'expectedRefund'),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticketIds';
        ticketIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CancellationInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
