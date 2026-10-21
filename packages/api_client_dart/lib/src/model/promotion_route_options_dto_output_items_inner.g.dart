// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_route_options_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionRouteOptionsDtoOutputItemsInner
    extends PromotionRouteOptionsDtoOutputItemsInner {
  @override
  final String routeId;
  @override
  final String routeName;
  @override
  final String operatorName;

  factory _$PromotionRouteOptionsDtoOutputItemsInner(
          [void Function(PromotionRouteOptionsDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PromotionRouteOptionsDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PromotionRouteOptionsDtoOutputItemsInner._(
      {required this.routeId,
      required this.routeName,
      required this.operatorName})
      : super._();
  @override
  PromotionRouteOptionsDtoOutputItemsInner rebuild(
          void Function(PromotionRouteOptionsDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionRouteOptionsDtoOutputItemsInnerBuilder toBuilder() =>
      PromotionRouteOptionsDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionRouteOptionsDtoOutputItemsInner &&
        routeId == other.routeId &&
        routeName == other.routeName &&
        operatorName == other.operatorName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PromotionRouteOptionsDtoOutputItemsInner')
          ..add('routeId', routeId)
          ..add('routeName', routeName)
          ..add('operatorName', operatorName))
        .toString();
  }
}

class PromotionRouteOptionsDtoOutputItemsInnerBuilder
    implements
        Builder<PromotionRouteOptionsDtoOutputItemsInner,
            PromotionRouteOptionsDtoOutputItemsInnerBuilder> {
  _$PromotionRouteOptionsDtoOutputItemsInner? _$v;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  PromotionRouteOptionsDtoOutputItemsInnerBuilder() {
    PromotionRouteOptionsDtoOutputItemsInner._defaults(this);
  }

  PromotionRouteOptionsDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeId = $v.routeId;
      _routeName = $v.routeName;
      _operatorName = $v.operatorName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionRouteOptionsDtoOutputItemsInner other) {
    _$v = other as _$PromotionRouteOptionsDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PromotionRouteOptionsDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionRouteOptionsDtoOutputItemsInner build() => _build();

  _$PromotionRouteOptionsDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PromotionRouteOptionsDtoOutputItemsInner._(
          routeId: BuiltValueNullFieldError.checkNotNull(
              routeId, r'PromotionRouteOptionsDtoOutputItemsInner', 'routeId'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'PromotionRouteOptionsDtoOutputItemsInner', 'routeName'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PromotionRouteOptionsDtoOutputItemsInner', 'operatorName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
