// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kuemele/core/get_it.dart';
import 'package:kuemele/features/auth/data/storage/auth_storage.dart';
import 'package:kuemele/core/app_config.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';
import 'package:kuemele/shared/services/interceptors/debug_interceptor.dart';
import 'package:kuemele/shared/services/interceptors/encoding_params_interceptor.dart';
import 'package:kuemele/shared/services/interceptors/refresh_token_interceptor.dart';
import 'package:kuemele/shared/utils/path_helper.dart';
import 'package:kuemele/shared/utils/utils.dart';

enum RequestMethod { NONE, GET, POST, PUT, PATCH, DELETE, DOWNLOAD }

enum SortType { none, asc, desc }

class ApiService {
  static final svgHttpClient = http.Client();
  static String _userAgent = AppConfig.defaultUserAgent;
  static String _token = '';
  // ignore: unused_field
  static String _refreshToken = '';
  static CancelToken _cancelToken = CancelToken();

  static const baseUrl = ApiConfig.baseUrl;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: ApiConfig.timeout),
      baseUrl: baseUrl,
    ),
  )
    ..interceptors.add(EncodingParamsInterceptor())
    ..interceptors.add(
      kDebugMode && ApiConfig.networkDebugLoggingRequested
          ? DebugInterceptor(printOnSuccess: true)
          : Interceptor(),
    )
    ..interceptors.add(RefreshInterceptor());

  static String getUserAgent() {
    return _userAgent;
  }

  static void setUserAgent({required String userAgent}) {
    _userAgent = userAgent;
  }

  static void setToken({required String? newToken, String? newRefreshToken}) {
    if (!Utils.isNullOrEmpty(newToken)) {
      final value = newToken ?? '';
      _token = value.startsWith('Bearer ') ? value : 'Bearer $value';
    }
    if (!Utils.isNullOrEmpty(newRefreshToken)) {
      _refreshToken = newRefreshToken ?? '';
    }
  }

  static bool hasToken() {
    return Utils.isNotNullOrEmpty(_token);
  }

  static String get token => _token;
  static String get refreshToken => _refreshToken;

  static void clearToken() {
    _token = '';
    _refreshToken = '';
  }

  static bool get isGuest => Utils.isNullOrEmpty(_token);

  // ------------------------- Base -------------------------
  static Map<String, String?> getHeader(bool useAuthenHeader) {
    return {
      'User-Agent': _userAgent,
      if (useAuthenHeader && hasToken()) 'authorization': _token,
    };
  }

  static Map<String, dynamic> extractMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        return response['data'] as Map<String, dynamic>;
      }
      if (response['user'] is Map<String, dynamic>) {
        return response['user'] as Map<String, dynamic>;
      }
      if (response['profile'] is Map<String, dynamic>) {
        return response['profile'] as Map<String, dynamic>;
      }
      return response;
    }
    return {};
  }

  static List<dynamic> extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        return response['data'] as List<dynamic>;
      }
      if (response['supported'] is List) {
        return response['supported'] as List<dynamic>;
      }
      if (response['available'] is List) {
        return response['available'] as List<dynamic>;
      }
    }
    return const [];
  }

  static String publicUrl(String url) {
    final guestUrl = url.split('/');
    guestUrl.insert(2, 'guest');
    return isGuest ? guestUrl.join('/') : url;
  }

  static String getRequestTime() {
    try {
      return Utils.convertTimeInMillisecond(
        DateTime.now().millisecondsSinceEpoch,
        'hh:mm:ss+SSS a',
      );
    } catch (e) {
      return '';
    }
  }

  static String getSavePath(Headers headers) {
    var fileName = headers.value('content-disposition')?.split('filename=')[1];
    if (fileName == null) {
      fileName = headers.value('uri')?.split('/').last;
      if (fileName == null) {
        throw ApiException(
          error: ApiErrorMessage.DOWNLOAD_CANT_GET_FILENAME_ERROR,
        );
      }
    }
    final savePath = '${PathHelper.storeDownloadFilesPath}/$fileName';
    return savePath;
  }

  static Future<dynamic> callRequest(
    RequestMethod method,
    String url,
    String apiDescription, {
    Map<String, dynamic>? params,
    Object? body,
    bool useAuthenHeader = true,
  }) async {
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }
    try {
      final httpMethod = Utils.enumToString(method);
      _logApiRequest(
        apiDescription: apiDescription,
        method: httpMethod,
        url: url,
        queryParameters: params,
        body: body,
      );

      final options = Options(
        method: httpMethod,
        headers: getHeader(useAuthenHeader),
        contentType: Headers.jsonContentType,
        extra: {'name': apiDescription, 'request_time': getRequestTime()},
      );
      if (method == RequestMethod.DOWNLOAD) {
        options.method = null;
        final res = await _dio.download(
          url,
          getSavePath,
          queryParameters: params,
          options: options,
        );
        String savePath = getSavePath(res.headers);
        _logApiResponse(
          apiDescription: apiDescription,
          method: httpMethod,
          url: url,
          data: {'savePath': savePath},
        );
        return savePath;
      } else {
        Response<dynamic> response = await _dio.request(
          url,
          queryParameters: params,
          data: body,
          options: options,
          cancelToken: _cancelToken,
        );
        _logApiResponse(
          apiDescription: apiDescription,
          method: httpMethod,
          url: url,
          data: response.data,
          statusCode: response.statusCode,
        );
        return response.data;
      }
    } on DioException catch (error) {
      _handelDioError(url, error);
    } catch (e) {
      throw ApiException(error: ApiErrorMessage.APP_API_ERROR);
    }
  }

  static Future<dynamic> uploadMultipart(
    String url,
    String apiDescription,
    FormData formData, {
    bool useAuthenHeader = true,
  }) async {
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }
    try {
      _logApiRequest(
        apiDescription: apiDescription,
        method: 'POST',
        url: url,
        body: <String, dynamic>{
          for (final field in formData.fields) field.key: field.value,
          for (final file in formData.files)
            file.key: file.value.filename ?? 'file',
        },
      );

      final response = await _dio.post<dynamic>(
        url,
        data: formData,
        cancelToken: _cancelToken,
        options: Options(
          headers: getHeader(useAuthenHeader),
          contentType: 'multipart/form-data',
          extra: {'name': apiDescription, 'request_time': getRequestTime()},
        ),
      );
      _logApiResponse(
        apiDescription: apiDescription,
        method: 'POST',
        url: url,
        data: response.data,
        statusCode: response.statusCode,
      );
      return response.data;
    } on DioException catch (error) {
      _handelDioError(url, error);
    } catch (e) {
      throw ApiException(error: ApiErrorMessage.APP_API_ERROR);
    }
  }

  static void _logApiRequest({
    required String apiDescription,
    required String method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Object? body,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('┌── API REQUEST ─────────────────────────')
      ..writeln('│ name   : $apiDescription')
      ..writeln('│ method : $method')
      ..writeln('│ url    : $baseUrl$url');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      buffer.writeln('│ query  :');
      buffer.write(
        _indentBlock(_formatPayload(queryParameters), prefix: '│   '),
      );
    }

    if (body != null) {
      buffer.writeln('│ body   :');
      buffer.write(_indentBlock(_formatPayload(body), prefix: '│   '));
    }

    buffer.writeln('└────────────────────────────────────────');
    log(buffer.toString(), name: 'ApiService');
  }

  static void _logApiResponse({
    required String apiDescription,
    required String method,
    required String url,
    required dynamic data,
    int? statusCode,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('┌── API RESPONSE ────────────────────────')
      ..writeln('│ name   : $apiDescription')
      ..writeln('│ method : $method')
      ..writeln('│ url    : $baseUrl$url');

    if (statusCode != null) {
      buffer.writeln('│ status : $statusCode');
    }

    buffer
      ..writeln('│ data   :')
      ..write(_indentBlock(_formatPayload(data), prefix: '│   '))
      ..writeln('└────────────────────────────────────────');

    log(buffer.toString(), name: 'ApiService');
  }

  static String _formatPayload(dynamic value) {
    if (value == null) return 'null';

    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  static String _indentBlock(String text, {required String prefix}) {
    return text.split('\n').map((line) => '$prefix$line\n').join();
  }

  static void _handelDioError(String url, DioException error) {
    Response? dioResponse = error.response;
    if (dioResponse != null) {
      log(
        'API FAIL 1 - $url - ${dioResponse.statusCode} - ${dioResponse.statusMessage}',
      );
      Utils.logWithJson(
        '',
        dioResponse.data,
        dioResponse.statusCode,
        dioResponse.statusMessage,
      );
      var errorMessage = ApiErrorExtractor.messageFrom(dioResponse.data) ??
          dioResponse.statusMessage;
      if (dioResponse.statusCode == ApiStatusCode.Unauthorized) {
        // _cancelToken.cancel();
        // if (hasToken()) {
        // LogoutHelper.handleLogout();
        // }
        throw ApiException(
          error: errorMessage,
          statusCode: dioResponse.statusCode,
        );
      } else if (dioResponse.statusCode == ApiStatusCode.NotHavePermission) {
        throw ApiException(
          error: errorMessage ?? ApiErrorMessage.NO_PERMISSION,
          statusCode: dioResponse.statusCode,
        );
      } else {
        throw ApiException(
          error: errorMessage,
          statusCode: dioResponse.statusCode,
        );
      }
    } else {
      log('API FAIL 2 - $url - ${error.message}');
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          log('API TIMEOUT');
          throw ApiException(error: ApiErrorMessage.TIMEOUT_ERROR);
        case DioExceptionType.cancel:
          log('API CANCELED');
          // throw ApiException(error: ApiErrorMessage.CANCEL_ERROR);
          break;
        case DioExceptionType.unknown:
          log('API ERROR - ${error.message}');
          if (error.error is SocketException) {
            throw ApiException(error: ApiErrorMessage.NETWORK_ERROR);
          } else {
            throw ApiException(error: ApiErrorMessage.ORTHER_ERROR);
          }
        default:
          log('API ERROR - ${error.message}');
          throw ApiException(error: ApiErrorMessage.UNKNOWN_ERROR);
      }
    }
  }

  static T? handleResponse<T>(T Function() parse) {
    try {
      var result = parse();
      return result;
    } catch (e, s) {
      if (!_cancelToken.isCancelled) {
        log(e.toString());
        log(s.toString());
        throw ApiException(error: ApiErrorMessage.APP_PARSE_ERROR);
      } else {
        return null;
      }
    }
  }

  static Future<bool> refreshAccessToken() async {
    if (Utils.isNullOrEmpty(_refreshToken)) {
      return false;
    }

    try {
      final bareDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(milliseconds: ApiConfig.timeout),
          baseUrl: baseUrl,
        ),
      );
      final response = await bareDio.post<dynamic>(
        GeneratedApiOperations.refreshToken.path,
        data: {'refreshToken': _refreshToken},
        options: Options(
          headers: {'User-Agent': _userAgent},
          contentType: Headers.jsonContentType,
        ),
      );

      final payload = extractMap(response.data);
      final nextToken = (payload['access_token'] ??
              payload['accessToken'] ??
              payload['token'])
          ?.toString();
      final nextRefresh =
          (payload['refresh_token'] ?? payload['refreshToken'])?.toString() ??
              _refreshToken;

      if (Utils.isNullOrEmpty(nextToken)) {
        return false;
      }

      setToken(newToken: nextToken, newRefreshToken: nextRefresh);
      await getIt<AuthStorage>().updateTokens(
        accessToken: nextToken!,
        refreshToken: nextRefresh,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<Response<dynamic>> retryRequest(RequestOptions requestOptions) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (hasToken()) {
      headers['authorization'] = _token;
    }

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        extra: requestOptions.extra,
      ),
    );
  }
}
