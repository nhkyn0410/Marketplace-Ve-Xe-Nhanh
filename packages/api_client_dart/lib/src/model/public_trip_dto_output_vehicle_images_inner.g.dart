// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_vehicle_images_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutputVehicleImagesInner
    extends PublicTripDtoOutputVehicleImagesInner {
  @override
  final String url;
  @override
  final String? caption;

  factory _$PublicTripDtoOutputVehicleImagesInner(
          [void Function(PublicTripDtoOutputVehicleImagesInnerBuilder)?
              updates]) =>
      (PublicTripDtoOutputVehicleImagesInnerBuilder()..update(updates))
          ._build();

  _$PublicTripDtoOutputVehicleImagesInner._({required this.url, this.caption})
      : super._();
  @override
  PublicTripDtoOutputVehicleImagesInner rebuild(
          void Function(PublicTripDtoOutputVehicleImagesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputVehicleImagesInnerBuilder toBuilder() =>
      PublicTripDtoOutputVehicleImagesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputVehicleImagesInner &&
        url == other.url &&
        caption == other.caption;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicTripDtoOutputVehicleImagesInner')
          ..add('url', url)
          ..add('caption', caption))
        .toString();
  }
}

class PublicTripDtoOutputVehicleImagesInnerBuilder
    implements
        Builder<PublicTripDtoOutputVehicleImagesInner,
            PublicTripDtoOutputVehicleImagesInnerBuilder> {
  _$PublicTripDtoOutputVehicleImagesInner? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  PublicTripDtoOutputVehicleImagesInnerBuilder() {
    PublicTripDtoOutputVehicleImagesInner._defaults(this);
  }

  PublicTripDtoOutputVehicleImagesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _caption = $v.caption;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputVehicleImagesInner other) {
    _$v = other as _$PublicTripDtoOutputVehicleImagesInner;
  }

  @override
  void update(
      void Function(PublicTripDtoOutputVehicleImagesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputVehicleImagesInner build() => _build();

  _$PublicTripDtoOutputVehicleImagesInner _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputVehicleImagesInner._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'PublicTripDtoOutputVehicleImagesInner', 'url'),
          caption: caption,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
