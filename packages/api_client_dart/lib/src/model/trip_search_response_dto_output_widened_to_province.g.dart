// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_widened_to_province.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputWidenedToProvince
    extends TripSearchResponseDtoOutputWidenedToProvince {
  @override
  final bool from;
  @override
  final bool to;

  factory _$TripSearchResponseDtoOutputWidenedToProvince(
          [void Function(TripSearchResponseDtoOutputWidenedToProvinceBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputWidenedToProvinceBuilder()..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputWidenedToProvince._(
      {required this.from, required this.to})
      : super._();
  @override
  TripSearchResponseDtoOutputWidenedToProvince rebuild(
          void Function(TripSearchResponseDtoOutputWidenedToProvinceBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputWidenedToProvinceBuilder toBuilder() =>
      TripSearchResponseDtoOutputWidenedToProvinceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputWidenedToProvince &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputWidenedToProvince')
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class TripSearchResponseDtoOutputWidenedToProvinceBuilder
    implements
        Builder<TripSearchResponseDtoOutputWidenedToProvince,
            TripSearchResponseDtoOutputWidenedToProvinceBuilder> {
  _$TripSearchResponseDtoOutputWidenedToProvince? _$v;

  bool? _from;
  bool? get from => _$this._from;
  set from(bool? from) => _$this._from = from;

  bool? _to;
  bool? get to => _$this._to;
  set to(bool? to) => _$this._to = to;

  TripSearchResponseDtoOutputWidenedToProvinceBuilder() {
    TripSearchResponseDtoOutputWidenedToProvince._defaults(this);
  }

  TripSearchResponseDtoOutputWidenedToProvinceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputWidenedToProvince other) {
    _$v = other as _$TripSearchResponseDtoOutputWidenedToProvince;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputWidenedToProvinceBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputWidenedToProvince build() => _build();

  _$TripSearchResponseDtoOutputWidenedToProvince _build() {
    final _$result = _$v ??
        _$TripSearchResponseDtoOutputWidenedToProvince._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'TripSearchResponseDtoOutputWidenedToProvince', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'TripSearchResponseDtoOutputWidenedToProvince', 'to'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
