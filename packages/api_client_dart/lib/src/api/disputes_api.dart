//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:api_client_dart/src/api_util.dart';
import 'package:api_client_dart/src/model/customer_dispute_list_dto_output.dart';
import 'package:api_client_dart/src/model/dispute_detail_dto_output.dart';
import 'package:api_client_dart/src/model/evidence_input_dto.dart';
import 'package:api_client_dart/src/model/problem_details_dto.dart';

class DisputesApi {

  final Dio _dio;

  final Serializers _serializers;

  const DisputesApi(this._dio, this._serializers);

  /// customerDisputeControllerGet
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [disputeId] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DisputeDetailDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DisputeDetailDtoOutput>> customerDisputeControllerGet({ 
    required String bookingId,
    required String disputeId,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/disputes/{disputeId}'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString()).replaceAll('{' r'disputeId' '}', encodeQueryParameter(_serializers, disputeId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (xBookingToken != null) r'X-Booking-Token': xBookingToken,
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

    DisputeDetailDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(DisputeDetailDtoOutput),
      ) as DisputeDetailDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DisputeDetailDtoOutput>(
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

  /// customerDisputeControllerList
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [CustomerDisputeListDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<CustomerDisputeListDtoOutput>> customerDisputeControllerList({ 
    required String bookingId,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/disputes'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (xBookingToken != null) r'X-Booking-Token': xBookingToken,
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

    CustomerDisputeListDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(CustomerDisputeListDtoOutput),
      ) as CustomerDisputeListDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<CustomerDisputeListDtoOutput>(
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

  /// customerDisputeControllerRespond
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [disputeId] 
  /// * [evidenceInputDto] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DisputeDetailDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DisputeDetailDtoOutput>> customerDisputeControllerRespond({ 
    required String bookingId,
    required String disputeId,
    required EvidenceInputDto evidenceInputDto,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/disputes/{disputeId}/responses'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString()).replaceAll('{' r'disputeId' '}', encodeQueryParameter(_serializers, disputeId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        if (xBookingToken != null) r'X-Booking-Token': xBookingToken,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(EvidenceInputDto);
      _bodyData = _serializers.serialize(evidenceInputDto, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    DisputeDetailDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(DisputeDetailDtoOutput),
      ) as DisputeDetailDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DisputeDetailDtoOutput>(
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
