import 'package:kuemele/shared/services/api_service/api_exception.dart';

class ApiResponse<T> {
  final String? message;
  final String? error;
  final bool success;
  final T? data;

  ApiResponse({
    this.data,
    this.message,
    this.error,
    this.success = false,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? parseData,
  }) {
    return ApiResponse<T>(
      message: json['message'] as String?,
      error: ApiErrorExtractor.messageFrom(json),
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && parseData != null
          ? parseData(json['data'])
          : null,
    );
  }
}
