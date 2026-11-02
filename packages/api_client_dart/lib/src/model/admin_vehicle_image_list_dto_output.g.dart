// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_image_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVehicleImageListDtoOutput extends AdminVehicleImageListDtoOutput {
  @override
  final BuiltList<AdminVehicleImageListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final BuiltList<AdminVehicleImageListDtoOutputOperatorsInner> operators;

  factory _$AdminVehicleImageListDtoOutput(
          [void Function(AdminVehicleImageListDtoOutputBuilder)? updates]) =>
      (AdminVehicleImageListDtoOutputBuilder()..update(updates))._build();

  _$AdminVehicleImageListDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.operators})
      : super._();
  @override
  AdminVehicleImageListDtoOutput rebuild(
          void Function(AdminVehicleImageListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleImageListDtoOutputBuilder toBuilder() =>
      AdminVehicleImageListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleImageListDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        operators == other.operators;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, operators.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminVehicleImageListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('operators', operators))
        .toString();
  }
}

class AdminVehicleImageListDtoOutputBuilder
    implements
        Builder<AdminVehicleImageListDtoOutput,
            AdminVehicleImageListDtoOutputBuilder> {
  _$AdminVehicleImageListDtoOutput? _$v;

  ListBuilder<AdminVehicleImageListDtoOutputItemsInner>? _items;
  ListBuilder<AdminVehicleImageListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminVehicleImageListDtoOutputItemsInner>();
  set items(ListBuilder<AdminVehicleImageListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>? _operators;
  ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner> get operators =>
      _$this._operators ??=
          ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>();
  set operators(
          ListBuilder<AdminVehicleImageListDtoOutputOperatorsInner>?
              operators) =>
      _$this._operators = operators;

  AdminVehicleImageListDtoOutputBuilder() {
    AdminVehicleImageListDtoOutput._defaults(this);
  }

  AdminVehicleImageListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _operators = $v.operators.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleImageListDtoOutput other) {
    _$v = other as _$AdminVehicleImageListDtoOutput;
  }

  @override
  void update(void Function(AdminVehicleImageListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleImageListDtoOutput build() => _build();

  _$AdminVehicleImageListDtoOutput _build() {
    _$AdminVehicleImageListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminVehicleImageListDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminVehicleImageListDtoOutput', 'total'),
            operators: operators.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'operators';
        operators.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminVehicleImageListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
