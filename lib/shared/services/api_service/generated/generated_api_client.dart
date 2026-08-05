import 'package:dio/dio.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog.dart';

class GeneratedApiResult {
  const GeneratedApiResult({
    required this.statusCode,
    required this.data,
    required this.headers,
  });

  final int statusCode;
  final dynamic data;
  final Headers headers;
}

class GeneratedApiClient {
  GeneratedApiClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 30000),
      baseUrl: ApiService.baseUrl,
      validateStatus: (_) => true,
    ),
  );

  static Future<GeneratedApiResult> perform(
    GeneratedApiDescriptor descriptor, {
    Map<String, String> pathValues = const {},
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool useAuth = true,
    Map<String, String>? extraHeaders,
  }) async {
    var path = descriptor.path;
    for (final name in descriptor.pathParameters) {
      final replacement = pathValues[name] ?? '11111111-1111-4111-8111-111111111111';
      path = path.replaceAll('{$name}', replacement);
    }

    final headers = <String, dynamic>{
      ...ApiService.getHeader(useAuth && descriptor.requiresAuth),
      if (extraHeaders != null) ...extraHeaders,
    };

    final response = await _dio.request<dynamic>(
      path,
      queryParameters: queryParameters,
      data: body,
      options: Options(
        method: descriptor.method.name.toUpperCase(),
        headers: headers,
        contentType: Headers.jsonContentType,
      ),
    );

    return GeneratedApiResult(
      statusCode: response.statusCode ?? -1,
      data: response.data,
      headers: response.headers,
    );
  }
}
