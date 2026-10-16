// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionOverviewDtoOutput extends CommissionOverviewDtoOutput {
  @override
  final CommissionOverviewDtoOutputDefault? default_;
  @override
  final BuiltList<CommissionOverviewDtoOutputOverridesInner> overrides;

  factory _$CommissionOverviewDtoOutput(
          [void Function(CommissionOverviewDtoOutputBuilder)? updates]) =>
      (CommissionOverviewDtoOutputBuilder()..update(updates))._build();

  _$CommissionOverviewDtoOutput._({this.default_, required this.overrides})
      : super._();
  @override
  CommissionOverviewDtoOutput rebuild(
          void Function(CommissionOverviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionOverviewDtoOutputBuilder toBuilder() =>
      CommissionOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionOverviewDtoOutput &&
        default_ == other.default_ &&
        overrides == other.overrides;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, default_.hashCode);
    _$hash = $jc(_$hash, overrides.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionOverviewDtoOutput')
          ..add('default_', default_)
          ..add('overrides', overrides))
        .toString();
  }
}

class CommissionOverviewDtoOutputBuilder
    implements
        Builder<CommissionOverviewDtoOutput,
            CommissionOverviewDtoOutputBuilder> {
  _$CommissionOverviewDtoOutput? _$v;

  CommissionOverviewDtoOutputDefaultBuilder? _default_;
  CommissionOverviewDtoOutputDefaultBuilder get default_ =>
      _$this._default_ ??= CommissionOverviewDtoOutputDefaultBuilder();
  set default_(CommissionOverviewDtoOutputDefaultBuilder? default_) =>
      _$this._default_ = default_;

  ListBuilder<CommissionOverviewDtoOutputOverridesInner>? _overrides;
  ListBuilder<CommissionOverviewDtoOutputOverridesInner> get overrides =>
      _$this._overrides ??=
          ListBuilder<CommissionOverviewDtoOutputOverridesInner>();
  set overrides(
          ListBuilder<CommissionOverviewDtoOutputOverridesInner>? overrides) =>
      _$this._overrides = overrides;

  CommissionOverviewDtoOutputBuilder() {
    CommissionOverviewDtoOutput._defaults(this);
  }

  CommissionOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _default_ = $v.default_?.toBuilder();
      _overrides = $v.overrides.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionOverviewDtoOutput other) {
    _$v = other as _$CommissionOverviewDtoOutput;
  }

  @override
  void update(void Function(CommissionOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionOverviewDtoOutput build() => _build();

  _$CommissionOverviewDtoOutput _build() {
    _$CommissionOverviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CommissionOverviewDtoOutput._(
            default_: _default_?.build(),
            overrides: overrides.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'default_';
        _default_?.build();
        _$failedField = 'overrides';
        overrides.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CommissionOverviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
