// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_check_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionCheckDtoOutput extends PromotionCheckDtoOutput {
  @override
  final String code;
  @override
  final String name;
  @override
  final int discount;
  @override
  final int total;

  factory _$PromotionCheckDtoOutput(
          [void Function(PromotionCheckDtoOutputBuilder)? updates]) =>
      (PromotionCheckDtoOutputBuilder()..update(updates))._build();

  _$PromotionCheckDtoOutput._(
      {required this.code,
      required this.name,
      required this.discount,
      required this.total})
      : super._();
  @override
  PromotionCheckDtoOutput rebuild(
          void Function(PromotionCheckDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionCheckDtoOutputBuilder toBuilder() =>
      PromotionCheckDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionCheckDtoOutput &&
        code == other.code &&
        name == other.name &&
        discount == other.discount &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionCheckDtoOutput')
          ..add('code', code)
          ..add('name', name)
          ..add('discount', discount)
          ..add('total', total))
        .toString();
  }
}

class PromotionCheckDtoOutputBuilder
    implements
        Builder<PromotionCheckDtoOutput, PromotionCheckDtoOutputBuilder> {
  _$PromotionCheckDtoOutput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _discount;
  int? get discount => _$this._discount;
  set discount(int? discount) => _$this._discount = discount;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PromotionCheckDtoOutputBuilder() {
    PromotionCheckDtoOutput._defaults(this);
  }

  PromotionCheckDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _discount = $v.discount;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionCheckDtoOutput other) {
    _$v = other as _$PromotionCheckDtoOutput;
  }

  @override
  void update(void Function(PromotionCheckDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionCheckDtoOutput build() => _build();

  _$PromotionCheckDtoOutput _build() {
    final _$result = _$v ??
        _$PromotionCheckDtoOutput._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PromotionCheckDtoOutput', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PromotionCheckDtoOutput', 'name'),
          discount: BuiltValueNullFieldError.checkNotNull(
              discount, r'PromotionCheckDtoOutput', 'discount'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PromotionCheckDtoOutput', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
