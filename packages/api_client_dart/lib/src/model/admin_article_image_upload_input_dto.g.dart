// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_image_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminArticleImageUploadInputDtoContentTypeEnum
    _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const AdminArticleImageUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const AdminArticleImageUploadInputDtoContentTypeEnum
    _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashPng =
    const AdminArticleImageUploadInputDtoContentTypeEnum._('imageSlashPng');
const AdminArticleImageUploadInputDtoContentTypeEnum
    _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashWebp =
    const AdminArticleImageUploadInputDtoContentTypeEnum._('imageSlashWebp');

AdminArticleImageUploadInputDtoContentTypeEnum
    _$adminArticleImageUploadInputDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminArticleImageUploadInputDtoContentTypeEnum>
    _$adminArticleImageUploadInputDtoContentTypeEnumValues = BuiltSet<
        AdminArticleImageUploadInputDtoContentTypeEnum>(const <AdminArticleImageUploadInputDtoContentTypeEnum>[
  _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashPng,
  _$adminArticleImageUploadInputDtoContentTypeEnum_imageSlashWebp,
]);

Serializer<AdminArticleImageUploadInputDtoContentTypeEnum>
    _$adminArticleImageUploadInputDtoContentTypeEnumSerializer =
    _$AdminArticleImageUploadInputDtoContentTypeEnumSerializer();

class _$AdminArticleImageUploadInputDtoContentTypeEnumSerializer
    implements
        PrimitiveSerializer<AdminArticleImageUploadInputDtoContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'imageSlashWebp': 'image/webp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'image/webp': 'imageSlashWebp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminArticleImageUploadInputDtoContentTypeEnum
  ];
  @override
  final String wireName = 'AdminArticleImageUploadInputDtoContentTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminArticleImageUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminArticleImageUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminArticleImageUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminArticleImageUploadInputDto
    extends AdminArticleImageUploadInputDto {
  @override
  final AdminArticleImageUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$AdminArticleImageUploadInputDto(
          [void Function(AdminArticleImageUploadInputDtoBuilder)? updates]) =>
      (AdminArticleImageUploadInputDtoBuilder()..update(updates))._build();

  _$AdminArticleImageUploadInputDto._(
      {required this.contentType, required this.sizeBytes})
      : super._();
  @override
  AdminArticleImageUploadInputDto rebuild(
          void Function(AdminArticleImageUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleImageUploadInputDtoBuilder toBuilder() =>
      AdminArticleImageUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleImageUploadInputDto &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticleImageUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class AdminArticleImageUploadInputDtoBuilder
    implements
        Builder<AdminArticleImageUploadInputDto,
            AdminArticleImageUploadInputDtoBuilder> {
  _$AdminArticleImageUploadInputDto? _$v;

  AdminArticleImageUploadInputDtoContentTypeEnum? _contentType;
  AdminArticleImageUploadInputDtoContentTypeEnum? get contentType =>
      _$this._contentType;
  set contentType(
          AdminArticleImageUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  AdminArticleImageUploadInputDtoBuilder() {
    AdminArticleImageUploadInputDto._defaults(this);
  }

  AdminArticleImageUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleImageUploadInputDto other) {
    _$v = other as _$AdminArticleImageUploadInputDto;
  }

  @override
  void update(void Function(AdminArticleImageUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleImageUploadInputDto build() => _build();

  _$AdminArticleImageUploadInputDto _build() {
    final _$result = _$v ??
        _$AdminArticleImageUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'AdminArticleImageUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'AdminArticleImageUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
