// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_list_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripScheduleListResponseDtoOutput
    extends TripScheduleListResponseDtoOutput {
  @override
  final BuiltList<TripScheduleListResponseDtoOutputItemsInner> items;

  factory _$TripScheduleListResponseDtoOutput(
          [void Function(TripScheduleListResponseDtoOutputBuilder)? updates]) =>
      (TripScheduleListResponseDtoOutputBuilder()..update(updates))._build();

  _$TripScheduleListResponseDtoOutput._({required this.items}) : super._();
  @override
  TripScheduleListResponseDtoOutput rebuild(
          void Function(TripScheduleListResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleListResponseDtoOutputBuilder toBuilder() =>
      TripScheduleListResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleListResponseDtoOutput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripScheduleListResponseDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class TripScheduleListResponseDtoOutputBuilder
    implements
        Builder<TripScheduleListResponseDtoOutput,
            TripScheduleListResponseDtoOutputBuilder> {
  _$TripScheduleListResponseDtoOutput? _$v;

  ListBuilder<TripScheduleListResponseDtoOutputItemsInner>? _items;
  ListBuilder<TripScheduleListResponseDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<TripScheduleListResponseDtoOutputItemsInner>();
  set items(ListBuilder<TripScheduleListResponseDtoOutputItemsInner>? items) =>
      _$this._items = items;

  TripScheduleListResponseDtoOutputBuilder() {
    TripScheduleListResponseDtoOutput._defaults(this);
  }

  TripScheduleListResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleListResponseDtoOutput other) {
    _$v = other as _$TripScheduleListResponseDtoOutput;
  }

  @override
  void update(
      void Function(TripScheduleListResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleListResponseDtoOutput build() => _build();

  _$TripScheduleListResponseDtoOutput _build() {
    _$TripScheduleListResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripScheduleListResponseDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripScheduleListResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
