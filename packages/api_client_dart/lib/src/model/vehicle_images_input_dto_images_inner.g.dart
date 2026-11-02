// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_images_input_dto_images_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VehicleImagesInputDtoImagesInner
    extends VehicleImagesInputDtoImagesInner {
  @override
  final String objectKey;
  @override
  final String? caption;

  factory _$VehicleImagesInputDtoImagesInner(
          [void Function(VehicleImagesInputDtoImagesInnerBuilder)? updates]) =>
      (VehicleImagesInputDtoImagesInnerBuilder()..update(updates))._build();

  _$VehicleImagesInputDtoImagesInner._({required this.objectKey, this.caption})
      : super._();
  @override
  VehicleImagesInputDtoImagesInner rebuild(
          void Function(VehicleImagesInputDtoImagesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleImagesInputDtoImagesInnerBuilder toBuilder() =>
      VehicleImagesInputDtoImagesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleImagesInputDtoImagesInner &&
        objectKey == other.objectKey &&
        caption == other.caption;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VehicleImagesInputDtoImagesInner')
          ..add('objectKey', objectKey)
          ..add('caption', caption))
        .toString();
  }
}

class VehicleImagesInputDtoImagesInnerBuilder
    implements
        Builder<VehicleImagesInputDtoImagesInner,
            VehicleImagesInputDtoImagesInnerBuilder> {
  _$VehicleImagesInputDtoImagesInner? _$v;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  VehicleImagesInputDtoImagesInnerBuilder() {
    VehicleImagesInputDtoImagesInner._defaults(this);
  }

  VehicleImagesInputDtoImagesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _objectKey = $v.objectKey;
      _caption = $v.caption;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleImagesInputDtoImagesInner other) {
    _$v = other as _$VehicleImagesInputDtoImagesInner;
  }

  @override
  void update(void Function(VehicleImagesInputDtoImagesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleImagesInputDtoImagesInner build() => _build();

  _$VehicleImagesInputDtoImagesInner _build() {
    final _$result = _$v ??
        _$VehicleImagesInputDtoImagesInner._(
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'VehicleImagesInputDtoImagesInner', 'objectKey'),
          caption: caption,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
