//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:api_client_dart/src/api_util.dart';
import 'package:api_client_dart/src/model/attachment_upload_input_dto.dart';
import 'package:api_client_dart/src/model/attachment_upload_response_dto_output.dart';
import 'package:api_client_dart/src/model/customer_ticket_input_dto.dart';
import 'package:api_client_dart/src/model/customer_ticket_list_dto_output.dart';
import 'package:api_client_dart/src/model/download_url_response_dto_output.dart';
import 'package:api_client_dart/src/model/message_input_dto.dart';
import 'package:api_client_dart/src/model/problem_details_dto.dart';
import 'package:api_client_dart/src/model/ticket_detail_dto_output.dart';

class SupportApi {

  final Dio _dio;

  final Serializers _serializers;

  const SupportApi(this._dio, this._serializers);

  /// customerSupportControllerCreate
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [customerTicketInputDto] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TicketDetailDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TicketDetailDtoOutput>> customerSupportControllerCreate({ 
    required String bookingId,
    required CustomerTicketInputDto customerTicketInputDto,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-tickets'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString());
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
      const _type = FullType(CustomerTicketInputDto);
      _bodyData = _serializers.serialize(customerTicketInputDto, specifiedType: _type);

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

    TicketDetailDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TicketDetailDtoOutput),
      ) as TicketDetailDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TicketDetailDtoOutput>(
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

  /// customerSupportControllerDownload
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [attachmentId] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DownloadUrlResponseDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DownloadUrlResponseDtoOutput>> customerSupportControllerDownload({ 
    required String bookingId,
    required String attachmentId,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-attachments/{attachmentId}/download-url'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString()).replaceAll('{' r'attachmentId' '}', encodeQueryParameter(_serializers, attachmentId, const FullType(String)).toString());
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
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    DownloadUrlResponseDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(DownloadUrlResponseDtoOutput),
      ) as DownloadUrlResponseDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DownloadUrlResponseDtoOutput>(
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

  /// customerSupportControllerGet
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [ticketId] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TicketDetailDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TicketDetailDtoOutput>> customerSupportControllerGet({ 
    required String bookingId,
    required String ticketId,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-tickets/{ticketId}'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString()).replaceAll('{' r'ticketId' '}', encodeQueryParameter(_serializers, ticketId, const FullType(String)).toString());
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

    TicketDetailDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TicketDetailDtoOutput),
      ) as TicketDetailDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TicketDetailDtoOutput>(
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

  /// customerSupportControllerList
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
  /// Returns a [Future] containing a [Response] with a [CustomerTicketListDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<CustomerTicketListDtoOutput>> customerSupportControllerList({ 
    required String bookingId,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-tickets'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString());
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

    CustomerTicketListDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(CustomerTicketListDtoOutput),
      ) as CustomerTicketListDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<CustomerTicketListDtoOutput>(
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

  /// customerSupportControllerReply
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [ticketId] 
  /// * [messageInputDto] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TicketDetailDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TicketDetailDtoOutput>> customerSupportControllerReply({ 
    required String bookingId,
    required String ticketId,
    required MessageInputDto messageInputDto,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-tickets/{ticketId}/messages'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString()).replaceAll('{' r'ticketId' '}', encodeQueryParameter(_serializers, ticketId, const FullType(String)).toString());
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
      const _type = FullType(MessageInputDto);
      _bodyData = _serializers.serialize(messageInputDto, specifiedType: _type);

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

    TicketDetailDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TicketDetailDtoOutput),
      ) as TicketDetailDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TicketDetailDtoOutput>(
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

  /// customerSupportControllerUpload
  /// 
  ///
  /// Parameters:
  /// * [bookingId] 
  /// * [attachmentUploadInputDto] 
  /// * [xBookingToken] - Mã truy cập booking (khách vãng lai).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AttachmentUploadResponseDtoOutput] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AttachmentUploadResponseDtoOutput>> customerSupportControllerUpload({ 
    required String bookingId,
    required AttachmentUploadInputDto attachmentUploadInputDto,
    String? xBookingToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/bookings/{bookingId}/support-attachments/upload-url'.replaceAll('{' r'bookingId' '}', encodeQueryParameter(_serializers, bookingId, const FullType(String)).toString());
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
      const _type = FullType(AttachmentUploadInputDto);
      _bodyData = _serializers.serialize(attachmentUploadInputDto, specifiedType: _type);

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

    AttachmentUploadResponseDtoOutput? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AttachmentUploadResponseDtoOutput),
      ) as AttachmentUploadResponseDtoOutput;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AttachmentUploadResponseDtoOutput>(
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
