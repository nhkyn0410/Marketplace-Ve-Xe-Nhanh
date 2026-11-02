// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PromotionDtoOutputScopeEnum _$promotionDtoOutputScopeEnum_PLATFORM =
    const PromotionDtoOutputScopeEnum._('PLATFORM');
const PromotionDtoOutputScopeEnum _$promotionDtoOutputScopeEnum_OPERATOR =
    const PromotionDtoOutputScopeEnum._('OPERATOR');

PromotionDtoOutputScopeEnum _$promotionDtoOutputScopeEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM':
      return _$promotionDtoOutputScopeEnum_PLATFORM;
    case 'OPERATOR':
      return _$promotionDtoOutputScopeEnum_OPERATOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionDtoOutputScopeEnum>
    _$promotionDtoOutputScopeEnumValues =
    BuiltSet<PromotionDtoOutputScopeEnum>(const <PromotionDtoOutputScopeEnum>[
  _$promotionDtoOutputScopeEnum_PLATFORM,
  _$promotionDtoOutputScopeEnum_OPERATOR,
]);

const PromotionDtoOutputDiscountTypeEnum
    _$promotionDtoOutputDiscountTypeEnum_PERCENT =
    const PromotionDtoOutputDiscountTypeEnum._('PERCENT');
const PromotionDtoOutputDiscountTypeEnum
    _$promotionDtoOutputDiscountTypeEnum_AMOUNT =
    const PromotionDtoOutputDiscountTypeEnum._('AMOUNT');

PromotionDtoOutputDiscountTypeEnum _$promotionDtoOutputDiscountTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'PERCENT':
      return _$promotionDtoOutputDiscountTypeEnum_PERCENT;
    case 'AMOUNT':
      return _$promotionDtoOutputDiscountTypeEnum_AMOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionDtoOutputDiscountTypeEnum>
    _$promotionDtoOutputDiscountTypeEnumValues = BuiltSet<
        PromotionDtoOutputDiscountTypeEnum>(const <PromotionDtoOutputDiscountTypeEnum>[
  _$promotionDtoOutputDiscountTypeEnum_PERCENT,
  _$promotionDtoOutputDiscountTypeEnum_AMOUNT,
]);

const PromotionDtoOutputStatusEnum _$promotionDtoOutputStatusEnum_DRAFT =
    const PromotionDtoOutputStatusEnum._('DRAFT');
const PromotionDtoOutputStatusEnum _$promotionDtoOutputStatusEnum_ACTIVE =
    const PromotionDtoOutputStatusEnum._('ACTIVE');
const PromotionDtoOutputStatusEnum _$promotionDtoOutputStatusEnum_PAUSED =
    const PromotionDtoOutputStatusEnum._('PAUSED');
const PromotionDtoOutputStatusEnum _$promotionDtoOutputStatusEnum_ENDED =
    const PromotionDtoOutputStatusEnum._('ENDED');

PromotionDtoOutputStatusEnum _$promotionDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$promotionDtoOutputStatusEnum_DRAFT;
    case 'ACTIVE':
      return _$promotionDtoOutputStatusEnum_ACTIVE;
    case 'PAUSED':
      return _$promotionDtoOutputStatusEnum_PAUSED;
    case 'ENDED':
      return _$promotionDtoOutputStatusEnum_ENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionDtoOutputStatusEnum>
    _$promotionDtoOutputStatusEnumValues =
    BuiltSet<PromotionDtoOutputStatusEnum>(const <PromotionDtoOutputStatusEnum>[
  _$promotionDtoOutputStatusEnum_DRAFT,
  _$promotionDtoOutputStatusEnum_ACTIVE,
  _$promotionDtoOutputStatusEnum_PAUSED,
  _$promotionDtoOutputStatusEnum_ENDED,
]);

const PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnum_DRAFT =
    const PromotionDtoOutputDisplayEnum._('DRAFT');
const PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnum_SCHEDULED =
    const PromotionDtoOutputDisplayEnum._('SCHEDULED');
const PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnum_RUNNING =
    const PromotionDtoOutputDisplayEnum._('RUNNING');
const PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnum_PAUSED =
    const PromotionDtoOutputDisplayEnum._('PAUSED');
const PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnum_ENDED =
    const PromotionDtoOutputDisplayEnum._('ENDED');

PromotionDtoOutputDisplayEnum _$promotionDtoOutputDisplayEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$promotionDtoOutputDisplayEnum_DRAFT;
    case 'SCHEDULED':
      return _$promotionDtoOutputDisplayEnum_SCHEDULED;
    case 'RUNNING':
      return _$promotionDtoOutputDisplayEnum_RUNNING;
    case 'PAUSED':
      return _$promotionDtoOutputDisplayEnum_PAUSED;
    case 'ENDED':
      return _$promotionDtoOutputDisplayEnum_ENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PromotionDtoOutputDisplayEnum>
    _$promotionDtoOutputDisplayEnumValues = BuiltSet<
        PromotionDtoOutputDisplayEnum>(const <PromotionDtoOutputDisplayEnum>[
  _$promotionDtoOutputDisplayEnum_DRAFT,
  _$promotionDtoOutputDisplayEnum_SCHEDULED,
  _$promotionDtoOutputDisplayEnum_RUNNING,
  _$promotionDtoOutputDisplayEnum_PAUSED,
  _$promotionDtoOutputDisplayEnum_ENDED,
]);

Serializer<PromotionDtoOutputScopeEnum>
    _$promotionDtoOutputScopeEnumSerializer =
    _$PromotionDtoOutputScopeEnumSerializer();
Serializer<PromotionDtoOutputDiscountTypeEnum>
    _$promotionDtoOutputDiscountTypeEnumSerializer =
    _$PromotionDtoOutputDiscountTypeEnumSerializer();
Serializer<PromotionDtoOutputStatusEnum>
    _$promotionDtoOutputStatusEnumSerializer =
    _$PromotionDtoOutputStatusEnumSerializer();
Serializer<PromotionDtoOutputDisplayEnum>
    _$promotionDtoOutputDisplayEnumSerializer =
    _$PromotionDtoOutputDisplayEnumSerializer();

class _$PromotionDtoOutputScopeEnumSerializer
    implements PrimitiveSerializer<PromotionDtoOutputScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM': 'PLATFORM',
    'OPERATOR': 'OPERATOR',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionDtoOutputScopeEnum];
  @override
  final String wireName = 'PromotionDtoOutputScopeEnum';

  @override
  Object serialize(Serializers serializers, PromotionDtoOutputScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionDtoOutputScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionDtoOutputScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionDtoOutputDiscountTypeEnumSerializer
    implements PrimitiveSerializer<PromotionDtoOutputDiscountTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PERCENT': 'PERCENT',
    'AMOUNT': 'AMOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionDtoOutputDiscountTypeEnum];
  @override
  final String wireName = 'PromotionDtoOutputDiscountTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PromotionDtoOutputDiscountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionDtoOutputDiscountTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionDtoOutputDiscountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PromotionDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionDtoOutputStatusEnum];
  @override
  final String wireName = 'PromotionDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers, PromotionDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionDtoOutputDisplayEnumSerializer
    implements PrimitiveSerializer<PromotionDtoOutputDisplayEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'RUNNING': 'RUNNING',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'SCHEDULED': 'SCHEDULED',
    'RUNNING': 'RUNNING',
    'PAUSED': 'PAUSED',
    'ENDED': 'ENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[PromotionDtoOutputDisplayEnum];
  @override
  final String wireName = 'PromotionDtoOutputDisplayEnum';

  @override
  Object serialize(
          Serializers serializers, PromotionDtoOutputDisplayEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PromotionDtoOutputDisplayEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PromotionDtoOutputDisplayEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PromotionDtoOutput extends PromotionDtoOutput {
  @override
  final String promotionId;
  @override
  final String code;
  @override
  final String name;
  @override
  final PromotionDtoOutputScopeEnum scope;
  @override
  final String? operatorId;
  @override
  final String? operatorName;
  @override
  final PromotionDtoOutputDiscountTypeEnum discountType;
  @override
  final int discountValue;
  @override
  final int? maxDiscount;
  @override
  final int minOrder;
  @override
  final String? routeId;
  @override
  final BuiltList<String> routeIds;
  @override
  final BuiltList<String> routeNames;
  @override
  final String? routeName;
  @override
  final String? tripId;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final int usageLimit;
  @override
  final int usedCount;
  @override
  final PromotionDtoOutputStatusEnum status;
  @override
  final PromotionDtoOutputDisplayEnum display;
  @override
  final bool editable;
  @override
  final bool? joined;
  @override
  final int? participants;
  @override
  final DateTime createdAt;

  factory _$PromotionDtoOutput(
          [void Function(PromotionDtoOutputBuilder)? updates]) =>
      (PromotionDtoOutputBuilder()..update(updates))._build();

  _$PromotionDtoOutput._(
      {required this.promotionId,
      required this.code,
      required this.name,
      required this.scope,
      this.operatorId,
      this.operatorName,
      required this.discountType,
      required this.discountValue,
      this.maxDiscount,
      required this.minOrder,
      this.routeId,
      required this.routeIds,
      required this.routeNames,
      this.routeName,
      this.tripId,
      required this.startsAt,
      required this.endsAt,
      required this.usageLimit,
      required this.usedCount,
      required this.status,
      required this.display,
      required this.editable,
      this.joined,
      this.participants,
      required this.createdAt})
      : super._();
  @override
  PromotionDtoOutput rebuild(
          void Function(PromotionDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionDtoOutputBuilder toBuilder() =>
      PromotionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionDtoOutput &&
        promotionId == other.promotionId &&
        code == other.code &&
        name == other.name &&
        scope == other.scope &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        discountType == other.discountType &&
        discountValue == other.discountValue &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        routeId == other.routeId &&
        routeIds == other.routeIds &&
        routeNames == other.routeNames &&
        routeName == other.routeName &&
        tripId == other.tripId &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        usageLimit == other.usageLimit &&
        usedCount == other.usedCount &&
        status == other.status &&
        display == other.display &&
        editable == other.editable &&
        joined == other.joined &&
        participants == other.participants &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, promotionId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, discountType.hashCode);
    _$hash = $jc(_$hash, discountValue.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeIds.hashCode);
    _$hash = $jc(_$hash, routeNames.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, usageLimit.hashCode);
    _$hash = $jc(_$hash, usedCount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, display.hashCode);
    _$hash = $jc(_$hash, editable.hashCode);
    _$hash = $jc(_$hash, joined.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionDtoOutput')
          ..add('promotionId', promotionId)
          ..add('code', code)
          ..add('name', name)
          ..add('scope', scope)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('discountType', discountType)
          ..add('discountValue', discountValue)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('routeId', routeId)
          ..add('routeIds', routeIds)
          ..add('routeNames', routeNames)
          ..add('routeName', routeName)
          ..add('tripId', tripId)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('usageLimit', usageLimit)
          ..add('usedCount', usedCount)
          ..add('status', status)
          ..add('display', display)
          ..add('editable', editable)
          ..add('joined', joined)
          ..add('participants', participants)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PromotionDtoOutputBuilder
    implements Builder<PromotionDtoOutput, PromotionDtoOutputBuilder> {
  _$PromotionDtoOutput? _$v;

  String? _promotionId;
  String? get promotionId => _$this._promotionId;
  set promotionId(String? promotionId) => _$this._promotionId = promotionId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PromotionDtoOutputScopeEnum? _scope;
  PromotionDtoOutputScopeEnum? get scope => _$this._scope;
  set scope(PromotionDtoOutputScopeEnum? scope) => _$this._scope = scope;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  PromotionDtoOutputDiscountTypeEnum? _discountType;
  PromotionDtoOutputDiscountTypeEnum? get discountType => _$this._discountType;
  set discountType(PromotionDtoOutputDiscountTypeEnum? discountType) =>
      _$this._discountType = discountType;

  int? _discountValue;
  int? get discountValue => _$this._discountValue;
  set discountValue(int? discountValue) =>
      _$this._discountValue = discountValue;

  int? _maxDiscount;
  int? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(int? maxDiscount) => _$this._maxDiscount = maxDiscount;

  int? _minOrder;
  int? get minOrder => _$this._minOrder;
  set minOrder(int? minOrder) => _$this._minOrder = minOrder;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  ListBuilder<String>? _routeIds;
  ListBuilder<String> get routeIds =>
      _$this._routeIds ??= ListBuilder<String>();
  set routeIds(ListBuilder<String>? routeIds) => _$this._routeIds = routeIds;

  ListBuilder<String>? _routeNames;
  ListBuilder<String> get routeNames =>
      _$this._routeNames ??= ListBuilder<String>();
  set routeNames(ListBuilder<String>? routeNames) =>
      _$this._routeNames = routeNames;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  int? _usageLimit;
  int? get usageLimit => _$this._usageLimit;
  set usageLimit(int? usageLimit) => _$this._usageLimit = usageLimit;

  int? _usedCount;
  int? get usedCount => _$this._usedCount;
  set usedCount(int? usedCount) => _$this._usedCount = usedCount;

  PromotionDtoOutputStatusEnum? _status;
  PromotionDtoOutputStatusEnum? get status => _$this._status;
  set status(PromotionDtoOutputStatusEnum? status) => _$this._status = status;

  PromotionDtoOutputDisplayEnum? _display;
  PromotionDtoOutputDisplayEnum? get display => _$this._display;
  set display(PromotionDtoOutputDisplayEnum? display) =>
      _$this._display = display;

  bool? _editable;
  bool? get editable => _$this._editable;
  set editable(bool? editable) => _$this._editable = editable;

  bool? _joined;
  bool? get joined => _$this._joined;
  set joined(bool? joined) => _$this._joined = joined;

  int? _participants;
  int? get participants => _$this._participants;
  set participants(int? participants) => _$this._participants = participants;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PromotionDtoOutputBuilder() {
    PromotionDtoOutput._defaults(this);
  }

  PromotionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _promotionId = $v.promotionId;
      _code = $v.code;
      _name = $v.name;
      _scope = $v.scope;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _discountType = $v.discountType;
      _discountValue = $v.discountValue;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _routeId = $v.routeId;
      _routeIds = $v.routeIds.toBuilder();
      _routeNames = $v.routeNames.toBuilder();
      _routeName = $v.routeName;
      _tripId = $v.tripId;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _usageLimit = $v.usageLimit;
      _usedCount = $v.usedCount;
      _status = $v.status;
      _display = $v.display;
      _editable = $v.editable;
      _joined = $v.joined;
      _participants = $v.participants;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionDtoOutput other) {
    _$v = other as _$PromotionDtoOutput;
  }

  @override
  void update(void Function(PromotionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionDtoOutput build() => _build();

  _$PromotionDtoOutput _build() {
    _$PromotionDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PromotionDtoOutput._(
            promotionId: BuiltValueNullFieldError.checkNotNull(
                promotionId, r'PromotionDtoOutput', 'promotionId'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'PromotionDtoOutput', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PromotionDtoOutput', 'name'),
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'PromotionDtoOutput', 'scope'),
            operatorId: operatorId,
            operatorName: operatorName,
            discountType: BuiltValueNullFieldError.checkNotNull(
                discountType, r'PromotionDtoOutput', 'discountType'),
            discountValue: BuiltValueNullFieldError.checkNotNull(
                discountValue, r'PromotionDtoOutput', 'discountValue'),
            maxDiscount: maxDiscount,
            minOrder: BuiltValueNullFieldError.checkNotNull(
                minOrder, r'PromotionDtoOutput', 'minOrder'),
            routeId: routeId,
            routeIds: routeIds.build(),
            routeNames: routeNames.build(),
            routeName: routeName,
            tripId: tripId,
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'PromotionDtoOutput', 'startsAt'),
            endsAt: BuiltValueNullFieldError.checkNotNull(
                endsAt, r'PromotionDtoOutput', 'endsAt'),
            usageLimit: BuiltValueNullFieldError.checkNotNull(
                usageLimit, r'PromotionDtoOutput', 'usageLimit'),
            usedCount: BuiltValueNullFieldError.checkNotNull(
                usedCount, r'PromotionDtoOutput', 'usedCount'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PromotionDtoOutput', 'status'),
            display: BuiltValueNullFieldError.checkNotNull(
                display, r'PromotionDtoOutput', 'display'),
            editable: BuiltValueNullFieldError.checkNotNull(
                editable, r'PromotionDtoOutput', 'editable'),
            joined: joined,
            participants: participants,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PromotionDtoOutput', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routeIds';
        routeIds.build();
        _$failedField = 'routeNames';
        routeNames.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PromotionDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
