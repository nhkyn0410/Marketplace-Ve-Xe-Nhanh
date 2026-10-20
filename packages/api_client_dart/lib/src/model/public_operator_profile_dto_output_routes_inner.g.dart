// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_operator_profile_dto_output_routes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicOperatorProfileDtoOutputRoutesInner
    extends PublicOperatorProfileDtoOutputRoutesInner {
  @override
  final String routeId;
  @override
  final String name;

  factory _$PublicOperatorProfileDtoOutputRoutesInner(
          [void Function(PublicOperatorProfileDtoOutputRoutesInnerBuilder)?
              updates]) =>
      (PublicOperatorProfileDtoOutputRoutesInnerBuilder()..update(updates))
          ._build();

  _$PublicOperatorProfileDtoOutputRoutesInner._(
      {required this.routeId, required this.name})
      : super._();
  @override
  PublicOperatorProfileDtoOutputRoutesInner rebuild(
          void Function(PublicOperatorProfileDtoOutputRoutesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicOperatorProfileDtoOutputRoutesInnerBuilder toBuilder() =>
      PublicOperatorProfileDtoOutputRoutesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicOperatorProfileDtoOutputRoutesInner &&
        routeId == other.routeId &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicOperatorProfileDtoOutputRoutesInner')
          ..add('routeId', routeId)
          ..add('name', name))
        .toString();
  }
}

class PublicOperatorProfileDtoOutputRoutesInnerBuilder
    implements
        Builder<PublicOperatorProfileDtoOutputRoutesInner,
            PublicOperatorProfileDtoOutputRoutesInnerBuilder> {
  _$PublicOperatorProfileDtoOutputRoutesInner? _$v;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PublicOperatorProfileDtoOutputRoutesInnerBuilder() {
    PublicOperatorProfileDtoOutputRoutesInner._defaults(this);
  }

  PublicOperatorProfileDtoOutputRoutesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeId = $v.routeId;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicOperatorProfileDtoOutputRoutesInner other) {
    _$v = other as _$PublicOperatorProfileDtoOutputRoutesInner;
  }

  @override
  void update(
      void Function(PublicOperatorProfileDtoOutputRoutesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicOperatorProfileDtoOutputRoutesInner build() => _build();

  _$PublicOperatorProfileDtoOutputRoutesInner _build() {
    final _$result = _$v ??
        _$PublicOperatorProfileDtoOutputRoutesInner._(
          routeId: BuiltValueNullFieldError.checkNotNull(
              routeId, r'PublicOperatorProfileDtoOutputRoutesInner', 'routeId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PublicOperatorProfileDtoOutputRoutesInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
