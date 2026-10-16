// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_generate_response_dto_output_skipped_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_EXISTS =
    const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum._(
        'EXISTS');
const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_PAST =
    const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum._('PAST');
const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_VEHICLE_CONFLICT =
    const TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum._(
        'VEHICLE_CONFLICT');

TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumValueOf(
        String name) {
  switch (name) {
    case 'EXISTS':
      return _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_EXISTS;
    case 'PAST':
      return _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_PAST;
    case 'VEHICLE_CONFLICT':
      return _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_VEHICLE_CONFLICT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum>
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumValues =
    BuiltSet<
        TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum>(const <TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum>[
  _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_EXISTS,
  _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_PAST,
  _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum_VEHICLE_CONFLICT,
]);

Serializer<TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum>
    _$tripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumSerializer =
    _$TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumSerializer();

class _$TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnumSerializer
    implements
        PrimitiveSerializer<
            TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EXISTS': 'EXISTS',
    'PAST': 'PAST',
    'VEHICLE_CONFLICT': 'VEHICLE_CONFLICT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EXISTS': 'EXISTS',
    'PAST': 'PAST',
    'VEHICLE_CONFLICT': 'VEHICLE_CONFLICT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum
  ];
  @override
  final String wireName =
      'TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum';

  @override
  Object serialize(Serializers serializers,
          TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripScheduleGenerateResponseDtoOutputSkippedInner
    extends TripScheduleGenerateResponseDtoOutputSkippedInner {
  @override
  final Date serviceDate;
  @override
  final TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum reason;

  factory _$TripScheduleGenerateResponseDtoOutputSkippedInner(
          [void Function(
                  TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder)?
              updates]) =>
      (TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder()
            ..update(updates))
          ._build();

  _$TripScheduleGenerateResponseDtoOutputSkippedInner._(
      {required this.serviceDate, required this.reason})
      : super._();
  @override
  TripScheduleGenerateResponseDtoOutputSkippedInner rebuild(
          void Function(
                  TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder toBuilder() =>
      TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleGenerateResponseDtoOutputSkippedInner &&
        serviceDate == other.serviceDate &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, serviceDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripScheduleGenerateResponseDtoOutputSkippedInner')
          ..add('serviceDate', serviceDate)
          ..add('reason', reason))
        .toString();
  }
}

class TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder
    implements
        Builder<TripScheduleGenerateResponseDtoOutputSkippedInner,
            TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder> {
  _$TripScheduleGenerateResponseDtoOutputSkippedInner? _$v;

  Date? _serviceDate;
  Date? get serviceDate => _$this._serviceDate;
  set serviceDate(Date? serviceDate) => _$this._serviceDate = serviceDate;

  TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum? _reason;
  TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum? get reason =>
      _$this._reason;
  set reason(
          TripScheduleGenerateResponseDtoOutputSkippedInnerReasonEnum?
              reason) =>
      _$this._reason = reason;

  TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder() {
    TripScheduleGenerateResponseDtoOutputSkippedInner._defaults(this);
  }

  TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _serviceDate = $v.serviceDate;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleGenerateResponseDtoOutputSkippedInner other) {
    _$v = other as _$TripScheduleGenerateResponseDtoOutputSkippedInner;
  }

  @override
  void update(
      void Function(TripScheduleGenerateResponseDtoOutputSkippedInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleGenerateResponseDtoOutputSkippedInner build() => _build();

  _$TripScheduleGenerateResponseDtoOutputSkippedInner _build() {
    final _$result = _$v ??
        _$TripScheduleGenerateResponseDtoOutputSkippedInner._(
          serviceDate: BuiltValueNullFieldError.checkNotNull(
              serviceDate,
              r'TripScheduleGenerateResponseDtoOutputSkippedInner',
              'serviceDate'),
          reason: BuiltValueNullFieldError.checkNotNull(reason,
              r'TripScheduleGenerateResponseDtoOutputSkippedInner', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
