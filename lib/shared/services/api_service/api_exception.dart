// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

class AudioException implements Exception {
  final String? error;
  final String? code;
  final dynamic details;
  final List<String?>? urls;

  AudioException({
    this.error,
    this.code,
    this.details,
    this.urls,
  });

  @override
  String toString() {
    return 'error: $error - code: $code \n details: $details \n urls: $urls';
  }
}

class SentryApiException implements Exception {
  final String? url;
  final String? curl;
  final String? error;
  final int? statusCode;

  SentryApiException({
    this.url,
    this.curl,
    this.error,
    this.statusCode,
  });

  @override
  String toString() {
    return 'url: $url - statusCode: $statusCode, error: $error \n $curl';
  }
}

class ApiException implements Exception {
  final String? error;
  final int? statusCode;

  ApiException({
    this.error,
    this.statusCode,
  });

  @override
  String toString() {
    if (error == null) return 'Exception';
    return '$error';
  }
}

class ApiErrorExtractor {
  static String? messageFrom(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          return messageFrom(jsonDecode(trimmed));
        } catch (_) {
          return trimmed;
        }
      }
      return trimmed;
    }

    if (data is! Map) return null;

    final map = Map<String, dynamic>.from(data);

    final message = _nonEmptyString(map['message']);
    if (message != null) return message;

    final detail = map['detail'];
    if (detail is String && detail.trim().isNotEmpty) return detail.trim();

    final error = map['error'];
    if (error is String && error.trim().isNotEmpty) return error.trim();
    if (error is Map) {
      final nested = messageFrom(error);
      if (nested != null) return nested;
    }

    final errors = map['errors'];
    if (errors is List && errors.isNotEmpty) {
      return messageFrom(errors.first);
    }

    return null;
  }

  static String? _nonEmptyString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }
}

abstract final class ExceptionMessages {
  ExceptionMessages._();

  static String from(Object error) {
    if (error is ApiException) {
      final message = error.error;
      if (message != null && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    final text = error.toString().trim();
    if (text.isNotEmpty && text != 'Exception') {
      return text;
    }

    return error.runtimeType.toString();
  }
}

class ApiErrorMessage {
  static String get ERROR_HAPPENS => 'An error occurred. Please try again.';
  static String get APP_API_ERROR => 'Failed to connect to the server.';
  static String get APP_PARSE_ERROR => 'Failed to process server response.';
  static String get APP_BLOC_ERROR =>
      'An unexpected application error occurred.';
  static String get APP_UNKNOWN_ERROR => 'Something went wrong.';
  static String get APP_EXCEPTION_ERROR => 'An unexpected exception occurred.';
  static String get APP_OTHER_ERROR =>
      'Something went wrong. Please try again.';
  static String get DOWNLOAD_CANT_GET_FILENAME_ERROR =>
      'Unable to resolve download file name.';
  static String get NO_PERMISSION =>
      'You do not have permission to access this.';
  static String get NETWORK_ERROR =>
      'No internet connection. Please check your connection.';
  static String get TIMEOUT_ERROR => 'Connection timeout. Please try again.';
  static String get UNKNOWN_ERROR => 'An unknown error occurred.';
  static String get CANCEL_ERROR => 'Request was canceled.';
  static String get ORTHER_ERROR => 'An unexpected error occurred.';
  static String get NOT_FOUND_ERROR => 'Requested resource not found.';
}

class ApiStatusCode {
  static const Success = 200;
  static const BadRequest = 400;
  static const Unauthorized = 401;
  static const NotFound = 404;
  static const NotHavePermission = 403;
  static const InternalServerError = 500;
}

class NoPemissionException extends ApiException {
  NoPemissionException() : super(error: ApiErrorMessage.NO_PERMISSION);
}

extension StringTrExtension on String {
  String tr({Map<String, String>? namedArgs}) {
    return '$this (code: ${namedArgs?['code'] ?? 'unknown'})';
  }
}
