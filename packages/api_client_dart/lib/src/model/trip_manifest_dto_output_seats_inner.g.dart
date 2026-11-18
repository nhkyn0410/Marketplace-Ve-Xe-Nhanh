// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_manifest_dto_output_seats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripManifestDtoOutputSeatsInner
    extends TripManifestDtoOutputSeatsInner {
  @override
  final String code;
  @override
  final int deck;
  @override
  final int row;
  @override
  final int column;

  factory _$TripManifestDtoOutputSeatsInner(
          [void Function(TripManifestDtoOutputSeatsInnerBuilder)? updates]) =>
      (TripManifestDtoOutputSeatsInnerBuilder()..update(updates))._build();

  _$TripManifestDtoOutputSeatsInner._(
      {required this.code,
      required this.deck,
      required this.row,
      required this.column})
      : super._();
  @override
  TripManifestDtoOutputSeatsInner rebuild(
          void Function(TripManifestDtoOutputSeatsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripManifestDtoOutputSeatsInnerBuilder toBuilder() =>
      TripManifestDtoOutputSeatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripManifestDtoOutputSeatsInner &&
        code == other.code &&
        deck == other.deck &&
        row == other.row &&
        column == other.column;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, deck.hashCode);
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, column.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripManifestDtoOutputSeatsInner')
          ..add('code', code)
          ..add('deck', deck)
          ..add('row', row)
          ..add('column', column))
        .toString();
  }
}

class TripManifestDtoOutputSeatsInnerBuilder
    implements
        Builder<TripManifestDtoOutputSeatsInner,
            TripManifestDtoOutputSeatsInnerBuilder> {
  _$TripManifestDtoOutputSeatsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  int? _deck;
  int? get deck => _$this._deck;
  set deck(int? deck) => _$this._deck = deck;

  int? _row;
  int? get row => _$this._row;
  set row(int? row) => _$this._row = row;

  int? _column;
  int? get column => _$this._column;
  set column(int? column) => _$this._column = column;

  TripManifestDtoOutputSeatsInnerBuilder() {
    TripManifestDtoOutputSeatsInner._defaults(this);
  }

  TripManifestDtoOutputSeatsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _deck = $v.deck;
      _row = $v.row;
      _column = $v.column;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripManifestDtoOutputSeatsInner other) {
    _$v = other as _$TripManifestDtoOutputSeatsInner;
  }

  @override
  void update(void Function(TripManifestDtoOutputSeatsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripManifestDtoOutputSeatsInner build() => _build();

  _$TripManifestDtoOutputSeatsInner _build() {
    final _$result = _$v ??
        _$TripManifestDtoOutputSeatsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'TripManifestDtoOutputSeatsInner', 'code'),
          deck: BuiltValueNullFieldError.checkNotNull(
              deck, r'TripManifestDtoOutputSeatsInner', 'deck'),
          row: BuiltValueNullFieldError.checkNotNull(
              row, r'TripManifestDtoOutputSeatsInner', 'row'),
          column: BuiltValueNullFieldError.checkNotNull(
              column, r'TripManifestDtoOutputSeatsInner', 'column'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
