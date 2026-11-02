// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnreadCountDtoOutput extends UnreadCountDtoOutput {
  @override
  final int unreadCount;

  factory _$UnreadCountDtoOutput(
          [void Function(UnreadCountDtoOutputBuilder)? updates]) =>
      (UnreadCountDtoOutputBuilder()..update(updates))._build();

  _$UnreadCountDtoOutput._({required this.unreadCount}) : super._();
  @override
  UnreadCountDtoOutput rebuild(
          void Function(UnreadCountDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnreadCountDtoOutputBuilder toBuilder() =>
      UnreadCountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnreadCountDtoOutput && unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnreadCountDtoOutput')
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class UnreadCountDtoOutputBuilder
    implements Builder<UnreadCountDtoOutput, UnreadCountDtoOutputBuilder> {
  _$UnreadCountDtoOutput? _$v;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  UnreadCountDtoOutputBuilder() {
    UnreadCountDtoOutput._defaults(this);
  }

  UnreadCountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnreadCountDtoOutput other) {
    _$v = other as _$UnreadCountDtoOutput;
  }

  @override
  void update(void Function(UnreadCountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnreadCountDtoOutput build() => _build();

  _$UnreadCountDtoOutput _build() {
    final _$result = _$v ??
        _$UnreadCountDtoOutput._(
          unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount, r'UnreadCountDtoOutput', 'unreadCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
