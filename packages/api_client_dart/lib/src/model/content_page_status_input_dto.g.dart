// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_status_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContentPageStatusInputDtoStatusEnum
    _$contentPageStatusInputDtoStatusEnum_DRAFT =
    const ContentPageStatusInputDtoStatusEnum._('DRAFT');
const ContentPageStatusInputDtoStatusEnum
    _$contentPageStatusInputDtoStatusEnum_PUBLISHED =
    const ContentPageStatusInputDtoStatusEnum._('PUBLISHED');

ContentPageStatusInputDtoStatusEnum
    _$contentPageStatusInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$contentPageStatusInputDtoStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$contentPageStatusInputDtoStatusEnum_PUBLISHED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageStatusInputDtoStatusEnum>
    _$contentPageStatusInputDtoStatusEnumValues = BuiltSet<
        ContentPageStatusInputDtoStatusEnum>(const <ContentPageStatusInputDtoStatusEnum>[
  _$contentPageStatusInputDtoStatusEnum_DRAFT,
  _$contentPageStatusInputDtoStatusEnum_PUBLISHED,
]);

Serializer<ContentPageStatusInputDtoStatusEnum>
    _$contentPageStatusInputDtoStatusEnumSerializer =
    _$ContentPageStatusInputDtoStatusEnumSerializer();

class _$ContentPageStatusInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<ContentPageStatusInputDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ContentPageStatusInputDtoStatusEnum
  ];
  @override
  final String wireName = 'ContentPageStatusInputDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ContentPageStatusInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageStatusInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageStatusInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageStatusInputDto extends ContentPageStatusInputDto {
  @override
  final ContentPageStatusInputDtoStatusEnum status;

  factory _$ContentPageStatusInputDto(
          [void Function(ContentPageStatusInputDtoBuilder)? updates]) =>
      (ContentPageStatusInputDtoBuilder()..update(updates))._build();

  _$ContentPageStatusInputDto._({required this.status}) : super._();
  @override
  ContentPageStatusInputDto rebuild(
          void Function(ContentPageStatusInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentPageStatusInputDtoBuilder toBuilder() =>
      ContentPageStatusInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentPageStatusInputDto && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentPageStatusInputDto')
          ..add('status', status))
        .toString();
  }
}

class ContentPageStatusInputDtoBuilder
    implements
        Builder<ContentPageStatusInputDto, ContentPageStatusInputDtoBuilder> {
  _$ContentPageStatusInputDto? _$v;

  ContentPageStatusInputDtoStatusEnum? _status;
  ContentPageStatusInputDtoStatusEnum? get status => _$this._status;
  set status(ContentPageStatusInputDtoStatusEnum? status) =>
      _$this._status = status;

  ContentPageStatusInputDtoBuilder() {
    ContentPageStatusInputDto._defaults(this);
  }

  ContentPageStatusInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentPageStatusInputDto other) {
    _$v = other as _$ContentPageStatusInputDto;
  }

  @override
  void update(void Function(ContentPageStatusInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentPageStatusInputDto build() => _build();

  _$ContentPageStatusInputDto _build() {
    final _$result = _$v ??
        _$ContentPageStatusInputDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ContentPageStatusInputDto', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
