// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_images_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VehicleImagesInputDto extends VehicleImagesInputDto {
  @override
  final BuiltList<VehicleImagesInputDtoImagesInner> images;

  factory _$VehicleImagesInputDto(
          [void Function(VehicleImagesInputDtoBuilder)? updates]) =>
      (VehicleImagesInputDtoBuilder()..update(updates))._build();

  _$VehicleImagesInputDto._({required this.images}) : super._();
  @override
  VehicleImagesInputDto rebuild(
          void Function(VehicleImagesInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleImagesInputDtoBuilder toBuilder() =>
      VehicleImagesInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleImagesInputDto && images == other.images;
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
    return (newBuiltValueToStringHelper(r'VehicleImagesInputDto')
          ..add('images', images))
        .toString();
  }
}

class VehicleImagesInputDtoBuilder
    implements Builder<VehicleImagesInputDto, VehicleImagesInputDtoBuilder> {
  _$VehicleImagesInputDto? _$v;

  ListBuilder<VehicleImagesInputDtoImagesInner>? _images;
  ListBuilder<VehicleImagesInputDtoImagesInner> get images =>
      _$this._images ??= ListBuilder<VehicleImagesInputDtoImagesInner>();
  set images(ListBuilder<VehicleImagesInputDtoImagesInner>? images) =>
      _$this._images = images;

  VehicleImagesInputDtoBuilder() {
    VehicleImagesInputDto._defaults(this);
  }

  VehicleImagesInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _images = $v.images.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleImagesInputDto other) {
    _$v = other as _$VehicleImagesInputDto;
  }

  @override
  void update(void Function(VehicleImagesInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleImagesInputDto build() => _build();

  _$VehicleImagesInputDto _build() {
    _$VehicleImagesInputDto _$result;
    try {
      _$result = _$v ??
          _$VehicleImagesInputDto._(
            images: images.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'images';
        images.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VehicleImagesInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
