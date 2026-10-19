// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_image_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVehicleImageListDtoOutputItemsInner
    extends AdminVehicleImageListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String url;
  @override
  final String? caption;
  @override
  final int position;
  @override
  final bool isCover;
  @override
  final String vehicleId;
  @override
  final String plateNumber;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final DateTime createdAt;

  factory _$AdminVehicleImageListDtoOutputItemsInner(
          [void Function(AdminVehicleImageListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminVehicleImageListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminVehicleImageListDtoOutputItemsInner._(
      {required this.id,
      required this.url,
      this.caption,
      required this.position,
      required this.isCover,
      required this.vehicleId,
      required this.plateNumber,
      required this.operatorId,
      required this.operatorName,
      required this.createdAt})
      : super._();
  @override
  AdminVehicleImageListDtoOutputItemsInner rebuild(
          void Function(AdminVehicleImageListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleImageListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminVehicleImageListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleImageListDtoOutputItemsInner &&
        id == other.id &&
        url == other.url &&
        caption == other.caption &&
        position == other.position &&
        isCover == other.isCover &&
        vehicleId == other.vehicleId &&
        plateNumber == other.plateNumber &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, isCover.hashCode);
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, plateNumber.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminVehicleImageListDtoOutputItemsInner')
          ..add('id', id)
          ..add('url', url)
          ..add('caption', caption)
          ..add('position', position)
          ..add('isCover', isCover)
          ..add('vehicleId', vehicleId)
          ..add('plateNumber', plateNumber)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminVehicleImageListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminVehicleImageListDtoOutputItemsInner,
            AdminVehicleImageListDtoOutputItemsInnerBuilder> {
  _$AdminVehicleImageListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  bool? _isCover;
  bool? get isCover => _$this._isCover;
  set isCover(bool? isCover) => _$this._isCover = isCover;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  String? _plateNumber;
  String? get plateNumber => _$this._plateNumber;
  set plateNumber(String? plateNumber) => _$this._plateNumber = plateNumber;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminVehicleImageListDtoOutputItemsInnerBuilder() {
    AdminVehicleImageListDtoOutputItemsInner._defaults(this);
  }

  AdminVehicleImageListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _caption = $v.caption;
      _position = $v.position;
      _isCover = $v.isCover;
      _vehicleId = $v.vehicleId;
      _plateNumber = $v.plateNumber;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleImageListDtoOutputItemsInner other) {
    _$v = other as _$AdminVehicleImageListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminVehicleImageListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleImageListDtoOutputItemsInner build() => _build();

  _$AdminVehicleImageListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminVehicleImageListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminVehicleImageListDtoOutputItemsInner', 'id'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'AdminVehicleImageListDtoOutputItemsInner', 'url'),
          caption: caption,
          position: BuiltValueNullFieldError.checkNotNull(position,
              r'AdminVehicleImageListDtoOutputItemsInner', 'position'),
          isCover: BuiltValueNullFieldError.checkNotNull(
              isCover, r'AdminVehicleImageListDtoOutputItemsInner', 'isCover'),
          vehicleId: BuiltValueNullFieldError.checkNotNull(vehicleId,
              r'AdminVehicleImageListDtoOutputItemsInner', 'vehicleId'),
          plateNumber: BuiltValueNullFieldError.checkNotNull(plateNumber,
              r'AdminVehicleImageListDtoOutputItemsInner', 'plateNumber'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'AdminVehicleImageListDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminVehicleImageListDtoOutputItemsInner', 'operatorName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminVehicleImageListDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
