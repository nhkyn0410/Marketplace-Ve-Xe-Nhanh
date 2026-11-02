// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_sales_dto_output_changes_inner_before_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSalesDtoOutputChangesInnerBeforeStopsInner
    extends TripSalesDtoOutputChangesInnerBeforeStopsInner {
  @override
  final int sequence;
  @override
  final String name;

  factory _$TripSalesDtoOutputChangesInnerBeforeStopsInner(
          [void Function(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder)?
              updates]) =>
      (TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder()..update(updates))
          ._build();

  _$TripSalesDtoOutputChangesInnerBeforeStopsInner._(
      {required this.sequence, required this.name})
      : super._();
  @override
  TripSalesDtoOutputChangesInnerBeforeStopsInner rebuild(
          void Function(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder toBuilder() =>
      TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSalesDtoOutputChangesInnerBeforeStopsInner &&
        sequence == other.sequence &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSalesDtoOutputChangesInnerBeforeStopsInner')
          ..add('sequence', sequence)
          ..add('name', name))
        .toString();
  }
}

class TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder
    implements
        Builder<TripSalesDtoOutputChangesInnerBeforeStopsInner,
            TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder> {
  _$TripSalesDtoOutputChangesInnerBeforeStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder() {
    TripSalesDtoOutputChangesInnerBeforeStopsInner._defaults(this);
  }

  TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSalesDtoOutputChangesInnerBeforeStopsInner other) {
    _$v = other as _$TripSalesDtoOutputChangesInnerBeforeStopsInner;
  }

  @override
  void update(
      void Function(TripSalesDtoOutputChangesInnerBeforeStopsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSalesDtoOutputChangesInnerBeforeStopsInner build() => _build();

  _$TripSalesDtoOutputChangesInnerBeforeStopsInner _build() {
    final _$result = _$v ??
        _$TripSalesDtoOutputChangesInnerBeforeStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(sequence,
              r'TripSalesDtoOutputChangesInnerBeforeStopsInner', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripSalesDtoOutputChangesInnerBeforeStopsInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
