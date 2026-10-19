// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_generate_response_dto_output_created_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum
    _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_DRAFT =
    const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum._(
        'DRAFT');
const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum
    _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_OPEN_FOR_SALE =
    const TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum._(
        'OPEN_FOR_SALE');

TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum
    _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'DRAFT':
      return _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_DRAFT;
    case 'OPEN_FOR_SALE':
      return _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_OPEN_FOR_SALE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum>
    _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumValues =
    BuiltSet<
        TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum>(const <TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum>[
  _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_DRAFT,
  _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum_OPEN_FOR_SALE,
]);

Serializer<TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum>
    _$tripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumSerializer =
    _$TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumSerializer();

class _$TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum
  ];
  @override
  final String wireName =
      'TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripScheduleGenerateResponseDtoOutputCreatedInner
    extends TripScheduleGenerateResponseDtoOutputCreatedInner {
  @override
  final String tripId;
  @override
  final Date serviceDate;
  @override
  final DateTime departureAt;
  @override
  final TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum status;
  @override
  final BuiltList<String> notOpenedReasons;

  factory _$TripScheduleGenerateResponseDtoOutputCreatedInner(
          [void Function(
                  TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder)?
              updates]) =>
      (TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder()
            ..update(updates))
          ._build();

  _$TripScheduleGenerateResponseDtoOutputCreatedInner._(
      {required this.tripId,
      required this.serviceDate,
      required this.departureAt,
      required this.status,
      required this.notOpenedReasons})
      : super._();
  @override
  TripScheduleGenerateResponseDtoOutputCreatedInner rebuild(
          void Function(
                  TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder toBuilder() =>
      TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleGenerateResponseDtoOutputCreatedInner &&
        tripId == other.tripId &&
        serviceDate == other.serviceDate &&
        departureAt == other.departureAt &&
        status == other.status &&
        notOpenedReasons == other.notOpenedReasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, serviceDate.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, notOpenedReasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripScheduleGenerateResponseDtoOutputCreatedInner')
          ..add('tripId', tripId)
          ..add('serviceDate', serviceDate)
          ..add('departureAt', departureAt)
          ..add('status', status)
          ..add('notOpenedReasons', notOpenedReasons))
        .toString();
  }
}

class TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder
    implements
        Builder<TripScheduleGenerateResponseDtoOutputCreatedInner,
            TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder> {
  _$TripScheduleGenerateResponseDtoOutputCreatedInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  Date? _serviceDate;
  Date? get serviceDate => _$this._serviceDate;
  set serviceDate(Date? serviceDate) => _$this._serviceDate = serviceDate;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum? _status;
  TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum? get status =>
      _$this._status;
  set status(
          TripScheduleGenerateResponseDtoOutputCreatedInnerStatusEnum?
              status) =>
      _$this._status = status;

  ListBuilder<String>? _notOpenedReasons;
  ListBuilder<String> get notOpenedReasons =>
      _$this._notOpenedReasons ??= ListBuilder<String>();
  set notOpenedReasons(ListBuilder<String>? notOpenedReasons) =>
      _$this._notOpenedReasons = notOpenedReasons;

  TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder() {
    TripScheduleGenerateResponseDtoOutputCreatedInner._defaults(this);
  }

  TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _serviceDate = $v.serviceDate;
      _departureAt = $v.departureAt;
      _status = $v.status;
      _notOpenedReasons = $v.notOpenedReasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleGenerateResponseDtoOutputCreatedInner other) {
    _$v = other as _$TripScheduleGenerateResponseDtoOutputCreatedInner;
  }

  @override
  void update(
      void Function(TripScheduleGenerateResponseDtoOutputCreatedInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleGenerateResponseDtoOutputCreatedInner build() => _build();

  _$TripScheduleGenerateResponseDtoOutputCreatedInner _build() {
    _$TripScheduleGenerateResponseDtoOutputCreatedInner _$result;
    try {
      _$result = _$v ??
          _$TripScheduleGenerateResponseDtoOutputCreatedInner._(
            tripId: BuiltValueNullFieldError.checkNotNull(tripId,
                r'TripScheduleGenerateResponseDtoOutputCreatedInner', 'tripId'),
            serviceDate: BuiltValueNullFieldError.checkNotNull(
                serviceDate,
                r'TripScheduleGenerateResponseDtoOutputCreatedInner',
                'serviceDate'),
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt,
                r'TripScheduleGenerateResponseDtoOutputCreatedInner',
                'departureAt'),
            status: BuiltValueNullFieldError.checkNotNull(status,
                r'TripScheduleGenerateResponseDtoOutputCreatedInner', 'status'),
            notOpenedReasons: notOpenedReasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notOpenedReasons';
        notOpenedReasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripScheduleGenerateResponseDtoOutputCreatedInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
