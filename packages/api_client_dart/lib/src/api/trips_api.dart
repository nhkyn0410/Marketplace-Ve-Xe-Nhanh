//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:api_client_dart/src/api_util.dart';
import 'package:api_client_dart/src/model/date.dart';
import 'package:api_client_dart/src/model/problem_details_dto.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output.dart';

class TripsApi {

  final Dio _dio;

  final Serializers _serializers;

  const TripsApi(this._dio, this._serializers);

  /// publicTripControllerGet
  /// 
  ///
  /// Parameters:
  /// * [tripId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PublicTripDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PublicTripDtoOutput>> publicTripControllerGet({ 
    required String tripId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/trips/{tripId}'.replaceAll('{' r'tripId' '}', encodeQueryParameter(_serializers, tripId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PublicTripDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(PublicTripDtoOutput),
      ) as PublicTripDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PublicTripDtoOutput>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// publicTripControllerSearch
  /// 
  ///
  /// Parameters:
  /// * [date] 
  /// * [fromProvinceId] 
  /// * [fromWardId] 
  /// * [fromStopPointId] 
  /// * [toProvinceId] 
  /// * [toWardId] 
  /// * [toStopPointId] 
  /// * [passengers] 
  /// * [operatorId] 
  /// * [vehicleForm] 
  /// * [vehicleClass] 
  /// * [departureFrom] 
  /// * [departureTo] 
  /// * [priceMin] 
  /// * [priceMax] 
  /// * [amenityIds] 
  /// * [sort] 
  /// * [page] 
  /// * [limit] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TripSearchResponseDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TripSearchResponseDtoOutput>> publicTripControllerSearch({ 
    required Date date,
    String? fromProvinceId,
    String? fromWardId,
    String? fromStopPointId,
    String? toProvinceId,
    String? toWardId,
    String? toStopPointId,
    int? passengers = 1,
    String? operatorId,
    String? vehicleForm,
    String? vehicleClass,
    String? departureFrom,
    String? departureTo,
    int? priceMin,
    int? priceMax,
    String? amenityIds,
    String? sort = 'departure',
    int? page = 1,
    int? limit = 20,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/trips/search';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (fromProvinceId != null) r'fromProvinceId': encodeQueryParameter(_serializers, fromProvinceId, const FullType(String)),
      if (fromWardId != null) r'fromWardId': encodeQueryParameter(_serializers, fromWardId, const FullType(String)),
      if (fromStopPointId != null) r'fromStopPointId': encodeQueryParameter(_serializers, fromStopPointId, const FullType(String)),
      if (toProvinceId != null) r'toProvinceId': encodeQueryParameter(_serializers, toProvinceId, const FullType(String)),
      if (toWardId != null) r'toWardId': encodeQueryParameter(_serializers, toWardId, const FullType(String)),
      if (toStopPointId != null) r'toStopPointId': encodeQueryParameter(_serializers, toStopPointId, const FullType(String)),
      r'date': encodeQueryParameter(_serializers, date, const FullType(Date)),
      if (passengers != null) r'passengers': encodeQueryParameter(_serializers, passengers, const FullType(int)),
      if (operatorId != null) r'operatorId': encodeQueryParameter(_serializers, operatorId, const FullType(String)),
      if (vehicleForm != null) r'vehicleForm': encodeQueryParameter(_serializers, vehicleForm, const FullType(String)),
      if (vehicleClass != null) r'vehicleClass': encodeQueryParameter(_serializers, vehicleClass, const FullType(String)),
      if (departureFrom != null) r'departureFrom': encodeQueryParameter(_serializers, departureFrom, const FullType(String)),
      if (departureTo != null) r'departureTo': encodeQueryParameter(_serializers, departureTo, const FullType(String)),
      if (priceMin != null) r'priceMin': encodeQueryParameter(_serializers, priceMin, const FullType(int)),
      if (priceMax != null) r'priceMax': encodeQueryParameter(_serializers, priceMax, const FullType(int)),
      if (amenityIds != null) r'amenityIds': encodeQueryParameter(_serializers, amenityIds, const FullType(String)),
      if (sort != null) r'sort': encodeQueryParameter(_serializers, sort, const FullType(String)),
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
      if (limit != null) r'limit': encodeQueryParameter(_serializers, limit, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    TripSearchResponseDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TripSearchResponseDtoOutput),
      ) as TripSearchResponseDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TripSearchResponseDtoOutput>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
