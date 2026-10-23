// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalate_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EscalateInputDto extends EscalateInputDto {
  @override
  final String? title;
  @override
  final String? customerRequest;
  @override
  final String reason;

  factory _$EscalateInputDto(
          [void Function(EscalateInputDtoBuilder)? updates]) =>
      (EscalateInputDtoBuilder()..update(updates))._build();

  _$EscalateInputDto._({this.title, this.customerRequest, required this.reason})
      : super._();
  @override
  EscalateInputDto rebuild(void Function(EscalateInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EscalateInputDtoBuilder toBuilder() =>
      EscalateInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EscalateInputDto &&
        title == other.title &&
        customerRequest == other.customerRequest &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, customerRequest.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EscalateInputDto')
          ..add('title', title)
          ..add('customerRequest', customerRequest)
          ..add('reason', reason))
        .toString();
  }
}

class EscalateInputDtoBuilder
    implements Builder<EscalateInputDto, EscalateInputDtoBuilder> {
  _$EscalateInputDto? _$v;

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

  EscalateInputDtoBuilder() {
    EscalateInputDto._defaults(this);
  }

  EscalateInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _customerRequest = $v.customerRequest;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EscalateInputDto other) {
    _$v = other as _$EscalateInputDto;
  }

  @override
  void update(void Function(EscalateInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EscalateInputDto build() => _build();

  _$EscalateInputDto _build() {
    final _$result = _$v ??
        _$EscalateInputDto._(
          title: title,
          customerRequest: customerRequest,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'EscalateInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
