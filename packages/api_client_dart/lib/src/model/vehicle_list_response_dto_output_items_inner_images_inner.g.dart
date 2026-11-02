// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_list_response_dto_output_items_inner_images_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VehicleListResponseDtoOutputItemsInnerImagesInner
    extends VehicleListResponseDtoOutputItemsInnerImagesInner {
  @override
  final String id;
  @override
  final String objectKey;
  @override
  final String url;
  @override
  final int position;
  @override
  final String? caption;

  factory _$VehicleListResponseDtoOutputItemsInnerImagesInner(
          [void Function(
                  VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder)?
              updates]) =>
      (VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder()
            ..update(updates))
          ._build();

  _$VehicleListResponseDtoOutputItemsInnerImagesInner._(
      {required this.id,
      required this.objectKey,
      required this.url,
      required this.position,
      this.caption})
      : super._();
  @override
  VehicleListResponseDtoOutputItemsInnerImagesInner rebuild(
          void Function(
                  VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder toBuilder() =>
      VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleListResponseDtoOutputItemsInnerImagesInner &&
        id == other.id &&
        objectKey == other.objectKey &&
        url == other.url &&
        position == other.position &&
        caption == other.caption;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VehicleListResponseDtoOutputItemsInnerImagesInner')
          ..add('id', id)
          ..add('objectKey', objectKey)
          ..add('url', url)
          ..add('position', position)
          ..add('caption', caption))
        .toString();
  }
}

class VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder
    implements
        Builder<VehicleListResponseDtoOutputItemsInnerImagesInner,
            VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder> {
  _$VehicleListResponseDtoOutputItemsInnerImagesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder() {
    VehicleListResponseDtoOutputItemsInnerImagesInner._defaults(this);
  }

  VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _objectKey = $v.objectKey;
      _url = $v.url;
      _position = $v.position;
      _caption = $v.caption;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleListResponseDtoOutputItemsInnerImagesInner other) {
    _$v = other as _$VehicleListResponseDtoOutputItemsInnerImagesInner;
  }

  @override
  void update(
      void Function(VehicleListResponseDtoOutputItemsInnerImagesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleListResponseDtoOutputItemsInnerImagesInner build() => _build();

  _$VehicleListResponseDtoOutputItemsInnerImagesInner _build() {
    final _$result = _$v ??
        _$VehicleListResponseDtoOutputItemsInnerImagesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VehicleListResponseDtoOutputItemsInnerImagesInner', 'id'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey,
              r'VehicleListResponseDtoOutputItemsInnerImagesInner',
              'objectKey'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'VehicleListResponseDtoOutputItemsInnerImagesInner', 'url'),
          position: BuiltValueNullFieldError.checkNotNull(position,
              r'VehicleListResponseDtoOutputItemsInnerImagesInner', 'position'),
          caption: caption,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
