// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_create_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApplicationCreateInputDtoAcceptTermsEnum
    _$applicationCreateInputDtoAcceptTermsEnum_true_ =
    const ApplicationCreateInputDtoAcceptTermsEnum._('true_');

ApplicationCreateInputDtoAcceptTermsEnum
    _$applicationCreateInputDtoAcceptTermsEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$applicationCreateInputDtoAcceptTermsEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApplicationCreateInputDtoAcceptTermsEnum>
    _$applicationCreateInputDtoAcceptTermsEnumValues = BuiltSet<
        ApplicationCreateInputDtoAcceptTermsEnum>(const <ApplicationCreateInputDtoAcceptTermsEnum>[
  _$applicationCreateInputDtoAcceptTermsEnum_true_,
]);

Serializer<ApplicationCreateInputDtoAcceptTermsEnum>
    _$applicationCreateInputDtoAcceptTermsEnumSerializer =
    _$ApplicationCreateInputDtoAcceptTermsEnumSerializer();

class _$ApplicationCreateInputDtoAcceptTermsEnumSerializer
    implements PrimitiveSerializer<ApplicationCreateInputDtoAcceptTermsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApplicationCreateInputDtoAcceptTermsEnum
  ];
  @override
  final String wireName = 'ApplicationCreateInputDtoAcceptTermsEnum';

  @override
  Object serialize(Serializers serializers,
          ApplicationCreateInputDtoAcceptTermsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplicationCreateInputDtoAcceptTermsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplicationCreateInputDtoAcceptTermsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApplicationCreateInputDto extends ApplicationCreateInputDto {
  @override
  final String operatorName;
  @override
  final String contactName;
  @override
  final String contactEmail;
  @override
  final ApplicationCreateInputDtoAcceptTermsEnum acceptTerms;

  factory _$ApplicationCreateInputDto(
          [void Function(ApplicationCreateInputDtoBuilder)? updates]) =>
      (ApplicationCreateInputDtoBuilder()..update(updates))._build();

  _$ApplicationCreateInputDto._(
      {required this.operatorName,
      required this.contactName,
      required this.contactEmail,
      required this.acceptTerms})
      : super._();
  @override
  ApplicationCreateInputDto rebuild(
          void Function(ApplicationCreateInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationCreateInputDtoBuilder toBuilder() =>
      ApplicationCreateInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationCreateInputDto &&
        operatorName == other.operatorName &&
        contactName == other.contactName &&
        contactEmail == other.contactEmail &&
        acceptTerms == other.acceptTerms;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, acceptTerms.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApplicationCreateInputDto')
          ..add('operatorName', operatorName)
          ..add('contactName', contactName)
          ..add('contactEmail', contactEmail)
          ..add('acceptTerms', acceptTerms))
        .toString();
  }
}

class ApplicationCreateInputDtoBuilder
    implements
        Builder<ApplicationCreateInputDto, ApplicationCreateInputDtoBuilder> {
  _$ApplicationCreateInputDto? _$v;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  ApplicationCreateInputDtoAcceptTermsEnum? _acceptTerms;
  ApplicationCreateInputDtoAcceptTermsEnum? get acceptTerms =>
      _$this._acceptTerms;
  set acceptTerms(ApplicationCreateInputDtoAcceptTermsEnum? acceptTerms) =>
      _$this._acceptTerms = acceptTerms;

  ApplicationCreateInputDtoBuilder() {
    ApplicationCreateInputDto._defaults(this);
  }

  ApplicationCreateInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorName = $v.operatorName;
      _contactName = $v.contactName;
      _contactEmail = $v.contactEmail;
      _acceptTerms = $v.acceptTerms;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationCreateInputDto other) {
    _$v = other as _$ApplicationCreateInputDto;
  }

  @override
  void update(void Function(ApplicationCreateInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationCreateInputDto build() => _build();

  _$ApplicationCreateInputDto _build() {
    final _$result = _$v ??
        _$ApplicationCreateInputDto._(
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName, r'ApplicationCreateInputDto', 'operatorName'),
          contactName: BuiltValueNullFieldError.checkNotNull(
              contactName, r'ApplicationCreateInputDto', 'contactName'),
          contactEmail: BuiltValueNullFieldError.checkNotNull(
              contactEmail, r'ApplicationCreateInputDto', 'contactEmail'),
          acceptTerms: BuiltValueNullFieldError.checkNotNull(
              acceptTerms, r'ApplicationCreateInputDto', 'acceptTerms'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
