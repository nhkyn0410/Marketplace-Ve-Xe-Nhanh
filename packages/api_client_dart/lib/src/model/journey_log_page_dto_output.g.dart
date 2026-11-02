// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_log_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JourneyLogPageDtoOutput extends JourneyLogPageDtoOutput {
  @override
  final BuiltList<JourneyLogPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$JourneyLogPageDtoOutput(
          [void Function(JourneyLogPageDtoOutputBuilder)? updates]) =>
      (JourneyLogPageDtoOutputBuilder()..update(updates))._build();

  _$JourneyLogPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  JourneyLogPageDtoOutput rebuild(
          void Function(JourneyLogPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyLogPageDtoOutputBuilder toBuilder() =>
      JourneyLogPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyLogPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JourneyLogPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class JourneyLogPageDtoOutputBuilder
    implements
        Builder<JourneyLogPageDtoOutput, JourneyLogPageDtoOutputBuilder> {
  _$JourneyLogPageDtoOutput? _$v;

  ListBuilder<JourneyLogPageDtoOutputItemsInner>? _items;
  ListBuilder<JourneyLogPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<JourneyLogPageDtoOutputItemsInner>();
  set items(ListBuilder<JourneyLogPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  JourneyLogPageDtoOutputBuilder() {
    JourneyLogPageDtoOutput._defaults(this);
  }

  JourneyLogPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JourneyLogPageDtoOutput other) {
    _$v = other as _$JourneyLogPageDtoOutput;
  }

  @override
  void update(void Function(JourneyLogPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyLogPageDtoOutput build() => _build();

  _$JourneyLogPageDtoOutput _build() {
    _$JourneyLogPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$JourneyLogPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JourneyLogPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
