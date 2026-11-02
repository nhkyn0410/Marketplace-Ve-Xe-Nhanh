// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_route_suggestion_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubRouteSuggestionListDtoOutputItemsInner
    extends SubRouteSuggestionListDtoOutputItemsInner {
  @override
  final RouteResponseDtoOutputSubRoutesInnerFrom from;
  @override
  final RouteResponseDtoOutputSubRoutesInnerFrom to;
  @override
  final String name;
  @override
  final int totalDistanceMeters;
  @override
  final int totalDurationSeconds;
  @override
  final BuiltList<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>?
      suggestedRules;

  factory _$SubRouteSuggestionListDtoOutputItemsInner(
          [void Function(SubRouteSuggestionListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (SubRouteSuggestionListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$SubRouteSuggestionListDtoOutputItemsInner._(
      {required this.from,
      required this.to,
      required this.name,
      required this.totalDistanceMeters,
      required this.totalDurationSeconds,
      this.suggestedRules})
      : super._();
  @override
  SubRouteSuggestionListDtoOutputItemsInner rebuild(
          void Function(SubRouteSuggestionListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubRouteSuggestionListDtoOutputItemsInnerBuilder toBuilder() =>
      SubRouteSuggestionListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubRouteSuggestionListDtoOutputItemsInner &&
        from == other.from &&
        to == other.to &&
        name == other.name &&
        totalDistanceMeters == other.totalDistanceMeters &&
        totalDurationSeconds == other.totalDurationSeconds &&
        suggestedRules == other.suggestedRules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, totalDistanceMeters.hashCode);
    _$hash = $jc(_$hash, totalDurationSeconds.hashCode);
    _$hash = $jc(_$hash, suggestedRules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SubRouteSuggestionListDtoOutputItemsInner')
          ..add('from', from)
          ..add('to', to)
          ..add('name', name)
          ..add('totalDistanceMeters', totalDistanceMeters)
          ..add('totalDurationSeconds', totalDurationSeconds)
          ..add('suggestedRules', suggestedRules))
        .toString();
  }
}

class SubRouteSuggestionListDtoOutputItemsInnerBuilder
    implements
        Builder<SubRouteSuggestionListDtoOutputItemsInner,
            SubRouteSuggestionListDtoOutputItemsInnerBuilder> {
  _$SubRouteSuggestionListDtoOutputItemsInner? _$v;

  RouteResponseDtoOutputSubRoutesInnerFromBuilder? _from;
  RouteResponseDtoOutputSubRoutesInnerFromBuilder get from =>
      _$this._from ??= RouteResponseDtoOutputSubRoutesInnerFromBuilder();
  set from(RouteResponseDtoOutputSubRoutesInnerFromBuilder? from) =>
      _$this._from = from;

  RouteResponseDtoOutputSubRoutesInnerFromBuilder? _to;
  RouteResponseDtoOutputSubRoutesInnerFromBuilder get to =>
      _$this._to ??= RouteResponseDtoOutputSubRoutesInnerFromBuilder();
  set to(RouteResponseDtoOutputSubRoutesInnerFromBuilder? to) =>
      _$this._to = to;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _totalDistanceMeters;
  int? get totalDistanceMeters => _$this._totalDistanceMeters;
  set totalDistanceMeters(int? totalDistanceMeters) =>
      _$this._totalDistanceMeters = totalDistanceMeters;

  int? _totalDurationSeconds;
  int? get totalDurationSeconds => _$this._totalDurationSeconds;
  set totalDurationSeconds(int? totalDurationSeconds) =>
      _$this._totalDurationSeconds = totalDurationSeconds;

  ListBuilder<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>?
      _suggestedRules;
  ListBuilder<SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>
      get suggestedRules => _$this._suggestedRules ??= ListBuilder<
          SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>();
  set suggestedRules(
          ListBuilder<
                  SubRouteSuggestionListDtoOutputItemsInnerSuggestedRulesInner>?
              suggestedRules) =>
      _$this._suggestedRules = suggestedRules;

  SubRouteSuggestionListDtoOutputItemsInnerBuilder() {
    SubRouteSuggestionListDtoOutputItemsInner._defaults(this);
  }

  SubRouteSuggestionListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _name = $v.name;
      _totalDistanceMeters = $v.totalDistanceMeters;
      _totalDurationSeconds = $v.totalDurationSeconds;
      _suggestedRules = $v.suggestedRules?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubRouteSuggestionListDtoOutputItemsInner other) {
    _$v = other as _$SubRouteSuggestionListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(SubRouteSuggestionListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SubRouteSuggestionListDtoOutputItemsInner build() => _build();

  _$SubRouteSuggestionListDtoOutputItemsInner _build() {
    _$SubRouteSuggestionListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$SubRouteSuggestionListDtoOutputItemsInner._(
            from: from.build(),
            to: to.build(),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'SubRouteSuggestionListDtoOutputItemsInner', 'name'),
            totalDistanceMeters: BuiltValueNullFieldError.checkNotNull(
                totalDistanceMeters,
                r'SubRouteSuggestionListDtoOutputItemsInner',
                'totalDistanceMeters'),
            totalDurationSeconds: BuiltValueNullFieldError.checkNotNull(
                totalDurationSeconds,
                r'SubRouteSuggestionListDtoOutputItemsInner',
                'totalDurationSeconds'),
            suggestedRules: _suggestedRules?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();

        _$failedField = 'suggestedRules';
        _suggestedRules?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubRouteSuggestionListDtoOutputItemsInner',
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
