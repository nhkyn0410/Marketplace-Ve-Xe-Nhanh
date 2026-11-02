// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_images_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VehicleImagesResponseDtoOutput extends VehicleImagesResponseDtoOutput {
  @override
  final BuiltList<VehicleListResponseDtoOutputItemsInnerImagesInner> images;

  factory _$VehicleImagesResponseDtoOutput(
          [void Function(VehicleImagesResponseDtoOutputBuilder)? updates]) =>
      (VehicleImagesResponseDtoOutputBuilder()..update(updates))._build();

  _$VehicleImagesResponseDtoOutput._({required this.images}) : super._();
  @override
  VehicleImagesResponseDtoOutput rebuild(
          void Function(VehicleImagesResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleImagesResponseDtoOutputBuilder toBuilder() =>
      VehicleImagesResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleImagesResponseDtoOutput && images == other.images;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VehicleImagesResponseDtoOutput')
          ..add('images', images))
        .toString();
  }
}

class VehicleImagesResponseDtoOutputBuilder
    implements
        Builder<VehicleImagesResponseDtoOutput,
            VehicleImagesResponseDtoOutputBuilder> {
  _$VehicleImagesResponseDtoOutput? _$v;

  ListBuilder<VehicleListResponseDtoOutputItemsInnerImagesInner>? _images;
  ListBuilder<VehicleListResponseDtoOutputItemsInnerImagesInner> get images =>
      _$this._images ??=
          ListBuilder<VehicleListResponseDtoOutputItemsInnerImagesInner>();
  set images(
          ListBuilder<VehicleListResponseDtoOutputItemsInnerImagesInner>?
              images) =>
      _$this._images = images;

  VehicleImagesResponseDtoOutputBuilder() {
    VehicleImagesResponseDtoOutput._defaults(this);
  }

  VehicleImagesResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _images = $v.images.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleImagesResponseDtoOutput other) {
    _$v = other as _$VehicleImagesResponseDtoOutput;
  }

  @override
  void update(void Function(VehicleImagesResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleImagesResponseDtoOutput build() => _build();

  _$VehicleImagesResponseDtoOutput _build() {
    _$VehicleImagesResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$VehicleImagesResponseDtoOutput._(
            images: images.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'images';
        images.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VehicleImagesResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
