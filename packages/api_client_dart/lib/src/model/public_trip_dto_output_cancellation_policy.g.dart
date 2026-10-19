// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_cancellation_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutputCancellationPolicy
    extends PublicTripDtoOutputCancellationPolicy {
  @override
  final BuiltList<PublicTripDtoOutputCancellationPolicyTiersInner> tiers;

  factory _$PublicTripDtoOutputCancellationPolicy(
          [void Function(PublicTripDtoOutputCancellationPolicyBuilder)?
              updates]) =>
      (PublicTripDtoOutputCancellationPolicyBuilder()..update(updates))
          ._build();

  _$PublicTripDtoOutputCancellationPolicy._({required this.tiers}) : super._();
  @override
  PublicTripDtoOutputCancellationPolicy rebuild(
          void Function(PublicTripDtoOutputCancellationPolicyBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputCancellationPolicyBuilder toBuilder() =>
      PublicTripDtoOutputCancellationPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputCancellationPolicy &&
        tiers == other.tiers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicTripDtoOutputCancellationPolicy')
          ..add('tiers', tiers))
        .toString();
  }
}

class PublicTripDtoOutputCancellationPolicyBuilder
    implements
        Builder<PublicTripDtoOutputCancellationPolicy,
            PublicTripDtoOutputCancellationPolicyBuilder> {
  _$PublicTripDtoOutputCancellationPolicy? _$v;

  ListBuilder<PublicTripDtoOutputCancellationPolicyTiersInner>? _tiers;
  ListBuilder<PublicTripDtoOutputCancellationPolicyTiersInner> get tiers =>
      _$this._tiers ??=
          ListBuilder<PublicTripDtoOutputCancellationPolicyTiersInner>();
  set tiers(
          ListBuilder<PublicTripDtoOutputCancellationPolicyTiersInner>?
              tiers) =>
      _$this._tiers = tiers;

  PublicTripDtoOutputCancellationPolicyBuilder() {
    PublicTripDtoOutputCancellationPolicy._defaults(this);
  }

  PublicTripDtoOutputCancellationPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tiers = $v.tiers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputCancellationPolicy other) {
    _$v = other as _$PublicTripDtoOutputCancellationPolicy;
  }

  @override
  void update(
      void Function(PublicTripDtoOutputCancellationPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputCancellationPolicy build() => _build();

  _$PublicTripDtoOutputCancellationPolicy _build() {
    _$PublicTripDtoOutputCancellationPolicy _$result;
    try {
      _$result = _$v ??
          _$PublicTripDtoOutputCancellationPolicy._(
            tiers: tiers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicTripDtoOutputCancellationPolicy',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
