// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_generate_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripScheduleGenerateInputDto extends TripScheduleGenerateInputDto {
  @override
  final bool openForSale;

  factory _$TripScheduleGenerateInputDto(
          [void Function(TripScheduleGenerateInputDtoBuilder)? updates]) =>
      (TripScheduleGenerateInputDtoBuilder()..update(updates))._build();

  _$TripScheduleGenerateInputDto._({required this.openForSale}) : super._();
  @override
  TripScheduleGenerateInputDto rebuild(
          void Function(TripScheduleGenerateInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleGenerateInputDtoBuilder toBuilder() =>
      TripScheduleGenerateInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleGenerateInputDto &&
        openForSale == other.openForSale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, openForSale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripScheduleGenerateInputDto')
          ..add('openForSale', openForSale))
        .toString();
  }
}

class TripScheduleGenerateInputDtoBuilder
    implements
        Builder<TripScheduleGenerateInputDto,
            TripScheduleGenerateInputDtoBuilder> {
  _$TripScheduleGenerateInputDto? _$v;

  bool? _openForSale;
  bool? get openForSale => _$this._openForSale;
  set openForSale(bool? openForSale) => _$this._openForSale = openForSale;

  TripScheduleGenerateInputDtoBuilder() {
    TripScheduleGenerateInputDto._defaults(this);
  }

  TripScheduleGenerateInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _openForSale = $v.openForSale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleGenerateInputDto other) {
    _$v = other as _$TripScheduleGenerateInputDto;
  }

  @override
  void update(void Function(TripScheduleGenerateInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleGenerateInputDto build() => _build();

  _$TripScheduleGenerateInputDto _build() {
    final _$result = _$v ??
        _$TripScheduleGenerateInputDto._(
          openForSale: BuiltValueNullFieldError.checkNotNull(
              openForSale, r'TripScheduleGenerateInputDto', 'openForSale'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
