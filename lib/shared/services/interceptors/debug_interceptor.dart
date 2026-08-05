import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kuemele/features/debug_tools/debug_logger.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';

/// Opt-in debug logging that excludes credentials and sensitive payload fields.
class DebugInterceptor extends Interceptor {
  final bool? printOnSuccess;
  final bool convertFormData;

  DebugInterceptor({this.printOnSuccess, this.convertFormData = true});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logRequest(
      _renderCurlRepresentation(err.requestOptions),
      err.requestOptions,
      err.response,
    );
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final curl = printOnSuccess == true
        ? _renderCurlRepresentation(response.requestOptions)
        : '';
    log(
      'API SUCCESS - ${response.realUri} - ${response.statusCode} - '
      '${response.statusMessage}',
    );
    logRequest(curl, response.requestOptions, response);
    handler.next(response);
  }

  void logRequest(
    String curl,
    RequestOptions requestOptions,
    Response? response,
  ) {
    DebugLogger.logRequest(
      type: RequestLogType.api,
      name: requestOptions.extra['name'],
      url: requestOptions.path,
      curl: curl,
      requestTime: requestOptions.extra['request_time'],
      responseBody: _redact(response?.data),
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
    );
  }

  String _renderCurlRepresentation(RequestOptions options) {
    try {
      final components = <String>['curl -i', '-X ${options.method}'];
      options.headers.forEach((key, value) {
        if (!_isSensitiveKey(key)) {
          components.add('-H "$key: $value"');
        }
      });

      if (options.data != null) {
        Object data = options.data!;
        if (data is FormData && convertFormData) {
          data = <String, dynamic>{
            for (final field in data.fields) field.key: field.value,
            for (final file in data.files)
              file.key: file.value.filename ?? 'file',
          };
        }
        final encoded = json.encode(_redact(data)).replaceAll('"', '\\\\"');
        components.add('-d "$encoded"');
      }

      components.add('"${options.uri}"');
      return components.join(' \\\n+\t');
    } catch (_) {
      return 'unable to create a safe cURL representation';
    }
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase();
    return normalized == 'authorization' ||
        normalized == 'cookie' ||
        normalized == 'set-cookie' ||
        normalized.contains('token') ||
        normalized.contains('password') ||
        normalized.contains('secret');
  }

  static dynamic _redact(dynamic value, {String? key}) {
    if (key != null && _isSensitiveKey(key)) return '[REDACTED]';
    if (value is Map) {
      return value.map(
        (entryKey, entryValue) => MapEntry(
          entryKey.toString(),
          _redact(entryValue, key: entryKey.toString()),
        ),
      );
    }
    if (value is Iterable) {
      return value.map((item) => _redact(item)).toList(growable: false);
    }
    return value;
  }
}
