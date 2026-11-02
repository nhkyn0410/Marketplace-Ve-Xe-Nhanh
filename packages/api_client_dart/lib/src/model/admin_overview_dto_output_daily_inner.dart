//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output_daily_inner.g.dart';

/// AdminOverviewDtoOutputDailyInner
///
/// Properties:
/// * [date] 
/// * [gmv] 
@BuiltValue()
abstract class AdminOverviewDtoOutputDailyInner implements Built<AdminOverviewDtoOutputDailyInner, AdminOverviewDtoOutputDailyInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'gmv')
  int get gmv;

  AdminOverviewDtoOutputDailyInner._();

  factory AdminOverviewDtoOutputDailyInner([void updates(AdminOverviewDtoOutputDailyInnerBuilder b)]) = _$AdminOverviewDtoOutputDailyInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputDailyInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutputDailyInner> get serializer => _$AdminOverviewDtoOutputDailyInnerSerializer();
}

class _$AdminOverviewDtoOutputDailyInnerSerializer implements PrimitiveSerializer<AdminOverviewDtoOutputDailyInner> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutputDailyInner, _$AdminOverviewDtoOutputDailyInner];

  @override
  final String wireName = r'AdminOverviewDtoOutputDailyInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutputDailyInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'gmv';
    yield serializers.serialize(
      object.gmv,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutputDailyInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputDailyInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'gmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutputDailyInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputDailyInnerBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


